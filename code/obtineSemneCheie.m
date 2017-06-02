function [ x ] = obtineSemneCheie( parameters, row, col )
% if x < 0 then there are abs(x) flat keys(bemol)
% if x > 0 then there are abs(x) sharp keys(diez)
% if x = 0 then there are no musical signs

if(size(parameters.img,3) > 1)
    img = rgb2gray(parameters.img);
else
    img = parameters.img;
end
x = 0;

% [h,w] = size(img);
% 
% % for i = 1:size(row,1)
% %     disp('New entry');
% %     left = col(i,1);
% %     right = col(i,2) + ((col(i,2) - col(i,1))*3);
% %     up = max(1,row(i,1)-5);
% %     down = min(h,row(i,2));
% %
% %     searchZone = img(up:down,left:right);
% % %     figure,imshow(searchZone);
% %
% %     maxim = 0;
% %     i_maxim = 0;
% %     % match signature against 7 existant sharp signatures
% %     rowss = zeros(0,1);
% %     colss = zeros(0,1);
% %     for j = 1:7
% %         disp('Different number');
% %         sharpSignature = (['../data/images/signature-sharp',num2str(j),'.png']);
% %
% %         newSignature = rgb2gray(imread(sharpSignature));
% %
% %         while(size(newSignature,1) > size(searchZone,1) - 15)
% %
% %             newSignature = imresize(newSignature,0.9);
% %
% % %             figure,imshow(newSignature);
% %
% %             [x_sign,y_sign] = size(newSignature);
% %
% %             if((x_sign > down - up) || (y_sign > right - left))
% %                 continue;
% %             end
% %
% % %             figure,imshow(zonaCautare);
% %             c = normxcorr2(newSignature,searchZone);
% %
% %             [row_aux,col_aux] = find(c > 0.8);
% %
% % %             disp(size(row_aux));
% %
% %             rowss = [rowss; row_aux-x_sign, row_aux];
% %             colss = [colss; col_aux-y_sign, col_aux];
% %
% %             max_val = max(c(:));
% %             disp(max_val);
% %             if(max_val > maxim)
% %
% %                 maxim = max_val;
% %                 i_maxim = j;
% %
% %             end
% % %             figure()
% %
% %             %imshow(img);
% %             %imtool(img);
% %             hold on;
% %
% %
% % %             for l = 1:size(row_aux,1)
% % %                 x = [ row_aux(l) - x_cheie, row_aux(l), row_aux(l) , row_aux(l) - x_cheie, row_aux(l) - x_cheie];
% % %                 y = [ col_aux(l) - y_cheie, col_aux(l) - y_cheie, col_aux(l) , col_aux(l) , col_aux(l) - y_cheie];
% % %                 plot( y, x, 'g-','linewidth',1);
% % %             end
% %         end
% %         disp(maxim);
% %         disp(i_maxim);
% %     end
% % end
% 
% for i = 1:size(row,1)
%     
%     rowss = zeros(0,1);
%     colss = zeros(0,1);
% 
%     left = col(i,1);
%     right = col(i,2) + ((col(i,2) - col(i,1))*3);
%     up = max(1,row(i,1)-5);
%     down = min(h,row(i,2));
%     
%     searchZone = img(up:down,left:right);
%     
%     while(size(diez,1) > 10)
%         
%         diez = imresize(diez,0.9);
%         
%         [x_cheie,y_cheie] = size(diez);
%         
%         if ((x_cheie > down-up) || (y_cheie > right - left))
%             continue;
%         end
%         
%         figure,imshow(searchZone);
%         
%         c = normxcorr2(diez,searchZone);
%         
%         [row_aux,col_aux] = find(c > 0.5);
%         
%         disp(size(row_aux));
%         
%         rowss = [rowss; row_aux-x_cheie, row_aux];
%         colss = [colss; col_aux-y_cheie, col_aux];
%         
%         max_val = max(c(:));
%         disp(max_val);
%         
%         %
%         %[ypeak, xpeak] = find(c==max(c(:)));
%         %     disp('row');
%         %     disp(row);
%         %     disp('col');
%         %     disp(col);
%         %     disp('peak');
%         %     disp(ypeak);
%         %     disp(xpeak);
%         
%         %     yoffSet = ypeak-size(imgCheie,1);
%         %     xoffSet = xpeak-size(imgCheie,2);
%         %
%         %     disp('yoffset');
%         %     disp(yoffSet);
%         %     disp('xoffset');
%         %     disp(xoffSet);
%         
%         %figure()
%         
%         %imshow(img);
%         %imtool(img);
%         hold on;
%         
%         
%         for i = 1:size(row_aux,1)
%             x = [ row_aux(i) - x_cheie, row_aux(i), row_aux(i) , row_aux(i) - x_cheie, row_aux(i) - x_cheie];
%             y = [ col_aux(i) - y_cheie, col_aux(i) - y_cheie, col_aux(i) , col_aux(i) , col_aux(i) - y_cheie];
%             plot( y, x, 'g-','linewidth',1);
%         end
%         %pause();
%         hold off;
%         
%     end
%     
% end

for i = 1:size(row,1)
    
    [h,w] = size(img);
    
    left = col(i,1) + round((col(i,2) - col(i,1))*2/3);
    right = col(i,2) + ((col(i,2) - col(i,1))*3);
    up = max(1,row(i,1)-5);
    down = min(h,row(i,2));
    
    original = img(up:down,left:right);
    
    
    threshold = mean(original(:));
    original = original < threshold;
    
    
    
    
    se = strel('line',9,90);
    
    erodeBW = imerode(original,se);
    dilateBW = imdilate(erodeBW,se);
    
    figure,imshow(original);
    [H,T,R] = hough(dilateBW,'Theta',-4:4);
    %imshow(dilateBW);
    P  = houghpeaks(H,50,'Threshold',0.05*max(H(:)),'NHoodSize',[1 1]);
    %x = T(P(:,2)); y = R(P(:,1));
    
    figure,imshow(dilateBW);
    lines = houghlines(dilateBW,T,R,P,'FillGap',3,'MinLength',3);
    afisareLinii(lines,dilateBW);
end


end

