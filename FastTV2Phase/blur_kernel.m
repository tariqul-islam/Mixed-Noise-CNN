function fker=blur_kernel(r,n,m)

%Generate the so-called pill-box kernel, which is a cylinder with volumn 1.
%The blur kernel is transfered into Fourier domain, so that it is easy to
%do convolution.
%Input: 
%r: 1-by-1 scalar, the radius of the pill-box;
%n: 1-by-1 scalar, the size of the image.
%Output:
%fker: n-by-n matrix, the blur kernel in Fourier domain.

for i=-r:r
    for j=-r:r
        if (i^2+j^2<=r^2) 
            ker(r+1+i,r+1+j)=1;
        end
    end
end
ker=ker/sum(ker(:));

%Shift so that the center goes to the upper-left.
temp(1:r+1,1:r+1)=ker(r+1:2*r+1,r+1:2*r+1);
temp(n-r+1:n,m-r+1:m)=ker(1:r,1:r);
temp(n-r+1:n,1:r+1)=ker(1:r,r+1:2*r+1);
temp(1:r+1,m-r+1:m)=ker(r+1:2*r+1,1:r);

%Because the pill-box kernel is symmertric, it is always real in Fourier
%domain.
fker=real(fft2(temp));