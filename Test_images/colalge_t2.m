clc;
clear;
close all;

fld = 'Test_Set_3';
files = dir(fld);
files = files(3:end);

N = length(files);

collage = zeros(202*3,202*5);

k=0;
for i=1:3
        for j=1:5
            k=k+1;
            x = im2double(imread(fullfile(fld,files(k).name)));
            if length(size(x))==3
                x = rgb2gray(x);
            end
            x = sizeit(x);
            x = imresize(x, [200,200]);
            collage( i*2+((i-1)*200:i*200-1), 2*j+((j-1)*200:j*200-1) ) = x;
        end
end
imshow(collage)
imwrite(collage,'collag2.png')