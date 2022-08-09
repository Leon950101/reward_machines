#!/bin/bash
cd ../reward_machines
for i in `seq 0 9`; # 59 
do
	# Single task baseline
	python run.py --alg=qlearning --env=Office-single-v0 --num_timesteps=1e5 --gamma=0.9 --log_path=../../results/my_results/ql/office-single/M1/$i
	python run.py --alg=qlearning --env=Office-single-v0 --num_timesteps=1e5 --gamma=0.9 --log_path=../../results/my_results/ql-rs/office-single/M1/$i --use_rs
	python run.py --alg=qlearning --env=Office-single-v0 --num_timesteps=1e5 --gamma=0.9 --log_path=../../results/my_results/crm/office-single/M1/$i --use_crm
	python run.py --alg=qlearning --env=Office-single-v0 --num_timesteps=1e5 --gamma=0.9 --log_path=../../results/my_results/crm-rs/office-single/M1/$i --use_crm --use_rs
	python run.py --alg=hrm --env=Office-single-v0 --num_timesteps=1e5 --gamma=0.9 --log_path=../../results/my_results/hrm/office-single/M1/$i
	python run.py --alg=hrm --env=Office-single-v0 --num_timesteps=1e5 --gamma=0.9 --log_path=../../results/my_results/hrm-rs/office-single/M1/$i --use_rs

	# More settings
	python run.py --alg=hrm --env=Office-single-v0 --num_timesteps=1e5 --gamma=0.9 --log_path=../../results/my_results_pk_fs/hrm/office-single/M1/$i
	python run.py --alg=hrm --env=Office-single-v0 --num_timesteps=1e5 --gamma=0.9 --log_path=../../results/my_results_pk_fs/hrm-rs/office-single/M1/$i --use_rs
	python run.py --alg=hrm --env=Office-single-v0 --num_timesteps=1e5 --gamma=0.9 --use_self_loops --log_path=../../results/my_results_pk_fs/hrm-wpk/office-single/M1/$i
	python run.py --alg=hrm --env=Office-single-v0 --num_timesteps=1e5 --gamma=0.9 --use_self_loops --log_path=../../results/my_results_pk_fs/hrm-rs-wpk/office-single/M1/$i --use_rs

done