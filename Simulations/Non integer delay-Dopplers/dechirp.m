%%%% This script takes a delay-Doppler symbol and a reference delay-Doppler
%%%% symbol and prforms a de-chirp 


% function dechirp(xref,xrx)

    %  -----------------------> Doppler <--> time
    %   |            (l)
    %   |
    %   |
    %   |(k)
    %   |
    %   |
    %   v
    %   delay <--> frequeny


% % % %     figure();
% % % %     ref = eye(64);
    ref= (xref);
% % % %     figure();
% % % %     imagesc(ref);
    rx = (xrx);
% % % %     rx = zeros(64,64);
% % % %     rx(:,10:64) = ref(:,1:55);
% % % %     rx(:,5:64) = ref(:,1:60);
% % % %     rx(:,1:50) = ref(:,15:64);
% % % %     rx(:,1:4) = ref(:,61:64);
% % % %     imagesc(rx);
% % % %     figure();
    ref_t_vec = [];
    rx_t_vec = [];
    for i = 1:N
        temp1 = sqrt(N)*ifft(ref(:,i)); % ifft along columns 
        ref_t_vec = [ref_t_vec;temp1];
        temp2 = sqrt(N)*ifft(rx(:,i));
        rx_t_vec = [rx_t_vec;temp2];
    end
% for i = 1:64
%         b = fft(ref(:,i)); % ifft along columns 
%         ref_t_vec = [ref_t_vec;b];
%         c = fft(rx(:,i));
%         rx_t_vec = [rx_t_vec;c];
%     end


    mixer = rx_t_vec.*conj(ref_t_vec);
%     figure;
%     plot(abs(mixer));
    % plot(real(ref_t_vec));
    % figure;
    % plot(real(rx_t_vec));
    % figure();
%     beat = fftshift(fft(mixer(2017:2080),64));
    beat = fftshift(fft(mixer));
    beat = beat/abs(max(beat));
    beat_low_pass;  %to calculate non integer values of delay-Doppler
    figure();
    subplot(2,2,1);
    imagesc(abs(xref)); colorbar;
    title('Reference Signal');
    subplot(2,2,2);
    imagesc(abs(xrx)); colorbar;
    title('Received Signal');
    subplot(2,2,3);
    plot(abs(beat_low_pass_eq));
    title('Calculate non integer delay-Doppler');
%     plot(unwrap(angle(beat)));
%     title('Phase plot of fft of mixed signal');
    subplot(2,2,4);
    plot(abs(beat));
    title('Magnitude plot of fft of mixed signal');
%     figure(33 + mode);
%     imagesc(angle(xrx));
% end
