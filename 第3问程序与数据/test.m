function flag=test(lenchrom,bound,code)
% lenchrom   input : Ⱦɫ�峤��
% bound      input : ������ȡֵ��Χ
% code       output: Ⱦɫ��ı���ֵ
flag=1;
for i=1:length(lenchrom)
    if (code(i)<bound(i,1))||(code(i)>bound(i,2))
        flag=0;    %ȡֵ��ΧԼ��
        break;
    end
end
for i=1:5
    if (bound(10*i,2)-sum(code( (10*i-9) :(10*i) ) )>bound(10*i,2))||(bound(10*i,2)-sum(code( (10*i-9) :(10*i) ) )<bound(10*i,1))
        flag=0;    %ȡֵ��ΧԼ��
        break;
    end
end
