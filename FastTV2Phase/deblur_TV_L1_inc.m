function [u,v]=deblur_TV_L1_inc(img,r,ind,tol,beta,eta)
%[u,v]=deblur_MS_rd_L1_inc(img,r,ind,tol,alpha,beta,epsilon)
%This function deblurs a images in the presence of random-valued noise by
%Mumfor-Shah functional from incomplete data.
%Input: img --- image to be deblured
%         r --- the radius of the blurring kernel
%       ind --- the index of faithful data
%       tol --- the tolerence to stop
%      beta --- regularazation parameter.
%       ind --- the position of the salt-pepper noise

[n,m]=size(img);
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

du=1;
u=img;
v=ones(n,m);
%vold=v;
iter=0;
while (du>=tol & iter<100)
    [vx,vy] = get_dcoef(u,eta);
    %v=(vnew+vold)/2;
    duu=1;
    iiter=1;
    uu=u;
    while (duu>=tol & iiter<=1)
        uunew=solvetv_l1_inc(uu,img,ind,vx,vy,r,beta,eta);
        duu=norm(uunew-uu,'fro')/norm(uu,'fro');
        disp(['   the error is ' num2str(duu)]);
        uu=uunew;
        iiter=iiter+1;
    end
    unew=uu;
    du=norm(unew-u,'fro')/norm(u,'fro');
    u=unew;
    iter=iter+1;
    error(iter)=du;
    disp(['The residual is ' num2str(du) ' at step ' num2str(iter)]);
end

%semilogy(error);