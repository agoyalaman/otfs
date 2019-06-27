a = eye(64); %chirp in delay-Doppler
a1 = isfft(a);

b = zeros(64,64);
b(10:64,:) = a(1:55,:); %delayed d-D chirp
b(1:9,:) = a(56:64,:);

b1 = isfft(b);
