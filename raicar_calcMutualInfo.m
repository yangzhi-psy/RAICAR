function [spatialCc, numIC1, numIC2] = raicar_calcMutualInfo (icasig, icasig2)
numIC1 = size (icasig,1);
numIC2 = size (icasig2,1);

%comboCc = corrcoef ([icasig', icasig2']);     % a combo cc matrix, upper right corner is the cross-correlation of two mixs
%spatialCc = comboCc (1:numIC1, numIC1+1:numIC1+numIC2);
    
%for i = 1:numIC1
%	for j = 1:numIC2
%		spatialCc (i, j) = muting ([icasig(i,:)', icasig2(j,:)']);
%	end
%end

tic,
spatialCc = MI_rot ([icasig',icasig2'], numIC1, 5);
toc,
