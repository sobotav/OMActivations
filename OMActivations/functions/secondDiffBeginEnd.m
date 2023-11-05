function [diff2Begin, diff2End] = secondDiffBeginEnd(signalSmoothDiff2, diff1Begin, diff1End)
%secondDiffBeginEnd returns the desired sequences of second difference of
%the smoothed signal

[diff2BeginsAll, ~]     = findPositiveSequences(signalSmoothDiff2);            	% find positive values in 2nd difference of smooth signal
diff2BeginsAll          = diff2BeginsAll(:)';                                 	% should be always a row vector
diff2Array              = getSequences(signalSmoothDiff2,diff1Begin,diff1End);  % get the corresponding sequences

% local maximum values of the 2nd difference
[~, diff2MaxPositions]  = max(diff2Array,[],1);                                 % position of diff2 maximum
diff2MaxPositions       = diff2MaxPositions' + diff1Begin-1;                  	% correction of diff2 maximum position

% beginnings of the upstrokes, defined as the last diff2 crossing of 0 before local maximum
diff2BeginComparisons   = bsxfun(@le, diff2BeginsAll, diff2MaxPositions);       % comparison of diff2 beginnings with the diff2 maximum values
[~, diff2BeginIndex]    = min(diff2BeginComparisons,[],2);                      % find the diff2 going through 0
if min(diff2BeginIndex) == 1 % if there is an index == 1, at the end
    diff2BeginIndex(sum(diff2BeginComparisons,2) == length(diff2BeginsAll)) = length(diff2BeginsAll);
end
diff2Begin = diff2BeginsAll(diff2BeginIndex-1)';                                % indices of diff2 beginnings, correction -1

% local minimum values of the 2nd difference
[~, diff2MinPositions]  = min(diff2Array,[],1);                                 % position of diff2 minimum
diff2MinPositions       = diff2MinPositions' + diff1Begin-1;                   	% correction of diff2 minimum position

% ends of the upstrokes, defined as the first diff2 crossing of 0 after
% local minimum
diff2EndComparisons = bsxfun(@le, diff2MinPositions, diff2BeginsAll);           % comparison of diff2 ends with the diff2 minimum values
[~, diff2EndIndex]  = max(diff2EndComparisons,[],2);                            % find the diff2 going through 0
diff2End            = diff2BeginsAll(diff2EndIndex)'-1;                       	% indices of diff2 ends

% if the inflection point at the beginning has negative 1st
% difference, use the upstroke beginning from the 1st difference
diff2Begin(diff2Begin<diff1Begin) = diff1Begin(diff2Begin<diff1Begin);

% if the inflection point at the end has negative 1st
% difference, use the upstroke end from the 1st difference 
diff2End(diff2End>diff1End) = diff1End(diff2End>diff1End);

end

