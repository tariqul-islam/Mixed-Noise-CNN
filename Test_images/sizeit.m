function y = sizeit(img)
    [M,N] = size(img);
    if M>N
        y=zeros(M,M);
        sc = floor((M-N)/2)+1;
        y(1:M,sc:sc+N-1) = img;
    else
        y=zeros(N,N);
        sc = floor((N-M)/2)+1;
        y(sc:sc+M-1,1:N) = img;
    end
    
    
end