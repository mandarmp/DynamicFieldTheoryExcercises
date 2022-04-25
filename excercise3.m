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
targetInfo1 = 2;
targetInfo2 = 0;
targetInfo3 = 0;
levelInfo1 = 2.5 ;
levelInfo2 = 5 ; 
levelInfo3 = 7 ;
%%
sim = Simulator();

sim.addElement(InputLoader('extractImage',targetInfo1, targetInfo2, targetInfo3, levelInfo1, levelInfo2, levelInfo3));
%InputLoader(label, targetInfo1, targetInfo2, targetInfo3, levelInfo1, levelInfo2, levelInfo3)
sim.addElement(SaliencyCompetitionNode('node', 10, h, 4, 1, 0, samplingRange, samplingResolution))
% TwoColourNode(label, tau, h, beta, selfExcitation, range, resolution)
sim.addConnection('extractImage','targetActivation','node');
sim.addConnection('extractImage','distractorSaliencyActivation','node');
sim.addElement(RunningHistory('history u_1', [1, 1], historyDuration, 1), 'node', 'loc1');
sim.addElement(RunningHistory('history u_2', [1, 1], historyDuration, 1), 'node', 'loc2');
sim.addElement(RunningHistory('history u_3', [1, 1], historyDuration, 1), 'node', 'loc3');
% sim.init()
% sim.run(2)
% %colorMap = parula(5);
% 
% 
% for x = 1 : 20
%     sim.step()
%     y(x,:) = sim.getComponent('node', 'output');
% end
% figure;
% subplot(1,2,1)
% hold on;
% plot(1:20,y(:,1)')
% plot(1:20,y(:,2)')
% plot(1:20,y(:,3)')

sim.addElement(NeuralField('field v', fieldSize, 10, -5, 4));
%hopefully this will show the 

elementGroups = {'node'} ;

% create the gui object
gui = StandardGUI(sim, [50, 50, 700, 500], 0.05, ...
  [0.0, 1/3, 1.0, 2/3], [1, 1], 0.1, ...
  [0.0, 0.0, 1.0, 1/3], [6, 3], elementGroups, elementGroups);


% % add a plot of nodes (with activation, output)
gui.addVisualization(MultiPlot({'history u_1', 'history u_2','history u_3'}, ...
  {'output', 'output','output'}, [1, 1, 1], 'horizontal', ...
 {'XLim', [-historyDuration, 10], 'YLim', [-1, 1], 'Box', 'on', 'XGrid', 'on', 'YGrid', 'on'}, ...
  { {'r-','LineWidth', 2, 'XData', 0:-1:-historyDuration+1,}, {'Color', [0, 0.5, 0], 'LineWidth', 2, 'XData', 0:-1:-historyDuration+1}, ...
  {'b-', 'LineWidth', 2, 'XData', 0:-1:-historyDuration+1} }, ...
  'node', 'relative time', 'output'), [1, 1]);
% gui.addVisualization(ScaledImage('node', 'activation', [-10, 10], {}, {}, 'field u activation'), [1, 1]);
% gui.addVisualization(ScaledImage('node', 'output', [0, 1], {}, {}, 'field u output'), [1, 2]);

% resting level of node
gui.addControl(ParameterSlider('h', 'node', 'h', [-10, 10],...
  '%0.1f', 1, 'resting level of field u'), [2, 1]);


% stimulus settings
gui.addControl(ParameterSlider('t1', 'extractImage', 'targetInfo1', [0, 5], '%0.1f', 1, ...
  'target info 1'), [3, 1]);
gui.addControl(ParameterSlider('t2', 'extractImage', 'targetInfo2', [0, 5], '%0.1f', 1, ...
  'target info 2'), [3, 2]);

gui.addControl(ParameterSlider('t3', 'extractImage', 'targetInfo3', [0, 5], '%0.1f', 1, ...
  'target info 3'), [4,1 ]);
gui.addControl(ParameterSlider('d1', 'extractImage', 'levelInfo1', [0, 10], '%0.1f', 1, ...
  'level info 1'), [5, 1]);
gui.addControl(ParameterSlider('d2', 'extractImage', 'levelInfo2', [0, 10], '%0.1f', 1, ...
  'level info 2'), [5, 2]);

gui.addControl(ParameterSlider('d3', 'extractImage', 'levelInfo3', [0, 10], '%0.1f', 1, ...
  'level info 3'), [6,1 ]);

gui.addControl(GlobalControlButton('Pause', gui, 'pauseSimulation', true, false, false, 'pause simulation'), [1, 3]);
gui.addControl(GlobalControlButton('Reset', gui, 'resetSimulation', true, false, true, 'reset simulation'), [2, 3]);
gui.addControl(GlobalControlButton('Parameters', gui, 'paramPanelRequest', true, false, false, 'open parameter panel'), [3, 3]);
gui.addControl(GlobalControlButton('Save', gui, 'saveParameters', true, false, true, 'save parameter settings'), [4, 3]);
gui.addControl(GlobalControlButton('Load', gui, 'loadParameters', true, false, true, 'load parameter settings'), [5, 3]);
gui.addControl(GlobalControlButton('Quit', gui, 'quitSimulation', true, false, false, 'quit simulation'), [6, 3]);


% run the simulation in the GUI
sim.init()
gui.run(inf);
