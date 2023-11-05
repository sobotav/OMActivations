function [upstrokeDataOut] = stFilter(upstrokeData, N_frames, th, kernel)
%stFilter spatiotemporal filtering of the upstroke detections
% upstrokeData  - upstroke data
% N_frames      - number of frames in the dataset (usually 2048)
% th            - threshold of the normalized convolution values <0;1>

% internal constants
N_pixRowColumn  = 100;                                  % number of pixels in each row and column of the dataset
N_pixTotal      = N_pixRowColumn * N_pixRowColumn;  	% total number of pixels

% create detection data
dataDetect      = upData2OmaData(upstrokeData, N_frames);

%% 3D convolution

data3D          = reshape(dataDetect,N_frames,N_pixRowColumn,N_pixRowColumn);   % reshape data for 3D convolution
data3DConv      = convn(data3D,kernel, 'same');                                 % 3D convolution
normData        = convn(ones(size(data3D)),kernel,'same');                     	% dataset used for normalization
data3DConv      = data3DConv./normData;                                         % normalization of the 3D dataset 
dataConv        = reshape(data3DConv,N_frames,N_pixTotal);                      % reshape the data back

%% Removing of false positives

N_detections = size(upstrokeData,1);      	% number of detections, defined as the number of rows in the up_data table
convValuesSum = zeros(N_detections,1);    	% memory allocation for the sum values from the spatiotemporal filtering
for i = 1:N_detections                      % for each detection
    convValuesSum(i) = sum(dataConv(upstrokeData(i,2):upstrokeData(i,3),upstrokeData(i,1)));  % sum of the values from convolution
end

convValuesMean      = convValuesSum./upstrokeData(:,4);    	% mean convolution values for each detection
thresholdCriterion  = convValuesMean>th;                    % criterion for leaving out some activations: thresholding of the mean convolution value
upstrokeDataOut     = upstrokeData(thresholdCriterion,:); 	% upstroke data after filtering

end

