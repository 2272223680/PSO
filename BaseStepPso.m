function [ParSwarm,OptSwarm,MaxValue]=BaseStepPso(ParSwarm,OptSwarm,ParticleScope,Int,Var,MaxV,CurCount,LoopCount)
%����������ȫ�ְ汾������������Ⱥ�㷨�ĵ�������λ��,�ٶȵ��㷨
%
%[ParSwarm,OptSwarm]=BaseStepPso(ParSwarm,OptSwarm,AdaptFunc,ParticleScope,MaxV)
%
%���������ParSwarm:����Ⱥ���󣬰������ӵ�λ�ã��ٶ��뵱ǰ��Ŀ�꺯��ֵ
%���������OptSwarm����������Ⱥ�������Ž���ȫ�����Ž��λ��
%���������ParticleScope:һ�������������и�ά�ķ�Χ��
%���������AdaptFunc����Ӧ�Ⱥ���
%���������Int: ����������ά���������������ĸ���
%�������:MaxV����ٶ�,-MaxV��С�ٶ�,��������Ϊ�ٶ�������
%�������:LoopCount��������


%���������ParSwarm�����º������Ⱥ����
%���������OptSwarm�����º���������Ž���Ⱥ���Ž�λ�þ���
%���������MaxValue��Ⱥ���Ž����Ӧ��ֵ�������÷�������MaxValue�������Ž⣩


%��ʼ�������µĲ���
%�õ�����ȺȺ���С�Լ�һ������ά������Ϣ
[ParRow,ParCol]=size(ParSwarm);
%�õ����ӵ�����
ParCol=(ParCol-1)/2;


%*********************************************
%*****�������Ӳ���*****
%****��ͬ���⣬�õĹ�������Ҳ��ͬ***************

%{
%���εݼ����ԣ�Ҫ���С����
w=zeros(1,ParCol);
for i=1:ParCol
   w(1,i)=MaxV(i)-CurCount*((MaxV(i)+MaxV(i))/LoopCount);
end
%}

%���Ȩ��
w=zeros(1,ParCol);
w(1,:)=random('unif',0.4,0.6,1,ParCol);

%{
%w�̶��������
w=zeros(1,ParCol);
for i=1:ParCol
   w(1,i)=0.7;
end
%}

%{
%w�����εݼ����԰������ݼ�
w=zeros(1,ParCol);
for i=1:ParCol
    w(1,i)=(MaxV(i)-MinV(i))*(CurCount/LoopCount)^2+(MinV(i)-MaxV(i))*(2*CurCount/LoopCount)+MaxV(i);
end
%}

%{
%w�����εݼ����԰������ݼ�
w=zeros(1,ParCol);
for i=1:ParCol
    w(1,i)=MinV(i)*(MaxV(i)/MinV(i))^(1/(1+10*CurCount/LoopCount));
end
%}
%*********************************************



%*********************************************
%*****�ٶȸ��²���*****
c1=2;
c2=2;
%
%con=1;
%c1=4-exp(-con*abs(mean(ParSwarm(:,2*ParCol+1))-AdaptFunc(OptSwarm(ParRow+1,:))));
%c2=4-c1;
%
%
%*********************************************



%*********************************************
%*****Լ������*****
%
%a=1;
%
a=0.729;
%*********************************************





%�ٶ�λ�þ���
TempV=zeros(ParRow,ParCol);
TempPos=zeros(ParRow,ParCol);
%ʵ��λ������������λ��֮��Ĳ
SubTract1=OptSwarm(1:ParRow,:)-ParSwarm(:,1:ParCol);

%��ʼ��Ⱥ���Ž�
MaxValue=AdaptFunc(OptSwarm(ParRow+1,:));

for row=1:ParRow
    %ʵ��λ����Ⱥ���Ž�֮��Ĳ
    SubTract2=OptSwarm(ParRow+1,:)-ParSwarm(row,1:ParCol);
    %�����ٶ�
    for col=1:ParCol
        TempV(row,col)=w(1,col)*ParSwarm(row,ParCol+col)+c1*random('unif',0,1).*SubTract1(row,col)+c2*random('unif',0,1).*SubTract2(col);
    end
    %���������ٶȣ�
    for i=1:ParCol
        if TempV(row,i)>MaxV(i);
            TempV(row,i)=MaxV(i);
        end
        if TempV(row,i)<-MaxV(i);
            TempV(row,i)=-MaxV(i);
        end
    end
    ParSwarm(row,ParCol+1:2*ParCol)=TempV(row,:);
  
     %λ�ø��£�
     for i=1:col
         TempPos(row,i)=ParSwarm(row,i)+a*TempV(row,i);
     end
     
      %���α�����01�����Ĵ���
      if Var>0 && Int>0
         for i=1:Var
             TempPos(row,i)=round(TempPos(row,i));     %��������;
         end 
         for i=Var+1:Int+Var
             %TempPos(row,i)=floor(TempPos(row,i));    %������ȡ��;
             %TempPos(row,i)=ceil(TempPos(row,i));     %������ȡ��;
             TempPos(row,i)=round(TempPos(row,i));    %��������;
             %TempPos(row,i)=fix(TempPos(row,i));      %ȡ�����������;
             %������α����Ķ�����������
             if TempPos(row,i)>ParticleScope(i,2)
                  TempPos(row,i)=TempPos(row,i)-1;
             elseif TempPos(row,i)<ParticleScope(i,1)
                  TempPos(row,i)=TempPos(row,i)+1;
             end
         end
      elseif Var>0
              for i=1:Var
                 TempPos(row,i)=round(TempPos(row,i));     %��������;
              end 
      elseif Int>0
              for i=1:Int
                 %TempPos(row,i)=floor(TempPos(row,i));    %������ȡ��;
                 %TempPos(row,i)=ceil(TempPos(row,i));     %������ȡ��;
                 TempPos(row,i)=round(TempPos(row,i));    %��������;
                 %TempPos(row,i)=fix(TempPos(row,i));       %ȡ�����������;
                 %������α����Ķ�����������
                 if TempPos(row,i)>ParticleScope(i,2)
                      TempPos(row,i)=TempPos(row,i)-1;
                 elseif ParSwarm(row,i)<ParticleScope(i,1)
                      TempPos(row,i)=TempPos(row,i)+1;
                 end
              end
      end
      %����λ�ã�
       for i=1:ParCol
           if TempPos(row,i)>=ParticleScope(i,2)
                 TempPos(row,i)=ParticleScope(i,2);
           end
           if TempPos(row,i)<=ParticleScope(i,1)
                 TempPos(row,i)=ParticleScope(i,1);
           end    
      end
      
      %����ʽԼ�����÷����������棻
      %{
         n=1;
         while(n<100)
            %λ�õĳ�������
             if (TempPos(row,1)+TempPos(row,2)+TempPos(row,3)+TempPos(row,4)+TempPos(row,5)<=400)&&((TempPos(row,1)+2*TempPos(row,2)+2*TempPos(row,3)+TempPos(row,4)+6*TempPos(row,5)<=800))&&((2*TempPos(row,1)+TempPos(row,2)+6*TempPos(row,3)<=200))&&((TempPos(row,3)+TempPos(row,4)+5*TempPos(row,5)<=200))
             %����ʽԼ��
             break;
             else
                 random=rand;
                 for i=1:ParCol
                      TempPos(row,i)=TempPos(row,i)*random;
                     %λ��˥����������Ϊ���Կ���һ�����죻
                 end
             end
             n=n+1;
         end
     %}
      %{
      while(~((TempPos(row,1)+TempPos(row,2)+TempPos(row,3)+TempPos(row,4)+TempPos(row,5)<=400) && ((TempPos(row,1)+2*TempPos(row,2)+2*TempPos(row,3)+TempPos(row,4)+6*TempPos(row,5)<=800)) && ((2*TempPos(row,1)+TempPos(row,2)+6*TempPos(row,3)<=200)) && ((TempPos(row,3)+TempPos(row,4)+5*TempPos(row,5)<=200))))
           random=rand;
                 for i=1:ParCol
                     TempPos(row,i)=TempPos(row,i)*random;
                     %λ��˥����������Ϊ���Կ���һ�����죻
                 end
       end
       %} 
      
     
     %����λ�� 
     ParSwarm(row,1:ParCol)=TempPos(row,:);
     %����ÿ�����ӵ��µ���Ӧ��ֵ
     ParSwarm(row,2*ParCol+1)=AdaptFunc(ParSwarm(row,1:ParCol));
     if ParSwarm(row,2*ParCol+1)>AdaptFunc(OptSwarm(row,1:ParCol))
         OptSwarm(row,1:ParCol)=ParSwarm(row,1:ParCol);
     end
     %ÿ��������Ӧ��ֵ�ø��£�
    
end



%�ڵ��������м����������,�䵱�������أ���������ֲ����Ž⣻
if CurCount<1*LoopCount/4 && CurCount>1*LoopCount/2
    k=ceil(ParRow*random('Poisson',0,0.5));
    for n=k:ParRow
       ParSwarm(n,:)=random('unif',ParticleScope(i,1),ParticleScope(i,2),1,2*ParCol+1);
       while (1)
      %���α�����01�����Ĵ���
      if Var>0 && Int>0
         for i=1:Var
             ParSwarm(n,i)=round(ParSwarm(n,i));    %��������;
         end 
         for i=Var+1:Int+Var
             %ParSwarm(n,i)=floor(ParSwarm(n,i));    %������ȡ��;
             %ParSwarm(n,i)=ceil(ParSwarm(n,i));     %������ȡ��;
             ParSwarm(n,i)=round(ParSwarm(n,i));     %��������;
             %ParSwarm(n,i)=fix(ParSwarm(n,i));      %ȡ�����������;             
             %������α����Ķ�����������
             if ParSwarm(n,i)>ParticleScope(i,2)
                 ParSwarm(n,i)=ParSwarm(n,i)-1;
             elseif ParSwarm(n,i)<ParticleScope(i,1)
                 ParSwarm(n,i)=ParSwarm(n,i)+1;
             end
         end
      elseif Int>0
              for i=1:Int
                 %ParSwarm(n,i)=floor(ParSwarm(n,i));    %������ȡ��;
                 %ParSwarm(n,i)=ceil(ParSwarm(n,i));     %������ȡ��;
                 ParSwarm(n,i)=round(ParSwarm(n,i));     %��������;
                 %ParSwarm(n,i)=fix(ParSwarm(n,i));      %ȡ�����������;
                 %������α����Ķ�����������
                 if ParSwarm(n,i)>ParticleScope(i,2)
                     ParSwarm(n,i)=ParSwarm(n,i)-1;
                 elseif ParSwarm(n,i)<ParticleScope(i,1)
                     ParSwarm(n,i)=ParSwarm(n,i)+1;
                 end
              end
             
      elseif Var>0
              for i=1:Var
                 ParSwarm(n,i)=round(ParSwarm(n,i));    %��������;
              end 
      else
      end
      %����ɸѡ�������۳������ӣ�
      if AdaptFunc(ParSwarm(n,:))>-Filter 
           %��ʼ�ٶ����ã�ϵ��0.2�ɵ�
           ParSwarm(n,ParticleSize:2*ParticleSize)=coefV*random('unif',0,1)*ParSwarm(n,ParticleSize:2*ParticleSize);
           break;
      else
           ParSwarm(n,:)=random('unif',ParticleScope(n,1),ParticleScope(n,2),1,2*ParticleSize+1);
           %unif��ƽ���ֲ��������λ�ã�norm����̬�ֲ��������λ�ã�poiss�������ֲ��������λ�á�
      end
       end
      %��Ӧ�ȸ��£�����λ�ø���
      ParSwarm(n,2*ParCol+1)=AdaptFunc(ParSwarm(n,1:ParCol));
      if ParSwarm(n,2*ParCol+1)>AdaptFunc(OptSwarm(n,1:ParCol))
         OptSwarm(n,1:ParCol)=ParSwarm(n,1:ParCol);
      end
     end
end




%ȫ�����Ž�λ�ø���
[Max,row]=max(ParSwarm(:,2*ParCol+1));
if  Max>MaxValue
    %����λ�ø���
    OptSwarm(ParRow+1,:)=ParSwarm(row,1:ParCol);
    %���Ž����
    MaxValue=Max;
end
end