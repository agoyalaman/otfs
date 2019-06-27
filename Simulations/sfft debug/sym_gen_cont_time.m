function x_kl = sym_gen_cont_time(mode)
%%%%% generates continuous time chirp and invchirp %%%%%

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
chirp = x_u;
invchirp = x_d;
xchirp = sqrt(2)*(0.5*invchirp + 0.5*chirp);

if mode == 1
    x_kl = 1*chirp;
elseif mode == 2
    x_kl = 1*xchirp;
elseif mode == 0
    x_kl = impulse_dD;
elseif mode == 3
    x_kl = invchirp;
end