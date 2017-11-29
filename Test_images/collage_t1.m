clc;
clear;
close all;

fld = 'Test_Set_1_and_2';
files = dir(fld);
files = files(3:end);

N = length(files);

collage = zeros(130*10,130*10);

k=0;
for i=1:10
        for j=1:10
            k=k+1;
            x = im2double(imread(fullfile(fld,files(k).name)));
            if length(size(x))==3
                x = rgb2gray(x);
            end
            
            collage( i*2+((i-1)*128:i*128-1), 2*j+((j-1)*128:j*128-1) ) = x;
        end
end

collage = imresize(collage,[1000,1000]);
imshow(collage)
imwrite(collage,'collag1.png')