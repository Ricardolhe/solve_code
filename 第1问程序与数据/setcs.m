%logistics回归（人口模型）

%% 论文方法
clc
clear
load('nihe.mat');
x1=nihe(:,1);%%相应时间人口
t1=nihe(:,2);%%已知数据时间
%load('date.mat');
%x1=date(:,1);%%相应时间人口
%t1=date(:,2);%%已知数据时间
cs=160;

y=log(cs./x1-1);
p1=polyfit(t1,y,1);
a=exp(p1(2));
b=-p1(1);
fun=@(td) cs./(1+a*exp(-b*td));

year=[2000:2100];
xhat=fun(year);
plot(year,xhat);

x_pre=fun(t1);
sst=sum((x1-mean(x1)).^2);
sse=sum((x1-x_pre).^2);
r2=1-sse/sst;


