if mode == 0
    xref = impulse_dD;
    dechirp;
elseif mode == 2
    xref = chirp;
    dechirp;
    [~,calc_max_chirp] = max(beat_low_pass_eq); 
    
%     close all;
    beat_chirp = beat/abs(max(beat));
    xref = invchirp;
    dechirp;
    [~,calc_max_invchirp] = max(beat_low_pass_eq);
    beat_invchirp = beat/abs(max(beat));
    
    calc_float_dop = (calc_max_invchirp - calc_max_chirp)/(2*N);
    calc_float_del = (calc_max_chirp - (N*M/2+1))/N + calc_float_dop;
    
    k = nnz(delay_vec); % number of non zero paths
    calc_delay = zeros(1,4);
    calc_doppler = zeros(1,4);
    [~,idx] = sort(delay_vec,'descend');
    
    [c1,f1] = maxk(abs(beat_chirp),k);
    [c2,f2] = maxk(abs(beat_invchirp),k);
    for i = 2:k
        if c1(i) < 0.45
            f1(i) = f1(1);
        end
        if c2(i) < 0.45
            f2(i) = f2(1);
        end
    end
    doppler = (f2-f1)/2*N; %values sorted according to path strengths
    delay = (f1-(N*M/2+1))/N + doppler; %values sorted according to path strengths
    
    for i = 1:k %sort according to actulal delay and doppler values
        calc_delay(idx(1,i)) = delay(i);
        calc_doppler(idx(1,i)) = doppler(i);
    end
end






% else
%     xref = chirp;
%     dechirp;
%     beat = beat/abs(max(beat));
%     beat_idx_chrp = [];
%     for i = 1:length(beat)
%         if abs(beat(i,1)) > corr_threshold
%             beat_idx_chrp = [beat_idx_chrp,i];
%         end
%     end
%
%     xref = invchirp;
%
%
%     dechirp;
%     beat = beat/abs(max(beat));
%     beat_idx_invchrp = [];
%     for i = 1:length(beat)
%         if abs(beat(i,1)) > corr_threshold
%             beat_idx_invchrp = [beat_idx_invchrp,i];
%         end
%     end
%
%     f1 = (beat_idx_chrp - 2049)/N;
%     if mode == 2
%         if ~ (isempty(beat_idx_invchrp))
%             f2 = (beat_idx_invchrp - 2049)/N;
%         else
%             f2 = 0;
%         end
%
%         if length(f2) == length(f1)
%             doppler = (f2(1,:) - f1(1,:))/2;
%             delay = f1 + doppler;
%         else
%             doppler = -6666;
%             delay = -6666;
%         end
%     end
%     if mode == 1
%         delay = f1;
%     end
% end
