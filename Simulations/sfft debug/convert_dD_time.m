function timeseries = convert_dD_time(d_D,N)
%%%%% inverse zak transform %%%%%
delay_time = sqrt(N)*ifft(d_D,[],2);
timeseries = reshape(delay_time,1,[]);


% freq_time = isfft(d_D);
% delay_time = sqrt(N)*ifft(freq_time);