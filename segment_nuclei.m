function [ image_seg] = segment_nuclei( image_g, image_r, varargin)   

% *********************************************************************************
% Function:  
%          Segment the nuclei using green channel image and red channel image
% Input: 
%          image_g: the green channel image
%          image_r: the red channel image
%Optional input:
%          BinarizeThresh: [0,2] (default 0.8), the weight of threshold in binarization.   
%                                    Set it higher if the image has high contrast, otherwise lower.
%          LHRatio: [0,1] (default 0.928), the ratio of the lowest to highest nuclear intensity.  
%                         Set it higher if your image is over segmented, otherwise lower.
%          PreciseWeight: [0,1] (default 0.4), the weight of binary image in "precise 
%                                   segmentation" step. If the rough boundary (output of
%                                   watershed) do not need too much modification, set it higher,
%                                   otherwise lower.
% Output: 
%          image_fused: the segmented nuclei in the background of fused image
% ************************************************************************************

    w_b = 0.8;
    r = 0.928;
    w_p = 0.4;

    arg_cnt = size(varargin, 2);
    for i = 1:arg_cnt
        if strcmpi('BinarizeThresh', varargin{i})
            i = i + 1;
            w_b = varargin{i};
        elseif strcmpi('LHRatio', varargin{i})
            i = i + 1;
            r = varargin{i};
        elseif strcmpi('PreciseWeight', varargin{i})
            i = i + 1;
            w_p = varargin{i};
        end
    end    

    [image_f16, image_f8] = fuse_2channel(image_g, image_r, w_b);
    image_bw = init_binarize(image_f16, w_b);
    image_seed = find_seed(image_bw, r);    
    image_bw_seg = watershed_seg(image_bw, image_seed);
    [boundx, boundy ] = precise_seg(image_f16, image_bw_seg, w_p);
    image_seg = image_f8;
    for i = 1:length(boundx)
        image_seg(boundx(i),boundy(i),1) = 255;
        image_seg(boundx(i),boundy(i),2) = 255;
        image_seg(boundx(i),boundy(i),3) = 255;
    end
end

