function [row, col, height, width] = obtinePozitiaCheii( parameters )

% transform images into 2 dimensional arrays
if(size(parameters.img,3) > 1)
    img = rgb2gray(parameters.img);
else
    img = parameters.img;
end
imgCheie = rgb2gray(parameters.clef);


% initialize variables
eps = 0.5;
row = zeros(0,1);
col = zeros(0,1);
height = zeros(0,1);
width = zeros(0,1);
% figure,imshow(img);
%resize the clef for further template matching (t.m.)
while(size(imgCheie,1) > 30)
    
    imgCheie = imresize(imgCheie,0.9);
    
    [x_cheie,y_cheie] = size(imgCheie);
    
    % use t.m. and find the detections that are over the
    % threshold
    c = normxcorr2(imgCheie,img);
    [d1,d2] = size(imgCheie);
    [row_aux,col_aux] = find(c > eps);
    
    % concatenate current detections with detections from other iterations
    row = [row; row_aux - x_cheie, row_aux];
    col = [col; col_aux - y_cheie, col_aux];
    
    % insert the size of the used template for each found row/column
    for k = 0:size(row,1)
        height = [height; d1];
        width = [width; d2];
    end
    
    
    % find the maximum value in the result array of t.m.
    max_val = max(c(:));
    
    % plot all detections
    
    
%     hold all;
%     for i = 1:size(row_aux,1)
%         x = [ row_aux(i) - x_cheie, row_aux(i), row_aux(i) , row_aux(i) - x_cheie, row_aux(i) - x_cheie];
%         y = [ col_aux(i) - y_cheie, col_aux(i) - y_cheie, col_aux(i) , col_aux(i) , col_aux(i) - y_cheie];
%         plot( y, x, 'g-','linewidth',1);
%     end
%     hold off;
%     close all;
    
end





end

