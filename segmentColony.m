function L = segmentColony(im);

% 1. smooth image
h = fspecial('gaussian', [7,7], 1.5);
im = imfilter(im, h);
subplot(2,2,1); imagesc(im); axis image; title('smoothed image');

% 2. Find edges and high gradient regions
[~, threshold] = edge(im, 'sobel');
fudgeFactor = .5;
BWs = edge(im,'sobel', threshold * fudgeFactor);
subplot(2,2,2); imshow(BWs), title('binary gradient mask');

% 3. Close gaps in contours
se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);
BWsdil = imdilate(BWs, [se90 se0]);
subplot(2,2,3); imshow(BWsdil), title('dilated gradient mask');

% 4. Watershed the contours to separate regions
L = watershed(BWsdil, 4);
subplot(2,2,4); imagesc(L==1); axis image;  title('watershed region 1');