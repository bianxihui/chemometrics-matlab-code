close all;clear;clc

%数据包含5类中药，共191个样品
%当归 (Angelicae sinensis Radix,ASR) 40个
%独活（Angelicae pubescentis Radix, APR) 39个
%川芎（Chuanxiong Rhizoma, CR）38个
%白术（Atractylodis macrocephalae Rhizoma, AMR）35个
%白芷（Angelicae dahuricae Radix, ADR）39个

load UV_TCM_20180416_One
%将每类样品的光谱及目标值分别保存不同的变量
cal1    = Spectra(1:40,:);cal2 = Spectra(41:79,:); cal3 = Spectra(80:117,:);cal4 = Spectra(118:152,:);cal5 = Spectra(153:191,:);
caltar1 = Target(1:40);caltar2 = Target(41:79); caltar3 = Target(80:117);caltar4 = Target(118:152);caltar5 = Target(153:191);
[m1,n1] = size(cal1); [m2,n2]  = size(cal2);    [m3,n3] = size(cal3);    [m4,n4] = size(cal4);     [m5,n5] = size(cal5);
cal     = Spectra;
caltar  = Target;
[m,n]   = size(cal);
%----------------------------绘制所有样品的光谱-----------------------------
figure;subplot(2,3,1);plot(repmat(wavelength,1,m1),cal1','r-');title('ASR');xlabel('Wavelength');ylabel('Transmission');
       subplot(2,3,2);plot(repmat(wavelength,1,m2),cal2','b-');title('APR');xlabel('Wavelength');ylabel('Transmission');
       subplot(2,3,3);plot(repmat(wavelength,1,m3),cal3','k-');title('CR');xlabel('Wavelength');ylabel('Transmission');
       subplot(2,3,4);plot(repmat(wavelength,1,m4),cal4','g-');title('AMR');xlabel('Wavelength');ylabel('Transmission');
       subplot(2,3,5);plot(repmat(wavelength,1,m5),cal5','m-');title('ADR');xlabel('Wavelength');ylabel('Transmission');
       subplot(2,3,6);plot(repmat(wavelength,1,m1),cal1','r-');title('All');xlabel('Wavelength');ylabel('Transmission');hold on; 
                      plot(repmat(wavelength,1,m2),cal2','b-');
                      plot(repmat(wavelength,1,m3),cal3','k-');
                      plot(repmat(wavelength,1,m4),cal4','g-');
                      plot(repmat(wavelength,1,m5),cal5','m-');hold off;
%-----------------------------数据分组--------------------------------------
class_method             = 2;
switch class_method
case 1
%-----------------KS对整体数据划分，训练集2/3，预测集1/3---------------------
[model,test]             = kenstone(cal,floor(2/3*m));
x_train                  = cal(model,:);
x_pred                   = cal(test,:);
y_train                  = caltar(model);
y_pred                   = caltar(test);
case 2
%---------------KS对5类数据分划2分，训练集3/4，预测集1/4---------------------
[model1,test1]           = kenstone(cal1,floor(3/4*m1));
[model2,test2]           = kenstone(cal2,floor(3/4*m2));
[model3,test3]           = kenstone(cal3,floor(3/4*m3));
[model4,test4]           = kenstone(cal4,floor(3/4*m4));
[model5,test5]           = kenstone(cal5,floor(3/4*m5));
mm1                      = length(model1);
mm2                      = length(model2);
mm3                      = length(model3);
mm4                      = length(model4);
mm5                      = length(model5);
index_class1             = 1:mm1;
index_class2             = mm1+1:mm1+mm2;
index_class3             = mm1+mm2+1:mm1+mm2+mm3;
index_class4             = mm1+mm2+mm3+1:mm1+mm2+mm3+mm4;
index_class5             = mm1+mm2+mm3+mm4+1:mm1+mm2+mm3+mm4+mm5;
x_train1  = cal1(model1,:);  mean_x_train1 = mean(x_train1);
x_train2  = cal2(model2,:);  mean_x_train2 = mean(x_train2);
x_train3  = cal3(model3,:);  mean_x_train3 = mean(x_train3);
x_train4  = cal4(model4,:);  mean_x_train4 = mean(x_train4);
x_train5  = cal5(model5,:);  mean_x_train5 = mean(x_train5);
%------------------绘制训练集样品的光谱及每类中药的平均光谱-------------------
figure;plot(repmat(wavelength,1,mm1),x_train1','r-');title('train spectra');xlabel('Wavelength');ylabel('Transmission');hold on
       plot(repmat(wavelength,1,mm2),x_train2','b-');
       plot(repmat(wavelength,1,mm3),x_train3','k-');
       plot(repmat(wavelength,1,mm4),x_train4','g-');
       plot(repmat(wavelength,1,mm5),x_train5','m-');
figure;plot(wavelength,mean_x_train1','r-');title('mean spectra');xlabel('Wavelength');ylabel('Transmission');hold on
       plot(wavelength,mean_x_train2','b-');
       plot(wavelength,mean_x_train3','k-');
       plot(wavelength,mean_x_train4','g-');
       plot(wavelength,mean_x_train5','m-');
       
       hold off;                      
%---------------合并每类样品的训练集合预测集，得到总体训练集合预测集-----------
x_pred1   = cal1(test1,:);  
x_pred2   = cal1(test2,:); 
x_pred3   = cal1(test3,:);  
x_pred4   = cal1(test4,:);  
x_pred5   = cal1(test5,:);
x_train                  = [x_train1; x_train2; x_train3; x_train4; x_train5];
x_pred                   = [x_pred1; x_pred2; x_pred3; x_pred4; x_pred5;];
y_train                  = [caltar1(model1); caltar2(model2); caltar3(model3);caltar4(model4);caltar5(model5)];
y_pred                   = [caltar1(test1); caltar2(test2); caltar3(test3);caltar4(test4);caltar5(test5)];
case 3
%--------------整体数据顺序选取2/3作为训练集，1/3作为预测集-------------------
index_pred               = 3:3:m;
x_pred                   = cal(index_pred,:);
y_pred                   = caltar(index_pred);
cal(index_pred,:)        = [];
caltar(index_pred)       = [];
x_train                  = cal;
y_train                  = caltar;
case 4
%-----------------整体随机选取2/3作为训练集，1/3作为预测集--------------------
index                    = randperm(m);
index_pred               = index(1:floor(1/3*m));
x_pred                   = cal(index_pred,:);
y_pred                   = caltar(index_pred);
cal(index_pred,:)        = [];
caltar(index_pred)       = [];
x_train                  = cal;
y_train                  = caltar;
end
%-----------------------------光谱预处理------------------------------------


%---------------------------数据中心化--------------------------------------
pretreatment = 2;%
switch pretreatment;
   case 1 %中心化
   mean_x_train         = mean(x_train); 
   x_train              = x_train - repmat(mean_x_train,size(x_train,1),1);
   x_pred               = x_pred - repmat(mean_x_train,size(x_pred,1),1);
   case 2 %Autoscaling
   std_x_train          = std(x_train,0,1);
   mean_x_train         = mean(x_train,1);
   x_train              = (x_train-repmat(mean_x_train,size(x_train,1),1))./repmat(std_x_train,size(x_train,1),1);
   x_pred               = (x_pred-repmat(mean_x_train,size(x_pred,1),1))./repmat(std_x_train,size(x_pred,1),1);  
end
scalen  = 6; waveletfunction = 'sym6';
[x_train]                = wavderiv(x_train,waveletfunction,scalen);
[x_pred]                 = wavderiv(x_pred,waveletfunction,scalen);

window0 = 19;
x_train                 = sgdiff(x_train,2,window0,0);
x_pred                  = sgdiff(x_pred,2,window0,0);
%%--------------------训练集样品光谱主成分分析-------------------------------
[U_train,S_train,V_train]  = svd(x_train);       
R_train                    = U_train*S_train;
%----------------计算每个主成分所含信息的百分比------------------------------
S                          = diag(S_train);
s                          = S.^2;
PC_percentages             = s./sum(s)*100;
PC3_sum_percent            = sum(s(1:3))./sum(s)*100;
format short
display(PC_percentages(1:3));
display(PC3_sum_percent)
PC1_class1                 = R_train(index_class1,1); 
PC2_class1                 = R_train(index_class1,2); 
PC3_class1                 = R_train(index_class1,3);
PC1_class2                 = R_train(index_class2,1); 
PC2_class2                 = R_train(index_class2,2); 
PC3_class2                 = R_train(index_class2,3);
PC1_class3                 = R_train(index_class3,1); 
PC2_class3                 = R_train(index_class3,2); 
PC3_class3                 = R_train(index_class3,3);
PC1_class4                 = R_train(index_class4,1); 
PC2_class4                 = R_train(index_class4,2); 
PC3_class4                 = R_train(index_class4,3);
PC1_class5                 = R_train(index_class5,1); 
PC2_class5                 = R_train(index_class5,2); 
PC3_class5                 = R_train(index_class5,3);
alpha = 0.05; distribution = 'F';
[x_CE1,y_CE1,z_CE1]        = PCAConfidenceEllipsoid([PC1_class1 PC2_class1 PC3_class1],alpha,distribution);
[x_CE2,y_CE2,z_CE2]        = PCAConfidenceEllipsoid([PC1_class2 PC2_class2 PC3_class2],alpha,distribution);
[x_CE3,y_CE3,z_CE3]        = PCAConfidenceEllipsoid([PC1_class3 PC2_class3 PC3_class3],alpha,distribution);
[x_CE4,y_CE4,z_CE4]        = PCAConfidenceEllipsoid([PC1_class4 PC2_class4 PC3_class4],alpha,distribution);
[x_CE5,y_CE5,z_CE5]        = PCAConfidenceEllipsoid([PC1_class5 PC2_class5 PC3_class5],alpha,distribution);
figure;plot3(PC1_class1,PC2_class1,PC3_class1,'r.','MarkerSize',16);title('Training set');xlabel('PC1');ylabel('PC2');zlabel('PC3');hold on
       plot3(PC1_class2,PC2_class2,PC3_class2,'b.','MarkerSize',16);
       plot3(PC1_class3,PC2_class3,PC3_class3,'k.','MarkerSize',16);       
       plot3(PC1_class4,PC2_class4,PC3_class4,'g.','MarkerSize',16);       
       plot3(PC1_class5,PC2_class5,PC3_class5,'m.','MarkerSize',16);
       legend('ASR','APR','CR','AMR','ADR')
       %------------椭圆画半透明的图，无法控制所每个椭球的颜色----------------
       %PCAConfidenceEllipsoid.m程序中第71行控制xy轴点的密集程度，画面取50
%        colormap = [0 1 1];
%        surf(x_CE1,y_CE1,z_CE1,'facealpha',0.2);              
%        surf(x_CE2,y_CE2,z_CE2,'facealpha',0.2);
%        surf(x_CE3,y_CE3,z_CE3,'facealpha',0.2);
%        surf(x_CE4,y_CE4,z_CE4,'facealpha',0.2);
%        surf(x_CE5,y_CE5,z_CE5,'facealpha',0.2);
%        shading interp;
       %-------------------椭圆画线图，每个椭球不同颜色----------------------
       %PCAConfidenceEllipsoid.m程序中第71行控制xy轴点的密集程度，画线取30
       plot3(x_CE1,y_CE1,z_CE1,'r-'); %view(3); rotate3d;
       plot3(x_CE2,y_CE2,z_CE2,'b-');
       plot3(x_CE3,y_CE3,z_CE3,'k-');
       plot3(x_CE4,y_CE4,z_CE4,'g-');
       plot3(x_CE5,y_CE5,z_CE5,'m-');
%------------------绘制预处理后的光谱图--------------------------------------
after_preprocess1 = x_train(index_class1,:); mean_after_preprocess1 = mean(x_train(index_class1,:));
after_preprocess2 = x_train(index_class2,:); mean_after_preprocess2 = mean(x_train(index_class2,:));
after_preprocess3 = x_train(index_class3,:); mean_after_preprocess3 = mean(x_train(index_class3,:));
after_preprocess4 = x_train(index_class4,:); mean_after_preprocess4 = mean(x_train(index_class4,:));
after_preprocess5 = x_train(index_class5,:); mean_after_preprocess5 = mean(x_train(index_class5,:));
figure;plot(after_preprocess1','r-');title('pretreated x-train');xlabel('Wavelength');ylabel('Transmission');hold on; 
       plot(after_preprocess2','b-');
       plot(after_preprocess3','k-');
       plot(after_preprocess4','g-');
       plot(after_preprocess5','m-');hold off;
%----------------绘制预处理后的平均光谱图------------------------------------
figure;plot(mean_after_preprocess1,'r-');title('pretreated mean x-train');xlabel('Wavelength');ylabel('Transmission');hold on; 
       plot(mean_after_preprocess2,'b-');
       plot(mean_after_preprocess3,'k-');
       plot(mean_after_preprocess4,'g-');
       plot(mean_after_preprocess5,'m-');hold off;


