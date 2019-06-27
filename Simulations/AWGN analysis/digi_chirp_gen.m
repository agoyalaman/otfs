
Sq_size = 64;
N = Sq_size;
M = Sq_size;
a = zeros(N,M);
chirp = eye(Sq_size);

invchirp = zeros(N,M);
for i = 1:M
    invchirp(:,i) = chirp(:,M+1-i);
end
xchirp = invchirp + chirp;

triangle(:,1:M) = invchirp(:,1:M);
triangle(:,M+1:2*M) = chirp(:,1:M);

imagesc(xchirp);
figure;
imagesc(triangle);
    
