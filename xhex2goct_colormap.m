function [ color_map] = xhex2goct_colormap( image_gray, varargin )

% ********************************************************************************
% Function:
%          rescale the lowest and highest gray level onto the whole colormap  
% Input:
%          image_gray: uint16 image
% Optional input:
%          Channel: the RGB channel,  1| 2(default) | 3
% Output:
%          color_map: a colormap for image_gray
% ********************************************************************************

channel = 2;
arg_cnt = size(varargin, 2);
for i = 1:arg_cnt
    if strcmpi('Channel', varargin{i})
        i = i + 1;
        channel = varargin{i};
    end
end

im_in_min = min(min(image_gray));
im_in_max = max(max(image_gray));

k = double(im_in_max - im_in_min);

full_range = 0:65535;
xhex2goct_map = max(min((double(full_range) - double(im_in_min)) / k, 1), 0);
color_map = zeros(im_in_max - im_in_min + 1, 3);
color_map(:,channel) = xhex2goct_map((im_in_min:im_in_max)+1);
color_map = max(min(color_map, 1), 0);

end

