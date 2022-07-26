#!/bin/bash
cd ../reward_machines
for i in `seq 0 19`; # 59 
do
	# Office Single Task
	# python run.py --alg=qlearning --env=Office-single-v0 --num_timesteps=1e5 --gamma=0.9 --log_path=../my_results_pk/ql/office-single/M1/$i
	# python run.py --alg=hrm --env=Office-single-v0 --num_timesteps=1e5 --gamma=0.9 --log_path=../my_results_pk/hrm/office-single/M1/$i
	python run.py --alg=hrm --env=Office-single-v0 --num_timesteps=1e5 --gamma=0.9 --use_self_loops=True --log_path=../my_results_pk/hrm-wpk/office-single/M1/$i
	# python run.py --alg=hrm --env=Office-single-v0 --num_timesteps=1e5 --gamma=0.9 --log_path=../my_results_pk/hrm-rs/office-single/M1/$i --use_rs
	python run.py --alg=hrm --env=Office-single-v0 --num_timesteps=1e5 --gamma=0.9 --use_self_loops=True --log_path=../my_results_pk/hrm-rs-wpk/office-single/M1/$i --use_rs
done