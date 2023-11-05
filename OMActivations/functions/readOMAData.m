function [tempdata, dataInfo] = readOMAData(path, fileName)
%readOMAData reads the Optical Mapping data saved in RSH and RSD files
%fileName   - the name of the RSH file
%path       - the path to the borth RSH and RSD files
%
%Outputs:
%tempdata   - the pixel values in time (usually with dimensions 2048x10002)
%dataInfo   - the information about the file, including:
%             Acquisition date
%             Number of frames
%             Sampling time (in ms)
%             Sampling frequency (in Hz)
%             names of the RSD files

%% reading of RSH file

FID=fopen(fullfile(path,fileName),'r');

dataLine = fgetl(FID);

j = 1;

dataInfo = struct('acquisitionDate', 'string', 'N_frames', 0, 'sampleTime', 0, 'f_sampl', 0, 'backgroundImg', zeros(100));

while (ischar(dataLine))
    if strncmp(dataLine, 'acquisition_date=',17)
        dataInfo.acquisitionDate = dataLine(18:end);
        fprintf('Acquisition date: \t %s\n',dataInfo.acquisitionDate);
    end
    if strncmp(dataLine, 'page_frames=',12)
        N_frames = dataLine(13:end);
        dataInfo.N_frames = str2double(N_frames);
        fprintf('Number of frames: \t %i\n',dataInfo.N_frames);
    end
    if strncmp(dataLine, 'sample_time=',12)
        sampleTime = dataLine(15:end);
        sampleTime = str2double(regexprep(sampleTime, 'msec', ''));
        dataInfo.sampleTime = sampleTime/1000; %sample time in miliseconds
        dataInfo.f_sampl = 1/dataInfo.sampleTime;
        fprintf('Sampling time: \t \t %1.3f ms\n',dataInfo.sampleTime);
        fprintf('Sampling frequency: \t %3.1f Hz\n',dataInfo.f_sampl);
    end
    
    %Dual camera mode - not expected
    if strncmp(dataLine, 'dualcam_mode=',13)
        dualCamModeString = dataLine(14:end);
    end
    
    if size((strfind(dataLine,'.rsd')),2) ~= 0
        if j == 1
            disp('Data files:');
        end
        %disp(data_line);
        dataFiles{j} = dataLine;
        j = j + 1;
    end
        dataLine = fgetl(FID);
end

dataInfo.dataFiles = dataFiles;
    
%read the data in single camera mode    
%function [outCamera1, outCamera2] = readUltimaFile(dataFiles, dualCamModeEnabled)
tempdata = [];
try
    nFiles = size(dataFiles,2);
    out = zeros(256 * nFiles,10000+2);
    
    fileCounter = 1;
    for j=1:nFiles
        fid = fopen(fullfile(path,dataFiles{j}), 'r');
        
        if fid > 0 % if file exists
            data=fread(fid, [128,100*256], 'int16');
            disp(dataFiles{j}); % file name

            for k=0:255
                data2 = transpose(data(21:120,k*100+1:k*100+100));
                out((k+1)+(j-1)*256,:) = [reshape(data2,1,10000),data(13,1+k*100),data(15,1+k*100)];
            end
            
            fileCounter = fileCounter + 1;
        end
        
    end
    
    tempdata = out;
catch ME
    disp('Failed to read Ultima file !');
    ME.stack
end

%create the backgroundImage
dataInfo.backgroundImg = reshape(tempdata(1,1:10000),100,100);

%replace the first row of the tempdata
tempdata(1,:) = tempdata(2,:);

% in case there were some files that were not found
nFilesNotFound = nFiles - (fileCounter-1);
if nFilesNotFound > 0
    if nFilesNotFound == 1
        fprintf('Warning: %i file not found! \nThe recording is probably corrupted.\n', nFilesNotFound);
    else
        fprintf('Warning: %i files not found! \nThe recording is probably corrupted.\n', nFilesNotFound);
    end
end
%}

end

