N = 64;
M = N;
fs = 20e6;
strOpt = 'equal';
startTime = 0;
L = 32;
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

%%
X_nm = isfft(x_kl);
x_n = sqrt(N)*ifft(X_nm);
x = reshape(x_n,1,numel(x_n));

h_amp = delay_vec .* exp(1i*2*pi*[0 rand(1,3)]);
h_amp = h_amp ./ (sum(abs(h_amp)));
h_delays = delay_pos;
h_gain = zeros(1,max(h_delays));
h_gain(h_delays) = h_amp;
F = dop_val*fs/(N+L)/M;
h_doppler(h_delays) = dop_vec*F;



EQUAL = 1;
RANDOM = 2;
% jakes
maxD = max(max(h_doppler));
Lx = numel(x);
Lg = numel(h_gain);
h_delays = find( h_gain ~= 0 );
L = Lx+Lg-1; % number of delay paths
y = zeros(Lg,L); % init
% parse options
if( strcmp(strOpt,'equal') )
    opt = EQUAL;
    str = sprintf('Equal Gain\n');
elseif( strcmp(strOpt,'random') )
    opt = RANDOM;
    str = sprintf('Random Gain\n');
else
    fprintf('Invalid Option!\n');
    opt = -666;
end
for l=h_delays
    y(l, (l - 1) + (1:Lx) ) = x .* ( h_gain(l).' * exp(1i*2*pi*(1/fs) ...
        * h_doppler(l)*( (0:Lx-1) + startTime )) );
end
z = sum(y,1);