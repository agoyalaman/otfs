function p_error = bpsk_AWGN(snr_db,N,M,type)

    x = randsrc(1,N*M);
    snr = 10.^(snr_db/10);
    sigma = sqrt(1 / 2 / snr);

%     y = x + sigma*randn(1, N);
    y = x + [1 1i]*sigma*randn(2,N*M);
    y_dec = zeros(1,N*M);
    err_cnt = 0;
    for i = 1:N*M
        if y(1,i) >= 0
            y_dec(1,i) = 1;
        else
            y_dec(1,i) = -1;
        end
        if y_dec(1,i) ~= x(1,i)
            err_cnt = err_cnt + 1;
        end
    end
%     err_cnt
    p_error = err_cnt/(N*M);
end


