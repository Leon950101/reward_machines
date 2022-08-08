#!/bin/bash
cd ../reward_machines
for i in `seq 0 9`; # 59 
do
	# Office Single Task with Bad terminations and hand made reward shaping
	python run.py --alg=hrm --env=Office-v0 --num_timesteps=1e5 --gamma=0.9 --use_self_loops --log_path=../../results/my_results_bt_rs/hrm-bt-rs/office-single/M1/$i
	python run.py --alg=hrm --env=Office-v0 --num_timesteps=1e5 --gamma=0.9 --use_self_loops --log_path=../../results/my_results_bt_rs/hrm-rs-bt-rs/office-single/M1/$i --use_rs

done