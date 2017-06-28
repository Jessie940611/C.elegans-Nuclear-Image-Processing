%******************************************************************
%
% An example to show how to use this nuclear segmentation program
%
%******************************************************************

green_addr = 'input_image\green_channel\';
red_addr = 'input_image\red_channel\';
output_addr = 'output_image\';
addpath(genpath('..'));

out_addr = 'output_image\';
if ~exist(out_addr, 'dir')
  mkdir(out_addr);
end

Files = dir([green_addr,'*.tif']);
for i = 1:length(Files)
    file_name = Files(i).name;
    image_g = imread([green_addr, file_name]);
    image_r  = imread([red_addr, file_name]);
    disp(['Processing ', file_name, '........']);
    image_seg = segment_nuclei(image_g, image_r);
    imwrite(image_seg, [output_addr, file_name]);
    axg = subplot(1,3,1); imagesc(image_g); axis image; m = xhex2goct_colormap(image_g,'channel', 2); colormap(axg, m); colorbar; title('green channel image');
    axr = subplot(1,3,2); imagesc(image_r); axis image; m = xhex2goct_colormap(image_r,'channel', 1); colormap(axr, m); colorbar; title('red channel image');
    subplot(1,3,3); imagesc(image_seg); axis image; title('segmentation result');
    saveas(gcf,[output_addr, file_name,'.fig']);
end




