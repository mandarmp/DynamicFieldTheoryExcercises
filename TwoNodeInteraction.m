% Example: Building and Running a Simple DNF Architecture with two neurons
% with competitive behaviour between the both
% (see the documentation for detailed explanation of the script)



historyDuration = 100;
samplingRange = [-10, 10];
samplingResolution = 0.05;

sim = Simulator();

sim.addElement(BoostStimulus('stimulus s_1', 1));
sim.addElement(BoostStimulus('stimulus s_2', 1));

sim.addElement(ModifiedSingleNodeDynamics('node u_1', 20, -5, 4, 0, 0, samplingRange, samplingResolution), 'stimulus s_1','output');
sim.addElement(ModifiedSingleNodeDynamics('node u_2', 20, -5, 4, 0, 0, samplingRange, samplingResolution), 'stimulus s_2','output');

sim.addElement(LateralInteractionsDiscrete('u1 -> u2', [1,1], 0, -1) ,...
  'node u_1', 'output', 'node u_2', 'output');

sim.addElement(LateralInteractionsDiscrete('u2 -> u1', [1,1], 0, -1) ,...
  'node u_2', 'output', 'node u_1', 'output');

%creating interactions

% sim.addElement(LateralInteractions1D('u1 -> u1', 100, 4, 15, 10, 15, 0), ...
%   'node u_1', 'output', 'node u_1', 'output');
% 
% sim.addElement(LateralInteractions1D('u2 -> u2', 100, 4, 15, 10, 15, 0), ...
%   'node u_2', 'output', 'node u_2', 'output');

% sim.addElement(LateralInteractions1D('u1 -> u2', 100, 4, 15, 10, 15, 0,0), ...
%   'node u_1', 'output', 'node u_2', 'output');
% 
% sim.addElement(LateralInteractions1D('u2 -> u1', 100, 4, 15, 10, 15, 0,0), ...
%   'node u_2', 'output', 'node u_1', 'output');
%utput = sim.getComponent('node u_1','output')

sim.addElement(RunningHistory('activation history u_1',[1,1] , historyDuration, 1), 'node u_1', 'activation');
sim.addElement(RunningHistory('activation history u_2', [1,1], historyDuration, 1), 'node u_2', 'activation');

sim.addElement(RunningHistory('op history u_1',[1,1] , historyDuration, 1), 'node u_1', 'output');
sim.addElement(RunningHistory('op history u_2', [1,1], historyDuration, 1), 'node u_2', 'output');

%% setting up the GUI

elementGroupLabels = {'node u_1', 'node u_2', 'u1 -> u2', 'u2 -> u1', ...
   'stimulus s_1', 'stimulus s_2','op history u_1','op history u_2','activation history u_1','activation history u_2'};
elementGroups = {'node u_1', 'node u_2' , 'u1 -> u2', 'u2 -> u1', ...
   'stimulus s_1', 'stimulus s_2','op history u_1','op history u_2','activation history u_1','activation history u_2'};

gui = StandardGUI(sim, [50, 50, 1020, 500], 0.01, [0.0, 0.0, 0.75, 1.0], [2, 3], [0.045, 0.08], ...
  [0.75, 0.0, 0.25, 1.0], [20, 1], elementGroups, elementGroups);

% gui.addVisualization(XYPlot({'node u_1', 'history u_1'}, {'activation', 'output'}, ...
%   {'node u_2', 'history u_2'}, {'activation', 'output'}, ...
%   {'XLim', [-10, 10], 'YLim', [-10, 10], 'Box', 'on', 'XGrid', 'on', 'YGrid', 'on'}, ...
%   { {'bo', 'MarkerFaceColor', 'b'}, {'b-', 'LineWidth', 2} }, '', 'activation u_1', 'activation u_2'), [1.5, 1]);

gui.addVisualization(MultiPlot({'activation history u_1', 'activation history u_2'}, ...
  {'output', 'output'}, [1, 1], 'horizontal', ...
 {'XLim', [-historyDuration, 10], 'YLim', [-10, 10], 'Box', 'on', 'XGrid', 'on', 'YGrid', 'on'}, ...
  { {'r-','LineWidth', 2, 'XData', 0:-1:-historyDuration+1}, ...
  {'b-', 'LineWidth', 2, 'XData', 0:-1:-historyDuration+1} }, ...
  'Saliency Node', 'relative time', 'activation'), [1, 1],[1,1]);

gui.addVisualization(MultiPlot({'op history u_1', 'op history u_2'}, ...
  {'output', 'output'}, [1, 1], 'horizontal', ...
 {'XLim', [-historyDuration, 10], 'YLim', [-0.2, 1], 'Box', 'on', 'XGrid', 'on', 'YGrid', 'on'}, ...
  { {'r-','LineWidth', 2, 'XData', 0:-1:-historyDuration+1}, ...
  {'b-', 'LineWidth', 2, 'XData', 0:-1:-historyDuration+1} }, ...
  'Saliency Node', 'relative time', 'output'), [1, 2],[1,1]);



% add parameter sliders
gui.addControl(ParameterSlider('h_1', 'node u_1', 'h', [-10, 0], '%0.1f', 1, 'resting level of node u_1'), [1, 1]);
gui.addControl(ParameterSlider('q_1', 'node u_1', 'noiseLevel', [0, 1], '%0.1f', 1, 'noise level for node u_1'), [2, 1]);
gui.addControl(ParameterSlider('c_11', 'node u_1', 'selfExcitation', [-10, 10], '%0.1f', 1, ...
  'connection strength from node u_1 to itself'), [3, 1]);
% gui.addControl(ParameterSlider('c_12 ampEx', 'u1 -> u2', 'amplitudeExc', [-20, 20], '%0.1f', 1, ...
%   'connection strength from node u_2 to node u_1'), [4, 1]);
gui.addControl(ParameterSlider('c_12', 'u1 -> u2', 'amplitudeGlobal', [-10, 10], '%0.1f', 1, ...
  'connection strength from node u_2 to node u_1'), [5, 1]);
gui.addControl(ParameterSlider('s_1', 'stimulus s_1', 'amplitude', [0, 20], '%0.1f', 1, ...
  'stimulus strength for node u_1'), [4, 1]);

gui.addControl(ParameterSlider('h_2', 'node u_2', 'h', [-10, 0], '%0.1f', 1, 'resting level of node u'), [7, 1]);
gui.addControl(ParameterSlider('q_2', 'node u_2', 'noiseLevel', [0, 1], '%0.1f', 1, 'noise level for node u'), [8, 1]);
gui.addControl(ParameterSlider('c_22', 'node u_2', 'selfExcitation', [-10, 10], '%0.1f', 1, ...
  'connection strength from node u_1 to itself'), [9, 1]);
% gui.addControl(ParameterSlider('c_21 ampEx', 'u2 -> u1', 'amplitudeExc', [-20, 20], '%0.1f', 1, ...
%   'connection strength from node u_2 to node u_1'), [10, 1]);
gui.addControl(ParameterSlider('c_21', 'u2 -> u1', 'amplitudeGlobal', [-10, 10], '%0.1f', 1, ...
  'connection strength from node u_2 to node u_1'), [11, 1]);
gui.addControl(ParameterSlider('s_2', 'stimulus s_2', 'amplitude', [0, 20], '%0.1f', 1, ...
  'stimulus strength for node u_2'), [10, 1]);

% add buttons
gui.addControl(GlobalControlButton('Pause', gui, 'pauseSimulation', true, false, false, 'pause simulation'), [15, 1]);
gui.addControl(GlobalControlButton('Reset', gui, 'resetSimulation', true, false, true, 'reset simulation'), [16, 1]);
gui.addControl(GlobalControlButton('Parameters', gui, 'paramPanelRequest', true, false, false, 'open parameter panel'), [17, 1]);
gui.addControl(GlobalControlButton('Save', gui, 'saveParameters', true, false, true, 'save parameter settings'), [18, 1]);
gui.addControl(GlobalControlButton('Load', gui, 'loadParameters', true, false, true, 'load parameter settings'), [19, 1]);
gui.addControl(GlobalControlButton('Quit', gui, 'quitSimulation', true, false, false, 'quit simulation'), [20, 1]);

gui.run(inf);





