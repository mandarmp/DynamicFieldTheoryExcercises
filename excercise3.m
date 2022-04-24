clear all;
close all;
clc;


fieldSize=[30, 30];
currentSelection = 1;

%% 
connectionValue = -2; %Amplitude for connections can be different for each one
historyDuration = 100;
samplingRange = [-10, 10];
samplingResolution = 0.05;
tStimOn=0;

sigmaInhY = 10;
sigmaInhX = 10;
amplitudeInh_dv = 0.8;

sigmaExcY = 5;
sigmaExcX = 5;
amplitudeExc = 5;

amplitudeGlobal_dd=-0.01;
amplitudeGlobal_dv=-0.005;
i=1;
h =-5;
coeffC = -1;
coeffD = -0.5;
targetInfo1 = 1;
targetInfo2 = 0;
targetInfo3 = 0;
levelInfo1 = 2.5;
levelInfo2 = 5; 
levelInfo3 = 7;
%%
sim = Simulator();

sim.addElement(InputLoader('targetImage',targetInfo1, targetInfo2, targetInfo3, levelInfo1, levelInfo2, levelInfo3));
%InputLoader(label, targetInfo1, targetInfo2, targetInfo3, levelInfo1, levelInfo2, levelInfo3)
sim.addElement(SaliencyCompetitionNode('node', 10, h, 4, 1, 0, samplingRange, samplingResolution,coeffC,coeffD))
% TwoColourNode(label, tau, h, beta, selfExcitation, range, resolution)
sim.addConnection('targetImage','targetActivation','node');
sim.addConnection('targetImage','distractorSaliencyActivation','node');
sim.init()
sim.run(2)
%colorMap = parula(5);


for x = 1 : 20
    sim.step()
    y(x,:) = sim.getComponent('node', 'output');
end
figure;
subplot(1,2,1)
hold on;
plot(1:20,y(:,1)')
plot(1:20,y(:,2)')
plot(1:20,y(:,3)')

sim.addElement(NeuralField('field v', fieldSize, 10, -5, 4));
%hopefully this will show the 

