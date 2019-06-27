clear all;
close all;

init = 0;
if init == 0 % initialize parameters
    delay_pos = [1 1 3 4];
    dop_val = 1; %number of units Doppler
    snr_db = 10;
    N = 64;
    M = N;
end
delay_vec = [0 1 0 0]; %delay and Doppler paths (nLOS) magnitudes (input in descending)
dop_vec = [1 1.6 1 1]; %doppler paths values

% mode = input('Enter mode : ');
mode = 2;
[xrx,chirp,invchirp,xchirp,impulse_dD] = gen_otfs(delay_vec,delay_pos,dop_vec,dop_val,mode,snr_db,N);
corr_threshold = 0.95;

calculate_d_D;






% if mode == 0
%      xref = impulse_dD;
%      dechirp;
% else 
%     xref = chirp;
%     dechirp;
%     beat = beat/abs(max(beat));
%     beat_idx_chrp = [];
%     for i = 1:length(beat)
%         if abs(beat(i,1)) > corr_threshold
%             beat_idx_chrp = [beat_idx_chrp,i];
%         end
%     end
%     
%     xref = xchirp;
%     
%     
%     dechirp;
%     beat = beat/abs(max(beat));
%     beat_idx_invchrp = [];
%     for i = 1:length(beat)
%         if abs(beat(i,1)) > corr_threshold
%             beat_idx_invchrp = [beat_idx_invchrp,i];
%         end
%     end
%     
%     f1 = (beat_idx_chrp - 2049)/64;
%     if mode == 2
%         if ~ (isempty(beat_idx_invchrp))
%             f2 = (beat_idx_invchrp - 2049)/64;
%         else
%             f2 = 0;
%         end
%         
%         if length(f2) == length(f1)
%             doppler = (f2(1,:) - f1(1,:))/2;
%             delay = f1 + doppler;
%         else
%             doppler = -6666;
%             delay = -6666;
%         end
%     end
%     if mode == 1
%         delay = f1;
%     end
% end


