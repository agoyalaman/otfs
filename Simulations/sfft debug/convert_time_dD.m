function d_D = convert_time_dD(timeseries,N)

% convert from time domain(1,N*N) to dD symbol(square matrix of side N)
%%%%% zak transform %%%%% 
delay_time = reshape(timeseries,N,N); % serial to parallel
d_D = 1/sqrt(N)*fft(delay_time,[],2); %fft along rows


% freq_time = 1/sqrt(N)*fft(delay_time,[],1); %fft along columns
% d_D = sfft(freq_time);


% subplot(1,2,1);
% imagesc(abs(freq_time)); colorbar(); xlabel('time'); ylabel('frequency'); title('Freq-Time');
% subplot(1,2,2);
% imagesc(abs(d_D)); colorbar(); xlabel('Doppler'); ylabel('delay'); title('Delay-Doppler')
% zak()
