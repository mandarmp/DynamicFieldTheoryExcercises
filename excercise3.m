

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
h =3;
selfexc = 1;
beta = 4;
coeffC = -1;
coeffD = -1.0;

levelInfo1 = 3;
levelInfo2 = 6.0 ; 
levelInfo3 = 6.0 ;


sigma_exc = 1;
%%
sim = Simulator();

sim.addElement(InputLoader('extractImage',levelInfo1, levelInfo2, levelInfo3));
%InputLoader(label, targetInfo1, targetInfo2, targetInfo3, levelInfo1, levelInfo2, levelInfo3)
sim.addElement(SaliencyCompetitionNode('node', 100, h, beta, selfexc, 0, samplingRange, samplingResolution,coeffC,coeffD))
% TwoColourNode(label, tau, h, beta, selfExcitation, range, resolution)
% sim.addConnection('extractImage','targetActivation','node');
sim.addConnection('extractImage','SaliencyActivation','node');
sim.addElement(RunningHistory('history u_1', [1, 1], historyDuration, 1), 'node', 'loc1');
sim.addElement(RunningHistory('history u_2', [1, 1], historyDuration, 1), 'node', 'loc2');
sim.addElement(RunningHistory('history u_3', [1, 1], historyDuration, 1), 'node', 'loc3');

sim.addElement(ModifiedGaussStimulus2D('item1', fieldSize, sigma_exc, sigma_exc,5 ,8,8));
sim.addElement(ModifiedGaussStimulus2D('item2', fieldSize, sigma_exc, sigma_exc, 5, 4,15 ));
sim.addElement(ModifiedGaussStimulus2D('item3', fieldSize, sigma_exc,  sigma_exc, 5,8,23));
sim.addElement(ModifiedPointwiseProduct('pointwiseNode',fieldSize));
sim.addConnection('node','output','pointwiseNode');
sim.addConnection('item1','output','pointwiseNode');
sim.addConnection('item2','output','pointwiseNode');
sim.addConnection('item3','output','pointwiseNode');

sim.addElement(NeuralField('targetLocationMap', fieldSize, 20, -1, 4)); % NeuralField(label, size, tau, h, beta)
sim.addConnection('pointwiseNode','output','targetLocationMap');



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

% % create the gui object
% gui = StandardGUI(sim, [50, 50, 700, 500], 0.05, ...
%   [0.0, 1/3, 1.0, 2/3], [1, 1], 0.1, ...
%   [0.0, 0.0, 1.0, 1/3], [8, 4], elementGroups, elementGroups);
gui = StandardGUI(sim,  [50, 50, 720, 400], 0, [0.0, 0.0, 0.75, 1.0], [3, 2], [0.03, 0.05], ...
    [0.0, 0.0, 1.0, 1/3], [8, 4], elementGroups, elementGroups);

% % add a plot of nodes (with activation, output)
gui.addVisualization(MultiPlot({'history u_1', 'history u_2','history u_3'}, ...
  {'output', 'output','output'}, [1, 1, 1], 'horizontal', ...
 {'XLim', [-historyDuration, 10], 'YLim', [-0.2, 1], 'Box', 'on', 'XGrid', 'on', 'YGrid', 'on'}, ...
  { {'r-','LineWidth', 2, 'XData', 0:-1:-historyDuration+1,}, {'Color', [0, 0.5, 0], 'LineWidth', 2, 'XData', 0:-1:-historyDuration+1}, ...
  {'b-', 'LineWidth', 2, 'XData', 0:-1:-historyDuration+1} }, ...
  'node', 'relative time', 'output'), [1, 1]);
% gui.addVisualization(ScaledImage('node', 'activation', [-10, 10], {}, {}, 'field u activation'), [1, 1]);
% gui.addVisualization(ScaledImage('node', 'output', [0, 1], {}, {}, 'field u output'), [1, 2]);
gui.addVisualization(ScaledImage('targetLocationMap', 'output',[0, 1], {'FontSize',5,'XTick', [], 'YTick', []},{}, '\fontsize{5}Target Location Map Output'), [1, 2],[1, 1]);
% resting level of node
gui.addControl(ParameterSlider('h', 'node', 'h', [-10, 10],...
  '%0.1f', 1, 'resting level of node'), [3, 1]);
gui.addControl(ParameterSlider('selfExc', 'node', 'selfExcitation', [-10, 10],...
  '%0.1f', 1, 'resting level of node'), [3, 2]);
gui.addControl(ParameterSlider('beta', 'node', 'beta', [-10, 10],...
  '%0.1f', 1, 'resting level of node'), [3, 3]);
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


% maximal simulation time
tMax = inf;

% initialize simulator and GUI
sim.init();
gui.init();

% run and visualize simulation manually step by step
exp = 0;
%time = zeros(1,500);
while ~gui.quitSimulation && sim.t < tMax
  gui.step();
  %numberOf
  
%   if any(sim.getComponent('field u', 'activation') > 5)
%     sim.setElementParameters('stim A', 'amplitude', 0);
%     sim.setElementParameters('stim B', 'amplitude', 0);
%     gui.checkAndUpdateControls();
%   end
% 
  targetOutput = sim.getComponent('targetLocationMap','output');
  gui.checkAndUpdateControls();
  time(1,sim.t) = targetOutput(4,15);
  if sim.t == 500
    exp = exp + 1;
    timingdata(exp,:) = time(1,1:500);
    disp('assigned')
  end
    
end

gui.close();

