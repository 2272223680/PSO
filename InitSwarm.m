
function [ParSwarm,OptSwarm,MaxV,MinV]=InitSwarm(SwarmSize,ParticleSize,ParticleScope,Integer)
 %[ParSwarm,OptSwarm,BadSwarm]=InitSwarm(SwarmSize,ParticleSize,ParticleScope,AdaptFunc)
 %
 %���������SwarmSize:��Ⱥ��С�ĸ���
 %���������ParticleSize��һ�����ӵ�ά��,����ǰInteger������������������Ϊ������������
 %���������ParticleScope:һ�������������и�ά�ķ�Χ��
 %����ParticleScope��ʽ:
 %����3ά���ӵ�ParticleScope��ʽ:
 %                               [x1Min,x1Max]
 %��������������������������������  x2Min,x2Max
 %                                x3Min,x3Max]
 %
 %���������AdaptFunc����Ӧ�Ⱥ���
 %���������Integer: ����������ά���������������ĸ���
 %�����ParSwarm��ʼ��������Ⱥ
 %�����OptSwarm����Ⱥ��ǰ���Ž���ȫ�����Ž�
 %

 %��ʼ������Ⱥ����
 %��ʼ������Ⱥ����ȫ����Ϊ[0-1]�����
 %rand('state',0);
 %ParSwarmǰParticleSize��Ϊλ�ò�����ParticleSize~2*ParticleSize��Ϊ�ٶȲ��������Ϊ��Ӧ�Ⱥ���
  
  
  %�����������,������Ⱥ�����������ַ�������
  ParSwarm=rand(SwarmSize,2*ParticleSize+1);  
 
  %{
  %1.����Ⱥ�����ı�������ѭ����ÿ��Ѱ��һ���������ӣ����������Ƚ�С�����⣬
    %��Ҫ�Ӵ������ܵõ��ȽϺõĳ�ʼ�㣬��Ҫ���ϳ��ԣ��Լ����ٶȵ�Ӱ��Ƚϴ�
  for n=1:SwarmSize
    Swarm=rand(20000*SwarmSize,ParticleSize);
    for i=1:ParticleSize
      Swarm(:,i)=Swarm(:,i)*(ParticleScope(i,2)-ParticleScope(i,1))+ParticleScope(i,1);
    end
     adapt=AdaptFunc(Swarm(:,1:ParticleSize));
    [maxValue,row]=max(adapt);
    ParSwarm(n,1:ParticleSize)=Swarm(row,1:ParticleSize);
  end
  %}
 
  
 
  %2.��while���ɸѡ�����ϲ���ʽԼ�������ӣ�����ɸѡ��������������Ӱ��ϴ�
  Filter=-100000;       %ɸѡ����,���ݷ�����ȷ����
 for n=1:SwarmSize
      Swarm=rand(1,ParticleSize);
      for i=1:ParticleSize
                Swarm(1,i)=Swarm(1,i)*(ParticleScope(i,2)-ParticleScope(i,1))+ParticleScope(i,1);
      end
      while (1)
          if AdaptFunc(Swarm(1,:))>Filter   
              break;
          else
              Swarm=rand(1,ParticleSize);
              for i=1:ParticleSize
                Swarm(1,i)=Swarm(1,i)*(ParticleScope(i,2)-ParticleScope(i,1))+ParticleScope(i,1);
             end
          end
      end
      ParSwarm(n,1:ParticleSize)=Swarm(1,:);
 end
  
  %{
  %3.��while���ɸѡ�����ϲ���ʽԼ����һ�����õġ����ӣ��Դ�Ϊ���ģ�������Ϊֱ���������ⷽ���������γ���Ⱥ��
     %ȱ�����ڣ����ɸѡ�������Ӳ������á�����������ֲ����Ž�!!!��
     Filter=-100000;       %ɸѡ����,���ݷ�����ȷ����
     Swarm=rand(1,ParticleSize);
      for i=1:ParticleSize
                Swarm(1,i)=Swarm(1,i)*(ParticleScope(i,2)-ParticleScope(i,1))+ParticleScope(i,1);
      end
      while (1)
          if AdaptFunc(Swarm(1,:))>Filter   
              break;
          else
              Swarm=rand(1,ParticleSize);
              for i=1:ParticleSize
                Swarm(1,i)=Swarm(1,i)*(ParticleScope(i,2)-ParticleScope(i,1))+ParticleScope(i,1);
             end
          end
      end 
      ParSwarm(1,1:ParticleSize)=Swarm(1,:);   %ɸѡ���ġ��õġ����ӣ�������Ⱥ�ġ�ĸ�������ӣ�
      for n=2:SwarmSize
          for i=1:ParticleSize
               ParSwarm(n,i)=ParSwarm(1,i)+0.5*(2*rand-1)*(ParticleScope(i,2)-ParticleScope(i,1));
              if ParSwarm(n,i)>ParticleScope(i,2)
                  ParSwarm(n,i)=ParticleScope(i,2);
              end
              if ParSwarm(n,i)<ParticleScope(i,1)
              ParSwarm(n,i)=ParticleScope(i,1);
              end
          end
      end
   %}       
          
  %�Ա���������Լ����������㷨�еĿ�������Ҫ�󣬲�������Ѿ��ڳ�����д�룻
  %{
  for i=1:SwarmSize
      for j=1:ParticleSize
          if ParSwarm(i,j)>ParticleScope(j,2)
              ParSwarm(i,j)=ParticleScope(j,2);
          end
          if ParSwarm(i,j)<ParticleScope(j,1)
              ParSwarm(i,j)=ParticleScope(j,1);
          end
      end
  end
  %}
              
 
 %��ʼ�ٶ�����
 for i=1:Integer
    ParSwarm(:,i)=floor(ParSwarm(:,i));   %����������������
    %�����ٶȣ�ʹ�ٶ���λ�õķ�Χһ��
    ParSwarm(:,ParticleSize+i)=0.2*(ParSwarm(:,ParticleSize+i)*(ParticleScope(i,2)-ParticleScope(i,1))+ParticleScope(i,1));
 end
 for i=Integer+1:ParticleSize
     ParSwarm(:,i)=ParSwarm(:,i);        %���ַ�������������
    %�����ٶȣ�ʹ�ٶ���λ�õķ�Χһ��
    ParSwarm(:,ParticleSize+i)=0.2*(ParSwarm(:,ParticleSize+i)*(ParticleScope(i,2)-ParticleScope(i,1))+ParticleScope(i,1));
 end
 
 
 
 %{
  for h=1:SwarmSize
  %��ʼɸѡ���ӣ������������˼·,�ж��������л���
    Punish=(max((ParSwarm(h,1)+ParSwarm(h,2)+ParSwarm(h,3)+ParSwarm(h,4)+ParSwarm(h,5)-400),0)).^2+(max((ParSwarm(h,1)+2*ParSwarm(h,2)+2*ParSwarm(h,3)+ParSwarm(h,4)+6*ParSwarm(h,5)-800),0))^.2+(max((2*ParSwarm(h,1)+ParSwarm(h,2)+6*ParSwarm(h,3)-200),0)).^2+(max((ParSwarm(h,3)+ParSwarm(h,4)+5*ParSwarm(h,5)-200),0)).^2;
    while(1)
       if Punish==0
           break;
       else
         random=rand;
         for i=1:Integer
              ParSwarm(h,:)=floor(ParSwarm(h,:)*random);
         end
         for i=Integer+1:ParticleSize
             ParSwarm(:,i)=ParSwarm(:,i)*(ParticleScope(i,2)-ParticleScope(i,1))+ParticleScope(i,1);
         end
       end
       Punish=(max((ParSwarm(h,1)+ParSwarm(h,2)+ParSwarm(h,3)+ParSwarm(h,4)+ParSwarm(h,5)-400),0)).^2+(max((ParSwarm(h,1)+2*ParSwarm(h,2)+2*ParSwarm(h,3)+ParSwarm(h,4)+6*ParSwarm(h,5)-800),0))^.2+(max((2*ParSwarm(h,1)+ParSwarm(h,2)+6*ParSwarm(h,3)-200),0)).^2+(max((ParSwarm(h,3)+ParSwarm(h,4)+5*ParSwarm(h,5)-200),0)).^2;
    end
  end
 %}
 MaxV=zeros(1,ParticleSize);
 MinV=zeros(1,ParticleSize);
 for i=1:ParticleSize
     MaxV(1,i)=0.2*(ParticleScope(i,2)-ParticleScope(i,1));
     MinV(1,i)=-0.2*(ParticleScope(i,2)-ParticleScope(i,1));
 end
 
%��ÿһ�����Ӽ�������Ӧ�Ⱥ�����ֵ
for i=1:SwarmSize
    ParSwarm(i,2*ParticleSize+1)=AdaptFunc(ParSwarm(i,1:ParticleSize));
end

 %��ʼ������Ⱥ���Ž����
 OptSwarm=zeros(SwarmSize+1,ParticleSize);
 %����Ⱥ���Ž����ȫ����Ϊ��
 [maxValue,row]=max(ParSwarm(:,2*ParticleSize+1));
 %Ѱ����Ӧ�Ⱥ���ֵ���Ľ��ھ����е�λ��(����)
 OptSwarm=ParSwarm(1:SwarmSize,1:ParticleSize);
 %�������Ž�λ�ò���
 OptSwarm(SwarmSize+1,:)=ParSwarm(row,1:ParticleSize);
 %��Ⱥ���Ž�λ�ò���
end




