function blurgi=blur_gauss_impulse(img,r,sigma,pc)

%This function blur the image first and plus gaussian noise, and then plus
%impuls salt-and-pepper noise.
%blurgi=blur_gauss_impulse(img,r,snr,pc)
%img is the input image;
%sigma is the variance of the gaussian noise sigma^2.
%pc is the percent of salt-and-pepper noise.
%r is the radius of the pill-box kernel.

%Generate the so-called pill-box kernel, which is a cylinder with volumn 1.
%The radius of it will be chosen r=3 in this function.
[n,m]=size(img);
fker=blur_kernel(r,n,m);

%Transfer the image into
%Fourier domain, then multiply these too one. We will get the noise free
%blured image by inverse Fourier transform.

% fimg=fft2(img);
% blur=real(ifft2(fker.*fimg));

for i=-r:r
    for j=-r:r
        if (i^2+j^2<=r^2) 
            ker(r+1+i,r+1+j)=1;
        end
    end
end
ker=ker/sum(ker(:));
blur=convb(img,ker,r);

%Add gaussian noise into the image;
ng=randn(n,m);
%ng=ng/norm(ng,'fro')^2*snr;
blurgi=blur+sigma*ng;

realsnr=20*log10(norm(blur,'fro')/norm(ng,'fro')/sigma);
disp(['The SNR is ' num2str(realsnr)]);

%Add salt-and-pepper noise;
ran=rand(n,m);
inds=find(ran<=pc/2);
indp=find(ran>=(1-pc/2));
blurgi(inds)=255;
blurgi(indp)=0;

%display the image
% colormap('gray');
% imagesc(blurgi);
% axis image;