function [peakBegin, peakEnd] = templateDetection(signal, template)
%templateDetection Template Detection Algorithm

% Template matching
detectionSignal = conv(signal, -template, 'same');          % convolution

% Peak detection
detectionSignal(detectionSignal<0) = 0;                             % set all the values <0 to 0
[peakBegin,peakEnd]     = findPositiveSequences(detectionSignal);   % find the beginnings and the ends of positive peaks

% remove the peaks with the length of 0 samples (one positive value surrounded by zeros)
isNotZeroLengthPeak	= (peakEnd-peakBegin) ~= 0;
peakBegin        	= peakBegin(isNotZeroLengthPeak);
peakEnd           	= peakEnd(isNotZeroLengthPeak);

% Deal with the first detected peak (which is usually an artifact) if the first nonzero part does not have a top (peak) then it is
% considered as artifact
firstPeak = detectionSignal(1:peakEnd(1));
diffFirstPeak = diff(firstPeak);
diffFirstPeak = diffFirstPeak(:);

if max(diffFirstPeak) <= 0              % there is no increasing part of the peak
    peakBegin   = peakBegin(2:end);     % remove the beginning index of the peak
    peakEnd     = peakEnd(2:end);       % remove the end index of the peak
else
    firstPeakIndex      = 1:peakEnd(1);                      	% vector of indices in the first peak
    diffFirstPeak       = [diffFirstPeak; diffFirstPeak(end)]; 	% adjust the length of diffFirstPeak so it is the same as the length of firstPeak
    positiveDiffIndex   = firstPeakIndex(diffFirstPeak>0);      % find indices of increasing parts in the first peak
    peakBegin(1)        = positiveDiffIndex(1);             	% set the new beginning of the first peak 
end

end

