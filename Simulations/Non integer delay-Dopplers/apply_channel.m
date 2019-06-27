function z=apply_channel(x,fs,h_gain,h_doppler,strOpt,startTime,samp_const,N)

% apply a time-varying channel to input x
%
% H_gain or H_doppler
%
%  -----------------------> delay
%   |
%   |
%   |
%   v
%   doppler

EQUAL = 1;
RANDOM = 2;
x = resample(x,samp_const,1);
% x = zeroPad(x,samp_const);
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

% fprintf('%s',str);

for l=h_delays
    if( opt == EQUAL )
        y(l, (l - 1) + (1:Lx) ) = x .* ( h_gain(l).' * exp(1i*2*pi*(1/fs) ...
            * h_doppler(l)*( (0:Lx-1) + startTime )) );
        
%         fprintf('Delay: %f\n Doppler: %f\n', l, H_doppler(l));
    else
        temp_g = randn(1,N);
        temp_g = temp_g / sum(temp_g);
        y(l, (l - 1) + (1:Lx) ) = x .* ( h_gain(l) * temp_g  ... 
            * exp(1i*2*pi*(1/fs) ...
            *ones(100,1) *(maxD)...
            *(0:Lx-1)));
    end
end

z = sum(y,1);
z = resample(z,1,samp_const);
% z = zeroUnPad(z(1,1:length(z) - Lg + 1),samp_const);
end