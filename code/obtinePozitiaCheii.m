function [row, col] = obtinePozitiaCheii( parameters )

coordonateCheie = zeros(0,4);

if(size(parameters.img,3) > 1)
    img = rgb2gray(parameters.img);
else
    img = parameters.img;
end
imgCheie = rgb2gray(parameters.clef);

size(imgCheie);
eps = 0.1;
row = zeros(0,1);
col = zeros(0,1);
while(size(imgCheie,1) > 30)
    
    imgCheie = imresize(imgCheie,0.9);
    %imshow(imgCheie);
    
    x_cheie = size(imgCheie,1);
    y_cheie = size(imgCheie,2);
    
    c = normxcorr2(imgCheie,img);
    
    [row_aux,col_aux] = find(c > 0.5);
    
    
    row = [row; row_aux-x_cheie, row_aux];
    col = [col; col_aux-y_cheie, col_aux];
    
    max_val = max(c(:));
    
    
    disp(max_val);
    
    %[ypeak, xpeak] = find(c==max(c(:)));
    %     disp('row');
    %     disp(row);
    %     disp('col');
    %     disp(col);
    %     disp('peak');
    %     disp(ypeak);
    %     disp(xpeak);
    
%     yoffSet = ypeak-size(imgCheie,1);
%     xoffSet = xpeak-size(imgCheie,2);
%     
%     disp('yoffset');
%     disp(yoffSet);
%     disp('xoffset');
%     disp(xoffSet);
    
    %figure()
    
    %imshow(img);
    %imtool(img);
    hold on;
    
    
    for i = 1:size(row_aux,1)
        x = [ row_aux(i) - x_cheie, row_aux(i), row_aux(i) , row_aux(i) - x_cheie, row_aux(i) - x_cheie];
        y = [ col_aux(i) - y_cheie, col_aux(i) - y_cheie, col_aux(i) , col_aux(i) , col_aux(i) - y_cheie];
        plot( y, x, 'g-','linewidth',1);
    end
    %pause();
    hold off;
    
    
%     hFig = figure;
%     hAx  = axes;
%     imshow(img,'Parent', hAx);
%     imrect(hAx, [xoffSet+1, yoffSet+1, size(imgCheie,2), size(imgCheie,1)]);
  
    close all;
    
end
%
% c = normxcorr2(imgCheie,img);
% %figure, surf(c), shading flat;
%
% [row,col] = find(c > 0.3);
% disp(size(row));
% % for i = 1:size(row,1)
% %    disp(row(i)); disp(col(i));
% % end
% cl = clock;
% disp(datestr(datenum(cl(4),cl(5),cl(6))));
%
% size(img)
%
% figure(4)
% imshow(img);
% hold on;
% for i = 1:size(row,1)
%     x = [ row(i), row(i) + 20, row(i) + 20, row(i), row(i)];
%     y = [ col(i), col(i), col(i) + 20, col(i) + 20, col(i) ];
%     plot( x, y, 'g-','linewidth',1);
% end
%
% hold off;




end

