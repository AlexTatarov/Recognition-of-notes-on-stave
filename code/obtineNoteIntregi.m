function [ row,col,type ] = obtineNoteIntregi( parameters,img )
%OBTINENOTEINTREGI Summary of this function goes here
%   Detailed explanation goes here

max_val = 0;
type = 0 ;
row = zeros(0,1);
col = zeros(0,1);

if(parameters.noteHeight >= 20)
    type = 0;
    black = rgb2gray(parameters.bigWhole);
    maxThreshold = 0.6;
    repetitions = 50;
    
elseif((parameters.noteHeight > 13) && (parameters.noteHeight < 20))
    type = 1;
    black = rgb2gray(parameters.mediumWhole);
    maxThreshold = 0.6;
    repetitions = 7;
    
elseif((parameters.noteHeight > 5) && (parameters.noteHeight <= 13))
    type = 2;
    black = rgb2gray(parameters.smallWhole);
    maxThreshold = 0.6;
    repetitions = 5;
    
else
    type = 3;
    black = rgb2gray(parameters.extraSmallWhole);
    repetitions = 1;
    maxThreshold = 0.6;
    
end


if(type < 3)
    while(size(black,1) > parameters.noteHeight + 2)
        black = imresize(black,0.9);
    end
end

maxim = 0;

% resize the template
while((size(black,1) > parameters.noteHeight) && (maxim < 0.8) && (repetitions > 0))
    %             figure,imshow(black);
    repetitions = repetitions - 1;
    %             disp('again');
    black = imresize(black,0.9);
    
    %             disp(size(black));
    %             disp(size(searchZone));
    
    
    % make sure the template is not bigger than the search zone
    
    x_template = size(black,1);
    y_template = size(black,2);
    
    c = normxcorr2(black,img);
    
    maxim = max(c(:));
    if(maxim > maxThreshold)
        [row_aux,col_aux] = find(c >= maxim*0.95);
        % for better placement on the stave detection
        %                 if(type < 3)
        %                     row_aux = row_aux - 1;
        %                 end
        row = [row; max(1,row_aux - x_template), row_aux];
        col = [col; max(1,col_aux - y_template), col_aux];
    end
end







% show all detections
figure,imshow(img);
hold all;
for i = 1:size(row,1)
    x = [ row(i,1), row(i,2), row(i,2) , row(i,1), row(i,1)];
    y = [ col(i,1), col(i,1), col(i,2) , col(i,2), col(i,1)];
    plot( y, x, 'g-','linewidth',1);
end

% validate notes by eliminating overlapping detections
[row,col] = validateNotes(parameters,row,col,type);

% show detections after validation
figure,imshow(img);
hold all;
for i = 1:size(row,1)
    x = [ row(i,1), row(i,2), row(i,2) , row(i,1), row(i,1)];
    y = [ col(i,1), col(i,1), col(i,2) , col(i,2), col(i,1)];
    plot( y, x, 'b-','linewidth',1);
end

% get note values by comparing its middle height point with the positions
% of the horizontal lines

% sort notes by col
for i = 1:size(col,1)
    for j = i+1:size(col,1)
        if ((i~=j) && (col(i,1) > col(j,1)))
            col([i,j],:) = col([j,i],:);
            row([i,j],:) = row([j,i],:);
        end
    end
end
obtainNoteValue(parameters,row,col);
keyboard();


end

