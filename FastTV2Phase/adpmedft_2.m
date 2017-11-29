function [f,ind]=adpmedft(g,w);
%Adaptive Median filter
%Input: g --- the noisy image
%       w --- the maximum window size.
%Output:  f --- the recovered image by AMF
%       ind --- a boolean matrix. If the (i,j)-entry is true, then (i,j)-entry of the image is a noise.
tic;
[n,m]=size(g);
f=g;
MaxMin=((f==255)|(f==0));
g = [g(:,w:-1:1) g g(:,m:-1:m-w+1)];
g = [g(w:-1:1,:) ; g ; g(n:-1:n-w+1,:)];  % reflexive boudary
ind=false(n,m);

%ffind=(find((f==255)|(f==0)));
%ff(:,1)=f(ffind);
ff(:,1)=reshape(f,n*m,1);
ffind=(1:n*m)';
jj=2;
for k=1:w
    if length(ffind)<1
        break;
    end
    for i=1:2*k
        t1=g(w+1+k:w+n+k,w-k+i:w-k+i+m-1);
        t2=g(w+1-k:w+n-k,w+k-i+2:w+k-i+m+1);
        t3=g(w-k+i:w-k+i+n-1,w+1-k:w+m-k);
        t4=g(w+k-i+2:w+k-i+n+1,w+1+k:w+m+k);
        ff(:,jj)=t1(ffind);
        ff(:,jj+1)=t2(ffind);
        ff(:,jj+2)=t3(ffind);
        ff(:,jj+3)=t4(ffind);
        jj=jj+4;
    end
    ffmax=max(ff,[],2);  %find the maximum
    ffmin=min(ff,[],2);  %find the minimun
    ffmed=median(ff,2);  %find the median
    Lff=((ffmax>ffmed)&(ffmed>ffmin));
    temp=((ffmax>ff(:,1))&(ff(:,1)>ffmin));
    %nnind=ffind(find(Lff&temp)); %If S_max<S<S_min, then not Noise.
    nind=ffind(find(Lff&(~temp))); %else it is a noise.
    ffind=ffind(find(~Lff)); %If S_max<S_min<S_min, then out.
    ff=ff(find(~Lff),:);
    ind(nind)=true;
    f(nind)=ffmed(find(Lff&(~temp)));
end

ind(ffind)=true;
f(ffind)=ffmed(find(~Lff));
ind=(ind&MaxMin);

t = toc;
%fig(f,'Adaptive Median Filter');
text = ['Noise identified and recovered by AMF, using ',num2str(t),' sec.'];
disp(text)