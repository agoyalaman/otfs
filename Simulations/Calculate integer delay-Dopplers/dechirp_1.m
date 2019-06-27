ref= xref;
rx = xrx;
ref_t_vec = [];
rx_t_vec = [];
for i = 1:64
    b = 8*ifft(ref(:,i));
    ref_t_vec = [ref_t_vec;b];
    c = 8*ifft(rx(:,i));
    rx_t_vec = [rx_t_vec;c];
end
mixer = rx_t_vec.*conj(ref_t_vec);
beat = fftshift(fft(mixer));
beat = beat/abs(max(beat));