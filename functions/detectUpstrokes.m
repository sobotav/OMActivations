function upstrokeData = detectUpstrokes(data, dataSmooth, template)
%detectUpstrokes detection of upstrokes in the whole dataset using template
%detection
% data          - original data
% dataSmooth    - smoothened signals
% template      - template for detection

[~,N_pix_total] = size(data);                   % total number of pixels
upstrokeData    = zeros(40*N_pix_total,6);   	% alocate an array for peak parameters 
k = 1;                                          % peak counter

for p = 1:N_pix_total
    
    signal = data(:,p);                                                                         % original signal
    [peakBegin, peakEnd]        = templateDetection(signal,template);                           % beginnings and ends based on template matching
    signalSmooth                = dataSmooth(:,p);                                              % smooth signal
    signalSmoothDiff1           = [0; diff(signalSmooth)];                                      % 1st difference of signalSmooth
    [diff1Begin, diff1End]      = firstDiffBeginEnd(signalSmoothDiff1,peakBegin,peakEnd);       % beginnings and ends based on the 1st difference
    signalSmoothDiff2           = [0; diff(signalSmoothDiff1)];                                 % 2nd difference of signal_smooth
    [diff2Begin, diff2End]      = secondDiffBeginEnd(signalSmoothDiff2,diff1Begin,diff1End);    % beginnings and ends based on the 2nd difference

    % in case there are some, remove artefact detections
    exclusionCriterion1 = diff2Begin<diff2End;
    begins              = diff2Begin(exclusionCriterion1);
    ends                = diff2End(exclusionCriterion1);
    
    % keep only the beginnings and ends with mins < maxs
    mins                = signal(begins);                   % local minimum values
    maxs                = signal(ends);                     % local maximum values
    exclusionCriterion2 = mins < maxs;                      % exclusion criterion applied to all
    begins              = begins(exclusionCriterion2);  	% the beginnings of the upstrokes
    ends                = ends(exclusionCriterion2);        % the ends of the upstrokes
    durations           = ends-begins+1;                    % duration of the upstrokes

    % Find the local maximum values of diff1 again and label them as max_dFdt_pos
    diffArray               = getSequences(signalSmoothDiff1,begins,ends);      % get the corresponding sequences
    %[~, diff1MaxPosition]    = max(diffArray,[],1);                              % upstroke maximum position
    [diff1Max, diff1MaxPosition]    = max(diffArray,[],1);                     	% upstroke maximum position
    diff1Max                = diff1Max';
    diff1MaxPosition        = diff1MaxPosition' + begins-1;                   	% position of peak maximum
    max_dFdt_pos            = diff1MaxPosition;                               	% maximum dFdt positions   
    
    N_upstrokes                         = size(begins,1);                      	% number of upstrokes in the signal
    pixelNrs                            = p*ones(N_upstrokes,1);               	% column vector with the pixel number
    upstrokeData(k:k+N_upstrokes-1,:)   = [pixelNrs, begins, ends, durations, max_dFdt_pos, diff1Max];  % save the upstroke data
       
    k = k + N_upstrokes;                % increase the peak counter    
end

upstrokeData(all(upstrokeData==0,2),:) = [];      %remove zero lines from the matrix

end

