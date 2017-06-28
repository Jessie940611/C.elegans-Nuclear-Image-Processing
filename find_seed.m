function [image_seed ] = find_seed(image_bw, r)

% ***************************************************************************
% Function: 
%          Seed detection based on distance matrix and seed combinition
% Input: 
%          image_bw: logical; initial binary image
%          r: [0,1]; the ratio of the lowest to highest foreground intensity.  
%             Set it higher if your image is over segmented, otherwise lower.
% Output: 
%          image_seed: logical;  seed points are true in the matrix and others are false;
% ***************************************************************************

    % compute the distance matrix
    edg = 3;  % edge length
    ahsize1 = 3;
    ahsize2 = 5;
    ghsize1 = 5;
    ghsigma = 5;
    [height, width] = size(image_bw);
    imgDistPf = logical(false(height+2*edg,width+2*edg));
    xn = edg+1:height+edg;
    yn = edg+1:width+edg;
    imgDistPf(xn,yn) = image_bw;
    imgdist = bwdist(~imgDistPf);
    imgdist = double(imgdist(xn,yn));

    ah = fspecial('average', ahsize1); 
    imgdist = conv2(imgdist, ah, 'same');
    ah = fspecial('average', ahsize2); 
    imgdist = conv2(imgdist, ah, 'same');
    gh = fspecial('gaussian', ghsize1, ghsigma);
    imgdist = conv2(imgdist, gh, 'same');

    % find the seeds
    [height, width] = size(imgdist);
    image_seed = imregionalmax(imgdist, 8);
    [a, b] = find(image_seed == 1);
    image_seed = logical(false(height, width));
    seedLoc = (b-1)*width + a;
    image_seed(seedLoc) = 1;
    [a, b] = find(image_seed == 1);

    % conbine some seeds
    c = [a,b];
    if length(c) > height
       image_seed(image_seed == 1) = 0;
       [a, b] = find(image_seed == 1);
       c = [a,b];
    end
    
    seedFlag = ones(size(a));
    if length(c(:)) > 2
        pd=pdist(c,'euclidean');
        lkg=linkage(pd,'single');
        shrn = find(lkg(:,3) <= 60);
        for i = 1:length(shrn)
            if lkg(shrn(i),1) > length(a) || lkg(shrn(i),2) > length(a) 
                continue;
            end
            seed1 = floor([a(lkg(shrn(i),1)), b(lkg(shrn(i),1))]);
            seed2 = floor([a(lkg(shrn(i),2)), b(lkg(shrn(i),2))]);
            ox = floor([a(lkg(shrn(i),1)), a(lkg(shrn(i),2))]);
            oy = floor([b(lkg(shrn(i),1)), b(lkg(shrn(i),2))]);
            minSeedH = min(imgdist(seed1(1),seed1(2)), imgdist(seed2(1),seed2(2)));
            p = polyfit(ox,oy,1);
            lineX = min(seed1(1),seed2(1)) : max(seed1(1),seed2(1));
            lineY = polyval(p, lineX);
            lineX = round(lineX);
            lineY = round(lineY);
            if isnan(lineY)
                continue;
            end
            minLineH = min(min(imgdist((lineY-1)*width+lineX)));
            newx = floor(mean(ox));
            newy = floor(mean(oy));
            a(length(a)+1) = newx;
            b(length(b)+1) = newy;
            seedFlag(length(b)) = 0;

            if minLineH >= minSeedH * r && seedFlag(lkg(shrn(i),1)) == 1 && seedFlag(lkg(shrn(i),2)) == 1
                image_seed(ox,oy) = 0;
                image_seed(newx,newy) = 1;
                seedFlag(length(b)) = 1;
            end
        end
    end
end

