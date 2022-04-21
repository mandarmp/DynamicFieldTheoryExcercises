% Example: Three spatial location maps < perceptual maps> and target
% identificaiton.
% selection based on the data extracted.
close all;
clear all;
% create object sim by constructor call
sim = Simulator();


sigma_exc = 1;
fieldSize=[30, 30];


% add elements
sim.addElement(NeuralField('field u', fieldSize, 10, -5, 4));
%hopefully this will do the target selection.

%Have three Gaussian stimulus at the locations

sim.addElement(ModifiedGaussStimulus2D('item1', fieldSize, sigma_exc, sigma_exc, 5,8,8));
sim.addElement(ModifiedGaussStimulus2D('item2', fieldSize, sigma_exc, sigma_exc, 5, 4,15 ));
sim.addElement(ModifiedGaussStimulus2D('item3', fieldSize, sigma_exc,  sigma_exc, 5,8,23));

sim.addElement(ModifiedPreprocessing2('preprocessing'));
sim.addConnection('item1','output','preprocessing');
sim.addConnection('item2','output','preprocessing');
sim.addConnection('item3','output','preprocessing');
sim.addConnection('field u','output','preprocessing');

sim.addElement(NeuralField('field v', fieldSize, 10, -5, 4));
%hopefully this will show the 

