close all;

init = 0;
if init == 0 % initialize parameters
    delay_pos = [1 5 10 15]; %insert delays max 29
    dop_val = 0.5;
    snr_db = 10;
    del_cnst = 1; %attenuation constant of delayed path
    dop_cnst = 1;
    N = 64;
    M = N;
end
delay_vec = [1 0 0 0]; %on and off delay and Doppler paths
%                       can be seen as attenuation constants for different paths
dop_vec = [1 0 0 0]; %on and off doppler paths 

mode = input('Enter mode : ');

apply_channel_1;