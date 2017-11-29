clc;
clear;
close all;

fld = 'Common_Images';
files = dir(fld);
files = files(3:end);

N = length(files);

collage = zeros(514*1,512*5);

k=0;
for i=1:1
        for j=1:5
            k=k+1;
            x = im2double(imread(fullfile(fld,files(k).name)));
            if length(size(x))==3
                x = rgb2gray(x);
            end
            x = sizeit(x);
            %x = imresize(x, [200,200]);
            collage( i*2+((i-1)*512:i*512-1), 2*j+((j-1)*512:j*512-1) ) = x;
        end
end
imshow(collage)
imwrite(collage,'common.png')