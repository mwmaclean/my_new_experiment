% (C) Copyright 2020 CPP visual motion localizer developpers

function varargout = preSaveSetup(varargin)
    % varargout = postInitializatinSetup(varargin)

    % generic function to prepare structures before saving

    [thisEvent, iBlock, iTrial, duration, onset, cfg, logFile] = ...
        deal(varargin{:});

    thisEvent.event = iTrial;
    thisEvent.block = iBlock;
    thisEvent.keyName = 'n/a';
    thisEvent.duration = duration;
    thisEvent.onset = onset - cfg.experimentStart;

    % Save the events txt logfile
    % we save event by event so we clear this variable every loop
    thisEvent.fileID = logFile.fileID;
    thisEvent.extraColumns = logFile.extraColumns;

    varargout = {thisEvent};

end
