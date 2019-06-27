function [p_bit_error, pkt_error] = otfs_AWGN(snr_db,type,N,M)
   % type = 0 for BPSK, 
   % type = 1 for QPSK
%     N = 1000; %Delay
%     M = 1000; %Doppler

%
%   -----------------------> Doppler
%   |
%   |
%   |
%   v
%   delay
    
    if type
        mult = 1/sqrt(2);
        x_kl = mult.*(randsrc(N,M) + 1i*randsrc(N,M)); %delay-Doppler QPSK symbol
    else
        mult = 1;
        x_kl = randsrc(N,M); %delay-Doppler BPSK symbol
    end
%     eb = ((x_kl(:))'*x_kl(:))/length(x_kl(:));
    %imagesc(x_kl);
    x_nm = sfft(x_kl); %Frequency-time symbol (Converting d-D symbol to f-t using ISFFT)
    x_tr_del_t = ifft(x_nm, N, 1); %(Converting f-t symbol to delay-time using IFFT) ifft along column
    x_tr_vec = reshape(x_tr_del_t,1,numel(x_tr_del_t)); % (Time series data)
    %energy_per_symb = abs(x_tr_vec*(x_tr_vec).')/(length(x_tr_vec))
    x_tr_vec = x_tr_vec.*sqrt(N);
    
    %scatter(real(x_tr_vec), imag(x_tr_vec));
    %%%%%%%%%%%%%%%% add noise %%%%%%%%%%%%%%%%%%
    snr = (10 .^ (snr_db/10));
    sigma = sqrt(1 / 2 / snr);
    y_rx_vec = x_tr_vec + [1 1i]*sigma*randn(2,numel(x_tr_vec)); %adding complex noise to the received time series)
%     figure();
%     scatter(real(y_rx_vec), imag(y_rx_vec));
    
    
    y_rx_del_t = reshape(y_rx_vec,size(x_tr_del_t)); %(rearranging the received time series back to delay-time)
    y_nm = fft(y_rx_del_t, N, 1); %Converting to f-t usinf FFT)
    y_kl = isfft(y_nm); %Converting back to d-D using SFFT
    
    %%%%%%%%%%%%%%% decoding %%%%%%%%%%%%%%%%%%%%
    re_y_kl_dec = zeros(size(y_kl));
    im_y_kl_dec = zeros(size(y_kl));
    y_kl_dec = zeros(size(y_kl));
    dim = size(y_kl);
    symb_error_cnt = 0;
    pkt_error = 0;
    for i = 1:dim(1)
        for j = 1:dim(2)
            if real(y_kl(i,j)) >= 0
                re_y_kl_dec(i,j) = 1;
            else
                re_y_kl_dec(i,j) = -1;
            end
            
            if type
                if imag(y_kl(i,j)) >= 0
                    im_y_kl_dec(i,j) = 1;
                else
                    im_y_kl_dec(i,j) = -1;
                end
            end
            
            y_kl_dec(i,j) = re_y_kl_dec(i,j) + 1i*im_y_kl_dec(i,j);
            
            if mult*y_kl_dec(i,j) ~= x_kl(i,j)
                symb_error_cnt = symb_error_cnt + 1;
            end
        end
    end
%     figure();
%     plot(y_kl_dec);
    %%%%%%%%%%%%%% calculating error probability %%%%%%%%%%%%%%%%
    p_bit_error = symb_error_cnt/((type+1)*N*M);
    
    if symb_error_cnt ~= 0
        pkt_error = 1;
    end

    %figure;
    %imagesc(y_kl_dec);

end
