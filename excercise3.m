

clear all;
close all;
clc;



%% Parameter initialisation

fieldSize=[30, 30];
historyDuration = 100;
samplingRange = [-10, 10];
samplingResolution = 0.05;
sigma_exc = 1;

%% settings for lta
% h =3;
% selfexc = 1;
% beta = 1;
% coeffA = 1;
% coeffC = -1;
% coeffD = -2;
% levelInfo1 = 1.5;
% levelInfo2 = 6; 
% levelInfo3 = 8;

%% settings for Wta
h =-1.5;
selfexc = 5;
beta = 1;
coeffA = 1;
coeffC = 0.7;
coeffD = -4.0;
levelInfo1 = 5;
levelInfo2 = 4.6; 
levelInfo3 = 4.8;


%% Setting up Cosivinia elements
sim = Simulator();

%loading the inputs into the cosivinia framework (done by InputLoader
% later this will be modified into ImageProcessing component)
%Argument list for InputLoader is (label, targetInfo1, targetInfo2, targetInfo3,
%levelInfo1, levelInfo2, levelInfo3)
sim.addElement(InputLoader('extractImage',levelInfo1, levelInfo2, levelInfo3)); 

%Argument list for SaliencyCompetitionNode is (label, tau, h, beta, 
%selfExcitation, range, resolution)
sim.addElement(SaliencyCompetitionNode('node', 10, h, beta, selfexc, 0, samplingRange, samplingResolution,coeffA ,coeffC,coeffD))
sim.addConnection('extractImage','SaliencyActivation','node');
%history for visualisation purpose.
sim.addElement(RunningHistory('history u_1', [1, 1], historyDuration, 1), 'node', 'loc1');
sim.addElement(RunningHistory('history u_2', [1, 1], historyDuration, 1), 'node', 'loc2');
sim.addElement(RunningHistory('history u_3', [1, 1], historyDuration, 1), 'node', 'loc3');

%Using Gaussian stimulus to create the spatial location maps of the items.
sim.addElement(ModifiedGaussStimulus2D('item1', fieldSize, sigma_exc, sigma_exc,5 ,8,8));
sim.addElement(ModifiedGaussStimulus2D('item2', fieldSize, sigma_exc, sigma_exc, 5, 4,15 ));
sim.addElement(ModifiedGaussStimulus2D('item3', fieldSize, sigma_exc,  sigma_exc, 5,8,23));

%This component will do the weighted sum of the Gaussian maps with the node
%output.
sim.addElement(ModifiedPointwiseProduct('pointwiseNode',fieldSize));
sim.addConnection('node','output','pointwiseNode');
sim.addConnection('item1','output','pointwiseNode');
sim.addConnection('item2','output','pointwiseNode');
sim.addConnection('item3','output','pointwiseNode');

%Creation of the Target Location map.
% Arguments to the NeuralField are (label, size, tau, h, beta)
sim.addElement(ModifiedNeuralField('targetLocationMap', fieldSize, 20, -1.5, 2)); 
sim.addConnection('pointwiseNode','output','targetLocationMap');
%Running history for visulisation process.
sim.addElement(RunningHistory('history u_4', [1, 1], historyDuration, 1), 'targetLocationMap', 'loc1');
sim.addElement(RunningHistory('history u_5', [1, 1], historyDuration, 1), 'targetLocationMap', 'loc2');
sim.addElement(RunningHistory('history u_6', [1, 1], historyDuration, 1), 'targetLocationMap', 'loc3');


%% GUI 

elementGroups = {'node'} ;

% create the gui object

gui = StandardGUI(sim,  [50, 50, 720, 400], 0, [0.0, 0.0, 0.75, 1.0], [3, 2], [0.03, 0.05], ...
    [0.0, 0.0, 1.0, 1/3], [8, 4], elementGroups, elementGroups);

% % add a plot of nodes (with activation, output)
gui.addVisualization(MultiPlot({'history u_1', 'history u_2','history u_3'}, ...
  {'output', 'output','output'}, [1, 1, 1], 'horizontal', ...
 {'XLim', [-historyDuration, 10], 'YLim', [-0.2, 1], 'Box', 'on', 'XGrid', 'on', 'YGrid', 'on'}, ...
  { {'r-','LineWidth', 2, 'XData', 0:-1:-historyDuration+1,}, {'Color', [0, 0.5, 0], 'LineWidth', 2, 'XData', 0:-1:-historyDuration+1}, ...
  {'b-', 'LineWidth', 2, 'XData', 0:-1:-historyDuration+1} }, ...
  'Saliency Node', 'relative time', 'output'), [1, 1],[1,1]);

gui.addVisualization(ScaledImage('targetLocationMap', 'output',[0, 1], {'FontSize',5,'XTick', [], 'YTick', []},{}, '\fontsize{5}Target Location Map Output'), [1, 3],[1, 0.75]);

gui.addVisualization(MultiPlot({'history u_4', 'history u_5','history u_6'}, ...
  {'output', 'output','output'}, [1, 1, 1], 'horizontal', ...
 {'XLim', [-historyDuration, 10], 'YLim', [-0.2, 1], 'Box', 'on', 'XGrid', 'on', 'YGrid', 'on'}, ...
  { {'r-','LineWidth', 2, 'XData', 0:-1:-historyDuration+1,}, {'Color', [0, 0.5, 0], 'LineWidth', 2, 'XData', 0:-1:-historyDuration+1}, ...
  {'b-', 'LineWidth', 2, 'XData', 0:-1:-historyDuration+1} }, ...
  'Target location Map', 'relative time', 'output'), [1, 2]);

% resting level of node
gui.addControl(ParameterSlider('h', 'targetLocationMap', 'h', [-10, 10],...
  '%0.1f', 1, 'resting level of node'), [2, 1]);
gui.addControl(ParameterSlider('beta', 'targetLocationMap', 'beta', [-10, 10],...
  '%0.1f', 1, 'resting level of node'), [2, 3]);
gui.addControl(ParameterSlider('h', 'node', 'h', [-10, 10],...
  '%0.1f', 1, 'resting level of node'), [3, 1]);
gui.addControl(ParameterSlider('selfExc', 'node', 'selfExcitation', [-10, 10],...
  '%0.1f', 1, 'resting level of node'), [3, 2]);
gui.addControl(ParameterSlider('beta', 'node', 'beta', [-10, 10],...
  '%0.1f', 1, 'resting level of node'), [3, 3]);
gui.addControl(ParameterSlider('coeffA', 'node', 'coeffA', [-5, 5],...
  '%0.1f', 1, 'resting level of node'), [5, 1]);
gui.addControl(ParameterSlider('coeffC', 'node', 'coeffC', [-5, 5],...
  '%0.1f', 1, 'resting level of node'), [5, 2]);
gui.addControl(ParameterSlider('coeffD', 'node', 'coeffD', [-5, 5],...
  '%0.1f', 1, 'resting level of node'), [5, 3]);
% stimulus settings

gui.addControl(ParameterSlider('d1', 'extractImage', 'levelInfo1', [0, 20], '%0.1f', 1, ...
  'level info 1'), [7, 1]);
gui.addControl(ParameterSlider('d2', 'extractImage', 'levelInfo2', [0, 20], '%0.1f', 1, ...
  'level info 2'), [7, 2]);

gui.addControl(ParameterSlider('d3', 'extractImage', 'levelInfo3', [0, 20], '%0.1f', 1, ...
  'level info 3'), [7,3 ]);

gui.addControl(GlobalControlButton('Pause', gui, 'pauseSimulation', true, false, false, 'pause simulation'), [1, 4]);
gui.addControl(GlobalControlButton('Reset', gui, 'resetSimulation', true, false, true, 'reset simulation'), [2, 4]);
gui.addControl(GlobalControlButton('Parameters', gui, 'paramPanelRequest', true, false, false, 'open parameter panel'), [3, 4]);
gui.addControl(GlobalControlButton('Save', gui, 'saveParameters', true, false, true, 'save parameter settings'), [4, 4]);
gui.addControl(GlobalControlButton('Load', gui, 'loadParameters', true, false, true, 'load parameter settings'), [5, 4]);
gui.addControl(GlobalControlButton('Quit', gui, 'quitSimulation', true, false, false, 'quit simulation'), [6, 4]);

%% GUI operation.

% maximal simulation time
tMax = inf;

% initialize simulator and GUI
sim.init();
gui.init();

% run and visualize simulation manually step by step

exp = 0;
timing = 0;
activation = 0
ts =0;
%time = zeros(1,500);
while ~gui.quitSimulation && sim.t < tMax
  if gui.resetSimulation
      ts = 0;
      clear timing activation
  end
  gui.step();
  
%   if any(sim.getComponent('field u', 'activation') > 5)
%     sim.setElementParameters('stim A', 'amplitude', 0);
%     sim.setElementParameters('stim B', 'amplitude', 0);     %test codes..
%     gui.checkAndUpdateControls();
%   end

  targetOutput = sim.getComponent('targetLocationMap','output');
  gui.checkAndUpdateControls();
  %2D activation map - op at centroid of the items being analysed.
  activation(1,sim.t) = targetOutput(8,8);   
  activation(2,sim.t) = targetOutput(4,15);
  activation(3,sim.t) = targetOutput(8,23);
  
  % finding the threshold and registering time ( initiation latency)
  if any(targetOutput(:)>0.5)
     ts = ts + 1;
     timing(1,ts) = sim.t;
  end
  if sim.t == 300
    exp = exp + 1;
    experimentData{exp,1} = activation(:,1:300);
    experimentData{exp,2} = timing(1,1)

    disp('assigned')
  end
    
end

gui.close();

