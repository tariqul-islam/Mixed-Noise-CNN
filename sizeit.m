function y = sizeit(img)
    [M,N] = size(img);
    if M>N
        y=zeros(M,M);
    else
        y=zeros(N,N);
    end
    
    y(1:M,1:N) = img;
end