function [x_value,y_value,z_value] = PCAConfidenceEllipsoid(xdat,alpha,distribution)
%   ����������������
%   ConfidenceRegion(xdat,alpha,distribution)
%   xdat�������۲�ֵ����,p*N �� N*p�ľ���p = 3
%   alpha��������ˮƽ��������ȡֵ����[0,1]��Ĭ��ֵΪ0.05
%   distribution���ַ�����'norm'��'experience'��������ָ�������������õ��ķֲ����ͣ�
%   CopyRight��Xihui Bian ����xiezhh��л�л����ĳ���ı�
%   
%   example_PCAConfidenceEllipsoid��x = mvnrnd([1;2;3],[3 0 0;0 5 -1;0 -1 1],100);
%             ConfidenceRegion(x)
%             ConfidenceRegion(x,'exp')
% �趨����Ĭ��ֵ
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
% �жϲ���ȡֵ�Ƿ����
if ~isscalar(alpha) || alpha>=1 || alpha<=0
    error('alpha��ȡֵ����0��1֮��')
end
% �������ά���Ƿ���ȷ
[m,n] = size(xdat);
p = min(m,n);  % ά��
if ~ismember(p,3)
    error('Ӧ������ά��������,������������Ӧ����3')
end
% �������۲�ֵ����ת�ã�ʹ���ж�Ӧ�۲⣬�ж�Ӧ����
if m < n
    xdat = xdat';
end
xm = mean(xdat); % ��ֵ
n = max(m,n);  % �۲�����
% ��ά�������� Confidence Ellipsoid��
        x = xdat(:,1);
        y = xdat(:,2);
        z = xdat(:,3);
        s = inv(cov(xdat));  % Э�������
        xd = xdat-repmat(xm,[n,1]);
        rd = sum(xd*s.*xd,2);
        if strncmpi(distribution,'F',3)
            r = finv(1-alpha,p,n-p)*p*(n-1)/(n-p);            
            display( 'Confidence Ellipsoid��F distribution��');
        end
        if strncmpi(distribution,'norm',3)
            r = chi2inv(1-alpha,p);            
            display( 'Confidence Ellipsoid��Norm distribution��');
        end        
        if strncmpi(distribution,'experience',3)            
           r = prctile(rd,100*(1-alpha));
           display( 'Confidence Ellipsoid��experience distribution��');
        end        
        [x_value,y_value,z_value] = ellipsoidvalue(xm,s,r);
        
%--------------------------------------------------
%   �Ӻ����������������������xyz����
%--------------------------------------------------
function  [x,y,z] = ellipsoidvalue(xc,P,r)
% ��һ������(x-xc)'*P*(x-xc) = r
[V, D] = eig(P);
    aa = sqrt(r/D(1,1));
    bb = sqrt(r/D(2,2));
    cc = sqrt(r/D(3,3));
    [u,v] = meshgrid(linspace(-pi,pi,30),linspace(0,2*pi,30));
    x = aa*cos(u).*cos(v);
    y = bb*cos(u).*sin(v);
    z = cc*sin(u);
    xyz = V*[x(:)';y(:)';z(:)'];  % ������ת
    x = reshape(xyz(1,:),size(x))+xc(1);
    y = reshape(xyz(2,:),size(y))+xc(2);
    z = reshape(xyz(3,:),size(z))+xc(3);
    %h = mesh(x,y,z);  % ��������������ͼ
    %plot3(x,y,z,color);
    %colormap(color);
    %h = surf(x,y,z,'facealpha',0.2,color);
    %shading interp; %flat %interp