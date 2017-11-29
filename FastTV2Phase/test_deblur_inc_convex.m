%diary('lena_sp_bsk_r3.txt');
rand('seed',2000);
randn('seed',2000);

r=5;
for imagenum=5:5
    switch imagenum
        case 1 
            imagename='bridge1.png'
        case 2 
            imagename='cameraman.tif'
        case 3 
            imagename='boat256.png'
        case 4 
            imagename='goldhill256.png'
        case 5
            imagename='lena256.png'
        case 6
            imagename='baboon.gif'
    end
    
    for times=2:2

        % noise_ratio=-0.05+times*0.15
        % beta_m=[0.005 0.01 0.02 0.1 0.2];
        % %beta_m=[0.01 0.02 0.02 0.1 0.2]; %For full variation


        noise_ratio=-0.1+times*0.2
        %beta_m=[0.00001 0.00002 0.00002 0.00002 0.00002];
        beta_m=[0.1 0.3 0.3 0.3 0.3];
        %beta_m=[0.01 0.02 0.05 0.2 0.5]; % for full variation

        tt=[];pp=[];
        tol=1e-4;
        eta=1;

        beta2=beta_m(times);

        disp([num2str(beta2)]);
        r=3;
        for j=1:1
            close all;
            lena=imread(imagename);
            lena=double(lena);
            lena2=lena;
            blu=blur_gauss_impulse(lena,0,10/255,0.3);

            t=cputime;

            % blu=addnoise(blu,-0.05+times*0.15,'rd');
            % tic;
            % rec=blu;
            % for i=1:4
            %     rec=acwmf(rec,lena,i);
            % end
            % toc;
            % ind=(rec~=blu);

            %blu=addnoise(blu,-0.1+times*0.2,'sp');
            tic;
            [rec,ind]=adpmedft(blu,19);
            toc;
            ind=(rec~=blu)&((blu==255)|(blu==0));
            rec(~ind)=blu(~ind);

            %ind=false(size(lena)); % for full variation.

            [rec1,v]=deblur_TV_L1_inc(rec,r,~ind,tol,beta2,eta);
            t=cputime-t;
            rec1(rec1>255)=255;rec1(rec1<0)=0;
            ps2=10*log10(255^2*size(rec1,1)*size(rec1,2)/norm(rec1(:)-lena2(:))^2)
            disp(['The two phase method: PSNR = ', num2str(ps2),' time = ',num2str(t)]);
            tt=[tt t];
            pp=[pp ps2];
            %fig(rec1)
        end
    end
end
    %disp(['Average PSNR = ',num2str(sum(pp)/10),' and average time is ',num2str(sum(tt)/10)])
    %diary off;
    %end