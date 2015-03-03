function[percentTseries] = timeCourse(roi, epi)

%%get the data from the roi

roiSize = length(find(roi));

% How long (number of temporal frames) are the time series?
numFrames = size(epi,4);

% Pick out the time series for those voxels. We will produce a matrix of
% time series data in which each column corresponds to the time series from
% one of the active voxels. The size of the matrix is nTimePoints by
% nVoxels. 
tSeries = zeros(numFrames,roiSize);
[x y z] = ind2sub(size(roi),find(roi));
for voxel = 1:roiSize
    tSeries(:,voxel) = squeeze(epi(x(voxel),y(voxel),z(voxel),:));
end

% Notice that they all have a different baseline/mean intensity. Let's fix
% that.

percentTseries = zeros(size(tSeries));
for voxel = 1:roiSize
    baseline = mean(tSeries(:,voxel));
    percentTseries(:,voxel) = 100 * (tSeries(:,voxel)/baseline - 1);
end
% 
% meanpercentTseries = (mean(percentTseries,2));

%average percentTseries across voxels

percentTseries = squeeze(mean(percentTseries,2));

%then remove the drift/trend

percentTseries = detrend(percentTseries);