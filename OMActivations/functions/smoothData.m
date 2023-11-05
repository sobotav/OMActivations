function [ dataSmooth ] = smoothData(data, smoothSpan)
%smoothData Smoothing of the optical mapping data

dataSmooth	= zeros(size(data));   % array for saving smooth data
N_pix_total	= size(data,2);        % total number of pixels

for pixel_i = 1:N_pix_total
    signal = smooth(data(:,pixel_i), smoothSpan, 'lowess'); 	% smoothing of the signal
    dataSmooth(:,pixel_i) = signal;                             % save the smooth signal                             
end

end

