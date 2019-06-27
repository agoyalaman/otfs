% multiple_paths;

beat_input = zeros(size(beat));  %takes dechirped value of beat as input
beat_input(1:N:length(beat_input)) = beat(1:N:length(beat_input));
beat_resampled = fftshift(fft(beat_input));
beat_lpe_freq = zeros(size(beat_resampled));
beat_lpe_freq(1:N,1) = beat_resampled(1:N,1); %low-pass filter
beat_low_pass_eq = N*ifft(beat_lpe_freq);
