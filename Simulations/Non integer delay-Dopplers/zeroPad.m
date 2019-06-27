function zeropadded = zeroPad(time_series,samp_const)

zeropadded = zeros(1,samp_const*(length(time_series)));
zeropadded(1,1:samp_const:length(time_series)*samp_const) = time_series(1,1:1:length(time_series));