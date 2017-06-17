function [  ] = obtinePozitiaNotelor(parameters, img )

tic;
if(size(img,3) > 1)
    img = rgb2gray(img);
end
% try to detect black notes(1/4, 1/8, 1/16)
[row,col,type] = obtineNoteNegre(parameters,img);

% try to detect halves(1/2)
% [row, col, type] = obtineNoteDoime(parameters,img);

% try to detect full notes(1/1)
[rowWhole,colWhole,typeWhole] = obtineNoteIntregi(parameters,img);

% elimintate whole note detections that are overlapping with other already
% made detections beacause of the stronger probability that there is the
% other note
for i = size(rowWhole,1):-1:1
    for j = 1:size(row,1)
%         disp(abs(colWhole(i,1) - col(j,1)));
%         disp(abs(colWhole(i,2) - col(j,2)));
       if(((abs(colWhole(i,1) - col(j,1)) <= 5) || (abs(colWhole(i,2) - col(j,2)) <= 5))...
                && ((abs(colWhole(i,1) - col(j,1)) < parameters.noteHeight ) || (abs(colWhole(i,1) - col(j,1)) < parameters.noteHeight)))
           rowWhole(i,:) = [];
           colWhole(i,:) = [];
           break;
       end
    end
end

for i = 1:size(col,1)
    for j = i+1:size(col,1)
        if ((i~=j) && (col(i,1) > col(j,1)))
            col([i,j],:) = col([j,i],:);
            row([i,j],:) = row([j,i],:);
        end
    end
end

obtainNoteValue(parameters,row,col);
% figure,imshow(img);
% hold all;
% for i = 1:size(rowWhole,1)
%     x = [ rowWhole(i,1), rowWhole(i,2), rowWhole(i,2) , rowWhole(i,1), rowWhole(i,1)];
%     y = [ colWhole(i,1), colWhole(i,1), colWhole(i,2) , colWhole(i,2), colWhole(i,1)];
%     plot( y, x, 'r-','linewidth',1);
% end
% keyboard();

end



