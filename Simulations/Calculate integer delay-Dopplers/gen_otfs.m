function [rx_del_Dop,chirp,invchirp,xchirp,impulse_dD] = gen_otfs(delay_vec,delay_pos,dop_vec,dop_val,mode,snr_db,N)

%   mode 0 : impulse in delay-Doppler
%   mode 1 : chirp
%   mode 2 : xchirp

nTrials = 1;

%% OTFS parameters
% % % % N = 64; % delay
% % % % M = 64; % doppler
M = N;

%     Nb_otfs = 8; %
Ns = N;
L = 32; %length of CP

% % % % CP_delay = 0;
% % % % CP_doppler = 0;

% % % % % set the packet detection period
% % % % Nb = min(32,M); % number of ofdm blocks

% sampling
dt = 1/20e6;
fs = 1/dt;

% tic;

for nn=1:nTrials
    
    %% channel parameters
% % % %     Lc = L; % Lc = length of the channel;
% % % %     a = 0.5;
    %     h_amp = [1 -a a^2 -a^3] .* exp(1i*2*pi*[0 rand(1,3)]); % Total 4 paths, thhe delyed paths have random phase
    h_amp = delay_vec .* exp(1i*2*pi*[0 rand(1,3)]); % Total 4 paths, thhe delyed paths have random phase
    
    %%%%h_amp = h_amp ./ sqrt(sum(h_amp.^2)); %(check: is the normalization correct? do we always get a unit norm of h_amp?
    h_amp = h_amp ./ sqrt(sum(abs(h_amp)));
    
    
    % h_amp = h_amp ./ sum(h_amp);
    %     Lc=16;
    %h_delays = [1 randi([2 Lc/4-1],1,1) randi([Lc/4 Lc/2-1],1,1) Lc-1];
    h_delays = delay_pos;
    % generates a delay profile: [1 random(2,3,4,5,6,7) random(8,9,10,11,12,13,14,15) 31]
    
    %     Lc=32;
    
    h_gains = zeros(1,max(h_delays));
    h_gains(h_delays) = h_amp; % putting normalized ampitudes at different delayed paths
    
    % 2x faster than bullet train
    F = dop_val*fs/(N+L)/M; %check
    %     F = 4*270/0.125; % (270m/s / 0.125 m) --> 972km/h @ 2.4GHz
    %     F = 138.900 / 0.125; % (138.889m/s / 0.125 m)  --> 500km/h @ 2.4GHz
    %     F = 35.76 / 0.125;
    
    % car travelling at 60mph
    %     F = 180; % (27 m/s / 0.15 meters)
    
    %         F = 2*fs;
    %h_doppler(h_delays) = [0 randn(1,numel(h_amp)-1)] * F; %original
    %h_doppler(h_delays) = [0 0.57*ones(1,numel(h_amp)-1)] * F;
    h_doppler(h_delays) = dop_vec*F;
    %h_doppler = zeros(1,32);
    
    %     h_doppler(h_delays) = [0 ones(1,numel(h_amp)-1)] * F;
    strOpt = 'equal';
    
    %% noise
    %         snr_db = 10;
    snr = 10 .^ (snr_db/10);
    sigma = sqrt(1 / 2 / snr);
    
    %% symbol generation
    %     x_kl = 0.707*(randsrc(N,M)+1i*randsrc(N,M)); %%%%%%original
    chirp = eye(N); 
    invchirp = zeros(N,M);
    for i = 1:M
        invchirp(:,i) = chirp(:,M+1-i);
    end
    xchirp = sqrt(2)*(0.5*invchirp + 0.5*chirp);
    impulse_dD = zeros(N,M);
    impulse_dD(1,1) = 8;
    if mode == 1
        x_kl = 1*chirp;
    elseif mode == 2
        x_kl = 1*xchirp;
    elseif mode == 0
        x_kl = impulse_dD;
    end
    X_nm = isfft(x_kl); % converts delay-doppler symbol x_kl to freq time equivalent
%     figure;
%     subplot(1,2,1);
%     imagesc(abs(X_nm));
%     subplot(1,2,2);
%     imagesc(angle(X_nm));
    [Y_nm,snr_otfs,s_n,r] = ofdm(X_nm,sigma,Ns,L,fs,h_gains,h_doppler,strOpt,1,0.00/fs);
    
    % convert to delay doppler
    y_kl = sfft(Y_nm);
%     figure;
%     imagesc(abs(Y_nm));
    rx_del_Dop = y_kl;
    
    
    dummy = 1;
    while dummy       % added so that the code looks cleaner
        %         imagesc(x_kl);
        %  -----------------------> delay
        %   |            (l)
        %   |
        %   |
        %   |(k)
        %   |
        %   |
        %   v
        %   doppler
        
        %% OTFS precoder
        
        % % % %     S_nm_tr = ones(N,M);
        % add "CP"
        % % % %     X_nm = isfft(x_kl); % converts delay-doppler symbol x_kl to freq time equivalent
        % % % %     X_nm_tr = S_nm_tr; % sending all ones
        % % % %     X_nm_ofdm = x_kl; % sending BPSK data
        % % % %     t_offset = 0;
        % training sequence
        % % % %     [Y_nm_tr0,~,~,~] = ofdm(X_nm_tr,sigma,Ns,L,fs,h_gains,h_doppler,strOpt,0,0);
        % % % %     H_nm_tr0 = Y_nm_tr0 ./ (X_nm_tr);
        
        % % % %     [Y_nm_tr,snr3,s_n_tr,r_tr] = ofdm(X_nm_tr,sigma,Ns,L,fs,h_gains,h_doppler,strOpt,0,t_offset);
        % % % %     H_nm_tr = Y_nm_tr ./(X_nm_tr);
        %     figure; surf(db( H_nm_tr0 - H_nm_tr ) )
        % % % %     H_nm_tr_shifted = circshift(H_nm_tr,round(t_offset/(N+L)),2);
        % % % %     X_nm_ofdm_pd = X_nm_ofdm  .* conj(H_nm_tr_shifted) ./ ( abs(H_nm_tr_shifted).^2 + sigma.^2);
        
        % % % %     %%
        % % % %     %otfs --> ofdm
        % % % %     [Y_nm,snr_otfs,s_n,r] = ofdm(X_nm,sigma,Ns,L,fs,h_gains,h_doppler,strOpt,1,0.00/fs);
        % % % %
        % % % %     % convert to delay doppler
        % % % %     y_kl = sfft(Y_nm);
        % % % %     rx_del_Dop = y_kl;
        
        
        %         %% Equalization
        %         % experiment with training sequence
        %
        %         % otfs equalize
        % % % % % %         H_nm_needed = Y_nm ./ (X_nm);
        % % % % % %
        % % % % % %
        % % % % % %         Y_eq = Y_nm .* conj(H_nm_tr_shifted) ./ ( abs(H_nm_tr_shifted).^2 + sigma.^2);
        % % % % % %
        % % % % % %         % otfs demod
        % % % % % %         y_kl_eq = sfft(Y_eq);
        % % % % % %
        % % % % % %         Hdiff = (abs(H_nm_needed-H_nm_tr));
        % % % % % %         avg_Hdiff_db(nn) = db(mean(mean(Hdiff))./mean(mean(abs(H_nm_needed))));
        %
        %         %% otfs cp removal
        % % % % % %         x_kl = x_kl( 1+CP_delay:end-CP_delay, 1+CP_doppler:end-CP_doppler );
        % % % % % %         y_kl_eq = y_kl_eq( 1+CP_delay:end-CP_delay, 1+CP_doppler:end-CP_doppler );
        % % % % % %
        % % % % % %         %% calculate evm
        % % % % % %         sym_pwr = mean(abs(x_kl(:) ).^2);
        % % % % % %
        % % % % % %         evm_otfs(nn) = mean(abs(x_kl(:) - y_kl_eq(:)).^2);
        % % % % % %
        % % % % % %         evm_ofdm_temp = (abs(X_nm_ofdm_blocks(:) - Y_nm_ofdm_blocks_eq(:)).^2);
        % % % % % %         evm_ofdm_temp = evm_ofdm_temp( evm_ofdm_temp ~= inf ); % remove values from divide by zero
        % % % % % %         evm_ofdm(nn) = mean(evm_ofdm_temp);
        % % % % % %
        % % % % % %         evm_ofdm_pd_temp = (abs(Y_nm_ofdm_pd(:) - X_nm_ofdm(:)).^2);
        % % % % % %         evm_ofdm_pd_temp = evm_ofdm_pd_temp( evm_ofdm_pd_temp ~= inf ); % remove values from divide by zero
        % % % % % %         evm_ofdm_pd(nn) = mean(evm_ofdm_pd_temp);
        %
        % % % % % %         if( ~mod(nn,100) )
        % % % % % %
        % % % % % %             fprintf('\nSNR(db) = %f\n',snr_db);
        % % % % % %             fprintf('\nOTFS EVM (dB): %f\nOFDM EVM (dB): %f\n', 10*log10(evm_otfs(nn)./sym_pwr), 10*log10(evm_ofdm(nn)));
        % % % % % %             fprintf('OTFS_pd EVM (dB): %f\n', 10*log10(evm_ofdm_pd(nn)./sym_pwr));
        % % % % % %             fprintf('Doppler Parameter: %f\n', F);
        % % % % % %
        % % % % % %             fprintf('\nIteration (%d/%d)\n',nn,nTrials);
        % % % % % %
        % % % % % %             toc;
        % % % % % %         end
        % % % % % %
        % % % % % %         % remove zero entries (i.e. the CP or useless data)
        % % % % % %         y_kl_save = y_kl_eq;
        % % % % % %         y_kl_eq = y_kl_eq( y_kl_eq ~= 0 );
        dummy = 0;
    end
    dummy = 1;
    
end
while dummy             % added so that the code looks cleaner
    %% calculate CDF
    % % % % %     cdfMin = -snr_db;
    % % % % %     cdfMax = 10;
    % % % % %     cdfN = 1e5;
    % % % % %     cdf_a = linspace(cdfMin,cdfMax,cdfN);
    % % % % %
    % % % % %     % pre-allocate
    % % % % %     cdf_ofdm = zeros(1,cdfN);
    % % % % %     cdf_otfs = zeros(1,cdfN);
    % % % % %     cdf_ofdm_pd = zeros(1,cdfN);
    % % % % %
    % % % % %     evm_ofdm_db = 10*log10(evm_ofdm);
    % % % % %     evm_otfs_db = 10*log10(evm_otfs);
    % % % % %     evm_ofdm_pd_db = 10*log10(evm_ofdm_pd);
    
    % % % % %     for n=1:cdfN
    % % % % %         cdf_ofdm(n) = sum(evm_ofdm_db < cdf_a(n));
    % % % % %         cdf_ofdm_pd(n) = sum(evm_ofdm_pd_db < cdf_a(n));
    % % % % %         cdf_otfs(n) = sum(evm_otfs_db < cdf_a(n));
    % % % % %     end
    % % % % %
    % % % % %     cdf_ofdm = cdf_ofdm / nTrials;
    % % % % %     cdf_otfs = cdf_otfs / nTrials;
    % % % % %     cdf_ofdm_pd = cdf_ofdm_pd / nTrials;
    % % % % %
    % % % % %     figure;
    % % % % %     plot(cdf_a, cdf_ofdm, cdf_a, cdf_ofdm_pd, cdf_a, cdf_otfs);
    % % % % %     xlabel('Average EVM^2 (dB)')
    % % % % %     ylabel('CDF');
    % % % % %     title(sprintf('OFDM/OTFS EVM Comparison, SNR_{dB} = %d',snr_db));
    % % % % %     legend('OFDM','OFDM w/ PreD','OTFS','location','northwest');
    % % % % %     grid on;
    
    % % % % %     %% surf plots
    % % % % %     figure;
    % % % % %     surf(db(y_kl_save));
    % % % % %
    % % % % %     % figure;
    % % % % %     % surf(db(H_nm_tr)); title('H training');
    % % % % %     % figure;
    % % % % %     % surf(db(H_nm_needed)); title('H needed');
    % % % % %     % figure;
    % % % % %     % surf(db(Hdiff)); title('H Difference');
    % % % % %     %
    % % % % %     figure;
    % % % % %     subplot(131);
    % % % % %     splot(Y_nm_ofdm_pd(:));
    % % % % %     title('OFDM w/ DD Predistortion no CP');
    % % % % %     axis([-2 2 -2 2]);
    % % % % %
    % % % % %     subplot(132);
    % % % % %     splot(Y_nm_ofdm_blocks_eq(:));
    % % % % %     title('OFDM w/ OFDM Equalization');
    % % % % %     axis([-2 2 -2 2]);
    % % % % %
    % % % % %     subplot(133);
    % % % % %     splot(y_kl_eq(:));
    % % % % %     title('OTFS w/ OTFS Equalization');
    % % % % %     axis([-2 2 -2 2]);
    dummy = 0;
end
% toc;
end