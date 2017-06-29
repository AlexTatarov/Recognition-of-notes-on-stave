function [  ] = obtinePozitiaNotelor(parameters, img )

tic;
if(size(img,3) > 1)
    img = rgb2gray(img);
end
% try to detect black notes(1/4, 1/8, 1/16)
[row,col,type,notesLength] = obtineNoteNegre(parameters,img);

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
                && ((abs(rowWhole(i,1) - row(j,1)) < parameters.noteHeight ) || (abs(rowWhole(i,2) - row(j,2)) < parameters.noteHeight)))
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
            notesLength([i,j]) = notesLength([j,i]);
        end
    end
end

for i = 1:size(rowWhole,1)
   notesLength = [notesLength;1]; 
end
disp(notesLength);
disp(size(row));
disp(size(notesLength));
row = [row; rowWhole];
col = [col; colWhole];
type = 2;
[row,col] = validateNotes(parameters,row,col,type,notesLength);

[row,col] = obtainNoteValue(parameters,row,col);
figure,imshow(img);
hold all;
for i = 1:size(row,1)
    x = [ row(i,1), row(i,2), row(i,2) , row(i,1), row(i,1)];
    y = [ col(i,1), col(i,1), col(i,2) , col(i,2), col(i,1)];
    plot( y, x, 'r-','linewidth',1);
end
% keyboard();

end



