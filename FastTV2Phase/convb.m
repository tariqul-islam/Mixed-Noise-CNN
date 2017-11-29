function c=convb(g,ker,r);
%This function conv g and blur kernel with reflection boundary.

if r==0
    c=g;
else
[n,m]=size(g);
bg=[g(:,r:-1:1) g g(:,m:-1:m-r+1)];
bg=[bg(r:-1:1,:);bg;bg(n:-1:n-r+1,:)];
temp=conv2(bg,ker);
c=temp(2*r+1:n+2*r,2*r+1:m+2*r);
end;