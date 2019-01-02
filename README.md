# RL_softrobot

Code for the paper 'Model-Based Reinforcement Learning for Closed-Loop Dynamic Control of Soft Robotic Manipulators' https://ieeexplore.ieee.org/abstract/document/8531756

# Code description

1. sampling.m is used to get the initial samples for learning the forward dynamic model
2. processsing.m is used for resampling the obtained data
3. rnn_2sec.m is used to learn the forward dynamic model using a RNN
4. opti.m is the optimization code used for generate multiple unique trajectories 
5. closednnsimple.m is used for learning the closed loop policy
6. The policy is tested using closedvicon.m (uses vicon for feedback)

The low level control is done using arduino (code provided)
