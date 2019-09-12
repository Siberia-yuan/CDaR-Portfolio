load Data;
rets=price2ret(Prices(:,:));
[m,n]=size(rets);
cumuSum=zeros(m,n);
records=zeros(1,n);
constrain=0.15;

for j=1:m
    for k=1:n
        records(k)=records(k)+rets(j,k);
        cumuSum(j,k)=cumuSum(j,k)+records(k);
    end
end


meanPort=-mean(rets);
target=[meanPort zeros(1,1+m)];
%target=[meanPort];
A=[];
b=[];

%x<=1 number is n
for i_0=1:n
    A=[A;[zeros(1,i_0-1) 1 zeros(1,n+1+m-i_0)]];
    %A=[A;[zeros(1,i_0-1) 1 zeros(1,n-i_0)]];
end
b=[b ones(1,n)];

%-x<=0 number is n
for i_1=1:n
    A=[A;[zeros(1,i_1-1) -1 zeros(1,n+1+m-i_1)]];
    %A=[A;[zeros(1,i_1-1) -1 zeros(1,n-i_1)]];
end
b=[b zeros(1,n)];

%sum X=1
%sum X<=1
A=[A;[ones(1,n) zeros(1,1+m)]];
%A=[A;[ones(1,n)]];
b=[b 1];
%sum -X<=-1
A=[A;[-1*ones(1,n) zeros(1,1+m)]];
%A=[A;[-1*ones(1,n)]];
b=[b -1];

% %u0=0
% %u0<=0;
% %-u0<=0;
% 
A=[A;[zeros(1,n) 1 zeros(1,m)]];
A=[A;[zeros(1,n) -1 zeros(1,m)]];
b=[b 0];
b=[b 0];


%uk-1-uk<=0

for i_2=1:m
    A=[A;[zeros(1,n+i_2-1) 1 -1 zeros(1,m-i_2)]];
end
b=[b zeros(1,m)];

%ykx-uk<=0

for i_3=1:m
    temp=[];
    for i_4=1:n
        temp=[temp cumuSum(i_3,i_4)];
    end
    A=[A;[temp zeros(1,i_3) -1 zeros(1,m-i_3)]];
end
b=[b zeros(1,m)];

% %uk-ykx<=constrain

for i_5=1:m
    temp1=[];
    for i_6=1:n
        temp1=[temp1 -1*cumuSum(i_5,i_6)];
    end
    A=[A;[temp1 zeros(1,i_5) 1 zeros(1,m-i_5)]];       
end

b=[b constrain*ones(1,m)];
[x,fval]=linprog(target,A,b);
-1*fval;
x(1:14)

result=zeros(1,m);
for n_0=1:n
    result=result+x(n_0)*cumuSum(:,n_0);
end
plot(result)



    
