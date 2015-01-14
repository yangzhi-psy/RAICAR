function [subj] = raicar_reformData (subj, orig, mask)
%
% function [subj] = raicar_reformData (subj, orig, mask)
%
% Author: Zhi Yang
% Version: 2.0
% Last change: May 04, 2007
% 
% Purpose: 
%   reform the input data into 2-D matrix and return the mapping table
% Input:
%   subj: subject object;
%   orig: 4-D form EPI data;
%   mask: 3-D form mask data;
% Output:
%   subj: subject object. the following fields has been changed:
%       forIca    : added or overwritten to store the 2-D format EPI data;
%       coordTable: mapping table for the 4-D/2-D transform;
%       mask      : added or overwritten to store the 3-D format mask;
%

% check input 
[errMsg] = nargchk(3, 3, nargin);
if ~isempty (errMsg)
    error ('raicar_reformData takes and only takes three input argument: subject object, 4-D data, and 3-D mask');
end

dimsOrig = size (orig);
if length (dimsOrig) ~= 4
    error ('raicar_reformData requires the second input argument as a 4-D matrix, but now it is %d-D', length (dimsOrig));
end

dimsMask = size (mask);
if length (dimsMask) ~= 3
    error ('raicar_reformData requires the third input argument as a 3-D matrix, but now it is %d-D', length (dimsMask));
end

if ~isa (subj, 'struct')
    error ('raicar_reformData requires the first input argument as a structure');
end

% reform the matrix to 2-dims
    % reshape the orig and mask to 2-dims matrix
reformOrig = reshape (orig, [dimsOrig(1)*dimsOrig(2)*dimsOrig(3), dimsOrig(4)]);
reformMask = reshape (mask, [dimsOrig(1)*dimsOrig(2)*dimsOrig(3), 1]);
    % create coordinate table recoding the 3-dim coordinates of the element of reshaped matrix  
[coordX coordY coordZ] = ind2sub (size(mask), 1:dimsOrig(1)*dimsOrig(2)*dimsOrig(3));
coordTable = [coordX' coordY' coordZ'];
    % mask out the voxels out of brain
subj.forIca = reformOrig;
subj.forIca (reformMask == 0,:) = [];
coordTable (reformMask == 0,:) = [];  % go with the dataset to keep a record of  the corresponding 3-dim coordinates
    % transport the forIca matrix to n*v form
subj.forIca = subj.forIca';
subj.coordTable = coordTable';
subj.mask = mask;
