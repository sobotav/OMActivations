function [kernel] = create3DKernel(k,t)
%create3DKernel Creates 3D kernel for spatiotemporal filtering
%Parameters:
% k - spatial half-diameter of the convolution kernel (diameter = 2*k+1)
% t - temporal half-lengthr of the convolution kernel (length = 2*t+1)

%spatial weights
squareSize      = 2*k+1;                                       	% size of the square
x               = -k:1:k;                                     	% spatial vector
mu              = [0 0];                                       	% mu of the distribution
Sigma           = [k/2 0; 0 k/2];                              	% sigma of the distribution
[X1,X2]         = meshgrid(x,x);                              	% square coordinates
spatialWeights  = mvnpdf([X1(:) X2(:)],mu,Sigma);               % spatial weights
spatialWeights  = reshape(spatialWeights,length(x),length(x));  % reshaped spatial weights

% time weights
timeVec         = 1:1:2*t+1;                	% time vector
timeWeights     = normpdf(timeVec,t+1,t/4);   	% time weights

% 3D convolution kernel
kernel	= repmat(timeWeights,squareSize*squareSize,1);      % repeat the time vector for each pixel
kernel	= bsxfun(@times, kernel, reshape(spatialWeights,squareSize*squareSize,1)); % multiple each pixel with the spatial weight
kernel 	= kernel';
kernel 	= reshape(kernel, 2*t+1, squareSize, squareSize);	% reshape to 3D kernel
kernel(:,k+1,k+1) = 0;                                      % the middle of the kernel is empty (the pixels that correspond with the activation itself)
kernel	= kernel/sum(kernel(:));                        	% normalization (total sum of the kernel3D==1)

end

