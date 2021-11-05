% (C) Copyright 2020 CPP visual motion localizer developpers

function varargout = preTrialSetup(varargin)
    % varargout = postInitializatinSetup(varargin)

    % generic function to prepare some structure before each trial

    [cfg, iBlock, iEvent] = deal(varargin{:});

    % set block name and if it is a target
    thisEvent.trial_type = cfg.design.blockNames{iBlock};
    thisEvent.target = randi([0, 1], [1, 1]);

    % If this frame shows a target we change the color of the cross
    thisFixation.fixation = cfg.fixation;
    thisFixation.screen = cfg.screen;

    varargout = {thisEvent, thisFixation, cfg};

end
