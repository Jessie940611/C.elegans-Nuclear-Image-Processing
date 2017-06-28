function [ image_bw_seg ] = watershed_seg(image_bw, image_seed )

% ***************************************************************************
% Function: 
%          use seed based watershed to segment binary image
% Input: 
%          image_bw: initial binary image
%          image_seed: logical;  seed points are true in the
%                               matrix and others are false;
% Output: 
%          image_bw_seg: logical; the segmented binary image (cluster splitted)
%
% ***************************************************************************

    D = -bwdist(~image_bw);
    D2 = imimposemin(D, image_seed);
    Ld2 = watershed(D2);
    image_bw_seg = image_bw;
    image_bw_seg(Ld2 == 0) = 0;
    image_bw_seg = bwareaopen(image_bw_seg, 400, 4);    
    
end

