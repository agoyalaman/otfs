function [] = splot(s)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

maxI = max(max(real(s)));
maxQ = max(max(imag(s)));

maxVal = max(maxI,maxQ);

plot( real(s), imag(s), '-r', real(s), imag(s), '.b' );
title('Constellation IQ');
ylabel('Quadrature');
xlabel('In-Phase');
grid on;
axis(maxVal*[-1 1 -1 1]);

end

