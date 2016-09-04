function [ParSwarm,OptSwarm,maxValue]=BaseStepPso(ParSwarm,OptSwarm,ParticleScope,Integer,MaxV,MinV,CurCount,LoopCount)
%����������ȫ�ְ汾������������Ⱥ�㷨�ĵ�������λ��,�ٶȵ��㷨
%
%[ParSwarm,OptSwarm]=BaseStepPso(ParSwarm,OptSwarm,AdaptFunc,ParticleScope,MaxW,MinW,LoopCount,CurCount)
%
%���������ParSwarm:����Ⱥ���󣬰������ӵ�λ�ã��ٶ��뵱ǰ��Ŀ�꺯��ֵ������ǰInteger������������������Ϊ������������
%���������OptSwarm����������Ⱥ�������Ž���ȫ�����Ž�ľ���
%���������ParticleScope:һ�������������и�ά�ķ�Χ��
%���������AdaptFunc����Ӧ�Ⱥ���
%���������Integer: ����������ά���������������ĸ���
%�������:MaxV����ٶ�,MinV��С�ٶ�,
%�������:CurCount��ǰ����������LoopCount��������
%����ֵ��ParSwarm OptSwarm
%

%��ʼ�������µĲ���
%�õ�����ȺȺ���С�Լ�һ������ά������Ϣ
[ParRow,ParCol]=size(ParSwarm);
%�õ����ӵ�ά��
ParCol=(ParCol-1)/2;


%*********************************************
%*****��������Ĵ��룬���Ը��Ĺ������ӵı仯*****
%****��ͬ���⣬�õĹ�������Ҳ��ͬ***************
%{
%���εݼ�����
w=zeros(1,ParCol);
for i=1:ParCol
   w(1,i)=MaxV(i)-CurCount*((MaxV(i)-MinV(i))/LoopCount);
end
%}


%w�̶��������
w=zeros(1,ParCol);
for i=1:ParCol
   w(1,i)=0.7;
end


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


SubTract1=OptSwarm(1:ParRow,:)-ParSwarm(:,1:ParCol);

%*********************************************
%*****��������Ĵ��룬���Ը���c1,c2�ı仯*****
c1=2;
c2=2;
%
%con=1;
%c1=4-exp(-con*abs(mean(ParSwarm(:,2*ParCol+1))-AdaptFunc(OptSwarm(ParRow+1,:))));
%c2=4-c1;
%
%
%*********************************************

TempV=zeros(ParRow,ParCol);
TempPos=zeros(ParRow,ParCol);
for row=1:ParRow
    SubTract2=OptSwarm(ParRow+1,:)-ParSwarm(row,1:ParCol);
    for col=1:ParCol
        TempV(row,col)=w(1,col)*ParSwarm(row,ParCol+col)+c1*unifrnd(0,1).*SubTract1(row,col)+c2*unifrnd(0,1).*SubTract2(col);
    end
    for h=1:ParCol
        if TempV(row,h)>0.2*(ParticleScope(h,2)-ParticleScope(h,1));
            TempV(row,h)=0.2*(ParticleScope(h,2)-ParticleScope(h,1));
        end
        if TempV(row,h)<-0.2*(ParticleScope(h,2)-ParticleScope(h,1));
            TempV(row,h)=-0.2*(ParticleScope(h,2)-ParticleScope(h,1));
            %��1e-10��ֹ��Ӧ�Ⱥ��������
        end
    end
    %�����ٶȵĴ���;
    ParSwarm(row,ParCol+1:2*ParCol)=TempV(row,:);
    %�����ٶ�
     
     %*********************************************
     %*****��������Ĵ��룬���Ը���Լ�����ӵı仯*****
     %
     %a=1;
     %
     a=0.729;
     %*********************************************
     for col=1:Integer
         TempPos(row,col)=floor(ParSwarm(row,col)+a*TempV(row,col));
     end
     for col=Integer+1:ParCol
         TempPos(row,col)=ParSwarm(row,col)+a*TempV(row,col);
     end
     %λ�ø��£�
      for h=1:ParCol
                if TempPos(row,h)>ParticleScope(h,2)
                     TempPos(row,h)=ParticleScope(h,2);
                end
                if TempPos(row,h)<=ParticleScope(h,1)
                    TempPos(row,h)=ParticleScope(h,1);
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
      
     ParSwarm(row,1:ParCol)=TempPos(row,:);
     %����λ��

     ParSwarm(row,2*ParCol+1)=AdaptFunc(ParSwarm(row,1:ParCol));
     %����ÿ�����ӵ��µ���Ӧ��ֵ
     if ParSwarm(row,2*ParCol+1)>AdaptFunc(OptSwarm(row,1:ParCol))
         OptSwarm(row,1:ParCol)=ParSwarm(row,1:ParCol);
     end
     %ÿ��������Ӧ��ֵ�ø��£�
end
%forѭ������

%Ѱ����Ӧ�Ⱥ���ֵ���Ľ��ھ����е�λ��(����)������ȫ�����ŵĸı� 
[maxValue,row]=max(ParSwarm(:,2*ParCol+1));
if  maxValue>AdaptFunc(OptSwarm(ParRow+1,:))
    OptSwarm(ParRow+1,:)=ParSwarm(row,1:ParCol);
end
end