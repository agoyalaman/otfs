if mode == 0
    xref = impulse_dD;
    dechirp;
elseif mode == 2
    xref = chirp;
    dechirp;
    beat_chirp = beat/abs(max(beat));
    xref = invchirp;
    dechirp;
    beat_invchirp = beat/abs(max(beat));
    calc_doppler = zeros(1,4);
    calc_delay = zeros(1,4);
    f1 = zeros(1,4);
    f2 = zeros(1,4);
    for i = 1 : 4
        if delay_vec(1,i) ~= 0
            corr_threshold = 0.9*delay_vec(1,i);
            [~,f1(1,i)] = max(abs(beat_chirp));
            %             [~,f2(1,i)] = findpeaks(abs(beat_invchirp),'threshold',corr_threshold);
            [~,f2(1,i)] = max(abs(beat_invchirp));
            beat_chirp(f1(1,i),1) = beat_chirp(f1(1,i),1)*0;
            beat_invchirp(f2(1,i),1) = beat_invchirp(f2(1,i),1)*0;
            calc_doppler(1,i) = (f2(1,i)-f1(1,i))/128;
            calc_delay(1,i) = (f1(1,i)-2049)/64 + calc_doppler(1,i);
        end
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
%     f1 = (beat_idx_chrp - 2049)/64;
%     if mode == 2
%         if ~ (isempty(beat_idx_invchrp))
%             f2 = (beat_idx_invchrp - 2049)/64;
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
