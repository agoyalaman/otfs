function time_series = zeroUnPad(zeropadded,samp_const)

time_series = zeros(1,length(zeropadded)/samp_const);
time_series(1,1:1:length(time_series)) = zeropadded(1,1:samp_const:length(time_series)*samp_const);