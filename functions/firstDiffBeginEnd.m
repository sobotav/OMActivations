function [diff1Begin, diff1End] = firstDiffBeginEnd(signalSmoothDiff, peakBegin, peakEnd)
%firstDiffBeginEnd returns the sequences with positive first difference of
%the smoothened signal

[diff1BeginsAll, diff1EndsAll]  = findPositiveSequences(signalSmoothDiff);          % find positive values in 1st difference of smooth signal
diff1BeginsAll                  = diff1BeginsAll(:)';                            	% should be always a row vector
diff1EndsAll                    = diff1EndsAll(:)';                                	% should be always a row vector
diff1Array                      = getSequences(signalSmoothDiff,peakBegin,peakEnd); % get the corresponding sequences

% maximum of 1st difference (maximum upstroke)
[diff1Max, diff1MaxPosition]    = max(diff1Array,[],1);                     % upstroke maximum position
positiveDiff1Max                = diff1Max>0;                               % use only the values with positive diff1 maximum
diff1MaxPosition                = diff1MaxPosition(positiveDiff1Max);       % apply for diff1MaxPosition
peakBegin                       = peakBegin(positiveDiff1Max);              % apply for peakBegin
diff1MaxPosition                = diff1MaxPosition' + peakBegin-1;          % position of peak maximum

% upstroke beginnings - found as beginnings of the segments with positive first difference
diff1BeginComparisons   = bsxfun(@le, diff1BeginsAll, diff1MaxPosition);    % comparison of upstroke beginnings
[~, diff1BeginIndex]    = min(diff1BeginComparisons,[],2);              	% find the upstroke beginnings before upstroke positions
if min(diff1BeginIndex) == 1 % if there is an index == 1, at the end
    diff1BeginIndex(sum(diff1BeginComparisons,2) == length(diff1BeginsAll)) = length(diff1BeginsAll);
end
diff1Begin = diff1BeginsAll(diff1BeginIndex-1)';                           % indices of upstroke beginnings, correction -1

%upstroke ends - found as ends of the segments with positive first difference
diff1EndComparisons     = bsxfun(@le, diff1MaxPosition, diff1EndsAll);      % comparison of upstroke ends
[~, diff1EndIndex]      = max(diff1EndComparisons,[],2);                 	% find the upstroke beginnings before upstroke positions
diff1End                = diff1EndsAll(diff1EndIndex)';                  	% indices of upstroke beginnings

end

