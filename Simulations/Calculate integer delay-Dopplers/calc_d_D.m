corr_threshold = 0.95;
if mode == 0 %d-D impulse
    xrx_flat = reshape(xrx,1,numel(xrx));
    xrx_flat = xrx_flat/max(xrx_flat);
    xrx = reshape(xrx_flat,N,M);
    cnt1 = 0;
    delay = [];
    doppler = [];
    temp = 0;
    for i = 1 : N
        for j = 1:M
            if  abs(xrx(i,j)) > corr_threshold
                cnt1 = cnt1 + 1;
                delay = [delay i-1];
                if j >= 32
                    temp = j-64;
                else
                    temp = j;
                end
                doppler = [doppler temp-1];
                
            end
        end
    end
else    
    xref = chirp;
    dechirp_1;
    % beat = beat/abs(max(beat));
    beat_idx_chrp = [];
    for i = 1:length(beat)
        if abs(beat(i,1)) > corr_threshold
            beat_idx_chrp = [beat_idx_chrp,i];
        end
    end
    
    xref = invchirp;
    dechirp_1;
    % beat = beat/abs(max(beat));
    beat_idx_invchrp = [];
    for i = 1:length(beat)
        if abs(beat(i,1)) > corr_threshold
            beat_idx_invchrp = [beat_idx_invchrp,i];
        end
    end
    
    f1 = (beat_idx_chrp - 2049)/64;
    if mode == 2 %x-chirp
        if ~ (isempty(beat_idx_invchrp))
            f2 = (beat_idx_invchrp - 2049)/64;
        else
            f2 = 0;
        end
        if length(f2) == length(f1)
            doppler = (f2(1,:) - f1(1,:))/2;
            delay = f1 + doppler;
        else
            doppler = -6666;
            delay = -6666;
        end
    end
    if mode == 1 %chirp
        delay = f1;
        doppler = in_doppler;
    end
end