% DirectionDiscrimination Threshold Experiment.
% In this experiment, the QUEST adaptive method* is used to estimate the threshold for
% discriminating the direction of moving dots (e.g., Up vs Down, Left
% vs.Right). This is a forced choice task and the stimuli can easily be
% presented at different locations on the screen. Each run lasts between 2
% and 5 minutes.
% *Reference: Watson, A. B. and Pelli, D. G. (1983) QUEST: a Bayesian adaptive psychometric method. 
% Percept Psychophys, 33 (2), 113-20.

% The main experiment is the current file: 'DirectionDiscrimination.m', 
% The supporting functions are at the end of this script:
% 1. DoDotMotion, generates the moving dots for each event 
% 2. Experimental_design, creates the design for the experiment

% This script outputs a logfile directory where you will find two logfiles
% for each run % (i.e. subject_name_run_number_all.mat and subject_name_run_number_Events.mat). 
% The following variables are saved: 1) Cfg, 2)conditions, 3)eventCoherence, 4)eventDurations,5)eventEnds,6)eventOnsets',
% 7)responseTime,8)eventResponse,9)correctResponses, 10)isCorrectResponse.
% At the end, you will have the estimated threshold 't' (log(10)contrast) and
% the standard deviation 'sd'. You can also plot the coherence for each event for each run of a participant('eventCoherence').

% To run, you will need Psychtoolbox (http://psychtoolbox.org).
% You must also adjust the parameters for your monitor setting (monitor width and viewing
% distance) which will then be converted to degrees of visual angles.

% Script initiated by Mohamed Rezk (2018)
% mohamed.rezk@uclouvain.be, 
% Modified by Michèle MacLean (2018)
% This experiment has now been adapted by M. MacLean to be used as a teaching example (2020). 
% michele.maclean@umontreal.ca


%Clear previous workspace & screen
clc;
clear all;

%Verify device used.
%Cfg.device = 'PC';  
Cfg.device = computer; % returns the computer type on which MATLAB is running. 'PCWIN64' - 64-bit Windows ; 'GLNXA64' - 64-bit Linux; 'MACI64' - 64-bit macOS
fprintf('Connected device is %s \n\n',Cfg.device);
    %Cfg: configuration, a structure that holds all the info of the experiment

% Windows= ispc % Can also be used to check computer type; will return 1 (True) or 0 (False)
% Linux = isunix
% Mac= ismac

% Basic parameters for presentation of events.
Cfg.numEvents              = 60 ;                   % Number of Total events 
Cfg.speedEvent             = 8  ;                   % Speed in visual angles
Cfg.eventDuration          = 1.2 ;                  % Duration of 1 event in seconds
Cfg.InterEventInterval     = 5 ;                    % time between events in secs (fixed time)
Cfg.response_time          = 1  ;

onsetDelay = 2;                                     % number of seconds before the motion stimuli are presented
endDelay = 3;                                       % number of seconds after the end all the stimuli before ending the run 

%jitterTime = zeros(Cfg.numEvents,1);
%% Parameters for monitor setting
% screenNumber=2
% [width_in_mm, height_in_mm]=Screen('DisplaySize', screenNumber); % Use to check the width and height of my screen
monitor_width  	 = 59.7;                            % Monitor Width in cm
screen_distance  = 53;                              % Distance from the screen in cm
diameter_aperture= 10;                              % Diameter/length of side of aperture in Visual angles

%Screen location where you will present the moving dots
Cfg.ShiftX = 0;                                     % Shift of the annulus in visual angle along the X axis (Positive numbers = Right, Negative numbers = Left)
Cfg.ShiftY = 0;                                     % Shift of the annulus in visual angle along the Y axis (Positive numbers = Down, Negative numbers = Up)

Cfg.coh = 1;                                        % Coherence Level (0-1), if not using QUEST
Cfg.maxDotsPerFrame = 99;                           % Maximum number dots per frame 
Cfg.dotLifeTime = 0.2;                              % Dot life time in seconds
Cfg.dontclear = 0;
Cfg.dotSize = 0.25;

% If you would like to test on a part of the screen, change to 1;
TestingSmallScreen = 0;

% Response buttons 1 & 2 numerical keyboard
Cfg.ResponseButtonUP='1';
Cfg.ResponseButtonDOWN='2';

%% QUEST PARAMETERS
includeQuest = 1;
Cfg.Quest.GuessedThreshold = 0.5 ; %tell Quest your 'prior knowledge' or threshold estimate
Cfg.Quest.GuessedThresSD = 3 ; % guessed standard deviation
Cfg.Quest.pThreshold=0.75; % threshold criterion expressed as probability of response==1, what coherence I need to achieve a behavioral accuracy of 75%
Cfg.Quest.beta=3;
Cfg.Quest.delta=0.01;
Cfg.Quest.gamma=0.5; 
Cfg.Quest.grain=0.1; 
Cfg.Quest.range=1;

%Structure to store quest parameters
q=QuestCreate(Cfg.Quest.GuessedThreshold,Cfg.Quest.GuessedThresSD ,Cfg.Quest.pThreshold,...
    Cfg.Quest.beta,Cfg.Quest.delta,Cfg.Quest.gamma,Cfg.Quest.grain,Cfg.Quest.range); 
q.normalizePdf=1; % This adds a few ms per call to QuestUpdate, but otherwise the pdf will underflow after about 1000 trials.

%% Fixation Cross parameters   
% Pixels are used since it is really small 
Cfg.fixCrossDimPix = 10;                            % Set the length of the lines (in Pixels) of the fixation cross
Cfg.lineWidthPix = 4;                               % Set the line width (in Pixels) for our fixation cross
                       
%% Color Parameters 
White = [255 255 255]; %RGB value for white is 255; RGB returns red-green-blue
Black = [ 0   0   0 ]; %RGB value for black is 0
Grey = [100 100 100]; % darker grey than the mean
% Grey  = mean([Black;White]);

Cfg.textColor           = White ;   %Define text color (e.g., instructions)
Cfg.Background_color    = Grey  ;   %Define background color (usually grey for psychophysics experiments)
Cfg.fixationCross_color = White ;   %Define fixation cross color 
Cfg.dotColor            = White ;   %Define moving dots color 

% Get subject name and run number (prompt to get the SubjectName & runNumber before the start of the experiment)
subjectName = input('Enter Subject Name: ','s');
if isempty(subjectName)
  subjectName = 'trial';
end

runNumber = input('Enter the run Number: ','s');
if isempty(runNumber)
  runNumber = 'trial';
end

% If the run number is set to zero, it is a training session
if strcmp(runNumber,'0')
    numberTraining = 10;
    Cfg.numEvents = numberTraining;
%     jitterTime = jitterTime(1:numberTraining,1);
end
%% Experimental Design 
% Calls function at the end of the script
[conditions,motionDirections,correctResponses] = experimental_design(Cfg); %conditions is verbal (i.e., Up, Down), motionDirections are angles (i.e., 90, 270), correctResponse (i.e., 1,2)

numEvents = size(conditions,1); 

%% Experiment 
AssertOpenGL; % Verify if PTB is based on OpenGL & Screen(), break & error if not

Screen('Preference','SkipSyncTests', 1); % forces script to continue if sync tests fail
Screen('Preference','TextRenderer', 0)
% Select screen with maximum id for output window:
screenid = max(Screen('Screens'));

% Open a fullscreen, onscreen window with grey background. 
PsychImaging('PrepareConfiguration');   %Prepare setup of imaging pipeline for onscreen window

if TestingSmallScreen 
    [Cfg.win, Cfg.winRect] = PsychImaging('OpenWindow', screenid, Cfg.Background_color,  [0,0, 480, 270]); % Open window in a small screen (when modifying/testing script) 
else
    [Cfg.win, Cfg.winRect] = PsychImaging('OpenWindow', screenid, Cfg.Background_color);                   % Open window on selected (max) screen
end

% Set maximum priority level
priorityLevel = MaxPriority(Cfg.win);  % prioritize over other computer processes
Priority(priorityLevel)

% Get the Center of the Screen
Cfg.center = [Cfg.winRect(3), Cfg.winRect(4)]/2; %it assumes the rectangle starts from (0,0); 3 and 4 are the components

%% Fixation Cross
xCoords = [-Cfg.fixCrossDimPix Cfg.fixCrossDimPix 0 0];
yCoords = [0 0 -Cfg.fixCrossDimPix Cfg.fixCrossDimPix];
Cfg.allCoords = [xCoords; yCoords];

% Query frame duration 
Cfg.ifi = Screen('GetFlipInterval', Cfg.win);
Cfg.monRefresh = 1/Cfg.ifi; 

% monitor distance
Cfg.mon_horizontal_cm  	= monitor_width;                         % Width of the monitor in cm
Cfg.view_dist_cm 		= screen_distance;                       % Distance from viewing screen in cm
Cfg.apD = diameter_aperture;                                     % diameter/length of side of aperture in Visual angles
%% Convert to pixels
% Everything is initially in coordinates of visual degrees, convert to pixels
% (pix/screen) * (screen/rad) * rad/deg
V = 2* (180 * (atan(Cfg.mon_horizontal_cm/(2*Cfg.view_dist_cm)) / pi));
Cfg.ppd = Cfg.winRect(3) / V ;

Cfg.d_ppd = floor(Cfg.apD * Cfg.ppd);                            % Convert the aperture diameter to pixels, floor: round down
Cfg.dotSize = floor (Cfg.ppd * Cfg.dotSize);                     % Convert the dot Size to pixels

% Convert Shift in X & Y from visual angles to pixels 
Cfg.ShiftX = Cfg.ShiftX * Cfg.ppd;
Cfg.ShiftY = Cfg.ShiftY * Cfg.ppd;

%%
% Enable alpha-blending, set it to a blend equation useable for linear
% superposition with alpha-weighted source. 
Screen('BlendFunction', Cfg.win, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);     %alpha blending combines color values of pixels already in the window with new color values from drawing commands.

%Flip to the screen
Screen('Flip', Cfg.win); % flip front and back display surfaces in sync with vertical retrace and return completion timestamps.

% Text options
    Screen('TextFont',Cfg.win, 'Courier New');
    Screen('TextSize',Cfg.win, 20);
    Screen('TextStyle', Cfg.win, 1);

%Instructions
DrawFormattedText(Cfg.win,'Appuyez sur la touche \n\n 1: pour du mouvement vers le haut \n\n OU \n\n 2: pour du mouvement vers le bas \n\n Appuyez sur une touche pour commencer',...
             'center', 'center', Cfg.textColor);
Screen('Flip', Cfg.win); %Clear text

[KeyIsDown, ~, ~]=KbCheck(-1);
KbWait([-1]);
Screen('Flip', Cfg.win);

%% Empty vectors and matrices for speed
eventOnsets    = zeros(numEvents,1); %num events with 1 column
eventEnds      = zeros(numEvents,1);
eventDurations = zeros(numEvents,1);
eventCoherence = zeros(numEvents,1);
eventResponse = zeros(numEvents,1);
isCorrectResponse = zeros(numEvents,1);
responseTime = zeros(numEvents,1);
responseKey  = zeros(numEvents,1);

%%
%Remove Cursor from screen during experiment
HideCursor;

%% txt logfiles
if ~exist('logfiles','dir') % ~: not
    mkdir('logfiles')
end

EventTxtLogFile = fopen(fullfile('logfiles',[subjectName,'_run_',runNumber,'_Events.txt']),'w');    %fopen: open file
 fprintf(EventTxtLogFile,'%18s %18s %18s %18s %18s %18s %18s %18s %18s \n',...  %fprintf : write formated dated to txt file
     'EventNumber','Condition','Coherence','Onset','End','Duration','CorrectResponse','SubjectResponse','isCorrectResponse'); %18s means 18 characters space

%% Experiment Start
Cfg.experimentStartTime = GetSecs; %built-in

Screen('DrawLines', Cfg.win, Cfg.allCoords,Cfg.lineWidthPix, [255 255 255] , [Cfg.center(1) Cfg.center(2)], 1);
Screen('Flip',Cfg.win);

% Delay (seconds) before motion stimuli presentation
WaitSecs(onsetDelay) 
                                 

%% For Each event
for iEvent = 1:numEvents
    
        disp(conditions{iEvent}) %print on command window
    
        if includeQuest==1      % If applying QUEST
            iEventCoherence  = QuestQuantile(q);    % QuestQuantile: Get Quest recommendation for next trial intensity/coherence.
            if iEventCoherence < 0        % If coherence level is < 0
                iEventCoherence= 0 ;      % Set it to zero, as coherence can't be below zero
            elseif isnan(iEventCoherence) && eventCoherence(iEvent-1,1)<0.1
                iEventCoherence= 0 ; 
            elseif iEventCoherence > 1    % If coherence level is > 1
                iEventCoherence =1;       % Set it to 1, as coherence can't be more than 1 
            elseif isnan(iEventCoherence) && eventCoherence(iEvent-1,1)>0.9
                iEventCoherence =1;
            end
            
        else
            iEventCoherence = Cfg.coh ;
        end

        iEventDirection1 = motionDirections(iEvent,1);      % Direction of that event
%         iEventJitter = jitterTime(iEvent,1);               
        
        % Event Onset
        eventOnsets(iEvent,1) = GetSecs-Cfg.experimentStartTime;
        
        % Dots Direction
        [response_key_Dots, responseTimeWithinEvent] = DoDotMotion(Cfg, iEventDirection1,iEventCoherence);
        
        % If Responded
        if response_key_Dots~=0
            responseKey(iEvent,1)  = response_key_Dots;
            responseTime(iEvent,1) = responseTimeWithinEvent;
        end
        
        % Add the fixation cross on top
        Screen('DrawLines', Cfg.win, Cfg.allCoords,Cfg.lineWidthPix, Cfg.fixationCross_color , [Cfg.center(1) Cfg.center(2)], 1); %keeps fixation between trials
        Screen('Flip', Cfg.win,0,Cfg.dontclear);

        eventEnds(iEvent,1) = GetSecs-Cfg.experimentStartTime;

        % Get event duration
        eventDurations(iEvent,1) = eventEnds(iEvent,1) - eventOnsets(iEvent,1);
        
        %% Get Responses
        % Get response during the inter-trial interval
        preResponseCollection = GetSecs();
        
%         while GetSecs() <= preResponseCollection + Cfg.InterEventInterval + iEventJitter
        while GetSecs() <= preResponseCollection + Cfg.InterEventInterval     
            % if key is pressed and correspond to UP give it
            % number 1
                [keyIsDown, secs, keyCode] = KbCheck(-1);
                if keyIsDown == 1 && strcmp(KbName(keyCode),Cfg.ResponseButtonUP)==1
                    responseTime(iEvent,1) = secs - Cfg.experimentStartTime;
                    responseKey(iEvent,1)= 1;
                    while keyIsDown ==1
                        [keyIsDown, ~, ~] = KbCheck(-1);
                    end
                    
                % if key is pressed and correspond to DOWN give it
                % number 2
                elseif keyIsDown == 1 && strcmp(KbName(keyCode),Cfg.ResponseButtonDOWN)==1
                    responseTime(iEvent,1)= secs - Cfg.experimentStartTime;
                    responseKey(iEvent,1)= 2;
                    while keyIsDown ==1
                        [keyIsDown, ~, ~] = KbCheck(-1);
                    end
              
                end
                

            if responseTime(iEvent,1)~=0
                WaitSecs(1);
                break
            end
            
        end
        
        % Is the Subject's response similar to the correct response
        isCorrectResponse(iEvent,1)= (correctResponses(iEvent,1)==responseKey(iEvent,1));
        
        %% Event txt_Logfile
        fprintf(EventTxtLogFile,'%18.0f %18s %18.6f %18.4f %18.4f %18.4f %18.0f %18.0f %18.0f \n',...
        iEvent,conditions{iEvent,1},iEventCoherence,eventOnsets(iEvent,1),eventEnds(iEvent,1),eventDurations(iEvent,1),...
        correctResponses(iEvent,1),responseKey(iEvent,1), isCorrectResponse(iEvent,1));
   
        q=QuestUpdate(q,iEventCoherence,isCorrectResponse(iEvent,1));  % update the structure q to reflect the results of the trial
        Q(iEvent+1,1)=q.quantileOrder;
        R(iEvent,1)=isCorrectResponse(iEvent,1);
        eventCoherence(iEvent,1) = iEventCoherence;
        
        fprintf('Current Threshold is %.2f%s \n',eventCoherence(iEvent,1),char(37))
end

% End of the run
WaitSecs(endDelay);

% Close txt log files
fclose(EventTxtLogFile);

Screen('CloseAll')
%sca

%Show Cursor on screen
ShowCursor;

% Behavoiral result
fprintf('\n\n Result = %.2f%s Correct responses \n\n',sum(isCorrectResponse)/Cfg.numEvents*100,char(37))

% Ask Quest for the final estimate of threshold.
t=QuestMean(q);		% Recommended by Pelli (1989) and King-Smith et al. (1994). Still our favorite.
sd=QuestSd(q);      %  Get the standard deviation of the threshold distribution. If q is a vector, then the returned t is a vector of the same size.
fprintf('Final threshold estimate (mean+-sd) is %.4f +- %.2f\n',t,sd);

% Optionally, reanalyze the data with beta as a free parameter.
fprintf('\nBETA. Many people ask, so here''s how to analyze the data with beta as a free\n');
fprintf('parameter. However, we don''t recommend it as a daily practice. The data\n');
fprintf('collected to estimate threshold are typically concentrated at one\n');
fprintf('contrast and don''t constrain beta. To estimate beta, it is better to use\n');
fprintf('100 trials per intensity (typically log contrast) at several uniformly\n');
fprintf('spaced intensities. We recommend using such data to estimate beta once,\n');
fprintf('and then using that beta in your daily threshold meausurements. With\n');
fprintf('that disclaimer, here''s the analysis with beta as a free parameter.\n');
QuestBetaAnalysis(q); % optional

figure();
plot(eventCoherence);

%priorityLevel(0);

%% Save the results
%save([SubjName,'.mat'])
save(fullfile('logfiles',[subjectName,'_run_',runNumber,'_all.mat']))   

save(fullfile('logfiles',[subjectName,'_run_',runNumber,'.mat']),...
'Cfg','conditions','eventCoherence','eventDurations','eventEnds',...
'eventOnsets','responseTime','eventResponse','correctResponses','isCorrectResponse') 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Supporting functions here

function [response_key_Dots, responseTimeWithinEvent] = DoDotMotion(Cfg, direction,EventCoherence)
% DODOTMOTION. This function generates the moving dots for every event.
% Motion is generated by creating images at every frame

duration = Cfg.eventDuration;       % Duration of each event
dontclear = Cfg.dontclear;
coh = EventCoherence;               % Coherence of the dots
dotSpeed = Cfg.speedEvent;          % Speed of the dots
dotSize = Cfg.dotSize;
dotLifeTime = Cfg.dotLifeTime; 
maxDotsPerFrame = Cfg.maxDotsPerFrame; 
dotColor = Cfg.dotColor ;           % White

% If you want to include static dots:
% if direction == -1          % if Static assign the direction to -1 
%     dotSpeed = 0;           % Speed is zero
% end

response_key_Dots= []; % prepare collection of response key
responseTimeWithinEvent=[]; % prepare collection of response time

w = Cfg.win;

% Number of dots
ndots = min(maxDotsPerFrame, ceil( Cfg.d_ppd .* Cfg.d_ppd  / Cfg.monRefresh)); % pick minimum between what we gave and the maximum feasible

% Create matrix containing the speed of every dot in x an y
    %   deg/sec * Ap-unit/deg * sec/jump = unit/jump
dxdy = repmat(dotSpeed /(Cfg.apD) * (3/Cfg.monRefresh) ...  %dxdy is an N x 2 matrix that gives jumpsize in units on 0..1
    * [cos(pi*direction/180.0) -sin(pi*direction/180.0)], ndots,1);

% ARRAYS for loop
ss = rand(ndots, 2); % array of dot positions raw [xposition, yposition]    
Ls = (1:ndots)' ;

% Show for how many frames
continue_show = floor(duration/Cfg.ifi) ;    %Cfg.ifi : flip interval
dotLifeTime = ceil(dotLifeTime/Cfg.ifi);   % Convert dotLifeTime from seconds to frames

% Create a ones vector to update to dotlife time of each dot
dotTime = ones(size(Ls,1),1);  

%% Start the loop for generating the dots
% Loop for every single frame
while continue_show

    % Random dot starting position 
    this_s = ss(Ls,:);   %  this_s: matrix of rand starting position, Ls picks out the previous set, 
                         %  ss & xs: matrices that have stuff for dots from the last 2 positions + current.
    
    % Randomize who is coherent and who not
    L = rand(ndots,1) < coh;        % L are the dots that will be moved coherently together   
    % Compute new dot locations in the coherent direction        
    this_s(L,:) = this_s(L,:) + dxdy(L,:);	% Offset the selected dots
    
    %coh=.7;
% L1 = rand(100,1);
% L=L1< coh;
% [L1 L]
    
    if sum(~L) > 0  % if not 100% coherence (if there is at least a point that is not supposed to move, rather be reallocated)
     % Compute new dot locations that are not coherent
        this_s(~L,:) = rand(sum(~L),2);	% Get new random dot locations for the rest                        
    end
    
    % Check if some dots are out of bound or out of lifetime
    N = sum((this_s > 1 | this_s < 0 | repmat(dotTime(:,1) > dotLifeTime,1,2))')' ~= 0 ; %N is the list of dots that need cleanup

      % Re-allocate the dots to random positions
    if sum(N) > 0
        this_s(N,:) = rand(sum(N),2);             % re-allocate the chosen dots to random positions
        dotTime(find(N==1),1) = 1;                % find the dots that were re-allocated and change its lifetime to 1 (first frame of life)
    end

        % Add one frame to the dot lifetime to each dot
        dotTime = dotTime + 1; 

        % Convert to stuff we can actually plot
        this_x(:,1:2) = floor(Cfg.d_ppd(1) * this_s); % pix/ApUnit

        % Shift dots
        dot_show = (this_x(:,1:2) - Cfg.d_ppd/2)'; % This assumes that zero is at the top left, but we want it to be in the center, so shift the dots up and left,
                                                   % which just means adding half of the aperture size to both the x and y direction.

        % Fixation Cross
        %Screen('DrawLines', Cfg.win, Cfg.allCoords,Cfg.lineWidthPix, Cfg.fixationCross_color , [Cfg.center(1) Cfg.center(2)], 1);          % Keep in center when presenting motion on the side
        %Screen('DrawLines', w, Cfg.allCoords,Cfg.lineWidthPix, [255 255 255] , [Cfg.center(1)+Cfg.ShiftX Cfg.center(2)+Cfg.ShiftY], 1);    % Draw the fixation cross on top of the motion

        % NaN out-of-circle dots  
        xyDis = dot_show;
        outCircle = sqrt(xyDis(1,:).^2 + xyDis(2,:).^2) + dotSize/2 > (Cfg.d_ppd/2);     %is your distance from the center bigger than the radius?   
        dots2Display = dot_show;
        dots2Display(:,outCircle) = NaN;
        
        Screen('DrawDots',w,dots2Display,dotSize,dotColor,[Cfg.center(1)+Cfg.ShiftX Cfg.center(2)+Cfg.ShiftY],2);
        
        Screen('DrawingFinished',w,dontclear);       
        Screen('Flip', w,0,dontclear);

        % Update the arrays so xor works next time
        xs(Ls, :) = this_x;
        ss(Ls, :) = this_s;
      
       % Check for end of loop 
        continue_show = continue_show - 1;
               
        % Response collection
        %Responses are collected in each frame (if participants holds down key for a few seconds)
%         if strcmp(Cfg.device,'PC')
        if strcmp(Cfg.device,computer)
            [KeyIsDown,PressedSecs,keyCode] = KbCheck(-1);
            if KeyIsDown == 1 && strcmp(KbName(keyCode),Cfg.ResponseButtonUP)==1
                response_key_Dots(end+1)= 1 ;
                responseTimeWithinEvent(end+1)= PressedSecs - Cfg.experimentStartTime;
            
            elseif KeyIsDown == 1 && strcmp(KbName(keyCode),Cfg.ResponseButtonDOWN)==1
                response_key_Dots(end+1)= 2 ;
                responseTimeWithinEvent(end+1)= PressedSecs - Cfg.experimentStartTime;
                
            else
                response_key_Dots(end+1)= 0;
                responseTimeWithinEvent(end+1)= 0;
            end
        end            
end

% Remove duplicate responses coming from the same button press
%If consecutive frames have the same button press
for iResponse = length(responseTimeWithinEvent):-1:2
    if responseTimeWithinEvent(iResponse-1)~=0               % if preceeding response exists
        responseTimeWithinEvent(iResponse)=0 ;               % cancel the current one. 
        response_key_Dots(iResponse)=0;
    end
end

% remove the zeros response times
responseTimeWithinEvent = responseTimeWithinEvent(responseTimeWithinEvent~=0);
response_key_Dots = response_key_Dots(response_key_Dots~=0);
end


function [conditions,motionDirections,correctResponses] = experimental_design(Cfg) 
% This function creates the design for the experiment. It takes as input the
% required number of trails 

% Total number of Trials
numEvents = Cfg.numEvents ;

%% Assign the conditions
RND = 1; % Randomize
[conditions] = BalanceTrials(numEvents, RND, {'Up','Down'});        % forced choice, 2 conditions
    %it's a built in function from PsychToolbox


%% Motion Directions  [0 right, 90 up, 180 left, 270 down]
% Create a vector of -1s (static)
motionDirections=ones(size(conditions,1),1)* -1 ;       %vector of motion direction related to the DoDotMotion script       

% Horizontal motion = right and left RDK directions
motionDirections(strcmp(conditions,'Up'),1) = 90;       %multiple directions are possible
motionDirections(strcmp(conditions,'Down'),1) = 270;

% Correct responses should be 1=Up , 2=Down
correctResponses = zeros(size(conditions));
correctResponses(strcmp(conditions,'Up'))=1  ;
correctResponses(strcmp(conditions,'Down'))=2  ;

end
