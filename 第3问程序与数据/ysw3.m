%% GA
%% ��ջ�������
clc,clear,close all
clear global
warning off
feature jit off

%% �Ŵ��㷨������ʼ��
maxgen = 1000;                      % ��������������������
sizepop = 100;                     % ��Ⱥ��ģ
pcross = 0.7;                    % �������ѡ��0��1֮��
pmutation = 0.01;                 % �������ѡ��0��1֮��
%Ⱦɫ������
people = xlsread('person.xlsx', 'sheet1', 'C15:G15');%��ȡ�Ͼ���Ԥ����������˿�
people=people.*10000;
old_rate=xlsread('person.xlsx', 'sheet1', 'B3:B13');%��ȡ�Ͼ��и��������˿ڱ���
income=[0.2,0.2,0.2,0.2,0.2];%���ȼ����뷶Χ
bed_size=[10,50,80,120,150];%��ͬ�ȼ�����Ժ��λ
bed_old=ceil(149.930*10000*45/1000);%�����д�λ,149.930��Ϊ2020���˿�
%% ǰ��������滮����������
for i=1:2
    bed_new=ceil(people(i)*(45+3*i)/1000);%�������贲λ
    bed(i)=bed_new-bed_old;%���������轨��Ĵ�λ
    bed_year(i,:)=ceil(bed(i).*income./bed_size);%�����������������Ŀ
    bed_old=bed_old+sum(bed_year(i,:).*bed_size);
end
%% 2027�꣬���ܻ��������룬������ϻ���
down=1;%�����ÿ����������Ϊ0.1%����ÿǧ�˾Ӽ�����������ÿ��������1
for i=3:5
    bed_new=ceil(people(i)*(45+3*i-down*(i-2))/1000);%�������贲λ
    bed(i)=bed_new-bed_old;%���������轨��Ĵ�λ
    bed_year(i,:)=ceil(bed(i).*income./bed_size);%�����������������Ŀ
    bed_old=bed_old+sum(bed_year(i,:).*bed_size);
end
for yy=1:5
    lenchrom=ones(1,5*(length(old_rate)-1));    % ÿ����ǰ4������Ϊ���Ʊ��������һ�����õ�ʽԼ����

    bound1=zeros(5*(length(old_rate)-1),1);
    bound2=[];
    for i=1:5
        bound2=[bound2;bed_year(yy,i).*ones(length(old_rate)-1,1)];
    end
    bound=[bound1 bound2];   % ���ݷ�Χ
    demand=ceil(bed(yy).*old_rate*income);%���������ȼ���λ������

    %% ---------------------------��Ⱥ��ʼ��------------------------------------
    individuals=struct('fitness',zeros(1,sizepop), 'chrom',[]);  %����Ⱥ��Ϣ����Ϊһ���ṹ��
    avgfitness = [];                      %ÿһ����Ⱥ��ƽ����Ӧ��
    bestfitness = [];                     %ÿһ����Ⱥ�������Ӧ��
    bestchrom = [];                       %��Ӧ����õ�Ⱦɫ��

    %% ��ʼ����Ⱥ
    for i=1:sizepop
        % �������һ����Ⱥ
        individuals.chrom(i,:)=Code(lenchrom,bound); % ���루binary��grey�ı�����Ϊһ��ʵ����float�ı�����Ϊһ��ʵ��������
        x=individuals.chrom(i,:);
        % ������Ӧ��
        individuals.fitness(i)=fun(x,bed_year(yy,:),demand);   % Ⱦɫ�����Ӧ�� 
    end

    %% ����õ�Ⱦɫ��
    [bestfitness bestindex] = min(individuals.fitness);
    bestchrom = individuals.chrom(bestindex,:);    % ��õ�Ⱦɫ��
    % ��¼ÿһ����������õ���Ӧ�Ⱥ�ƽ����Ӧ��
    trace=zeros((maxgen+1),1);
    trace(1) = bestfitness; 
    %% ���������ѳ�ʼ��ֵ��Ȩֵ
    % ������ʼ
    for i=1:maxgen
        % ѡ��
        individuals=Select(individuals,sizepop);
        % ����
        individuals.chrom=Cross(pcross,lenchrom,individuals.chrom,sizepop,bound);
        % ����
        individuals.chrom=Mutation(pmutation,lenchrom,individuals.chrom,sizepop,i,maxgen,bound);
        % ������Ӧ��
        for j=1:sizepop
            x=individuals.chrom(j,:);        % ����
            individuals.fitness(j)=fun(x,bed_year(yy,:),demand);   % Ⱦɫ�����Ӧ�� 
        end

        % �ҵ���С�������Ӧ�ȵ�Ⱦɫ�弰��������Ⱥ�е�λ��
        [newbestfitness,newbestindex]=min(individuals.fitness);
        [worestfitness,worestindex]=max(individuals.fitness);
        % ������һ�ν�������õ�Ⱦɫ��
        if bestfitness>newbestfitness
            bestfitness=newbestfitness;
            bestchrom=individuals.chrom(newbestindex,:);
        end
        individuals.chrom(worestindex,:)=bestchrom; % �޳�������
        trace(i+1)=bestfitness; %��¼ÿһ����������õ���Ӧ��
    end
    bestchrom=round(bestchrom);
    supply1=[bestchrom(1:10);bestchrom(11:20); bestchrom(21:30); bestchrom(31:40); bestchrom(41:50)]';
    supply2=[bed_year(yy,1)-sum(bestchrom(1:10)) bed_year(yy,2)-sum(bestchrom(11:20)) bed_year(yy,3)-sum(bestchrom(21:30)) bed_year(yy,4)-sum(bestchrom(31:40)) bed_year(yy,5)-sum(bestchrom(41:50))];
    supply=[supply1;supply2];
    result_trace(yy,:)=trace';
    result_fitness(yy)=bestfitness;
    result_supply{yy}=supply;
end
