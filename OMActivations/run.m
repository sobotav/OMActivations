clc;
clear variables;
close all;

%add path to the OMAFunctions
addpath('functions')

% sample data
path = '';
name = 'file.rsh';

%% Data load

fprintf('Loading data:\n');

[dataTemp, dataInfo]    = readOMAData(path, name);  % load data
dataOMA                 = dataTemp(:,1:1e4);       	% select just the image data
Nframes                 = size(dataOMA,1);          % total number of pixels
dataOMA                 = -dataOMA;                	% inversion of the signal     

fprintf('\nDone!\n');

% save data
%save('data_OMA.mat', 'dataOMA');

%% Data smoothening

% Parameters
smoothSpan = 15;   

fprintf('\nSmoothening of signals...'); 

dataOMASmooth = smoothData(dataOMA, smoothSpan);

fprintf('\nDone!\n');

%% Detect upstrokes in the file without baseline removal

% Parameteres
upstrokeDuration   = 20;                   % upstroke duration (for the template)
fs                  = dataInfo.f_sampl;     % sampling frequency
upperLimit         = 1;                    % upper value of the template
lowerLimit         = -1;                   % lower value of the template

fprintf('\nDetecting upstrokes...');

%create the template
template = createTemplate(upstrokeDuration,fs,upperLimit,lowerLimit);

% detect upstrokes in the optical  mapping data
% the variable upstroke data contains the pixel index and the beginning and the end index of the upstroke
dataUpstroke = detectUpstrokes(dataOMA, dataOMASmooth, template);    

fprintf('\nDone!\n');

%% Spatiotemporal filtering

% Parameters
k   = 1;        % spatial half-diameter - 1
t  	= 7;    	% time half-diamteter - 1
th  = 0.5;   	% threshold  

fprintf('\nSpatiotemporal filtering...'); 

% kreate kernel
kernel = create3DKernel(k,t);   

% perform spatiotemporal filtering
dataUpstrokeStFilt = stFilter(dataUpstroke, Nframes, th, kernel);  	

fprintf('\nDone!\n');

% save data
%save('upstrokeData.mat', 'dataUpstroke', 'dataUpstrokeStFilt');

%% Visualization - 3D scatter plot

% Parameters
timeCutoff  = 750;
markerSize  = 10;
cMapName    = 'hot';
N_row       = 100;
ax          = [0,N_row,0,timeCutoff,0,N_row];

fprintf('\nInitializing visualization - 3D scatter plot...\n'); 

dataUpstrokeSample          = dataUpstroke(dataUpstroke(:,5)<timeCutoff,:);                % crop the upstroke data
dataUpstrokeStFiltSample    = dataUpstrokeStFilt(dataUpstrokeStFilt(:,5)<timeCutoff,:);    % crop the filtered upstroke data

figure
subplot(1,2,1)
OMAscatter3D(dataUpstrokeSample(:,1), dataUpstrokeSample(:,5), dataUpstrokeSample(:,6), cMapName, markerSize);
axis(ax); axis square;
xlabel('Pixel column'), ylabel('Time (ms)'), zlabel('Pixel row')
title('Primary detections')

subplot(1,2,2)
OMAscatter3D(dataUpstrokeStFiltSample(:,1), dataUpstrokeStFiltSample(:,5), dataUpstrokeStFiltSample(:,6), cMapName, markerSize);
axis(ax); axis square;
xlabel('Pixel column'), ylabel('Time (ms)'), zlabel('Pixel row')
title('Detections after spatiotemporal filtering')
