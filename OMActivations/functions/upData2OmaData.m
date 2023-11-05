function [ OmaData ] = upData2OmaData(upData, N_frames)
%upData2OmaData converts the table with upstroke data into OMA data-like
%matrix

if isempty(upData)
    error('The variable up_data is empty!');
end

[rows, cols] = size(upData);
if cols < 3
    error('The number of columns in the up_data table is not sufficient!');
end

%create upstroke data
OmaData = zeros(N_frames,10000);
for i = 1:rows
    OmaData(upData(i,2):upData(i,3),upData(i,1)) = 1; 
end

end
