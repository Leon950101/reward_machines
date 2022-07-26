import tensorflow as tf

def grid_environment():
    return dict(
        lr=0.5,
        epsilon=0.1,
        q_init=2.0,
        hrm_lr=0.5,
        print_freq=2000)