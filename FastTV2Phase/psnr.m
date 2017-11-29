function p=psnr(rim,im)

%The function calculate the peak signal-to-noise ration.
p=10*(log10(255^2*size(im,1)*size(im,2))-log10(norm(rim(:)-im(:))^2));