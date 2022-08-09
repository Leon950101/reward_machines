# Reward Machines: Exploiting Reward Function Structure in Reinforcement Learning (NSRL Project Version)

Reinforcement learning (RL) methods usually treat reward functions as black boxes. As such, these methods must extensively interact with the environment in order to discover rewards and optimal policies. In most RL applications, however, users have to program the reward function and, hence, there is the opportunity to treat reward functions as white boxes instead — to show the reward function's code to the RL agent so it can exploit its internal structures to learn optimal policies faster. In the original project, they show how to accomplish this idea in two steps. First, they propose reward machines (RMs), a type of finite state machine that supports the specification of reward functions while exposing reward function structure. They then describe different methodologies to exploit such structures, including automated reward shaping, task decomposition, and counterfactual reasoning for data augmentation. Their experiments on tabular show the benefits of exploiting reward structure across different tasks and RL agents.

This code is meant to be a clean and usable version of their approach. Base on this, I am trying to discuss three issues in their work, which are:

- The influence about prior knowledge (self-loop and bad terminations) for HRM setting
- The HRM coverage sub-optimal
- The Automated Reward Shaping influence the performance of HRM

## Installation instructions

The code has the following requirements: 

- Python 3.6 or 3.7
- NumPy
- OpenAI Gym
- [OpenAI Baselines](https://github.com/openai/baselines)

However, the only *real* requirement is to have installed the master branch of Baselines. Installing baselines is not trivial, though. Their master branch only supports Tensorflow from version 1.4 to 1.14. These versions of Tensorflow seem to work fine with Python 3.6 and 3.7, but they **do not** work with Python 3.8+. We also included a [requirements.txt](requirements.txt) file as a reference, but note that such a file includes more libraries than the ones strictly needed to run our code.

## How to run the code

To run the code, move to the *reward_machines* folder and execute *run.py*. This code follows the same interface as *run.py* from [Baselines](https://github.com/openai/baselines):

```
python3 run.py --alg=<name of the algorithm> --env=<environment_id> [additional arguments]
```

However, they included the following (additional) RM-tailored algorithms (which are described in the paper). Some can be used as the value of the `--alg=` flag and some are activated with additional arguments.

- **Counterfactual Experiences for Reward Machines (CRM)**: CRM is an RM-tailored approach that uses counterfactual reasoning to generate *synthetic* experiences in order to learn policies faster. CRM can be combined with any off-policy learning method, including tabular Q-learning (`--alg=qlearning`). To use CRM, include the flag `--use_crm` when running an experiment.

- **Hierarchical RL for Reward Machines (HRM)**: HRM is an RM-tailored approach that automatically extracts a set of *options* from a RM to learn policies faster. We included implementations of tabular HRM (`--alg=hrm`). In addition to the standard learning hyperparameters, HRM uses R_min to penalize an option policy when it reaches an unwanted subgoal (this can be set with, e.g., `--r_min=-1`), R_max to reward an option policy when it reaches its target subgoal (e.g., `--r_max=1`), and another hyperparameter to define whether to learn options for the self-loops (by default, HRM does not learn options for self-loops unless the flag `--use_self_loops` is present).

- **Automated Reward Shaping (RS)**: RS is an RM-tailored approach that changes the reward from a *simple RM* so that the optimal policies remain the same but the overall reward becomes less sparse. RS can be used with tabular Q-learning (`--alg=qlearning`) and tabular HRM (`--alg=hrm`). To use RS, include the flag `--use_rs` when running an experiment. Note that RS uses two hyperparameters in determining the shaped rewards -- the same discount factor used for the environment (which can be set with, e.g., `--gamma=0.9`) and the discount factor used in calculating the potential function (e.g., `--rs_gamma=0.9`). 

For each of the different algorithms that can be named in the `--alg=` flag, default values for the hyperparameters in various environments are specified in `reward_machines/rl_agents/<name of the algorithm>/defaults.py`.

Note that RM-tailored algorithms assume that the environment is a *RewardMachineEnv* (see [reward_machines/reward_machines/rm_environment.py](reward_machines/reward_machines/rm_environment.py)). These environments define their reward function using a reward machine. They included 4 different RM environments in their code but I only need:

- **Office domain**: The office domain includes single and multi task versions (`--env=Office-single-v0` and `--env=Office-v0`, respectively). The `--env=Office-single-v0` is their original Office single task and `--env=Office-v0` is the test environment in my project.

Since the resluts on all environments and algorithms are similar, thus the discussion on this environments could be extended to others smoothly.

## Running examples and raw results

As an example, executing the following commands from the *reward_machines* folder will run multi-task experiments on the office domain:

```
python3 run.py --env=Office-v0 --num_timesteps=1e5 --gamma=0.9 --alg=qlearning                     # Tabular Q-learning: 
python3 run.py --env=Office-v0 --num_timesteps=1e5 --gamma=0.9 --alg=qlearning --use_rs            # Tabular Q-learning with reward shaping: 
python3 run.py --env=Office-v0 --num_timesteps=1e5 --gamma=0.9 --alg=qlearning --use_crm           # Tabular Q-learning with CRM 
python3 run.py --env=Office-v0 --num_timesteps=1e5 --gamma=0.9 --alg=qlearning --use_crm --use_rs  # Tabular Q-learning with CRM and reward shaping: 
python3 run.py --env=Office-v0 --num_timesteps=1e5 --gamma=0.9 --alg=hrm                           # Tabular HRM 
python3 run.py --env=Office-v0 --num_timesteps=1e5 --gamma=0.9 --alg=hrm --use_rs                  # Tabular HRM with reward shaping 
```

You can reproduce the results from report by running the scripts.

## Playing the environment

Finally, note that we included code that allows you to manually play each environment. Go to the *reward_machines* folder and run the following command (To control the agent, use the WASD keys):

```
python3 play.py --env Office-single-v0
```