function [ c ] = obtinePozitiaNotelor( parameters )

if(size(parameters.img,3) > 1)
    img = rgb2gray(parameters.img);
else
    img = parameters.img;
end
if(size(parameters.blackNote,3) > 1)
    imgNoteNegre = rgb2gray(parameters.blackNote);
else
    imgNoteNegre = parameters.blackNote;
end

while(size(imgNoteNegre,1) > 15)
    
    imgNoteNegre = imresize(imgNoteNegre,0.9);
    %imshow(imgCheie);
    
    x_cheie = size(imgNoteNegre,1);
    y_cheie = size(imgNoteNegre,2);
    
    c = normxcorr2(imgNoteNegre,img);
    
    [row,col] = find(c > 0.6);
    disp(row);
    disp(col);
    
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
    
    figure()
    imshow(img);
    
    hold on;
    
    
    for i = 1:size(row,1)
        x = [ row(i) - x_cheie, row(i), row(i) , row(i) - x_cheie, row(i) - x_cheie];
        y = [ col(i) - y_cheie, col(i) - y_cheie, col(i) , col(i) , col(i) - y_cheie];
        plot( y, x, 'g-','linewidth',1);
    end
    pause();
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



