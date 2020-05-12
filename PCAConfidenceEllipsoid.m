function [x_value,y_value,z_value] = PCAConfidenceEllipsoid(xdat,alpha,distribution)
%   绘制置信椭球区域
%   ConfidenceRegion(xdat,alpha,distribution)
%   xdat：样本观测值矩阵,p*N 或 N*p的矩阵，p = 3
%   alpha：显著性水平，标量，取值介于[0,1]，默认值为0.05
%   distribution：字符串（'norm'或'experience'），用来指明求置信区域用到的分布类型，
%   CopyRight：Xihui Bian 根据xiezhh（谢中华）的程序改编
%   
%   example_PCAConfidenceEllipsoid：x = mvnrnd([1;2;3],[3 0 0;0 5 -1;0 -1 1],100);
%             ConfidenceRegion(x)
%             ConfidenceRegion(x,'exp')
% 设定参数默认值
if nargin == 1
    distribution = 'F';
    alpha = 0.05;
elseif nargin == 2
    if ischar(alpha)
        distribution = alpha;
        alpha = 0.05;
    else
        distribution = 'F';
    end
end
% 判断参数取值是否合适
if ~isscalar(alpha) || alpha>=1 || alpha<=0
    error('alpha的取值介于0和1之间')
end
% 检查数据维数是否正确
[m,n] = size(xdat);
p = min(m,n);  % 维数
if ~ismember(p,3)
    error('应输入三维样本数据,并且样本容量应大于3')
end
% 把样本观测值矩阵转置，使得行对应观测，列对应变量
if m < n
    xdat = xdat';
end
xm = mean(xdat); % 均值
n = max(m,n);  % 观测组数
% 三维置信椭球 Confidence Ellipsoid）
        x = xdat(:,1);
        y = xdat(:,2);
        z = xdat(:,3);
        s = inv(cov(xdat));  % 协方差矩阵
        xd = xdat-repmat(xm,[n,1]);
        rd = sum(xd*s.*xd,2);
        if strncmpi(distribution,'F',3)
            r = finv(1-alpha,p,n-p)*p*(n-1)/(n-p);            
            display( 'Confidence Ellipsoid（F distribution）');
        end
        if strncmpi(distribution,'norm',3)
            r = chi2inv(1-alpha,p);            
            display( 'Confidence Ellipsoid（Norm distribution）');
        end        
        if strncmpi(distribution,'experience',3)            
           r = prctile(rd,100*(1-alpha));
           display( 'Confidence Ellipsoid（experience distribution）');
        end        
        [x_value,y_value,z_value] = ellipsoidvalue(xm,s,r);
        
%--------------------------------------------------
%   子函数：用来计算置信椭球的xyz坐标
%--------------------------------------------------
function  [x,y,z] = ellipsoidvalue(xc,P,r)
% 画一般椭球：(x-xc)'*P*(x-xc) = r
[V, D] = eig(P);
    aa = sqrt(r/D(1,1));
    bb = sqrt(r/D(2,2));
    cc = sqrt(r/D(3,3));
    [u,v] = meshgrid(linspace(-pi,pi,30),linspace(0,2*pi,30));
    x = aa*cos(u).*cos(v);
    y = bb*cos(u).*sin(v);
    z = cc*sin(u);
    xyz = V*[x(:)';y(:)';z(:)'];  % 坐标旋转
    x = reshape(xyz(1,:),size(x))+xc(1);
    y = reshape(xyz(2,:),size(y))+xc(2);
    z = reshape(xyz(3,:),size(z))+xc(3);
    %h = mesh(x,y,z);  % 绘制椭球面网格图
    %plot3(x,y,z,color);
    %colormap(color);
    %h = surf(x,y,z,'facealpha',0.2,color);
    %shading interp; %flat %interp