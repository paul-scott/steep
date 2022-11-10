import os
import time
import numpy as np

import argparse
import solsticepy
from solsticepy.design_crs import CRS
#from solsticepy.design_crs_aimingstrategy import *
from solsticepy.input import Parameters
from solsticepy.output_motab import output_metadata_motab, output_motab, read_motab

def set_param(inputs={}):
    '''
    set parameters
    '''

    pm=Parameters()
    for k, v in inputs.items():

        if hasattr(pm, k):
            setattr(pm, k, v)
        else:
            raise RuntimeError("invalid paramter '%s'"%(k,)) 

    pm.dependent_par()
    return pm

def run_simul(inputs={}):
    '''
    design the field base on performance of annual performance
    the annual performance is TMY DNI weighted
    '''

    pm=set_param(inputs)

    print('')
    print('Test inputs')
    for k, v in inputs.items():
        print(k, '=', getattr(pm, k))
    print('')
    print('')

    TIME=np.array([])
    print('')

    casedir=pm.casedir
    pm.saveparam(casedir)
    tablefile=casedir+'/OELT_Solstice.motab'
    if os.path.exists(tablefile):    
        print('')
        print('Load exsiting OELT')

    else:
        start=time.time()

        if pm.aimingstrategy:
            tablefile=design_crs_aimingstrategy(pm)
        else:
            tablefile=design_crs(pm)

        end=time.time()
        print('')
        print('total time %.2f'%((end-start)/60.), 'min')
        np.savetxt(casedir+'/time.csv', np.r_[pm.n_rays, end-start], fmt='%.4f', delimiter=',')

    tablefile=tablefile.encode('utf-8')
    return tablefile


def design_crs(pm):
    '''
    Design a central receiver system without sophisticated aiming strategy
    Steps:
	    1) Generate an oversized heliostat field
	    2) Perform annual optical simulations, obtain and save the annual performance of each individual heliostats
	    3) Rank the heliostats according to their annual optical efficiency
	    4) Adding the heat output of each heliostat at desin point until it reaches the system requied heat to the receiver
	    5) Post processing the performance of the selected heliostats, obtain the optical efficiency lookup table (OELT)

    Argument: 
	    pm: class, the Parameter class that contains all the parameters for the system

    Return:
	    tablefile: str, the directory that the OELT is saved

    '''

    crs=CRS(latitude=pm.lat, casedir=casedir_des, nproc=int(pm.n_procs), verbose=pm.verbose)

    crs.receiversystem(receiver=pm.rcv_type, rec_w=float(pm.W_rcv), rec_h=float(pm.H_rcv), rec_x=float(pm.X_rcv), rec_y=float(pm.Y_rcv), rec_z=float(pm.Z_rcv), rec_tilt=float(pm.tilt_rcv), rec_grid_w=int(pm.n_W_rcv), rec_grid_h=int(pm.n_H_rcv), rec_abs=float(pm.alpha_rcv))

    if pm.method==1:
        crs.heliostatfield(field=pm.field_type, hst_rho=pm.helio_refl, slope=pm.slope_error, hst_w=pm.W_helio, hst_h=pm.H_helio, tower_h=pm.H_tower, tower_r=pm.R_tower, hst_z=pm.Z_helio, num_hst=pm.n_helios, R1=pm.R1, fb=pm.fb, dsep=pm.dsep)

    else:
        crs.heliostatfield(field=pm.field_type, hst_rho=pm.rho_helio, slope=pm.slope_error, hst_w=pm.W_helio, hst_h=pm.H_helio, tower_h=pm.H_tower, tower_r=pm.R_tower, hst_z=pm.Z_helio, num_hst=pm.n_helios*2, R1=pm.R1, fb=pm.fb, dsep=pm.dsep)


    crs.yaml(sunshape=pm.sunshape, sunshape_param=pm.sunshape_param)

    if pm.field_type[-3:]=='csv':
        oelt, A_land=crs.annual_oelt(dni_des=pm.dni_des, num_rays=int(pm.n_rays), nd=int(pm.n_row_oelt), nh=int(pm.n_col_oelt))

    else:
        oelt, A_land=crs.field_design_annual(dni_des=pm.dni_des, num_rays=int(pm.n_rays), nd=int(pm.n_row_oelt), nh=int(pm.n_col_oelt), weafile=pm.wea_file, method=pm.method, Q_in_des=pm.Q_in_rcv, n_helios=pm.n_helios, zipfiles=False, gen_vtk=False, plot=False)

        crs.casedir=pm.casedir+'/performance'
        if not os.path.exists(crs.casedir):
	        os.makedirs(crs.casedir)
        crs.yaml(sunshape=pm.sunshape, sunshape_param=pm.sunshape_param)
        oelt, A_land=crs.annual_oelt(dni_des=pm.dni_des, num_rays=int(pm.n_rays), nd=int(pm.n_row_oelt), nh=int(pm.n_col_oelt))	

    if (A_land==0):    
        tablefile=None
    else:
        tablefile=pm.casedir+'/OELT_Solstice.motab'                                      
        A_helio=pm.H_helio*pm.W_helio
        output_metadata_motab(table=oelt, field_type=pm.field_type, aiming='single', n_helios=crs.n_helios, A_helio=A_helio, eff_annual=crs.eff_annual, eff_design=crs.eff_des, H_rcv=pm.H_rcv, W_rcv=pm.W_rcv, H_tower=pm.H_tower, Q_in_rcv=pm.Q_in_rcv, A_land=A_land, savedir=tablefile)

    return tablefile
    
def design_crs_aimingstrategy(pm):
	'''
	Design a central receiver system that requires a sophisticated aiming strategy, like molten salt or sodium systems
	MDBA method
	TBD...

	'''
	casedir=pm.casedir	
	tablefile=casedir+'/OELT_Solstice.motab'

	if not os.path.exists(casedir):
		os.makedirs(casedir)

	from mdbapy.one_key_co_optimisation import one_key_start
	from mdbapy.cal_sun import SunPosition
	from mdbapy.cal_layout_r import radial_stagger, aiming_cylinder
	from mdbapy.Deviation_aiming_new3 import aiming
	from mdbapy.Open_CSPERB import eval_v_max, Cyl_receiver
	from mdbapy.Open_CSPERB_plots import tower_receiver_plots
	from mdbapy.HC import Na
	from mdbapy.Tube_materials import Inconel740H
	from mdbapy.Flux_reader import read_data
	from mdbapy.Loss_analysis import receiver_correlation
	from mdbapy.output_motab import output_motab, output_metadata_motab
	from mdbapy.python_postprocessing import proces_raw_results, get_heliostat_to_receiver_data
	from mdbapy.SOLSTICE import SolsticeScene

	HTF=pm.HTF #'sodium' or 'salt'
	Model=one_key_start(casedir=casedir, 
		tower_h=pm.H_tower, # 150-300
		Q_rec=pm.Q_in_rcv, 
		T_in=pm.T_in,
		T_out=pm.T_out,
		HTF=pm.HTF,
		rec_material=pm.rcv_material,
		r_diameter=pm.W_rcv, #15-25 sodium, 15-30
		r_height=pm.H_rcv, #15-30 
		fluxlimitpath=pm.fluxlimitpath,
		SM=pm.SM,
		oversizing=pm.f_oversize, 	
		delta_r2=pm.delta_r2, # sw thesis last chapter
		delta_r3=pm.delta_r3, #
		hst_w=pm.W_helio, 
		hst_h=pm.H_helio,
		mirror_reflectivity=pm.helio_refl,
		slope_error=pm.slope_error,
		sunshape=pm.sunshape,
		sunshape_param=pm.sunshape_param,
		num_rays=int(pm.n_rays),
		latitude=pm.lat,
		num_bundle=int(pm.Nb))

	#Model.big_field_generation()
	#Model.annual_big_field()
	#Model.determine_field()
	'''
	if HTF=='salt':
		Model.flow_path_salt(num_bundle=int(pm.Nb), num_fp=int(pm.Nfp),D0=pm.Do, pattern='NES-NWS') 
		Model.MDBA_aiming_new(dni=pm.dni_des, phi=0.,elevation=75.89)
	else:
		Model.flow_path_sodium()
	'''
	Model.annual_trimmed_field()

	return tablefile

def convert_list(alist, delimiter=','):
	c=[]
	tmp=''
	for l in alist:
		if l==delimiter:
			c.append(tmp)
			tmp=''
		else:
			tmp+=l
	return c
    
if __name__=='__main__':
	'''
    case="./test"
    Q_in_rcv=553e6 #W
    W_helio=12.015614841
    H_helio=12.015614841
    H_tower=183.331344997
    n_row_oelt=3
    n_col_oelt=5
    R1=40.
    fb=0.4
    W_rcv=14.9999995285
    H_rcv=18.6699994131
    n_W_rcv=50
    n_H_rcv=10
    n_rays=10e6
    rcv_type='cylinder'    

    field_type='surround'
    wea_file='../../SolarTherm/Data/Weather/gen3p3_Daggett_TMY3_EES.motab'
    inputs={'casedir': case, 'Q_in_rcv':Q_in_rcv, 'W_rcv':W_rcv, 'H_rcv':H_rcv, 'H_tower':H_tower, 'wea_file':wea_file, 'n_row_oelt':n_row_oelt, 'n_col_oelt': n_col_oelt, 'rcv_type': 'cylinder', 'R1':R1, 'fb':fb, 'field_type': field_type,"n_W_rcv":n_W_rcv,"n_H_rcv":n_H_rcv, "n_rays":n_rays }

    run_simul(inputs)
	'''
	parser = argparse.ArgumentParser()
	parser.add_argument('--casedir', type=str)
	parser.add_argument('--wea_file', type=str)
	parser.add_argument('--field_type', type=str)
	parser.add_argument('--rcv_type', type=str)
	parser.add_argument('--rcv_material', type=str)
	parser.add_argument('--HTF', type=str)
	parser.add_argument('--sunshape', type=str)	
	parser.add_argument('--fluxlimitpath', type=str)	
	parser.add_argument('--num_args', type=int, default=0, 
			help="number of float arguments")
	parser.add_argument('--var_names', type=list)
	parser.add_argument('--var_vals', type=list)
		
	args = parser.parse_args()
	args.var_names=convert_list(args.var_names)
	args.var_vals=convert_list(args.var_vals)
	inputs=vars(args)
	
	for i in range(args.num_args):
		i=int(i)
		n=args.var_names[i]
		v=float(args.var_vals[i])
		inputs[n]=v
			
	del inputs['num_args']
	del inputs['var_names']
	del inputs['var_vals']

	run_simul(inputs)


