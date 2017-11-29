  function [dcoefx,dcoefy] = get_dcoef(u,beta)

%  [dcoefx,dcoefy] = get_dcoef(u,beta)
%
%  Generate 2 arrays, dcoefx and dcoefy, used in the CCFD discretization 
%  of the diffusion equation
%     L(u)v = -div (dcoef grad u)
%           = - d/dx(dcoef du/dx) - d/dy(dcoef du/dy)
%  where
%     dcoef = 1 / sqrt((du/dx)^2 + (du/dy)^2 + beta^2).
%
%  dcoefx gives values of dcoef across cell x-interfaces.
%  dcoefy gives values of dcoef across cell y-interfaces.

  [n,m] = size(u);
  %h = 1/n;
  h=1;
    
  ux = diff(u)/h;
  uy = diff(u')'/h;
  
  uxavg = (ux(:,1:n-1) + ux(:,2:n))/2;
  uxavg = [zeros(1,n-1); uxavg; zeros(1,n-1)];
  uxavg = (uxavg(1:n,:) + uxavg(2:n+1,:))/2;
  uyavg = (uy(1:n-1,:) + uy(2:n,:))/2;
  uyavg = [zeros(n-1,1) uyavg zeros(n-1,1)];
  uyavg = (uyavg(:,1:n) + uyavg(:,2:n+1))/2;
  dcoefy = 1./sqrt(ux.^2 + uyavg.^2 + beta);
  dcoefx = 1./sqrt(uxavg.^2 + uy.^2 + beta);

%  ux=diff(u,1,2);
%  uy=diff(u,1,1);
%  ux1=([ux(:,1) ux]+[ux ux(:,m-1)])/2;
%  uy1=([uy(1,:);uy]+[uy;uy(n-1,:)])/2;
%  dcoefx=1./sqrt(ux.^2+((uy1(:,1:m-1)+uy1(:,2:m))/2).^2+beta);
%  dcoefy=1./sqrt(uy.^2+((ux1(1:n-1,:)+ux1(2:n,:))/2).^2+beta);