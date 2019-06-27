% error probability-snr curve

type = 0;
N = 100;
M = 100;
lwr_lmt = -30;
upr_lmt = 30;

snr_db = lwr_lmt : 1 : upr_lmt;
p_e_otfs = [];
p_e_theo = [];
snr = (10 .^ (snr_db/10));

for i = 1:length(snr_db)
    [p_e,a] = otfs_AWGN(snr_db(1,i),type,N,M);
    p_e_otfs = [p_e_otfs,p_e];
    p_e = bpsk_AWGN(snr_db(1,i),N,M,type);
    p_e_theo = [p_e_theo,p_e];
end


figure;
plot(snr_db,p_e_otfs,'O');
% legend('Error Probability for BPSK coded OTFS in AWGN')
hold on 
plot(snr_db,p_e_theo,'*');
% legend('Error Probability for BPSK')
theo = [];
% theo1 = [];
for i = lwr_lmt : 0.01 : upr_lmt
    snr = (10 .^ (i/10));
    err = qfunc(sqrt(2*snr));
%     err1 = 2*qfunc(sqrt(snr));
    theo = [theo,err];
%     theo1 = [theo1,err1];
    
end
plot((lwr_lmt:0.01:upr_lmt),theo,'green');
% plot((lwr_lmt:0.01:upr_lmt),theo1,'blue');
axis([lwr_lmt upr_lmt 0 0.6])
legend('Error Probability for BPSK coded OTFS in AWGN','Error Probability for BPSK','Theoratical Error Probability for BPSK')
title('Probability of error analysis under AWGN - Matched Filter');
ylabel('Error Probability');
xlabel('SNR in dB')
%%
figure();
mat = [p_e_otfs; p_e_theo];
semilogy(snr_db,mat);
%legend('Error Probability for BPSK coded OTFS in AWGN','Error Probability for BPSK'];
ylabel('Error Probability on logarithmic scale');
xlabel('SNR in dB')
title('Probability of error analysis under AWGN - Matched Filter');

%semilog plot
   