clear all;

close all;

init = 0;
if init == 0 % initialize parameters
    N = 64; %give even value
    M = N;
    samp_const = 1;
    delay_pos = [1 2 10 15]; %insert delays max 29
    delay_pos = (delay_pos)*samp_const;
    dop_val = 1;
    dop_val = dop_val/samp_const;
    snr_db = 15;
end
% delay_vec = [1 0.6 0.7 0.8]; %on and off delay and Doppler paths
%                       can be seen as attenuation constants for different paths
% delay_vec = [1 0 0 0];
delay_vec = [1 0 0 0]; %amplitudes of different paths
dop_vec = [1/70 0.01 0 0]; %on and off doppler paths 

% % % % mode = input('Enter mode : ');
mode = 2;
% mode = 1;
[xrx,chirp,invchirp,xchirp,impulse_dD] = gen_otfs(delay_vec,delay_pos,dop_vec,dop_val,mode,snr_db,N,samp_const);
% corr_threshold = 0.6;


calculate_d_D;
% % % % if mode == 0
% % % % %     xrx_flat = reshape(xrx,1,numel(xrx));
% % % % %     xrx_flat = xrx_flat/max(xrx_flat);
% % % % %     xrx = reshape(xrx_flat,N,M);
% % % % %     cnt1 = 0;
% % % % %     delay = [];
% % % % %     doppler = [];
% % % % %     temp = 0;
% % % % %     for i = 1 : N
% % % % %        for j = 1:M
% % % % %           if  abs(xrx(i,j)) > corr_threshold
% % % % %               cnt1 = cnt1 + 1;
% % % % %               delay = [delay i-1];
% % % % %               if j >= 32 
% % % % %                   temp = j-64;
% % % % %               else 
% % % % %                   temp = j;
% % % % %               end
% % % % %               doppler = [doppler temp-1];
% % % % %               
% % % % %           end
% % % % %        end
% % % % %     end
% % % %     
% % % %      xref = impulse_dD;
% % % % %     %      xref = chirp;
% % % %      dechirp;
% % % % % imagesc(abs(xrx));
% % % % else
% % % %     xref = chirp;
% % % %     dechirp;
% % % %     beat = beat/abs(max(beat));
% % % %     beat_idx_chrp = [];
% % % %     for i = 1:length(beat)
% % % %         if abs(beat(i,1)) > corr_threshold
% % % %             beat_idx_chrp = [beat_idx_chrp,i];
% % % %         end
% % % %     end
% % % %     
% % % %     xref = invchirp;
% % % % %     xref = xchirp;
% % % %     dechirp;
% % % %     beat = beat/abs(max(beat));
% % % %     beat_idx_invchrp = [];
% % % %     for i = 1:length(beat)
% % % %         if abs(beat(i,1)) > corr_threshold
% % % %             beat_idx_invchrp = [beat_idx_invchrp,i];
% % % %         end
% % % %     end
% % % %     
% % % %     f1 = (beat_idx_chrp - 2049)/64;
% % % %     if mode == 2
% % % %         if ~ (isempty(beat_idx_invchrp))
% % % %             f2 = (beat_idx_invchrp - 2049)/64;
% % % %         else
% % % %             f2 = 0;
% % % %         end
% % % %         
% % % %         if length(f2) == length(f1)
% % % %             doppler = (f2(1,:) - f1(1,:))/2;
% % % %             delay = f1 + doppler;
% % % %         else
% % % %             doppler = -6666;
% % % %             delay = -6666;
% % % %         end
% % % %     end
% % % %     if mode == 1
% % % %         delay = f1;
% % % %     end
% % % % end



