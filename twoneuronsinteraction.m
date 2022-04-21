% Example: Building and Running a Simple DNF Architecture with two neurons
%one excitory and other inhibitory
% (see the documentation for detailed explanation of the script)
close all;
clear all;
% create object sim by constructor call
sim = Simulator();

% add elements
sim.addElement(NeuralField('field u', 100, 10, -5, 4));

% LateralInteractions1D(label, size, sigmaExc, amplitudeExc, ...
%     sigmaInh, amplitudeInh, amplitudeGlobal, circular, normalized, ...
%     cutoffFactor)


sim.addElement(NeuralField('field v', 100, 10, -5, 4));
% sim.addElement(LateralInteractions1D('u -> v', 100, 4, 0, 4, 15, 0), ...
%   'field u', 'output', 'field v', 'output');
% sim.addElement(LateralInteractions1D('v -> u', 100, 4, 25, 4, 0, 0), ...
%   'field v', 'output', 'field u', 'output');

sim.addElement(GaussStimulus1D('stim A', 100, 5, 5, 50), ...
  [], [], 'field u');
sim.addElement(GaussStimulus1D('stim B', 100, 5, 5, 50), ...
  [], [], 'field v');
% GaussStimulus1D(label, size, sigma, amplitude, position, circular, normalized)

% try initialization and step to see if the architecture runs
% (this procedure is not necessary, but helpful for debugging)
sim.tryInit();
sim.tryStep();


% initialize the simulator
sim.init();


% show initial activation of neural field
figure;
subplot(2,1,1)
plot(sim.getComponent('field u', 'activation'), 'b');
xlabel('field position'); ylabel('activation');
subplot(2,1,2)
plot(sim.getComponent('field v', 'activation'), 'b');
xlabel('field position'); ylabel('activation');





% run the simulation for 10 steps
for i = 1 : 10
  sim.step();
end


% plot field activation again
subplot(2,1,1)
hold on;
plot(sim.getComponent('field u', 'activation'), 'r');
xlabel('field position'); ylabel('activation');

subplot(2,1,2)
hold on;
plot(sim.getComponent('field v', 'activation'), 'r');
xlabel('field position'); ylabel('activation');

% change strength of stimulus B and re-initialize the element
hStimB = sim.getElement('stim B'); % get element handle
hStimB.amplitude = 0; % change element parameter
hStimB.init();


% run the simulation for another 10 steps
for i = 1 : 15
  sim.step();
end


% plot field activation again
subplot(2,1,1)
hold on;
plot(sim.getComponent('field u', 'activation'), 'y');
xlabel('field position'); ylabel('activation');
subplot(2,1,2)
hold on;
plot(sim.getComponent('field v', 'activation'), 'y');
xlabel('field position'); ylabel('activation');

for i = 1 : 25
  sim.step();
end


hold on;
subplot(2,1,1)
plot(sim.getComponent('field u', 'activation'), 'g');
xlabel('field position'); ylabel('activation');
subplot(2,1,2)
hold on;
plot(sim.getComponent('field v', 'activation'), 'g');
xlabel('field position'); ylabel('activation');


for i = 1 : 50
  sim.step();
end
subplot(2,1,1)
hold on;
plot(sim.getComponent('field u', 'activation'), 'm');
xlabel('field position'); ylabel('activation');
ylim([-8 10])
legend('intial state of the field', 'after 10 steps', 'after 25 steps ','after 50 steps ','after 100 steps ');
subplot(2,1,2)
hold on;
plot(sim.getComponent('field v', 'activation'), 'm');
xlabel('field position'); ylabel('activation');
ylim([-8 10])
% add legend to the figure
legend('intial state of the field', 'after 10 steps', 'after 25 steps ','after 50 steps ','after 100 steps ');


% % alternative to the above: use the run method
% sim.run(10, true); % initialize and run until t = 10
% 
% hStimB = sim.getElement('stim B'); % get element handle
% hStimB.amplitude = 0; % change element parameter
% hStimB.init();
% 
% sim.run(20); % run until t = 20;




