% if init == 1
    delay_pos = [1 10 15 31];
    dop_val = 10;
    snr_db = 1000;
    del_cnst = 0.5; %attenuation constant of delayed path
    dop_cnst = 0.55;
    N = 64;
% end
%% Only Delay
delay_vec = [1 del_cnst 0 0]; %signle path delay with LOS 
dop_vec = [0 0 0 0];

mode = 1;
[chirp_del1_dop0_los,~,~,~,~] = gen_otfs(delay_vec,delay_pos,dop_vec,dop_val,mode,snr_db,N);
figure(1);
title('check');
subplot(2,2,1);
imagesc(abs(chirp_del1_dop0_los));colorbar;
title('chirp del1 dop0: LOS');
ylabel('delay');
xlabel('Doppler');

mode = 2;
[xchirp_del1_dop0_los,~,~,~,~] = gen_otfs(delay_vec,delay_pos,dop_vec,dop_val,mode,snr_db,N);
% figure(2);
subplot(2,2,2);
imagesc(abs(xchirp_del1_dop0_los));colorbar;
title('xchirp del1 dop0: LOS')
ylabel('delay');
xlabel('Doppler');

%%
delay_vec = [0 1 0 0]; %signle path delay with LOS blocked
dop_vec = [0 0 0 0];

mode = 1;
[chirp_del1_dop0_nlos,~,~,~,~] = gen_otfs(delay_vec,delay_pos,dop_vec,dop_val,mode,snr_db,N);
%figure(1);
subplot(2,2,3);
imagesc(abs(chirp_del1_dop0_nlos));colorbar;
title('chirp del1 dop0: nLOS');
ylabel('delay');
xlabel('Doppler');

mode = 2;
[xchirp_del1_dop0_nlos,~,~,~,~] = gen_otfs(delay_vec,delay_pos,dop_vec,dop_val,mode,snr_db,N);
% figure(2);
subplot(2,2,4);
imagesc(abs(xchirp_del1_dop0_nlos));colorbar;
title('xchirp del1 dop0: nLOS')
ylabel('delay');
xlabel('Doppler');


%% Only Doppler
delay_vec = [1 0 0 0]; %signle path delay with LOS 
dop_vec = [dop_cnst 0 0 0];

mode = 1;
[chirp_del0_dop1_los,~,~,~,~] = gen_otfs(delay_vec,delay_pos,dop_vec,dop_val,mode,snr_db,N);
figure(2);
subplot(2,2,1);
imagesc(abs(chirp_del0_dop1_los));colorbar;
title('chirp del0 dop1: LOS');
ylabel('delay');
xlabel('Doppler');

mode = 2;
[xchirp_del0_dop1_los,~,~,~,~] = gen_otfs(delay_vec,delay_pos,dop_vec,dop_val,mode,snr_db,N);
% figure(2);
subplot(2,2,2);
imagesc(abs(xchirp_del0_dop1_los));colorbar;
title('xchirp del0 dop1: LOS')
ylabel('delay');
xlabel('Doppler');

%%
delay_vec = [0 1 0 0]; %signle path delay and Doppler (nLOS) 
dop_vec = [0 dop_cnst 0 0];

mode = 1;
[chirp_del1_dop1_nlos,~,~,~,~] = gen_otfs(delay_vec,delay_pos,dop_vec,dop_val,mode,snr_db,N);
%figure(1);
subplot(2,2,3);
imagesc(abs(chirp_del1_dop1_nlos));colorbar;
title('chirp del1 dop1: nLOS');
ylabel('delay');
xlabel('Doppler');

mode = 2;
[xchirp_del1_dop1_nlos,~,~,~,~] = gen_otfs(delay_vec,delay_pos,dop_vec,dop_val,mode,snr_db,N);
 figure(2);
subplot(2,2,4);
imagesc(abs(xchirp_del1_dop1_nlos));colorbar;
title('xchirp del1 dop1: LOS blocked')
ylabel('delay');
xlabel('Doppler');





