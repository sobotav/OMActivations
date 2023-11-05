function sequenceArray = getSequences(signal,begins,ends)
%getSequences get sequences of signals determined by their respective 
%begins and ends

if length(begins) ~= length(ends)
    error('The vector "begins" does not have the same lengths as "ends"');
end

begins              = begins(:)';            	% always a row vector
ends                = ends(:)';               	% always a row vector
N                   = length(signal);          	% length of the signal
N_segments          = length(begins);          	% total number of segments
segmentLengths      = ends-begins+1;          	% lengths of the segments
maxSegmentLength    = max(segmentLengths);   	% length of the longest segment

N_rows_NaN                  = 2*maxSegmentLength;                     	% number of rows in the NaN_array
NanVec                      = ones(N_rows_NaN,1);                                               
NanVec(1:maxSegmentLength)  = NaN;                                    	% vector with first N_segments of NaN and the same number of zeros
NanIndicesMatrix            = repmat((1:N_rows_NaN)',1,N_segments);   	% matrix of NaN indices
NanIndicesMatrix            = mod(bsxfun(@plus,NanIndicesMatrix,-segmentLengths-1),N_rows_NaN)+1;% shift the indices by the length of the segments
NanIndicesMatrix            = NanIndicesMatrix(1:maxSegmentLength,:);  	% use only the first half of the array
NanArray                    = NanVec(NanIndicesMatrix);             	% segment values have a value of 1, the rest is NaN

%shift the columns in the signal matrix
indicesMatrix = repmat((1:maxSegmentLength)',1,N_segments);    	% indices of segment values
indicesMatrix = mod(bsxfun(@plus,indicesMatrix,begins-2),N)+1; 	% shift each column by the vector 'begins'
sequenceArray = signal(indicesMatrix);                        	% array of all segments, all having the length of max_segment_l
sequenceArray = sequenceArray.*NanArray(1:maxSegmentLength,:);	% 'crop' the final array of segments

end

