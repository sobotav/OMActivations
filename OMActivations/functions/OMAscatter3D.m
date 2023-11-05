function [] = OMAscatter3D(pixelIndices, positions, values, cMapName, markerSize)
%OMAscatter3D Visualization of wavefronts using 3D scatter

[X,Y] = ind2sub([100,100],pixelIndices);                            % get X and Y coordinates

% colors
percCut                 = 0.9;                                      % use only the bottom 90% of the colormap
cMap                    = colormap(eval(cMapName));                 % set colormap
N_colorLevelsDefault    = size(cMap,1);                             % number of color levels
N_colorLevels           = round(N_colorLevelsDefault*percCut);      % the actual number of color levels
cMap                    = cMap(1:N_colorLevels,:);                  % crop the colormap
colorIndices            = ceil(values/max(values)*N_colorLevels);   % map the color using the values
colors                  = repmat([0,0,0],numel(values),1);
colors(:,1)             = cMap(colorIndices,1);                     % R
colors(:,2)             = cMap(colorIndices,2);                     % G
colors(:,3)             = cMap(colorIndices,3);                     % B

% sizes
sizes = markerSize*ones(size(X));

% Visualization
scatter3(X,positions,Y,sizes,colors,'filled')

end

