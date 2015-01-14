
% script to visualize the MI across rotations
rowtoDraw = 1;

fac = 1;

%PSF = fspecial('gaussian',1,1);
tmp = cell2mat (overallRtvs(rowtoDraw));
tmp = (tmp-min(tmp(:)))/(max(tmp(:))-min(tmp(:)));
[x1,y1,numRot] = size (tmp),

tmp2 = [];
for rt=1:numRot
%	tmp(:,:,rt) = imfilter (tmp(:,:,rt), PSF, 'symmetric', 'conv'); 
        %tmp(:,:,rt) = resample(tmp(:,:,rt), 2000, x1);
	tmp2(:,:,rt) = resizem(squeeze(tmp(:,:,rt)), [x1*fac,y1*fac]);
end

x1 = linspace(1,x1, x1*fac);
y1 = linspace(1,y1, y1*fac);
[x1,y1] = meshgrid(x1,y1);

f = figure('DoubleBuffer', 'on');
while ishandle(f)                                       
for rt=1:numRot          
if ~ishandle(f), break,end
h = mesh(x1',y1',tmp2(:,:,rt));view([75.5, 70]);
zlim([0 0.8]);colormap('jet');colorbar;
str = sprintf ('rotate %2.2f degrees', (rt-1)*90/numRot);
title (str);
drawnow; pause(1);         
end                    
end



figure,
x1 = 1:200;
y1 = 1:5;
[x1,y1] = meshgrid(x1,y1);
mesh(x1',y1',squeeze(tmp2(24,:,:)));view([75.5, 70]);


