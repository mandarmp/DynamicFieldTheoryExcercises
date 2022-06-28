% Example: Building and Running a Simple DNF Architecture with two neural
% fields.
% with competitive behaviour between the both
% (see the documentation for detailed explanation of the script)


fieldSize=[30, 30];
historyDuration = 100;
samplingRange = [-10, 10];
samplingResolution = 0.05;
sigma_exc = 1;


sim = Simulator();

sim.addElement(ModifiedGaussStimulus2D('stimulus s_1', fieldSize, sigma_exc, sigma_exc,10,8,8   ));
sim.addElement(ModifiedGaussStimulus2D('stimulus s_2', fieldSize, sigma_exc, sigma_exc, 10, 4,15 ));

sim.addElement(ModifiedNeuralField('node u_1', fieldSize, 20, -1.0, 4)); 
sim.addConnection('stimulus s_1','output','node u_1');
sim.addConnection('stimulus s_2','output','node u_1');
sim.addElement(ModifiedNeuralField('node u_2', fieldSize, 20, -1.0, 4)); 
sim.addConnection('stimulus s_1','output','node u_2');
sim.addConnection('stimulus s_2','output','node u_2');
% sim.addElement(LateralInteractionsDiscrete('u1 -> u2', [1,1], 0, -1) ,...
%   'node u_1', 'output', 'node u_2', 'output');
% 
% sim.addElement(LateralInteractionsDiscrete('u2 -> u1', [1,1], 0, -1) ,...
%   'node u_2', 'output', 'node u_1', 'output');

%creating interactions

sigmaExcY = 5;
sigmaExcX = 5;
amplitudeExc = 5;
sigmaInhY= 10;
sigmaInhX = 10;
amplitudeInh = 0;
amplitudeGlobal_dd = -0.01;

sim.addElement(LateralInteractions2D('u1 -> u1', fieldSize, sigmaExcY,sigmaExcX, amplitudeExc, sigmaInhY, sigmaInhX, amplitudeInh, amplitudeGlobal_dd))%, 'field d', 'output', 'field d');
sim.addConnection('node u_2','output','u1 -> u1');
% sim.addElement(RunningHistory('activation history u_1',[1,1] , historyDuration, 1), 'node u_1', 'activation');
% sim.addElement(RunningHistory('activation history u_2', [1,1], historyDuration, 1), 'node u_2', 'activation');
% 
% sim.addElement(RunningHistory('op history u_1',[1,1] , historyDuration, 1), 'node u_1', 'output');
% sim.addElement(RunningHistory('op history u_2', [1,1], historyDuration, 1), 'node u_2', 'output');

%% setting up the GUI

elementGroupLabels = {'node u_1', 'node u_2', 'u1 -> u1',...
   'stimulus s_1', 'stimulus s_2'};%,'op history u_1','op history u_2','activation history u_1','activation history u_2'};
elementGroups = {'node u_1', 'node u_2' ,  'u1 -> u1', ...
   'stimulus s_1', 'stimulus s_2'};%,'op history u_1','op history u_2','activation history u_1','activation history u_2'};

gui = StandardGUI(sim, [50, 50, 1020, 500], 0.01, [0.0, 0.0, 0.75, 1.0], [2, 3], [0.045, 0.08], ...
  [0.75, 0.0, 0.25, 1.0], [20, 1], elementGroups, elementGroups);


gui.addVisualization(ScaledImage('node u_1', 'output',[0, 1], {'FontSize',1,'XTick', [], 'YTick', []},{}, '\fontsize{5}NOde u1 output'), [1, 1],[1, 1]);
gui.addVisualization(ScaledImage('node u_2', 'output',[0, 1], {'FontSize',1,'XTick', [], 'YTick', []},{}, '\fontsize{5}NOde u1 output'), [1, 2],[1, 1]);
gui.addVisualization(ScaledImage('u1 -> u1', 'output',[0, 1], {'FontSize',1,'XTick', [], 'YTick', []},{}, '\fontsize{5} Lateral interaction'), [1, 3],[1, 1]);



% add parameter sliders
gui.addControl(ParameterSlider('h_1', 'node u_1', 'h', [-10, 10], '%0.1f', 1, 'resting level of node u_1'), [1, 1]);
gui.addControl(ParameterSlider('b1', 'node u_1', 'beta', [0, 7], '%0.1f', 1, 'noise level for node u_1'), [2, 1]);
gui.addControl(ParameterSlider('h_2', 'node u_2', 'h', [-10, 10], '%0.1f', 1, 'resting level of node u_2'), [3, 1]);
gui.addControl(ParameterSlider('b2', 'node u_2', 'beta', [0, 7], '%0.1f', 1, 'noise level for node u_2'), [4, 1]);
%gui.addControl(ParameterSlider('c_11', 'node u_1', 'selfExcitation', [-10, 10], '%0.1f', 1, ...
 % 'connection strength from node u_1 to itself'), [3, 1]);

gui.addControl(ParameterSlider('amp Ex', 'u1 -> u1', 'amplitudeExc', [0, 20], '%0.1f', 1, ...
  'connection strength from node u_2 to node u_1'), [5, 1]);
gui.addControl(ParameterSlider('amp In', 'u1 -> u1', 'amplitudeInh', [0, 20], '%0.1f', 1, ...
  'connection strength from node u_2 to node u_1'), [6, 1]);

gui.addControl(ParameterSlider('amp Global', 'u1 -> u1', 'amplitudeGlobal', [-1, 1], '%0.01f', 1, ...
  'connection strength from node u_2 to node u_1'), [7, 1]);
gui.addControl(ParameterSlider('s_1', 'stimulus s_1', 'amplitude', [0, 20], '%0.1f', 1, ...
  'stimulus strength for node u_1'), [8, 1]);
gui.addControl(ParameterSlider('s_2', 'stimulus s_2', 'amplitude', [0, 20], '%0.1f', 1, ...
  'stimulus strength for node u_1'), [9, 1]);



% add buttons
gui.addControl(GlobalControlButton('Pause', gui, 'pauseSimulation', true, false, false, 'pause simulation'), [15, 1]);
gui.addControl(GlobalControlButton('Reset', gui, 'resetSimulation', true, false, true, 'reset simulation'), [16, 1]);
gui.addControl(GlobalControlButton('Parameters', gui, 'paramPanelRequest', true, false, false, 'open parameter panel'), [17, 1]);
gui.addControl(GlobalControlButton('Save', gui, 'saveParameters', true, false, true, 'save parameter settings'), [18, 1]);
gui.addControl(GlobalControlButton('Load', gui, 'loadParameters', true, false, true, 'load parameter settings'), [19, 1]);
gui.addControl(GlobalControlButton('Quit', gui, 'quitSimulation', true, false, false, 'quit simulation'), [20, 1]);

gui.run(inf);





