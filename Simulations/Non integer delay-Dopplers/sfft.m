function x_kl = sfft(X_nm)
% Implement the Inverse Symplectic Fourier Transform   

[N,M] = size(X_nm);

x_kl = sqrt(1/N/M)*N*ifft(fft(X_nm,[],2),[],1);

end

%
%   ----------------------> fft
%   |
%   |
%   |
%   v
%   ifft