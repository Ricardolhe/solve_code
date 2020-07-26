%logistics�ع飨�˿�ģ�ͣ�

%% ���ķ���
clc
clear
load('date.mat');
x=date(:,1);%%��Ӧʱ���˿�
t=date(:,2);%%��֪����ʱ��
dt=1;
for i=1:(length(x)-1)
    r(i)=(x(i+dt)-x(i))/x(i);
end
p=polyfit(x(1:end-1)',r,1);  
cs=abs(p(2)/p(1));

%cs=170�ȴ��궨
y=log(cs./x-1);
p1=polyfit(t,y,1);
a=exp(p1(2));
b=-p1(1);
fun=@(td) cs./(1+a*exp(-b*td));
year=[2000:2090];%%�����귶Χ
xhat=fun(year);
plot(year,xhat);





%% �����䷽��
%logistics�ع飨�˿�ģ�ͣ�
clc
clear
load('date.mat');
x=date(:,1);%%��Ӧʱ���˿�
t=date(:,2);%%��֪����ʱ���
t0=t(1);
x0=x(1);
fun=@(cs,td)cs(1)./(1+(cs(1)/x0-1)*exp(-cs(2)*(td-t0)));%S�����߷��� ����Ϊ��������Խ��ԽС
%���Ϊ�� �ʺ���һֱ����ֱ���̶�ֵ�������½���
cs=lsqcurvefit(fun,rand(2,1),t(4:3:end),x(4:3:end),zeros(2,1))%ȷ������
year=[2000:2035];%%�����귶Χ
xhat=fun(cs,year);
plot(year,xhat);
