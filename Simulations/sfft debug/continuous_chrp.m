% clear all;
% close all;

% up-chirp


side = 64;
N = side*side;
nFFT = side;
n = 0:N-1;

COMP = 0;
OFDM = 0;

if( ~OFDM )
    if( COMP )
        x_u = exp(1i*2*pi*(-n/2 + n.^2/2.*(1-1/nFFT)./(N-1) ) );
        x_d = exp(1i*2*pi*(n*(1/2-1/nFFT) - n.^2/2.*(1-1/nFFT)./(N-1) ) );
    else
        x_u = exp(1i*2*pi*(-n/2 + n.^2/2.*(1)./(N-1) ) );
        x_d = exp(1i*2*pi*(n*(1/2) - n.^2/2.*(1)./(N-1) ) );    
    end
else
    
end
x_x = x_u + x_d;
X_u = reshape((x_u),nFFT,nFFT);
X_d = reshape((x_d),nFFT,nFFT);
% 
% figure;
% surf(abs(fft((X_u))));
% 
% figure;
% surf(abs(fft((X_d))));
% 

% imagesc(abs(convert_time_dD(x_u,nFFT))); colorbar(); title('upchirp');
% figure;
% imagesc(abs(convert_time_dD(x_d,nFFT))); colorbar(); title('downchirp');
figure;
% convert_time_dD(x_u,nFFT);
imagesc(abs(convert_time_dD(x_u,side)));colorbar;



