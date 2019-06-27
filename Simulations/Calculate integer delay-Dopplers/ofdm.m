function [Y_nm, snr, s_n,r ]= ofdm(X_nm,sigma,Ns,L,fs,h_gain,h_doppler,strOpt,bTraining,startPhase)

% L: CP length
% sigma: noise std dev
% M: FFT size
% N: number of OFDM blocks
% strOpt: equal

% check dimensions
[N,M] = size(X_nm);

% reshape the matrix based on # of subcarriers
Nr = M;
X_shaped = reshape(X_nm, Ns, Nr);

% ofdm modulator
x_n = sqrt(Ns)*ifft(X_shaped);

% add CP
x_n_cp = zeros(L+Ns,Nr);
x_n_cp((L+1):end, :) = x_n;
x_n_cp( 1:L, : ) = x_n_cp( (Ns+1):end, : );

% P to S
s_n = reshape(x_n_cp,1,numel(x_n_cp));

% apply channel
r = apply_channel(s_n,fs,h_gain,h_doppler,strOpt,startPhase);
r = r(1:numel(s_n));        % clip length

% add noise
if( bTraining)
    sigma_new = sqrt( var(s_n) / 2 / (1/2/sigma^2));
else
    sigma_new = sigma;
end

save_noise = [1 1i] * sigma_new*randn(2,numel(r));

r_n = r + save_noise;
% % % % r_n = r;
snr= 10*log10(var(r)./var(save_noise));

% ofdm demod
r_sp = reshape(r_n, L+Ns,Nr);

% remove CP
r_nocp = r_sp( (L+1):end, :);
Y_nm = (1/sqrt(Ns))*fft(r_nocp);

% reshape the matrix based on # of subcarriers
Y_nm = reshape(Y_nm, N, M);

end


