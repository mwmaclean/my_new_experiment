% (C) Copyright 2018 Mohamed Rezk
% (C) Copyright 2020 CPP visual motion localizer developpers

%% mainScript
% 1- Nom de l’expérience ici
% 2- Courte description de l’expérience & de la consigne pour le participant
% 3- Nom du fichier de l’expérience (script principal) & noms des fonctions utilisées
% 4- Courte description de ce qui est enregistré (output du script)
% 5- Ce dont on a besoin pour rouler votre script (e.g.,: PsychToolBox, fichier des conditions/essais)
% 6- L’année, vos noms & courriels

%Code ci-dessous:

% Clear all previous stuff
clear all;
clc;

% make sure we got access to all the required functions and inputs
initEnv();

    %Cfg: configuration, a structure that holds all the info of the experiment
    
% Set and load all the parameters to run the experiment
cfg = setParameters; 

% Get subject name & run number before the start of the experiment
cfg = userInputs(cfg);
%         % Other option for user inputs:
%        % Get subject name and run number 
%         subjectName = input('Enter Subject Name: ','s');
%         if isempty(subjectName)
%           subjectName = 'trial';
%         end
%         
%         runNumber = input('Enter the run Number: ','s');
%         if isempty(runNumber)
%           runNumber = 'trial';
%         end
%         
%         % If the run number is set to zero, it is a training session
%         if strcmp(runNumber,'0')
%             numberTraining = 10;
%             Cfg.numEvents = numberTraining;
%         end

% Create the BIDS directories & fileNames for the behavioral output
    % for this subject / session / run using the information from cfg.
cfg = createFilename(cfg); 

%%  Experiment

% Safety loop: close the screen if code crashes (try-catch)
try

    %% Init the experiment
    [cfg] = initPTB(cfg);
    
%           % Basic elements to include to initialize the experiment:
%             AssertOpenGL; % Verify if PTB is based on OpenGL & Screen(), break & error if not
%             
%             Screen('Preference','SkipSyncTests', 1); % forces script to continue if sync tests fail
%             Screen('Preference','TextRenderer', 0)
%             % Select screen with maximum id for output window:
%             screenid = max(Screen('Screens'));
%             
%             % Open a fullscreen, onscreen window with grey background. 
%             PsychImaging('PrepareConfiguration');   %Prepare setup of imaging pipeline for onscreen window
%             
%             if TestingSmallScreen 
%                 [Cfg.win, Cfg.winRect] = PsychImaging('OpenWindow', screenid, Cfg.Background_color,  [0,0, 480, 270]); % Open window in a small screen (when modifying/testing script) 
%             else
%                 [Cfg.win, Cfg.winRect] = PsychImaging('OpenWindow', screenid, Cfg.Background_color);                   % Open window on selected (max) screen
%             end
%             
%             % Set maximum priority level
%             priorityLevel = MaxPriority(Cfg.win);  % prioritize over other computer processes
%             Priority(priorityLevel)
%             
%             % Get the Center of the Screen
%             Cfg.center = [Cfg.winRect(3), Cfg.winRect(4)]/2; %it assumes the rectangle starts from (0,0); 3 and 4 are the components


% Finalize PTB setup
    cfg = postInitializationSetup(cfg);

%             % generic function to finalize some set up after PTB has been
%             % initialized
%         
%             cfg = deal(varargin{:});
%         
%             % Convert some values from degrees to pixels
%         
%             % Get some values in pixels per frame
%         
%             varargout = {cfg};

    % Prepare output logfiles
    cfg = checkCFG(cfg);
    logFile = saveEventsFile('init', cfg);
    logFile = saveEventsFile('open', cfg, logFile);

    disp(cfg);

    % Show experiment instruction
%     standByScreen(cfg);
    
%             Screen('FillRect', cfg.screen.win, cfg.color.background, cfg.screen.winRect);
%         
%             DrawFormattedText(cfg.screen.win, ...
%                               cfg.task.instruction, ...
%                               'center', 'center', cfg.text.color);
%         
%             Screen('Flip', cfg.screen.win);
%         
%             % Wait for space key to be pressed
%             pressSpaceForMe();

    % Prepare the KbQueue to collect responses
    getResponse('init', cfg.keyboard.responseBox, cfg);

    %% Experiment Start

    cfg = getExperimentStart(cfg);
    
%             drawFixation(cfg);
%             vbl = Screen('Flip', cfg.screen.win);
%             cfg.experimentStart = vbl;

    getResponse('start', cfg.keyboard.responseBox);

    %% For Each Block

    for iBlock = 1:cfg.design.nbBlocks

        waitFor(cfg, cfg.timing.onsetDelay);

        for iTrial = 1:cfg.design.nbTrials

            fprintf('\n - Running trial %.0f \n', iTrial);

            % Check for experiment abortion from operator
            checkAbort(cfg, cfg.keyboard.keyboard);

            [thisEvent, thisFixation, cfg] = preTrialSetup(cfg, iBlock, iTrial);

            % play the dots and collect onset and duraton of the event
            [onset, duration] = doTrial(cfg, thisEvent, thisFixation);

            thisEvent = preSaveSetup( ...
                                     thisEvent, ...
                                     iBlock, ...
                                     iTrial, ...
                                     duration, onset, ...
                                     cfg, ...
                                     logFile);

            saveEventsFile('save', cfg, thisEvent);

            % collect the responses and appends to the event structure for
            % saving in the tsv file
            responseEvents = getResponse('check', cfg.keyboard.responseBox, cfg);

            responseEvents(1).fileID = logFile.fileID;
            responseEvents(1).extraColumns = logFile.extraColumns;
            saveEventsFile('save', cfg, responseEvents);

            waitFor(cfg, cfg.timing.ISI);

        end

    end

    % End of the run for the BOLD to go down (if doing an fMRI experiment)
    waitFor(cfg, cfg.timing.endDelay);

    cfg = getExperimentEnd(cfg);
%             drawFixation(cfg);
%             endExpmt = Screen('Flip', cfg.screen.win);
%         
%             disp(' ');
%             ExpmtDur = endExpmt - cfg.experimentStart;
%             ExpmtDurMin = floor(ExpmtDur / 60);
%             ExpmtDurSec = mod(ExpmtDur, 60);
%             disp(['Experiment lasted ', ...
%                   num2str(ExpmtDurMin), ' minutes ', ...
%                   num2str(ExpmtDurSec), ' seconds']);
%             disp(' ');


    % Close the logfiles
    saveEventsFile('close', cfg, logFile);

    getResponse('stop', cfg.keyboard.responseBox);
    getResponse('release', cfg.keyboard.responseBox);

    createJson(cfg, cfg); 

    farewellScreen(cfg);
%         Screen('FillRect', cfg.screen.win, cfg.color.background, cfg.screen.winRect);
%         DrawFormattedText(cfg.screen.win, 'Thank you!', 'center', 'center', cfg.text.color);
%         Screen('Flip', cfg.screen.win);
%         if isfield(cfg, 'mri')
%             WaitSecs(cfg.mri.repetitionTime * 2);
%         end

    cleanUp(); % close all windows, ports, show mouse cursor, close keyboard queues & give access back to the keyboards

catch

    cleanUp();  
    psychrethrow(psychlasterror); % will catch bug in last error and display

end
