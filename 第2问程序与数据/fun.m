function [f] = fun(x,bed,demand)
%该函数用来计算适应度值
x=round(x);
bed_size=[10,50,80,120,150];%不同等级养老院床位
supply1=[x(1:10);x(11:20); x(21:30); x(31:40); x(41:50)]';
supply2=[bed(1)-sum(x(1:10)) bed(2)-sum(x(11:20)) bed(3)-sum(x(21:30)) bed(4)-sum(x(31:40)) bed(5)-sum(x(41:50))];
supply=[supply1;supply2];
supply=supply.*bed_size;
cha=demand-supply;
f=sum(cha(cha>0));









