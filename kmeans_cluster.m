 function [img_lgc] = kmeans_cluster(img_gray, img_bg, bg_level, w_p)
 
 %*************************************************************************
 % Function:
 %        use k-means to cluster the pixels into two groups, foreground and
 %        background groups
 % Input:
 %        img_gray: an image of one nucleus 
 %        img_bg: a binary image of one nucleus
 %        bg_level: the intensity of pure intensity background
 %        w_p: [0,1]; the weight of binary image
 % Output:
 %        img_lgc: binary image of one nucleus with modified contour
 %
 %*************************************************************************
 
    [ny,nx] = size(img_gray);
    img_gray(img_gray == 0) = bg_level;

    d(:,1) = reshape( img_gray(:), ny*nx, 1);
    d(:,2) = reshape(img_bg(:), ny*nx, 1);
    d(:,1) = d(:,1) / max(d(:,1));
    d(:,2) = d(:,2) * w_p;
    k = 2; % number of clusters
    [img_lgc, ~] = kmeans( d, k ); 
    img_lgc = reshape( img_lgc, ny, nx );     

    label = img_lgc(1,1);
    if label == 2
        imgFillHoles = ~imfill(~(logical(img_lgc - 1)), 'holes');
    else
        imgFillHoles = imfill(logical(img_lgc - 1), 'holes');
    end
    img_lgc = double(imgFillHoles + 1);
    clear d;

    d(:,1) = reshape( img_gray(:), ny*nx, 1);
    d(:,2) = reshape( img_lgc(:), ny*nx, 1);
    d(:,1) = d(:,1)/max(d(:,1));
    d(:,2) = d(:,2) * w_p;
    [img_lgc, ~] = kmeans( d, k );
    img_lgc = reshape( img_lgc, ny, nx ); 
    img_lgc = logical(img_lgc - 1);

    if img_lgc(1,1) == 1
        img_lgc = ~img_lgc;
    end   
    
    img_lgc = bwareaopen(img_lgc, 10, 4);
    [c,d] = find(img_lgc == 1);
    if length(c) < 50
        img_lgc = [];
        return;
    end
    [x,~] = boundary(c,d,0.5);
    
    cs=cscvn([c(x)';d(x)']);
    kk=fnplt(cs);        
    row=round(kk(1,:));
    col=round(kk(2,:));
    img_lgc =roipoly(img_lgc,col,row);
end


