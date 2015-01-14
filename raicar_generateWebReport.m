function raicar_generateWebReport (subj, threshold)
%
% function raicar_generateWebReport (subj, threshold)
%
% Author: Zhi Yang
% Version: 2.0
% Last change: July 1, 2007
% 
% Purpose: 
%   generage webreport of the RAICAR results. by default, the report will be
%   saved in a directory named as 'webreport'. if this directory has
%   already existed, then the directory will be named as 'webreport1'. Again, if
%   the directory exists, the number after 'webreport' will keep
%   increasing
% Input:
%   subj: subject object. The following input field will affect this
%   function:
%       subj.result.aveMap : mosaic format of the averaged map (3D matrix)
%       subj.result.aveTc  : averaged time course (2D matrix)
%       subj.result.reproRank : reproducibility rank (1D matrix)
%       subj.result.anat   : mosaice format of the anatomy image
% Output:
%   None
%

fprintf ('\n Generating web page report...\n');
% set default 
if nargin == 1
    threshold = 2.0;
end

% check wether the output directory exists
dirNm = strcat (subj.setup.outPrefix, '_webreport');
count = 1;
while exist (dirNm, 'dir')
    dirNm = strcat (dirNm, num2str (count));
    count = count + 1;
end
mkdir (dirNm);
    
% generate the index page: 00index.html
totalComp = size (subj.result.aveMap, 3);
indexNm = strcat (dirNm, '/00index');
raicar_generateIndex (totalComp, indexNm);

% generate plots for each component
sz = size (subj.result.aveMap);
tc_length = size (subj.result.aveTc, 1);

h = figure ('Visible','off','Position',[0,0,50,60]);

for comp = 1:totalComp
    fprintf ('\tgenerating figures %d of %d\r', comp, totalComp);
	clf;
    
    % plot component map
    set (gcf, 'PaperPosition', [0, 0, 7.5, 7.5/sz(2)*sz(1)]); 
    set (gca, 'Position', [0, 0, 1, 1]); 
	raicar_render (subj.result.aveMap(:,:, ...
        	comp), subj.result.anat, threshold)
	fn = sprintf ('%s/map_IC%d.png', dirNm, comp);
	print ('-dpng', fn);

    % plot unthresholded component map
	clf;
	raicar_render (subj.result.aveMap(:,:, ...
        	comp), subj.result.anat, 0.0);
	fn = sprintf ('%s/map_IC_nothresh%d.png', dirNm, comp);
	print ('-dpng', fn);

    % plot time course and spectrum
	clf;
    set (gcf, 'PaperPosition', [0, 0, 4.5, 3]);
	subplot (2,1,1);
    set (gca, 'Position', [0.05, 0.6, 0.9, 0.38]);
	plot (subj.result.aveTc(:, comp), 'LineWidth', 1);
	if ~isempty (subj.result.paradigm)
			subj.result.paradigm = zscore (subj.result.paradigm);
            hold on, plot (subj.result.paradigm+1, 'r', 'LineWidth', 1);
        end
    xlim ([-0.5, tc_length+0.5]);
	subplot (2,1,2);
    set (gca, 'Position', [0.05, 0.1, 0.9, 0.38]);
	[mx, f] = getPowerSpectra (subj.result.aveTc(:, comp), subj.result.TR);
	plot (f, mx, 'LineWidth', 1);
    xlim ([-0.01, 1.01]);
	fn = sprintf ('%s/tc_IC%d.png', dirNm, comp);
	print ('-dpng', fn);

    % plot reproducibility rank
	clf;
    set (gcf, 'PaperPosition', [0, 0, 3, 3]); 
    set (gca, 'Position', [0.2, 0.1, 0.7, 0.85]);
	bar (subj.result.reproRank, 1, 'k');
	hold on, area ([comp-0.5, comp+0.8], [subj.result.reproRank(comp) subj.result.reproRank(comp)], 'FaceColor', 'r');
	xlim ([-0.5, tc_length+2]);
    %bar (comp, subj.result.reproRank(comp), 'r');
	fn = sprintf ('%s/rank_IC%d.png', dirNm, comp);
	print ('-dpng', fn);

    % generate a page for each component
	raicar_webReportTemplate (comp, totalComp, dirNm);
end
fprintf ('\tsuccess\n');

% % generate thumbs
% cd (dirNm);
% raicar_makeThumbdir (64, 2, '*.png');
% cd ..;

close (h);
	
