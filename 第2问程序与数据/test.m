function flag=test(lenchrom,bound,code)
% lenchrom   input : 染色体长度
% bound      input : 变量的取值范围
% code       output: 染色体的编码值
flag=1;
for i=1:length(lenchrom)
    if (code(i)<bound(i,1))||(code(i)>bound(i,2))
        flag=0;    %取值范围约束
        break;
    end
end
for i=1:5
    if (bound(10*i,2)-sum(code( (10*i-9) :(10*i) ) )>bound(10*i,2))||(bound(10*i,2)-sum(code( (10*i-9) :(10*i) ) )<bound(10*i,1))
        flag=0;    %取值范围约束
        break;
    end
end
