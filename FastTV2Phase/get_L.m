  function [L] = get_L(kappa_x,kappa_y);
%
%  [L] = get_L(kappa_x,kappa_y);
%
%  L = L_x + L_y is the cell-centered finite difference discretization of
%  the diffusion operator
%      L*v = -div (kappa grad v), in Omega = [0,1]x[0,1]
%      dv/dn = 0                        on bndry of Omega.

%  Build n*n by n*n block tridiagonal matrix L_y.  Each block is diagonal.
%  L_y has the form
%
%         D1  -D1
%        -D1 D1+D2  -D2
%         0   -D2  D2+D3  -D3
%                   -D3  D3+D4  -D4
%                          ...   ...    ...
%                              -D(n-1) D(n-1)
%
%  Dj is diag of the jth column of kappa_y. 
%  kappa_y is n by (n-1).

  [nm1,n] = size(kappa_x);
  [tmp1,tmp2] = size(kappa_y);
  
  if n-1 ~= nm1
    disp('*** Error in get_L.m. Size of dcoefxh is incorrect ***');
    return
  elseif tmp1-1 ~= tmp2
    disp('*** Error in get_L.m. Size of dcoefyh is incorrect ***');
    return
  elseif tmp1 ~= n
    disp('*** Error in get_L.m. size(dcoefxh) ~= size(dcoefyh`) ***');
    return
  end

  nsq = n*n;
  
%  Build diagonal blocks.

  Lymain = zeros(nsq,1);
  Lymain(1:n) = kappa_y(:,1);
  for i = 1:n-2
    l = i*n+1;
    u = (i+1)*n;
    Lymain(l:u) = kappa_y(:,i) + kappa_y(:,i+1);
  end
  l=(n-1)*n+1;
  Lymain(l:nsq) = kappa_y(:,n-1);

%  Build sub- and super-diagonal blocks.

  Lysub = zeros(nsq,1);
  Lysuper = Lysub;
  for i = 1:n-1
    l = i*n+1;
    u = (i+1)*n;
    Lysub(l-n:u-n) = -kappa_y(:,i);
    Lysuper(l:u) = -kappa_y(:,i);
  end

%  Store diagonals in MATLAB sparse matrix format.
  
  L_y = spdiags([Lysub Lymain Lysuper], [-n 0 n], nsq,nsq);
  
%  Build block diagonal matrix L_x.  Each block is tridiagonal. 
%  The jth block has the form
%  
%         d1  -d1
%        -d1 d1+d2  -d2
%         0   -d2  d2+d3  -d3
%                   -d3  d3+d4  -d4
%                          ...   ...    ...
%                              -d(n-1) d(n-1)
%
%  di is ith entry of the jth row of kappa_x. 
%  kappa_x is (n-1) by n.

  Lxmain = zeros(nsq,1);
  Lxsub = Lxmain;
  Lxsuper = Lxmain;
  for j = 1:n
    d = kappa_x(:,j);
    dmain = [d(1); d(1:n-2)+d(2:n-1); d(n-1)];
    l = (j-1)*n + 1;
    u = j*n;
    Lxmain(l:u) = dmain;
    Lxsub(l:u) = [-d;0];
    Lxsuper(l:u) = [0;-d];
  end

%  Store diagonals in MATLAB sparse matrix format.
  
  L_x = spdiags([Lxsub Lxmain Lxsuper], [-1 0 1], nsq,nsq);

  L = L_x + L_y;
  