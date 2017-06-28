function [ image_bw] = init_binarize( image, w_b)

% ***************************************************************************
% Function: 
%          Binarize the image ("Thresholding segmentation")
% Input: 
%          image: the target image that we use to segment nucleus;
%          w_b: [0,2]; the weight of threshold in binarization. Set it higher 
%                   if the image has high contrast, otherwise lower.
% Output: 
%          image_bw: logical; initial binarized image
% ***************************************************************************

    graythr = 8000; 
    areaThr = 400; % the minimum size (area) of nuclei
    imageThr = image;
    imageThr(image > graythr) = graythr;
    thresh = graythresh(imageThr);
    image_bw = im2bw(image, thresh * w_b);    
    image_bw = imfill(image_bw, 'holes');
    imgNewBw = ~image_bw;
    L = bwlabeln(imgNewBw);
    S = regionprops(L, 'Area');
    imgNewBw = ismember(L, find([S.Area] <= 5000));
    image_bw = image_bw | imgNewBw;
    image_bw = bwareaopen(image_bw, areaThr);
    image_bw = medfilt2(image_bw);
    se=strel('disk',5);
    image_bw=imopen(image_bw,se);
end


