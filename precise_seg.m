function [boundx, boundy ] = precise_seg (image_gray, image_bw, w_p)

% ***************************************************************************
% Function: 
%          use k-means to cluster the foreground and bachground pixels
% Input: 
%          image_gray: the fused image
%          image_bw: the segmented binary image
%          w_p: [0,1], the weight of binary image
% Output: 
%          boundx: 1xN double, the x position of pixels on nuclear boundary 
%          boundy: 1xN double, the y position of pixels on nuclear boundary 
%
% ***************************************************************************

    thr = 5000;
    [bound_bg, img_conn_bg] = bwboundaries(image_bw, 4);
    [seg_img_gray, pnt_pixel_gray] = seg_image( image_gray, bound_bg, img_conn_bg, 3);
    [seg_img_bg, ~] = seg_image( image_bw, bound_bg, img_conn_bg, 3);
    boundx = [];
    boundy = [];
    bg_level = mean(image_gray(image_bw == 0)) * 2.5;
    
    % for each connected region, perform the k-means cluster
    for i = 1 : length(bound_bg)
        img_gray = seg_img_gray(i);
        img_gray = double(img_gray{:});
        img_gray = medfilt2(img_gray, [3,3]);
        img_bg = seg_img_bg(i);
        img_bg = double(img_bg{:});
        img_bg = medfilt2(img_bg, [3,3]);
        
        img_gray2 = img_gray;
        img_gray2(img_gray > thr) = thr;
        l = kmeans_cluster( img_gray2, img_bg, bg_level, w_p);     
        if isempty(l)
            continue;
        end

        [cell_bound,logic] = bwboundaries(l);
        if length(find(logic==1)) < 400
            continue;
        end
        cell_bound = cell_bound(1);
        cell_bound = cell_bound{:};

        pnt = pnt_pixel_gray(i);
        pnt = pnt{:};
        xmin = min(pnt(:,1));
        ymin = min(pnt(:,2));
        
        a0 = (cell_bound(:,1) + xmin - 4)';
        b0 = (cell_bound(:,2) + ymin - 4)';   
        
        boundx = [boundx,a0];
        boundy = [boundy,b0];        
        clear img_gray;
    end;
end

