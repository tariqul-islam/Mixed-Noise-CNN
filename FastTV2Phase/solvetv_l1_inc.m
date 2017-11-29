function u=solvetv_l1_inc(uold,gold,ind,vx,vy,r,beta,eta)
%u=solveu_whole_l1_inc(uold,gold,ind,v,r,beta.eta)
%This function debluring with Mumford-Shah functional from incomplete data.
%Input: uold --- the initial guess
%       gold --- the image to be deblured.
%        ind --- the index of faithful data
%          v --- the edge detected by the Mumfor-Shah functional
%          r --- the radius of the blurring kernel.
%       beta --- the regularization parameter.
%        eta --- the parameter

[n,m]=size(uold);
h=1/n;

%D=spdiags(v(:),0,n*m,n*m);

[A]=get_L(vy,vx);

if r==0;
    ker=1;
else
for i=-r:r
    for j=-r:r
        if (i^2+j^2<=r^2) 
            ker(r+1+i,r+1+j)=1;
        end
    end
end
ker=ker/sum(ker(:));
end

% temp=zeros(n);
% temp(1,1)=1;
% ei=convb(temp,ker,r);
% % ei is the eigenvalues of the blur kernel.
% e1=dct2(temp);
% ei=dct2(ei)./e1;

datafit=convb(uold,ker,r)-gold;
w=1./sqrt(datafit(ind).^2+eta^2);
ggold=zeros(n,m);
ggold(ind)=gold(ind).*w;
b=convb(ggold,ker,r);
b=b(:);

global inner_iter;
inner_iter=0;
% if r==0
% dia=zeros(n,m);
% dia(ind)=1.*w;
% B=spdiags(dia(:),0,n*m,n*m)+2*beta*A;
% [L,U] = luinc(B,.001);
% uu=pcg(B,b,1e-10,m*n,L,[],uold(:));
% else
uu=pcg(@(x)mult(A,x,ind,ker,w,r,n,m,beta),b,1e-7,m*n,[],[],uold(:));
% end
u=reshape(uu,n,m);

%==================================================
function Ax=mult(A,x,ind,ker,w,r,n,m,beta)
global inner_iter;
inner_iter=inner_iter+1;
if mod(inner_iter,100)==0
    fprintf('%d ',inner_iter);
    if mod(inner_iter,2000)==0
        fprintf('\n');
    end
end
h=1/n;
xx=reshape(x,n,m);
c=convb(xx,ker,r);
temp=zeros(n,m);
temp(ind)=c(ind).*w;
c=convb(temp,ker,r);
Ax=c(:)+2*beta*A*x;

% Ax=dct2((ei.*idct2(xx)));
% Ax=Ax(:);
% Ax=Ax+beta*A*x;