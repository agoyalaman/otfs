N = 64;

mode = input('mode: Enter 0 for d-D impulse, 1 for chirp, 2 for xchirp : ');

paths = input('path: Enter [1 0 0 0] for LOS \n [0 1 0 0] for blocked LOS \n [1 1 0 0] for two-path : ');
dop_vec = paths;
delay_vec = paths;

delay_val = input('delay in second path (< (N/2-1) ) ; 1 for no delay: ');
delay_pos = [1 delay_val 15 31];

att_cnst = input('0 <= att_cnst < 1: Enter attenuation constant for delayed path : ');
delay_vec(1,2) = delay_vec(1,2)*att_cnst;
% dop_vec = [1 att_cnst 0 0];

dop_val = input('Doppler in second path:  -(N/2-1) < Doppler < (N/2-1) ; 0 for no Doppler: ');

snr_db = input('snr_db: Enter SNR value in dB : ');

%%
[xrx,chirp,invchirp,xchirp,impulse_dD] = gen_otfs(delay_vec,delay_pos,dop_vec,dop_val,mode,snr_db,N);

xref = chirp;
dechirp;
beat_idx_chrp = [];
for i = 1:length(beat)
    if abs(beat(i,1)) > 20
        beat_idx_chrp = [beat_idx_chrp,i];
    end
end

xref = invchirp;
dechirp;
beat_idx_invchrp = [];
for i = 1:length(beat)
    if abs(beat(i,1)) > 20
        beat_idx_invchrp = [beat_idx_invchrp,i];
    end
end

f1 = beat_idx_chrp - 2049;
if length(beat_idx_invchrp) ~= 0
    f2 = beat_idx_invchrp - 2049;
else
    f2 = 0;
end

doppler = (f2(1,:) - f1(1,:))./(N*2);
delay = f1/64 + doppler;