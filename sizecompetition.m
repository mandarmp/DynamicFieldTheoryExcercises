 


sim = Simulator();

fieldSize = 120;
sigma_exc = 1;
sigma_inh = 10;


area = [ 35.0; 67.0; 67.0];

weightedCentroid = [ [30 30]; [60 15];[90 30]];  % if somehow useful in the encoding shceme#dhkfkj

threshold = -5;


% GaussStimulus2D(label, size, sigmaY, sigmaX, amplitude, positionY, ...
%     positionX, circularY, circularX, normalized)


sim.addElement(GaussStimulus2D('item 1', [fieldSize, fieldSize], sigma_exc, sigma_exc, area(1)*100, ...
  round(1/4 * fieldSize), round(1/4 * fieldSize)));
sim.addElement(GaussStimulus2D('item 2', [fieldSize, fieldSize], sigma_exc, sigma_exc, area(2)*100, ...
  round(3/4 * fieldSize), round(3/4 * fieldSize)));
sim.addElement(GaussStimulus2D('item 3', [fieldSize, fieldSize], sigma_exc,  sigma_exc, area(3)*100, ...
  round(1/4 * fieldSize), round(1/4 * fieldSize)));

% NeuralField(label, size, tau, h, beta)
% two-dimensional field

sim.addElement(NeuralField('size', [fieldSize, fieldSize], 20, -1, 4), ...
  {'item 1', 'item 2', 'item 3'});
%how to make them interact with each other?
% create interactions
sim.addElement(LateralInteractions2D('s -> s', [fieldSize, fieldSize], sigma_exc, sigma_exc, 0, ...
  sigma_inh, sigma_inh, 0, 0), 'size', [], 'size');
sim.addElement(NormalNoise('noise', [fieldSize, fieldSize], 1.0));
sim.addElement(GaussKernel2D('noise kernel', [fieldSize, fieldSize], 0, 0, 1.0), 'noise', [], 'size');


sim.run(100);
figure('Name', 'Output')
[X,Y] = meshgrid(1:120,1:120);
z=sim.getComponent('size', 'output');
surf(X,Y,z)
% imagesc(sim.getComponent('size', 'output'), [-7.5, 7.5])
% 
% figure('Name', 'After 100 steps')
% imagesc(sim.getComponent('size', 'activation'), [-7.5, 7.5])