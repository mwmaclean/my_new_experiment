function [conditions,motionDirections,correctResponses] = experimental_design(Cfg) 
% This function creates the design for the experiment. It takes as input the
% required number of trails 

% Total number of Trials
numEvents = Cfg.numEvents ;

%% Assign the conditions
RND = 1; % Randomize
[conditions] = BalanceTrials(numEvents, RND, {'Up','Down'});


%% Motion Directions  [0 right, 90 up, 180 left, 270 down]
% Create a vector of -1s (static)
motionDirections=ones(size(conditions,1),1)* -1 ;       

% Horizontal motion = right and left RDK directions
motionDirections(strcmp(conditions,'Up'),1) = 90;
motionDirections(strcmp(conditions,'Down'),1) = 270;

% Correct responses should be 1=Up , 2=Down
correctResponses = zeros(size(conditions));
correctResponses(strcmp(conditions,'Up'))=1  ;
correctResponses(strcmp(conditions,'Down'))=2  ;

end