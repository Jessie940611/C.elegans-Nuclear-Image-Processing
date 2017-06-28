% green_addr = 'input_image\green_channel\';
% red_addr = 'input_image\red_channel\';
% output_addr = 'output_image\';
% addpath('..') ;

% out_addr = 'output_image\';
% if ~exist(out_addr, 'dir')
%   mkdir(out_addr);
% end

% file_name ='MQD1658_Day1_14_1.tif';
% image_g = imread([green_addr, file_name]);
% image_r = imread([red_addr, file_name]);
% disp(['Processing ', file_name, '........']);
% image_seg = segment_nuclei(image_g, image_r, 1.2, 1, 0.2);
% imwrite(image_seg, [output_addr, file_name]);
%1
%399,411,412
%4
%519,602,610
%6
%647,673
%10
%17,33,5,14,21,39
%12
%76,78
%16
%297,324




close all; clear; clc;
green_addr = 'H:\C.elegans Images\Clust_16B3C2D\488\';
red_addr = 'H:\C.elegans Images\Clust_16B3C2D\561\'; 
Files = dir([green_addr,'*.tif']);
for i = [210]
    filename = Files(i).name;
    image_g = imread([green_addr, filename]);
    image_r  = imread([red_addr, filename]);
    image_seg = segment_nuclei(image_g, image_r, 0.8, 0.928, 0.4);
    figure;
    axg = subplot(1,3,1); imagesc(image_g); axis image; m = xhex2goct_colormap(image_g,'channel', 2); colormap(axg, m); colorbar; title(num2str(i))
    axr = subplot(1,3,2); imagesc(image_r); axis image; m = xhex2goct_colormap(image_r,'channel', 1); colormap(axr, m); colorbar;
    subplot(1,3,3); imagesc(image_seg); axis image;
end


