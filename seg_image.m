function [ segimg, pntpx ] = seg_image( image, boundaries, logical, edge )

%**************************************************************************
% Function:
%        crop the image into some small images, each image contains only one nucleus
% Input:
%        image: an image that contains N connected region (nuclei)
%        boundaries: N x 1 cell array, each cell contains the x and y axis of boundary pixels 
%        logical: logical image (output of function "bwboundaries")
%        edge: the width of egde
% Output:
%        segimg: 1 x N  cell array, each cell contains an image of an object (nucleus)
%        pntpixel: 1 x N  cell array, each cell contains the x and y axis of four corner 
%                       pixels(the order is upper left, uppr right, lower left, lower right) in  
%                       original image 
%
%**************************************************************************

N = length(boundaries);
if N == 0
    segimg = NaN;
    pntpx = NaN;
    return;
end

pntpx = cell(1,N);
segimg = cell(1,N);
for i = 1:N
    bound = boundaries(i);
    bound = bound{:};
    maxx = max(bound(:,1));
    minx = min(bound(:,1));
    maxy = max(bound(:,2));
    miny = min(bound(:,2));
    
    d(1,1) = minx; d(1,2) = miny;    
    d(2,1) = maxx; d(2,2) = miny;
    d(3,1) = minx; d(3,2) = maxy;
    d(4,1) = maxx; d(4,2) = maxy;
    pntpx(i) = {d};
    
    imgCopy = zeros(size(image));
    imgCopy(logical == i) = image(logical == i);
    imgTemp = imgCopy(minx:maxx, miny:maxy);
    img = zeros(maxx - minx + 2 * edge + 1, maxy - miny +2 * edge + 1);
    img(edge + 1 : maxx - minx + edge + 1, edge + 1: maxy - miny + edge + 1) = imgTemp;
    segimg(i) = {img};
end


