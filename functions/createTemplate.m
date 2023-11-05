function [ template ] = createTemplate(upstrokeDuration,fs,upperLimit, lowerLimit)
%createTemplate creates a template for template matching (cross-correlation)

%template parameters
upstrokeDuration = upstrokeDuration/1000*fs;    	% upstroke duration in number of samples samples
constantPartDuration = ceil(upstrokeDuration/5);  	% duration of the constant part in ms

% template construction
template = [lowerLimit*ones(1,constantPartDuration), linspace(lowerLimit,upperLimit,upstrokeDuration) ...
    upperLimit*ones(1,constantPartDuration)];

end

