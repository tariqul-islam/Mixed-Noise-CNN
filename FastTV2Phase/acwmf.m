function A1 = acwmf(A, O, iter)
% adaptive center median filter
% A1 = acwmf(A, O, iter)
% A is observed (noise) image, O is original image
% A1 is restored image
if nargin==2
    iter = O;
    O=zeros(size(A));
end
A = double(A);
O = double(O);
[M, N] = size(A);
B = A;
B = [B(:, 1), B, B(:, N)];  % initial boundary value
B = [B(1, :); B; B(M, :)];  % initial boundary value
switch iter
    case 4
        delta = [40, 25, 10, 5];
    case 3
        delta = [60, 45, 30, 25];
    case 2
        delta = [80, 65, 50, 45];
    case 1
        delta = [100, 85, 70, 65];
end
s = .3;
for i = 2:M+1
    for j = 2:N+1
        w = B([i-1:i+1],[j-1:j+1]);
        w = reshape(w,1,9);
        v = sort(w);
        Y = v(5);
        z = abs(B([i-1:i+1],[j-1:j+1])-Y);
        z = reshape(z,1,9);
        r = sort(z);
        MAD = r(5);
        d(1) = abs(Y - B(i,j));
        T = s*MAD + delta;
        k = 1;
        while (d(k) <= T(k)) & (k <= 3)
            w(1, [9+1:9+2*k]) = B(i, j);
            u = sort(w);
            x = u(k+4+1);
            C(i,j) = x;
            k = k+1;
            d(k) = abs(C(i,j)-B(i,j));
        end
        if d(k) <= T(k)
            B(i,j) = B(i,j); D(i,j) = 0;  % not noise candidate, set D(i, j) = 0
        else
            B(i,j) = Y; D(i,j) = 1;   % if it's noise candidate, set D(i, j) = 1
        end
    end
end
pd=D(2:M+1,2:N+1);
A1=B(2:M+1,2:N+1);
%A1=double(A1);
%A1=uint8(A1);
%figure;image(A1);colormap(repmat((0:255)'/255,1,3));axis image; % display restored image
%figure;imagesc(pd);colormap('gray');axis image; % display noise candidate