%% GA
%% 清空环境变量
clc,clear,close all
clear global
warning off
feature jit off

%% 遗传算法参数初始化
maxgen = 1000;                      % 进化代数，即迭代次数
sizepop = 100;                     % 种群规模
pcross = 0.7;                    % 交叉概率选择，0和1之间
pmutation = 0.01;                 % 变异概率选择，0和1之间
%染色体设置
people = xlsread('person.xlsx', 'sheet1', 'C15:G15');%读取南京市预测年份老年人口
people=people.*10000;
old_rate=xlsread('person.xlsx', 'sheet1', 'B3:B13');%读取南京市各区老年人口比例
income=[0.2,0.2,0.2,0.2,0.2];%各等级收入范围
bed_size=[10,50,80,120,150];%不同等级养老院床位
bed_old=ceil(149.930*10000*45/1000);%现已有床位,149.930万为2020年人口
%% 前两个三年规划，正常增速
for i=1:2
    bed_new=ceil(people(i)*(45+3*i)/1000);%该年所需床位
    bed(i)=bed_new-bed_old;%该三年所需建设的床位
    bed_year(i,:)=ceil(bed(i).*income./bed_size);%该三年各机构建设数目
    bed_old=bed_old+sum(bed_year(i,:).*bed_size);
end
%% 2027年，智能机器人引入，替代养老机构
down=1;%替代率每三年增长率为0.1%，即每千人居家养老人数，每三年增加1
for i=3:5
    bed_new=ceil(people(i)*(45+3*i-down*(i-2))/1000);%该年所需床位
    bed(i)=bed_new-bed_old;%该三年所需建设的床位
    bed_year(i,:)=ceil(bed(i).*income./bed_size);%该三年各机构建设数目
    bed_old=bed_old+sum(bed_year(i,:).*bed_size);
end
for yy=1:5
    lenchrom=ones(1,5*(length(old_rate)-1));    % 每个区前4个变量为控制变量，最后一个利用等式约束求

    bound1=zeros(5*(length(old_rate)-1),1);
    bound2=[];
    for i=1:5
        bound2=[bound2;bed_year(yy,i).*ones(length(old_rate)-1,1)];
    end
    bound=[bound1 bound2];   % 数据范围
    demand=ceil(bed(yy).*old_rate*income);%各地区各等级床位需求数

    %% ---------------------------种群初始化------------------------------------
    individuals=struct('fitness',zeros(1,sizepop), 'chrom',[]);  %将种群信息定义为一个结构体
    avgfitness = [];                      %每一代种群的平均适应度
    bestfitness = [];                     %每一代种群的最佳适应度
    bestchrom = [];                       %适应度最好的染色体

    %% 初始化种群
    for i=1:sizepop
        % 随机产生一个种群
        individuals.chrom(i,:)=Code(lenchrom,bound); % 编码（binary和grey的编码结果为一个实数，float的编码结果为一个实数向量）
        x=individuals.chrom(i,:);
        % 计算适应度
        individuals.fitness(i)=fun(x,bed_year(yy,:),demand);   % 染色体的适应度 
    end

    %% 找最好的染色体
    [bestfitness bestindex] = min(individuals.fitness);
    bestchrom = individuals.chrom(bestindex,:);    % 最好的染色体
    % 记录每一代进化中最好的适应度和平均适应度
    trace=zeros((maxgen+1),1);
    trace(1) = bestfitness; 
    %% 迭代求解最佳初始阀值和权值
    % 进化开始
    for i=1:maxgen
        % 选择
        individuals=Select(individuals,sizepop);
        % 交叉
        individuals.chrom=Cross(pcross,lenchrom,individuals.chrom,sizepop,bound);
        % 变异
        individuals.chrom=Mutation(pmutation,lenchrom,individuals.chrom,sizepop,i,maxgen,bound);
        % 计算适应度
        for j=1:sizepop
            x=individuals.chrom(j,:);        % 解码
            individuals.fitness(j)=fun(x,bed_year(yy,:),demand);   % 染色体的适应度 
        end

        % 找到最小和最大适应度的染色体及它们在种群中的位置
        [newbestfitness,newbestindex]=min(individuals.fitness);
        [worestfitness,worestindex]=max(individuals.fitness);
        % 代替上一次进化中最好的染色体
        if bestfitness>newbestfitness
            bestfitness=newbestfitness;
            bestchrom=individuals.chrom(newbestindex,:);
        end
        individuals.chrom(worestindex,:)=bestchrom; % 剔除最差个体
        trace(i+1)=bestfitness; %记录每一代进化中最好的适应度
    end
    bestchrom=round(bestchrom);
    supply1=[bestchrom(1:10);bestchrom(11:20); bestchrom(21:30); bestchrom(31:40); bestchrom(41:50)]';
    supply2=[bed_year(yy,1)-sum(bestchrom(1:10)) bed_year(yy,2)-sum(bestchrom(11:20)) bed_year(yy,3)-sum(bestchrom(21:30)) bed_year(yy,4)-sum(bestchrom(31:40)) bed_year(yy,5)-sum(bestchrom(41:50))];
    supply=[supply1;supply2];
    result_trace(yy,:)=trace';
    result_fitness(yy)=bestfitness;
    result_supply{yy}=supply;
end
