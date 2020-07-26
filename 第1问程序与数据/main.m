%logistics回归（人口模型）

%% 论文方法
clc
clear
load('date.mat');
x=date(:,1);%%相应时间人口
t=date(:,2);%%已知数据时间
dt=1;
for i=1:(length(x)-1)
    r(i)=(x(i+dt)-x(i))/x(i);
end
p=polyfit(x(1:end-1)',r,1);  
cs=abs(p(2)/p(1));

%cs=170等待标定
y=log(cs./x-1);
p1=polyfit(t,y,1);
a=exp(p1(2));
b=-p1(1);
fun=@(td) cs./(1+a*exp(-b*td));
year=[2000:2090];%%横坐标范围
xhat=fun(year);
plot(year,xhat);





%% 工具箱方法
%logistics回归（人口模型）
clc
clear
load('date.mat');
x=date(:,1);%%相应时间人口
t=date(:,2);%%已知数据时间点
t0=t(1);
x0=x(1);
fun=@(cs,td)cs(1)./(1+(cs(1)/x0-1)*exp(-cs(2)*(td-t0)));%S型曲线方程 这里为增长速率越来越小
%最后为零 故函数一直增长直到固定值（不会下降）
cs=lsqcurvefit(fun,rand(2,1),t(4:3:end),x(4:3:end),zeros(2,1))%确定参数
year=[2000:2035];%%横坐标范围
xhat=fun(cs,year);
plot(year,xhat);
