close all;clear;clc
%数据包含5类中药，共191个样品
%当归 (Angelicae sinensis Radix,ASR) 40个
%独活（Angelicae pubescentis Radix, APR) 39个
%川芎（Chuanxiong Rhizoma, CR）38个
%白术（Atractylodis macrocephalae Rhizoma, AMR）35个
%白芷（Angelicae dahuricae Radix, ADR）39个
load UV_TCM_20180416_One
class_method             = 2;
switch class_method
case 1
%-----------------KS对整体数据划分，训练集2/3，预测集1/3---------------------
cal                      = Spectra;
caltar                   = Target;
[m,n]                    = size(cal);
[model,test]             = kenstone(cal,floor(2/3*m));
x_train                  = cal(model,:);
x_pred                   = cal(test,:);
y_train                  = caltar(model);
y_pred                   = caltar(test);
case 2
%--------------KS对10类数据分划2分，训练集2/3，预测集1/3---------------------
cal1 = Spectra(1:40,:);cal2 = Spectra(41:79,:); cal3 = Spectra(80:117,:);cal4 = Spectra(118:152,:);cal5 = Spectra(153:191,:);
caltar1 = Target(1:40);caltar2 = Target(41:79); caltar3 = Target(80:117);caltar4 = Target(118:152);caltar5 = Target(153:191);
[m1,n1]                  = size(cal1);
[model1,test1]           = kenstone(cal1,floor(3/4*m1)); 
[m2,n2]                  = size(cal2);
[model2,test2]           = kenstone(cal2,floor(3/4*m2));
[m3,n3]                  = size(cal3);
[model3,test3]           = kenstone(cal3,floor(3/4*m3));
[m4,n4]                  = size(cal4);
[model4,test4]           = kenstone(cal4,floor(3/4*m4));
[m5,n5]                  = size(cal5);
[model5,test5]           = kenstone(cal5,floor(3/4*m5));
x_train                  = [cal1(model1,:); cal2(model2,:); cal3(model3,:);cal4(model4,:);cal5(model5,:)];
x_pred                   = [cal1(test1,:); cal2(test2,:); cal3(test3,:);cal4(test4,:);cal5(test5,:)];
y_train                  = [caltar1(model1); caltar2(model2); caltar3(model3);caltar4(model4);caltar5(model5)];
y_pred                   = [caltar1(test1); caltar2(test2); caltar3(test3);caltar4(test4);caltar5(test5)];
case 3
%--------------整体数据顺序选取2/3作为训练集，1/3作为预测集-------------------
cal                      = Spectra;
caltar                   = Target;
[m,n]                    = size(cal);
index_pred               = 3:3:m;
x_pred                   = cal(index_pred,:);
y_pred                   = caltar(index_pred);
cal(index_pred,:)        = [];
caltar(index_pred)       = [];
x_train                  = cal;
y_train                  = caltar;
case 4
%-----------------整体随机选取2/3作为训练集，1/3作为预测集--------------------
cal                      = Spectra;
caltar                   = Target;
[m,n]                    = size(cal);
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
scalen  = 6;            waveletfunction = 'sym6'; 
[x_train]               = wavderiv(x_train,waveletfunction,scalen);
[x_pred]                = wavderiv(x_pred,waveletfunction,scalen);

figure;plot(x_train');
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
window0 = 19;
x_train                 = sgdiff(x_train,2,window0,0);
x_pred                  = sgdiff(x_pred,2,window0,0);
%---------------------------ELM--------------------------------------------
disp('ELM预测的训练集及预测集的预测正确率');
tic
[c_train, c_ELM, TrainingAccuracy, TestingAccuracy] = elm(x_train,y_train,x_pred,y_pred,1,100,'hardlim');
disp([TrainingAccuracy, TestingAccuracy]);
%[c_train, c_ELM, TrainingAccuracy, TestingAccuracy] =elm(x_trainPCA,y_train,x_predPCA,y_pred,0, 10, 'sig');
toc
