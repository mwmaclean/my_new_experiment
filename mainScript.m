% (C) Copyright 2018 Mohamed Rezk
% (C) Copyright 2020 CPP visual motion localizer developpers

%% mainScript

% Clear all the previous stuff
clc;
if ~ismac
    close all;
    clear Screen;
end

% make sure we got access to all the required functions and inputs
initEnv();

% set and load all the parameters to run the experiment
cfg = setParameters;
cfg = userInputs(cfg);
cfg = createFilename(cfg);

%%  Experiment

% Safety loop: close the screen if code crashes
try

    %% Init the experiment
    [cfg] = initPTB(cfg);

    cfg = postInitializationSetup(cfg);

    [el] = eyeTracker('Calibration', cfg);

    %     [cfg] = expDesign(cfg);

    % Prepare for the output logfiles with all
    logFile.extraColumns = cfg.extraColumns;
    logFile = saveEventsFile('open', cfg, logFile);

    disp(cfg);

    % Show experiment instruction
    standByScreen(cfg);

    % prepare the KbQueue to collect responses
    getResponse('init', cfg.keyboard.responseBox, cfg);

    %% Experiment Start

    eyeTracker('StartRecording', cfg);

    cfg = getExperimentStart(cfg);

    getResponse('start', cfg.keyboard.responseBox);

    %% For Each Block

    for iBlock = 1:cfg.design.nbBlocks

        waitFor(cfg, cfg.timing.onsetDelay);

        for iTrial = 1:cfg.design.nbTrials

            fprintf('\n - Running trial %.0f \n', iTrial);

            % Check for experiment abortion from operator
            checkAbort(cfg, cfg.keyboard.keyboard);

            [thisEvent, thisFixation, cfg] = preTrialSetup(cfg, iBlock, iTrial);

            % AVAILABLE IN A NEW RELEASE SOON
            %
            % eyeTracker('Message', cfg, ...
            %     ['start_trial-', num2str(iTrial), '_', thisEvent.trial_type]);

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

            % AVAILABLE IN A NEW RELEASE SOON
            %
            % eyeTracker('Message', cfg, ...
            %     ['end_trial-', num2str(iTrial), '_', thisEvent.trial_type]);

            waitFor(cfg, cfg.timing.ISI);

        end

    end

    % End of the run for the BOLD to go down
    waitFor(cfg, cfg.timing.endDelay);

    cfg = getExperimentEnd(cfg);

    eyeTracker('StopRecordings', cfg);

    % Close the logfiles
    saveEventsFile('close', cfg, logFile);

    getResponse('stop', cfg.keyboard.responseBox);
    getResponse('release', cfg.keyboard.responseBox);

    eyeTracker('Shutdown', cfg);

    createJson(cfg, cfg);

    farewellScreen(cfg);

    cleanUp();

catch

    cleanUp();
    psychrethrow(psychlasterror);

end
