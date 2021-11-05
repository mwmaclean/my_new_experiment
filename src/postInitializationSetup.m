% (C) Copyright 2020 CPP visual motion localizer developpers

function varargout = postInitializationSetup(varargin)
    % varargout = postInitializatinSetup(varargin)

    % generic function to finalize some set up after psychtoolbox has been
    % initialized

    cfg = deal(varargin{:});

    % Convert some values from degrees to pixels

    % Get some values in pixels per frame

    varargout = {cfg};

end
