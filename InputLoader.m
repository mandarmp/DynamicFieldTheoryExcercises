%% InputLoader 
% Adapted from the ImageLoader of COSIVINA toolbox.
% The element loads images from a file and switches between them.
% Modified version also provides inputs to the other elements in MainCode.m


classdef InputLoader < Element
    
    properties (Constant)
        parameters = struct('targetInfo1', ParameterStatus.Changeable, 'targetInfo2', ParameterStatus.Changeable, ...
            'targetInfo3', ParameterStatus.Changeable,'levelInfo1', ParameterStatus.Changeable,'levelInfo2', ParameterStatus.Changeable, ...
            'levelInfo3', ParameterStatus.Changeable);
        components = {'output','targetActivation','distractorSaliencyActivation'};
        defaultOutputComponent = 'output';
    end
    
    properties
        % parameters

        targetInfo1 = 0;
        targetInfo2 = 0;
        targetInfo3 = 0;
        levelInfo1 = 0;
        levelInfo2 = 0;
        levelInfo3 = 0;

        % accessible structures
        output
        targetActivation
        distractorSaliencyActivation
        
    end
    
    methods
        % constructor
        function obj = InputLoader(label, targetInfo1, targetInfo2, targetInfo3, levelInfo1, levelInfo2, levelInfo3)
            if nargin > 0
                obj.label = label;
            end
            if nargin >= 2
                obj.targetInfo1= targetInfo1;
            end
            if nargin >= 3
                obj.targetInfo2 = targetInfo2;
            end
            if nargin >= 4
                obj.targetInfo3 = targetInfo3;
            end
            if nargin >= 5
                obj.levelInfo1 = levelInfo1;
            end
            if nargin >= 6
                obj.levelInfo2 = levelInfo2;
            end
            if nargin >= 7
                obj.levelInfo3 = levelInfo3;
            end
        end
        
        % step function
        function obj = step(obj, time, deltaT) %#ok<INUSD>
            obj.output = [0,0,0];
            obj.targetActivation = [ obj.targetInfo1 obj.targetInfo2 obj.targetInfo3];
            obj.distractorSaliencyActivation = [obj.levelInfo1 obj.levelInfo2 obj.levelInfo3];
        end
        
        
        % initialization
        function obj = init(obj)
            obj.output = [0,0,0];
            obj.targetActivation = [ obj.targetInfo1 obj.targetInfo2 obj.targetInfo3];
            obj.distractorSaliencyActivation = [obj.levelInfo1 obj.levelInfo2 obj.levelInfo3];
        end
        
    end
end


