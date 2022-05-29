
clear all
close all 
clc
clf

% timing1 = getfield(load('exp1.mat','timingdata'),'timingdata');
% timing2 = getfield(load('exp2.mat','timingdata'),'timingdata');
% timing3 = getfield(load('exp3.mat','timingdata'),'timingdata');
% timing4 = getfield(load('exp4.mat','timingdata'),'timingdata');
% timing5 = getfield(load('exp5.mat','timingdata'),'timingdata');
% timing6 = getfield(load('exp6.mat','timingdata'),'timingdata');

timing1 = getfield(load('lta.mat','timing1'),'timing1');
timing2 = getfield(load('lta.mat','timing2'),'timing2');
timing3 = getfield(load('lta.mat','timing3'),'timing3');
timing4 = getfield(load('lta.mat','timing4'),'timing4');
timing5 = getfield(load('lta.mat','timing5'),'timing5');
timing6 = getfield(load('lta.mat','timing6'),'timing6');
% timing(7,:) = getfield(load('exp11.mat','timingdata'),'timingdata');
% timing(8,:) = getfield(load('exp12.mat','timingdata'),'timingdata');
% timing(9,:) = getfield(load('exp9.mat','timingdata'),'timingdata');
subplot(2,3,1)
plot(timing1','LineWidth',1.05)
ylim([-0.2 1.2])
title('3 6 8 TDd')
subplot(2,3,2)
plot(timing2','LineWidth',1.05)
ylim([-0.2 1.2])
title('3 6 6 Tdd')
subplot(2,3,3)
plot(timing3','LineWidth',1.05)
ylim([-0.2 1.2])
title('3 8 8 TDD')
subplot(2,3,4)
plot(timing4','LineWidth',1.05)
ylim([-0.2 1.2])
title('3 8 12 tDd')
subplot(2,3,5)
plot(timing5','LineWidth',1.05)
ylim([-0.2 1.2])
title('3 8 8 tdd')
subplot(2,3,6)
plot(timing6','LineWidth',1.05)
ylim([-0.2 1.2])
title('3 12 12 tDD')
legend('loc1','loc2','loc3')
% legend({'3 6 8 TDd','3 6 6 Tdd','3 8 8 TDD','3 8 12 tDd','3 10 10 tdd','3 12 12 tDD'})