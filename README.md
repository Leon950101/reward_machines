# Reward Machines (Compact Version)

Reinforcement learning (RL) methods usually treat reward functions as black boxes. As such, these methods must extensively interact with the environment in order to discover rewards and optimal policies. In most RL applications, however, users have to program the reward function and, hence, there is the opportunity to treat reward functions as white boxes instead — to show the reward function's code to the RL agent so it can exploit its internal structures to learn optimal policies faster. In this project, we show how to accomplish this idea in two steps. First, we propose reward machines (RMs), a type of finite state machine that supports the specification of reward functions while exposing reward function structure. We then describe different methodologies to exploit such structures, including automated reward shaping, task decomposition, and counterfactual reasoning for data augmentation. Our experiments on tabular show the benefits of exploiting reward structure across different tasks and RL agents. 

This code is meant to be a clean and usable version of our approach. If you find any bugs or have questions about it, please let us know. We'll be happy to help you!


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

However, we included the following (additional) RM-tailored algorithms (which are described in the paper). Some can be used as the value of the `--alg=` flag and some are activated with additional arguments.

- **Counterfactual Experiences for Reward Machines (CRM)**: CRM is an RM-tailored approach that uses counterfactual reasoning to generate *synthetic* experiences in order to learn policies faster. CRM can be combined with any off-policy learning method, including tabular Q-learning (`--alg=qlearning`). To use CRM, include the flag `--use_crm` when running an experiment.

- **Hierarchical RL for Reward Machines (HRM)**: HRM is an RM-tailored approach that automatically extracts a set of *options* from a RM to learn policies faster. We included implementations of tabular HRM (`--alg=hrm`). In addition to the standard learning hyperparameters, HRM uses R_min to penalize an option policy when it reaches an unwanted subgoal (this can be set with, e.g., `--r_min=-1`), R_max to reward an option policy when it reaches its target subgoal (e.g., `--r_max=1`), and another hyperparameter to define whether to learn options for the self-loops (by default, HRM does not learn options for self-loops unless the flag `--use_self_loops` is present).

- **Automated Reward Shaping (RS)**: RS is an RM-tailored approach that changes the reward from a *simple RM* so that the optimal policies remain the same but the overall reward becomes less sparse. RS can be used with tabular Q-learning (`--alg=qlearning`) and tabular HRM (`--alg=hrm`). To use RS, include the flag `--use_rs` when running an experiment. Note that RS uses two hyperparameters in determining the shaped rewards -- the same discount factor used for the environment (which can be set with, e.g., `--gamma=0.9`) and the discount factor used in calculating the potential function (e.g., `--rs_gamma=0.9`). 

For each of the different algorithms that can be named in the `--alg=` flag, default values for the hyperparameters in various environments are specified in `reward_machines/rl_agents/<name of the algorithm>/defaults.py`.

Note that RM-tailored algorithms assume that the environment is a *RewardMachineEnv* (see [reward_machines/reward_machines/rm_environment.py](reward_machines/reward_machines/rm_environment.py)). These environments define their reward function using a reward machine. We included the following RM environments in our code:

- **Office domain**: The office domain includes single and multi task versions (`--env=Office-single-v0` and `--env=Office-v0`, respectively).

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

You can reproduce the results from our paper by running the scripts located at the *scripts* folder. We also included all the raw data from the experiments that we report in the paper. Those results are located at the *results* folder.


## Exporting results

You can export a summary of the results by running the following command (from the *reward_machines* folder) after all the experiments are done:

```
python3 export_results.py
```

By default, that code will use the results that are saved at the *results* folder. The summaries will be saved on *results/summary*. 

## Computing optimal policies using value iteration

To normalize the results on the tabular domains, we computed the optimal policies using value iterations by executing the following commands from the *reward_machines* folder:

```
python3 test_optimal_policies.py --env <environment_id>
```

where `<environment_id>` can be any of the tabular environments.


## Playing each environment

Finally, note that we included code that allows you to manually play each environment (except for the Half-Cheetah). Go to the *reward_machines* folder and run the following command:

```
python3 play.py --env <environment_id>
```

where `<environment_id>` can be any of the office, craft, or water domains. To control the agent, use the WASD keys. The environments are described in the paper.
