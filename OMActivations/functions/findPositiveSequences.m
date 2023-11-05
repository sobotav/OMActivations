function [begins, ends] = findPositiveSequences(vec)
%findPositiveSequences
% Detects all positive sequences in the vector and returns the respective 
% indices of the BEGINS and the ENDS

vec                 = vec(:);                   	% column vector
N                   = length(vec);                	% length of the vector

indexVec            = 1:N+1;                       	% vector of indices
positiveVec         = zeros(N,1);                   % initializaiton of positiveVec
positiveVec(vec>0)  = 1;                            % positive values = 1, elsewhere = 0
diffPositiveVec     = diff([0; positiveVec; 0]);    % diff of the positiveVec

begins              = indexVec(diffPositiveVec==1); % beginnings of the sequences
indexVec            = indexVec-1;                   % shift of -1 for detection of ends
ends                = indexVec(diffPositiveVec==-1);% ends of the sequences 

begins              = begins(:);                    % column vector
ends                = ends(:);                      % column vector

end

