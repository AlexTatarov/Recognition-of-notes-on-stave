function [ nothing ] = obtineNoteNegre( parameters,img )

nothing = 0



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

[d1,d2] = size(img);

used = zeros(1,d2);
figure,imshow(img);

max_val = 0;
type = 0 ;
row = zeros(0,1);
col = zeros(0,1);

addWidth = round(parameters.currentClefWidth/2);

% for every vertical line we try to use template matching to decide if that
% is a note or other kind of notation
for i = 1:size(vertLines,2)
    fprintf('Procesam linia verticala nr %d din %d\n',i,size(vertLines,2));
    
    
    % we take the coordinate on ox axis and do matching only once for that
    % point
    l = vertLines(i).point1(:,1);
    if(used(l) == 0)
        used(l) = 1;
        
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
        
        if(parameters.currentClefWidth > 25)
            black = rgb2gray(parameters.bigBlackEllipse);
            widthThreshold = (parameters.currentClefWidth*3/7);
            maxThreshold = 0.65;
        else
            black = rgb2gray(parameters.smallBlackEllipse);
            widthThreshold = 8;
            maxThreshold = 0.8
        end
    
        
        
        % resize the template
        while((size(black,1) > widthThreshold) && (maxim < 0.8))
                        figure,imshow(black);
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
            if(maxim > maxThreshold)
                [row_aux,col_aux] = find(c >= maxim*0.95);
                row = [row; max(1,row_aux - x_template - 1), row_aux - 1];
                col = [col; max(1,l - addWidth + col_aux - y_template), l - addWidth + col_aux];
            end
        end
    end
end
toc;

figure,imshow(img);
hold all;
for i = 1:size(row,1)
    x = [ row(i,1), row(i,2), row(i,2) , row(i,1), row(i,1)];
    y = [ col(i,1), col(i,1), col(i,2) , col(i,2), col(i,1)];
    plot( y, x, 'g-','linewidth',1);
end



end

