function [image_f16, image_f8] = fuse_2channel(image_g, image_r, w_b)

% ***************************************************************************
% Function:  
%          fuse two channel images ("Two-channel image fusion")
% Input: 
%          image_g: the green channel image
%          image_r: the red channel image
%          w_b: [0,2]; the weight of threshold in binarization. Set it higher 
%                   if the image has high contrast, otherwise lower.
% Output: 
%          image_f16: the 16 bit fused image
%          image_f8: the 8 bit fused image (used to show to users)
% ***************************************************************************

    % binarize the green channel image
    imgG = medfilt2(image_g, [3,3]);
    imgR = medfilt2(image_r, [3,3]);
    thr = 3000;    
    imageThr = imgG;
    imageThr(imgG > thr) =thr;
    thresh = graythresh(imageThr);
    imgBw = im2bw(imgG, thresh * w_b);
       
    imgBw = imfill(imgBw, 'holes');
    imgNewBw = ~imgBw;
    L = bwlabeln(imgNewBw);
    S = regionprops(L, 'Area');
    imgNewBw = ismember(L, find([S.Area] <= 5000));
    imgBw = imgBw | imgNewBw;
    imgBw = imfill(imgBw, 'holes');
    areaThr = 400;
    imgBw = bwareaopen(imgBw, areaThr);
    
    
    % if global threshold doesn't work, use local threshold
    if length(find(imgBw == 1)) > length(imgBw(:)) * 0.3
        imgBw = localthresh(imgG,ones(701),3,1.5,'local');
        imgBw = imfill(imgBw, 'holes');
        imgBw = bwareaopen(imgBw, areaThr);
    end
    
    % fuse the green channel image and red channel image
    maxG = max(imgG(:));
    maxR = max(imgR(:));
    paraG = 16000 * 0.6 / double(maxG);
    paraR = 16000 * 0.4 / double(maxR);
    imageRtemp = image_r;
    imageRtemp(imgBw == 0) = mean(image_r(:)) * 0.9;
    image_f16 = image_g * paraG + imageRtemp * paraR;
    
    % construct the 8 bit fused image
    image_f8 = uint8(zeros(1000,1000,3));
    image_f8(:,:,1) = ceil(double(imageRtemp) * paraR  * double(255) / double(8000));
    image_f8(:,:,2) = ceil(double(image_g) * paraG * double(255) / double(8000));
end

