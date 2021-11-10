function [response_key_Dots, responseTimeWithinEvent] = DoDotMotion(Cfg, direction,EventCoherence)
% DODOTMO This function draws a specific type of dots
%   Detailed explanation goes here

duration = Cfg.eventDuration;       % Duration of each event
dontclear = Cfg.dontclear;
% Dot stuff     
coh = EventCoherence;               % Coherence of the dots
dotSpeed = Cfg.speedEvent;
%direction = Cfg.direction;    
dotSize = Cfg.dotSize;
dotLifeTime = Cfg.dotLifeTime; 
maxDotsPerFrame = Cfg.maxDotsPerFrame; 


if direction == -1          % if Static (Direction -1 reflects static)
    dotSpeed = 0;           % Speed is zero
end

dotColor = Cfg.dotColor ;
response_key_Dots= [];
responseTimeWithinEvent=[];

%t_duration = Cfg.t_duration ;
%fixationChangeDuration = Cfg.fixationChangeDuration;

w = Cfg.win;
ndots = min(maxDotsPerFrame, ceil( Cfg.d_ppd .* Cfg.d_ppd  / Cfg.monRefresh));

% dxdy is an N x 2 matrix that gives jumpsize in units on 0..1
%   deg/sec * Ap-unit/deg * sec/jump = unit/jump
dxdy = repmat(dotSpeed * 10/(Cfg.apD*10) * (3/Cfg.monRefresh) ...
    * [cos(pi*direction/180.0) -sin(pi*direction/180.0)], ndots,1);

% ARRAYS, INDICES for loop
ss = rand(ndots*3, 2); % array of dot positions raw [xposition, yposition]    

% Divide dots into three sets
Ls = cumsum(ones(ndots,3)) + repmat([0 ndots ndots*2], ndots, 1);
loopi = 1; % Loops through the three sets of dots

% Show for how many frames
continue_show = floor(duration/Cfg.ifi) ;    

dotLifeTime = ceil(dotLifeTime/Cfg.ifi);   % Covert the dot LifeTime from seconds to frames

% Create a ones vector to update to dotlife time of each dot
dotTime = ones(size(Ls,1),2);  

%%
while continue_show


    %Counter = Counter + 1 ;

    % Get ss & xs from the big matrices. xs and ss are matrices that have 
    % stuff for dots from the last 2 positions + current.
    Lthis  = Ls(:,1);% Ls picks out the previous set (1:5, 6:10, or 11:15)    Lthis  = Ls(:,loopi); % Lthis picks out the loop from 3 times ago, which 
                          % is what is then moved in the current loop
    this_s = ss(Lthis,:);  % this is a matrix of random #s - starting position
    % Update the loop pointer
    loopi = loopi+1;   
    if loopi == 4
        loopi = 1;
    end
    % Compute new locations
    % L are the dots that will be moved
    L = rand(ndots,1) < coh;                
    this_s(L,:) = this_s(L,:) + dxdy(L,:);	% Offset the selected dots

    if sum(~L) > 0  % if not 100% coherence
        this_s(~L,:) = rand(sum(~L),2);	% get new random locations for the rest                        
    end

    N = sum((this_s > 1 | this_s < 0 | repmat(dotTime(:,1) > dotLifeTime,1,2))')' ~= 0 ;

      %% Re-allocate the dots to random positions
    if sum(N) > 0
        this_s(N,:) = rand(sum(N),2);             % re-allocate the chosen dots to random positions
        dotTime(find(N==1),:) = 1;                % find the dots that were re-allocated and change its lifetime to 1
    end

%           % Reallocate to the border of the aperture
%             if sum(N) > 0
%                 xdir = sin(pi*direction/180.0);
%                 ydir = cos(pi*direction/180.0);
%                 % Flip a weighted coin to see which edge to put the replaced dots
%                 if rand < abs(xdir)/(abs(xdir) + abs(ydir))              
%                     this_s(find(N==1),:) = [rand(sum(N),1) (xdir > 0)*ones(sum(N),1)];
%                     dotTime(find(N==1),:) = 1;
%                 else
%                     this_s(find(N==1),:) = [(ydir < 0)*ones(sum(N),1) rand(sum(N),1)];
%                     dotTime(find(N==1),:) = 1;
%                 end
%             end
    %%      
        % add one frame to the dot lifetime to each dot
        dotTime = dotTime + 1; 

        % Convert to stuff we can actually plot
        this_x(:,1:2) = floor(Cfg.d_ppd(1) * this_s); % pix/ApUnit

        % This assumes that zero is at the top left, but we want it to be in the 
        % center, so shift the dots up and left, which just means adding half of 
        % the aperture size to both the x and y direction.
        dot_show = (this_x(:,1:2) - Cfg.d_ppd/2)';

        % Now do next drawing commands
        %Screen('DrawDots', Cfg.win, dot_show, dotSize, dotColor, Cfg.center,2);   %if you want to change location change Cfg.center        
%         Screen('DrawLines', Cfg.win, Cfg.allCoords,Cfg.lineWidthPix, Cfg.fixationCross_color , [Cfg.center(1) Cfg.center(2)], 1);   % to keep fixation cross in center when presenting motion on the side
        %Screen('DrawLines', w, Cfg.allCoords,Cfg.lineWidthPix, [255 255 255] , [Cfg.center(1)+Cfg.ShiftX Cfg.center(2)+Cfg.ShiftY], 1);  %        %Draw the fixation cross on top of the motion

        % NaN out-of-circle dots  
        xyDis = dot_show;
        outCircle = sqrt(xyDis(1,:).^2 + xyDis(2,:).^2) + dotSize/2 > (Cfg.d_ppd/2);        
        dots2Display = dot_show;
        dots2Display(:,outCircle) = NaN;
        
        Screen('DrawDots',w,dots2Display,dotSize,dotColor,[Cfg.center(1)+Cfg.ShiftX Cfg.center(2)+Cfg.ShiftY],2);
        
        Screen('DrawingFinished',w,dontclear);       
        Screen('Flip', w,0,dontclear);

        % Update the arrays so xor works next time
        xs(Lthis, :) = this_x;
        ss(Lthis, :) = this_s;
      
       %% Check for end of loop 
        continue_show = continue_show - 1;
        
       
        %% response collection
        % If PC
        if strcmp(Cfg.device,'PC')
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

%% Remove duplicate responses coming from the same button press
for iResponse = length(responseTimeWithinEvent):-1:2
    if responseTimeWithinEvent(iResponse-1)~=0               % if preceeding response exists
        responseTimeWithinEvent(iResponse)=0 ;               % cancel the current one. 
        response_key_Dots(iResponse)=0;
    end
end

% remove the zeros response times
responseTimeWithinEvent = responseTimeWithinEvent(responseTimeWithinEvent~=0);
response_key_Dots = response_key_Dots(response_key_Dots~=0);


%% Present last dots
%Screen('DrawLines', w, Cfg.allCoords,Cfg.lineWidthPix, [255 255 255] , [Cfg.center(1) Cfg.center(2)], 1);  % Draw the fixation cross
%Screen('Flip', w,0,dontclear);

%Erase last dots
% Screen('DrawLines', w, Cfg.allCoords,Cfg.lineWidthPix, Cfg.fixationCross_color , [Cfg.center(1) Cfg.center(2)], 1);   
% Screen('DrawingFinished',w,dontclear);
% Screen('Flip', w,0,dontclear);

end
