function [ row, col, type ] = obtineNoteNegre( parameters,img )

fprintf('Inaltimea notelor este %d\n',parameters.noteHeigth);

original = img;
threshold = mean(original(:));
original = original < threshold;

se = strel('line',9,90);

erodeBW = imerode(original,se);
dilateBW = imdilate(erodeBW,se);

% figure,imshow(original);
[H,T,R] = hough(dilateBW,'Theta',-5:0.5:5);
%imshow(dilateBW);
P  = houghpeaks(H,500,'Threshold',0.05*max(H(:)),'NHoodSize',[3 3]);
%x = T(P(:,2)); y = R(P(:,1));

% figure,imshow(dilateBW);
vertLines = houghlines(dilateBW,T,R,P,'FillGap',3,'MinLength',11);
% afisareLinii(vertLines,dilateBW);
% keyboard();
addWidth = round(parameters.currentClefWidth/2);

[d1,d2] = size(img);

used = zeros(1,d2);
figure,imshow(img);

max_val = 0;
type = 0 ;
row = zeros(0,1);
col = zeros(0,1);

row_half = zeros(0,1);
col_half = zeros(0,1);

position = zeros(1,size(vertLines,2));
foundLines = [];
% fprintf('Inaltimea notelor est e %d\n',parameters.noteHeight);
% for every vertical line we try to use template matching to decide if that
% is a note or other kind of notation
for i = 1:size(vertLines,2)
%     fprintf('Procesam linia verticala nr %d din %d\n',i,size(vertLines,2));
    
    
    % we take the coordinate on ox axis and do matching only once for that
    % point
    l = vertLines(i).point1(:,1);
    if(used(l) == 0)
        used(l) = 1;
%         disp(vertLines(i));
        %         if(abs(vertLines(i).point1(:,2) - vertLines(i).point2(:,2)) < parameters.noteHeight*3)
        %            continue;
        %         end
        % select a zone of 12 pixels around that point and consider that
        % the search zone for template matching
        left = max(1,l-addWidth);
        right = min(size(img,2),l+addWidth);
        
        searchZone = img(:,left:right);
        %     disp(vertLines(i).point1(:,1));
        %     disp(getfield(vertLines(i),'point1'));
        %     disp(getfield(vertLines(i),'point2'));
        %     disp(getfield(vertLines(i),'theta'));
        %     disp(getfield(vertLines(i),'rho'));
        %         figure,imshow(searchZone);
        
        % if the width of the zone is less than 15 pixels it means that the
        % zone is at the left/right end of the picture and there can be no
        % note there
        if(right - left < 15)
            continue;
        end
        maxim = 0;
        
        if(parameters.noteHeight >= 20)
            type = 0;
            black = rgb2gray(parameters.bigBlackEllipse);
            widthThreshold = (parameters.currentClefWidth*3/7);
            maxThreshold = 0.65;
            repetitions = 100;
            
        elseif((parameters.noteHeight > 13) && (parameters.noteHeight < 20))
            type = 1;
            black = rgb2gray(parameters.mediumBlackEllipse);
            widthThreshold = (parameters.currentClefWidth*3/7);
            maxThreshold = 0.65;
            repetitions = 7;
            
        elseif((parameters.noteHeight > 5 ) && (parameters.noteHeight <= 13))
            type = 2;
            black = rgb2gray(parameters.smallBlackEllipse);
            widthThreshold = (parameters.currentClefWidth*3/7);
            maxThreshold = 0.65;
            repetitions = 7;
            
        else
            type = 3;
            black = rgb2gray(parameters.extraSmallBlackEllipse);
            widthThreshold = 2;
            repetitions = 1;
            maxThreshold = 0.8;
            
        end
        %             disp(size(black));
        %             disp(parameters.noteHeight);
%         fprintf('size black %d',size(black,1));
        if(type < 3)
            while(size(black,1) > (parameters.noteHeight + 4))
                black = imresize(black,0.9);
            end
        end
%         
%         fprintf('inainte de while\n');
        % resize the template
%         disp(size(black,1));
%         disp((parameters.noteHeight + 1));
%         disp(maxim);
%         disp(repetitions);
        while((size(black,1) >= (parameters.noteHeight + 1)) && (maxim < 0.8) && (repetitions > 0))
            %             figure,imshow(black);
            repetitions = repetitions - 1;
%             fprintf('intram in while\n');
            %             disp('again');
            black = imresize(black,0.9);
            
            %             disp(size(black));
            %             disp(size(searchZone));
            
            
            % make sure the template is not bigger than the search zone
            if((size(black,2) > size(searchZone,2)) || (size(black,1) > size(searchZone,1)))
                continue;
            end
            
            x_template = size(black,1);
            y_template = size(black,2);
            
            c = normxcorr2(black,searchZone);
            
            maxim = max(c(:));
            disp(maxim);
            if(maxim > maxThreshold)
                [row_aux,col_aux] = find(c >= maxim*0.95);
                % for better placement on the stave detection
                %                 if(type < 3)
                %                     row_aux = row_aux - 1;
                %                 end
                
%                 disp('aiciiiiiiiii');
                for ii = 1:size(row_aux,1)
                    mijloc = round((row_aux(ii) + row_aux(ii) - x_template)/2);
                    if((mijloc < vertLines(i).point2(:,2)) && ...
                            (mijloc > vertLines(i).point1(:,2)))
                        row = [row; max(1,row_aux(ii) - x_template), row_aux(ii)];
                        col = [col; max(1,l - addWidth + col_aux(ii) - y_template), l - addWidth + col_aux(ii)];
                        foundLines = [foundLines; i];
                        
                        
                    end
                end
                
                %                 row = [row; max(1,row_aux - x_template), row_aux];
                %                 col = [col; max(1,l - addWidth + col_aux - y_template), l - addWidth + col_aux];
            end
        end
 %--------------------------------------------------------------------------------------
        % try to find half notes
        if(maxim <= maxThreshold)
            maxim = 0;
            
            % select half note size
            if(parameters.noteHeight >= 20)
                type = 0;
                half = rgb2gray(parameters.bigHalf);
                maxThreshold = 0.5;
                repetitions = 100;
                
            elseif((parameters.noteHeight > 13) && (parameters.noteHeight < 20))
                type = 1;
                half = rgb2gray(parameters.mediumHalf);
                maxThreshold = 0.5;
                repetitions = 4;
                
            elseif((parameters.noteHeight > 5 ) && (parameters.noteHeight <= 13))
                type = 2;
                half = rgb2gray(parameters.smallHalf);
                maxThreshold = 0.5;
                repetitions = 7;
                
            else
                type = 3;
                half = rgb2gray(parameters.extraSmallHalf);
                repetitions = 1;
                maxThreshold = 0.5;
                
            end
            
            
            if(type < 3)
                while(size(half,1) > parameters.noteHeight + 4)
                    half = imresize(half,0.9);
                end
            end
            
            
            %           resize the template
            while((size(half,1) > parameters.noteHeight + 1) && (maxim < 0.8) && (repetitions > 0))
                %                             figure,imshow(half);
                repetitions = repetitions - 1;
                %             disp('again');
                half = imresize(half,0.9);
                
                %             disp(size(black));
                %             disp(size(searchZone));
                
                
                % make sure the template is not bigger than the search zone
                if((size(half,2) > size(searchZone,2)) || (size(half,1) > size(searchZone,1)))
                    continue;
                end
                
                x_template = size(half,1);
                y_template = size(half,2);
                
                c = normxcorr2(half,searchZone);
                
                maxim = max(c(:));
                %                 disp(maxim);
                if(maxim > maxThreshold)
                    [row_aux,col_aux] = find(c >= maxim*0.95);
                    % for better placement on the stave detection
                    %                 if(type < 3)
                    %                     row_aux = row_aux - 1;
                    %                 end
%                                             disp('acoloooooooooo');

                    for ii = 1:size(row_aux,1)
                        if((((row_aux(ii) + row_aux(ii) - x_template)/2) < vertLines(i).point2(:,2)) && ...
                                (((row_aux(ii) + row_aux(ii) - x_template)/2) > vertLines(i).point1(:,2)))
                            row_half = [row_half; max(1,row_aux(ii) - x_template), row_aux(ii)];
                            col_half = [col_half; max(1,l - addWidth + col_aux(ii) - y_template), l - addWidth + col_aux(ii)];
                        end
                    end
                    
                    
                end
            end
        end
    end
end
%---------------------------------------------------------------------------
% size(foundLines);
% keyboard();
% show all detections
% figure,imshow(img);
% hold all;
% for i = 1:size(row,1)
%     x = [ row(i,1), row(i,2), row(i,2) , row(i,1), row(i,1)];
%     y = [ col(i,1), col(i,1), col(i,2) , col(i,2), col(i,1)];
%     plot( y, x, 'r-','linewidth',1);
% end
% 
% figure,imshow(img);
% hold all;
% for i = 1:size(row_half,1)
%     x = [ row_half(i,1), row_half(i,2), row_half(i,2) , row_half(i,1), row_half(i,1)];
%     y = [ col_half(i,1), col_half(i,1), col_half(i,2) , col_half(i,2), col_half(i,1)];
%     plot( y, x, 'y-','linewidth',1);
% end

% validate notes by eliminating overlapping detections
type = 1;
[row,col,foundLines] = validateNotes(parameters,row,col,type,foundLines);

type = 2;
[row,col] = validateNotes(parameters,row,col,type);

position = [];

for i = 1:size(foundLines,1)
    mijloc = round((row(i,1) + row(i,2))/2);
    if(abs(mijloc - vertLines(i).point1(:,2)) < abs(mijloc - vertLines(i).point2(:,2)))
        % sus 1
        % jos 2
        position = [position ; 1];
    else
        position = [position; 2];
    end
end

% sort notes by col
for i = 1:size(col,1)
    for j = i+1:size(col,1)
        if ((i~=j) && (col(i,1) > col(j,1)))
            col([i,j],:) = col([j,i],:);
            row([i,j],:) = row([j,i],:);
            position([i,j]) = position([j,i]);
        end
    end
end

% show detections after validation
figure,imshow(img);
hold all;
for i = 1:size(row,1)
    x = [ row(i,1), row(i,2), row(i,2) , row(i,1), row(i,1)];
    y = [ col(i,1), col(i,1), col(i,2) , col(i,2), col(i,1)];
    plot( y, x, 'b-','linewidth',1);
end

for i = 1:size(row_half,1)
    x = [ row_half(i,1), row_half(i,2), row_half(i,2) , row_half(i,1), row_half(i,1)];
    y = [ col_half(i,1), col_half(i,1), col_half(i,2) , col_half(i,2), col_half(i,1)];
    plot( y, x, 'g-','linewidth',1);
end

% for i = 1:size(foundLines,1)
%     fprintf('Linia este pe pozitia %d',vertLines(i).point1(:,1));
%     if(position(i) == 1)
%         fprintf('sus\n');
%     elseif(position(i) == 2)
%         fprintf('jos\n');
%     end
%     
% end
% get note values by comparing its middle height point with the positions
% of the horizontal lines

obtainNoteLength(original,vertLines,foundLines);
% keyboard();
obtainNoteValue(parameters,row,col);


% keyboard();

end

