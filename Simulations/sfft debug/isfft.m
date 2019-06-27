function X_nm = isfft(x_kl)
% Implement the Inverse Symplectic Fourier Transform   

[N,M] = size(x_kl);

X_nm = sqrt(1/N/M)*fft(M*ifft(x_kl,[],2),[],1);

end

