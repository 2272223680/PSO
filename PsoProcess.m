function [Particle,Result]=PsoProcess(SwarmSize,ParticleSize,ParticleScope,Maxgen,Integer)
%[ParSwarm,OptSwarm,BadSwarm]=InitSwarm(SwarmSize,ParticleSize,ParticleScope,AdaptFunc)
 %
 %���������SwarmSize:��Ⱥ��С�ĸ���
 %���������ParticleSize��һ�����ӵ�ά��,����ǰinteger������������������Ϊ������������
 %���������ParticleScope:һ�������������и�ά�ķ�Χ��
 %����ParticleScope��ʽ:
 %����3ά���ӵ�ParticleScope��ʽ:
 %                               [x1Min,x1Max]
 %��������������������������������  x2Min,x2Max
 %                                x3Min,x3Max]
 %
 %���������AdaptFunc����Ӧ�Ⱥ���
 %�����Result ���������е�ȫ�����Ž�
 %�����Particle ȫ�����Ž��λ��

 Result=zeros(1,Maxgen);
 Particle=zeros(1,ParticleSize);
[ParSwarm,OptSwarm,MaxV,MinV]=InitSwarm(SwarmSize,ParticleSize,ParticleScope,Integer);
for i=1:Maxgen
    [ParSwarm,OptSwarm,maxValue]=BaseStepPso(ParSwarm,OptSwarm,ParticleScope,Integer,MaxV,MinV,i,Maxgen);
    Result(1,i)=maxValue;
end
Particle=OptSwarm(SwarmSize+1,:);
plot(Result);
disp(Result(1,Maxgen));
end















