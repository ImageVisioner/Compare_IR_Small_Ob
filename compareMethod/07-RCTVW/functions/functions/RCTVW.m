function [tenB, S,change] = RCTVW(tenD, lambda,r,tau)

% Solve the WSNM problem 
% ---------------------------------------------
% Input:
%       tenD       -    n1*n2*n3 tensor
%       lambda  -    >0, parameter
%       mu-      regelarization parameter
%       p    -    key parameter of Schattern p norm
%
% Output:
%       tenB       -    n1*n2*n3 tensor
%       tenT       -    n1*n2*n3 tensor
%       change     -    change of objective function value
[M,N,p] = size(tenD);
D       = zeros(M*N,p) ;
for i=1:p
    bandp = tenD(:,:,i);
    D(:,i)= bandp(:);
end

%% initialize
Y = D;
norm_two = lansvd(Y, 1, 'L');
norm_inf = norm( Y(:), inf);
dual_norm = max(norm_two, norm_inf);
Y = Y / dual_norm;
mu=0.01; %tuning
mu1=0.0002;%tuning
weightTenT = ones(M*N,p);
%% FFT setting
h               = M;
w               = N;
d               = r;
sizeU           = [h,w,d];
%% 
Eny_x   = ( abs(psf2otf([+1; -1], [h,w,d])) ).^2  ;
Eny_y   = ( abs(psf2otf([+1, -1], [h,w,d])) ).^2  ;
determ  =  Eny_x + Eny_y;
%% Initializing optimization variables
[u,s,v]= svd(D,'econ');
U              = u(:,1:r)*s(1:r,1:r);
V              = v(:,1:r);
X              = U*V';
S              = zeros(M*N,p);%Sparse
E              = zeros(M*N,p);%Gaussian

M1 = zeros(M*N*r,1);  % multiplier for Dx_U-G1
W1 = ones(M*N*r,1);
M2 = zeros(M*N*r,1);  % multiplier for Dy_U-G2
W2 = ones(M*N*r,1);
M3 = zeros([M*N,p]);  % multiplier for D-UV^T-E
% W3 = ones(M*N,p);
% Weight = ones(M*N,p);
% iter = 0;

%% initialize
tol = 1e-7; 
max_iter = 500;
rho = 1.1;
max_mu = 1e10;
normD = norm(tenD(:));
if ~exist('opts', 'var')
    opts = [];
end    
if isfield(opts, 'tol');         tol = opts.tol;              end
if isfield(opts, 'max_iter');    max_iter = opts.max_iter;    end
if isfield(opts, 'rho');         rho = opts.rho;              end
if isfield(opts, 'max_mu');      max_mu = opts.max_mu;        end

dim = size(tenD);
tenB = zeros(dim);
preTnnT= 0;
NOChange_counter = 0;
change=zeros(1,max_iter);
for iter = 1 : max_iter
 %% -Update G1,G2
    G1 = softthre_s(diff_x(U,sizeU)+M1/mu,tau(1)/mu,W1);
    G2 = softthre_s(diff_y(U,sizeU)+M2/mu,tau(2)/mu,W2);
 %% -Update U
    diffT_p  = diff_xT(G1-M1/mu,sizeU)+diff_yT(G2-M2/mu,sizeU);
    temp     = (D-S+M3/mu1)*V;
    numer1   = reshape( diffT_p +temp(:), sizeU);
    x        = real( ifftn( fftn(numer1) ./ (determ + 1+eps) ) );
    U        = reshape(x,[M*N,r]);
 %% -Update V
    [u,~,v]     = svd((D-S+M3/mu1)'*U,'econ');
    V           = u*v';
    tenB=U*V';
 %% -Update S  
  S = ClosedWL1(D-U*V'+M3/mu1,weightTenT*lambda/mu1,eps);%RCTVW
  weightTenT = 1 ./ (abs(S) + 0.01); %enhance sparsity
 %% -Update Multiplier
    leq1 = diff_x(U,sizeU)-G1;
    leq2 = diff_y(U,sizeU)-G2;
    leq3 = D-U*V'-S;    
     M1 = M1 + mu*leq1;
     M2 = M2 + mu*leq2;
     M3 = M3 + mu1*leq3;
     mu = min(max_mu,mu*rho);
     mu1 = min(max_mu,mu1*rho);
%% chg+tubalrank %%运行使用
stopCriterion = norm(tenD(:)- tenB(:)- S(:)) / normD;
change(iter)=(stopCriterion);
currTnnT=tubalrank(S,0);
if currTnnT == preTnnT
    NOChange_counter=NOChange_counter +1;
else
    NOChange_counter = 0;
end
if (stopCriterion < tol) || (NOChange_counter >=1)
    break;
end             
    preTnnT = currTnnT; 
    disp(['#Iteration ' num2str(iter) ' trankT ' ...
        num2str(currTnnT) ...
        ' stopCriterion ' num2str(stopCriterion) ]);
end