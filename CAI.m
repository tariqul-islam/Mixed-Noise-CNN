clc;
clear;
close all;

addpath(genpath('FastTV2Phase'));

image_name = 'butter_sign.png'; %name of the image
cai_save_name = 'butter_sign.mat'; %the name of data after Cai's method


gauss_sigma = 20/255; %sigma = 20;
salt_pepper = 0.30; %30%
rvin = 0.00;
is_rvin = 0; %set to 1 for AMF+ACWMF, 0 for Cai

beta=0.00002;
r=0;
tol=0.001;
eta=1;


img = im2double(imread(image_name));
[MM,NN] = size(img);

imn = img + gauss_sigma*randn(size(img));
[imn,Narr] = impulsenoise(imn,salt_pepper,0);
if is_rvin ~= 0
    [imn,Narr] = impulsenoise(imn,rvin,1);
end

    
[imm,ind] = adpmedft(imn,19);

if is_rvin == 0   
    rec = sizeit(imm);
    xs = sizeit(imn);
    ind=((xs==1)|(xs==0));
    rec(~ind)=xs(~ind);

    [cai_out,v]=deblur_TV_L1_inc(rec*255,r,~ind,tol,beta,eta); %0-255
    cai_out = cai_out(1:MM,1:NN);
    cai_out(cai_out>255)=255;
    cai_out(cai_out<0)=0;
    cai_out = cai_out/255;
    imm256 = imresize(cai_out,[MM*2 NN*2]);
else
    [immacwmf,ind] = acwmf(imm,3);
    imm256 = imresize(immacwmf,[MM*2 NN*2]);
end

save(cai_save_name, 'imm256', 'img', 'imn', 'cai_out');

