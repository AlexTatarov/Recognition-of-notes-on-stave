function [ x ] = obtineSemneCheie( parameters, row, col, clefWidth )
% if x < 0 then there are abs(x) flat keys(bemol)
% if x > 0 then there are abs(x) sharp keys(diez)
% if x = 0 then there are no musical signs

if(size(parameters.firstImg,3) > 1)
    img = rgb2gray(parameters.firstImg);
else
    img = parameters.firstImg;
end
x = 0;
[h,w] = size(img);

right = col(1,2) + ((col(1,2) - col(1,1))*2);

original = img(:,1:clefWidth(1)*2);
% figure,imshow(original);
threshold = mean(original(:));

original = original < threshold;
se = strel('line',9,90);

erodeBW = imerode(original,se);
dilateBW = imdilate(erodeBW,se);
[H,T,R] = hough(dilateBW,'Theta',-4:4);
%imshow(dilateBW);
P  = houghpeaks(H,200,'Threshold',0.03*max(H(:)),'NHoodSize',[1 1]);
%x = T(P(:,2)); y = R(P(:,1));

lines = houghlines(dilateBW,T,R,P,'FillGap',1,'MinLength',floor(parameters.noteHeight*1.7));

horzLines = parameters.firstLines;
height = parameters.noteHeight;

% for i = 1:length(horzLines)
%     disp(horzLines(i));
% end

% sort and unify lines
for i = 1:length(lines)
    for j = i + 1:length(lines)
        if(lines(i).point1(:,1) > lines(j).point1(:,1))
            lines([i,j]) = lines([j,i]);
        end
    end
end
% afisareLinii(lines,dilateBW);

% unite lines
d = length(lines);
i = 1;
while(i<d)
    d = length(lines);
    delete = false;
    
    for j = i+1:d
        if(((abs(lines(i).point1(:,1) - lines(j).point1(:,1)) < 2) && ...
                (abs(lines(i).point1(:,2) - lines(j).point1(:,2)) + ...
                abs(lines(i).point2(:,2) - lines(j).point2(:,2)) <= height)) || ((abs(lines(i).point1(:,1) - lines(j).point1(:,1)) < 2)))
            lines(i).point1(:,2) = min(lines(i).point1(:,2),lines(j).point1(:,2));
            lines(i).point2(:,2) = max(lines(i).point2(:,2),lines(j).point2(:,2));
            lines(j) = [];
            delete = true;
            break;
        end
    end
    
    if(delete == true)
        d = length(lines);
        continue;
    else
        i = i+1;
    end
    d = length(lines);
end

% for i = 1:length(horzLines)
%     disp(horzLines(i));
% end
% disp('7777777777');
% print lines
% for i = 1:length(lines)
%     disp(lines(i));
% end


% detect if there are possible sharp signs or flat ones
if(length(lines) > 1)
    %     disp(abs(lines(1).point1(:,2) - lines(2).point1(:,2)));
    %     disp(ceil(height*0.7));
    %     disp(abs(lines(1).point2(:,2) - lines(2).point2(:,2)));
    if((abs(lines(1).point1(:,2) - lines(2).point1(:,2)) <= ceil(height*0.8)) && (abs(lines(1).point2(:,2) - lines(2).point2(:,2)) <= ceil(height*0.8)))
%         disp('am intrat pe diez');
        for i = 1:length(lines)
            
            if((x == 0) && (abs(lines(i).point2(:,2) - horzLines(2).point1(:,2)) <= ceil(height/2))  ...
                    && ((lines(i).point2(:,2) - lines(i).point1(:,2)) <= (3*height)) )
%                 disp('este fa diez');
                x = 1;
                continue;
            end
            
            if((x == 1) && ((lines(i).point2(:,2) <= horzLines(4).point1(:,2)) && (lines(i).point2(:,2) >= horzLines(3).point1(:,2)) )  ...
                    && (abs(lines(i).point2(:,2) - lines(i).point1(:,2)) <= (3*height)) )
%                 disp('este do diez');
                x = 2;
                continue;
                
            end
%                         disp('---');
%                         disp(abs(lines(i).point2(:,2) - horzLines(2).point1(:,2)));
%                         disp(ceil(height/2));
%                         disp((lines(i).point2(:,2) - lines(i).point1(:,2)));
%                         disp(3*height);
            if((x == 2) && (abs(lines(i).point2(:,2) - horzLines(2).point1(:,2)) - round(height/2) <= ceil(height/2) )  ...
                    && ((lines(i).point2(:,2) - lines(i).point1(:,2)) <= (3*height)))
%                 disp('este sol diez');
                x = 3;
                continue;
                
            end
%             disp('---');
%             disp(i);
%                         disp(abs(lines(i).point2(:,2) - horzLines(3).point1(:,2))-round(height/2));
%                         disp(ceil(height/2));
%                         disp((lines(i).point2(:,2) - lines(i).point1(:,2)));
%                         disp(3*height);
            if((x == 3) && ((abs(lines(i).point2(:,2) - horzLines(3).point1(:,2)) - round(height/2)) <= ceil(height/2) ) ...
                    && ((lines(i).point2(:,2) - lines(i).point1(:,2)) <= (3*height)))
%                 disp('este re diez');
                x = 4;
                continue;
                
            end
            
            if((x == 4) && ((abs(lines(i).point2(:,2) - horzLines(5).point1(:,2)) <= ceil(height/2) ) ) ...
                    && ((lines(i).point2(:,2) - lines(i).point1(:,2)) <= (3*height)) )
%                 disp('este la diez');
                x = 5;
                continue;
                
            end
            
            if((x == 5) && (abs(lines(i).point2(:,2) - horzLines(3).point1(:,2)) < ceil(height/2)) ...
                    && ((lines(i).point2(:,2) - lines(i).point1(:,2)) <= (3*height)) )
%                 disp('este mi diez');
                x = 6;
                continue;
                
            end
            
            if((x == 6) && (abs(lines(i).point2(:,2) - horzLines.point1(:,1) - round(height/4)) < ceil(height/2))  ...
                    && ((lines(i).point2(:,2) - lines(i).point1(:,2)) <= (3*height)) )
%                 disp('este si diez');
                x = 7;
                continue;
                
            end
            
        end
    end
end
if (x == 0)
%     disp('am intrat pe bemol');
    for i = 1:length(lines)
        
        if((x == 0) && ((lines(i).point2(:,2) < horzLines(4).point1(:,2)) && (lines(i).point2(:,2) > horzLines(3).point1(:,2))) ...
                && ((lines(i).point2(:,2) - lines(i).point1(:,2)) < (3*height)) )
%             disp('este si bemol');
            x = -1;
            continue;
            
        end
        
        if((x == -1) && ((lines(i).point2(:,2) < horzLines(4).point1(:,2)) && (lines(i).point2(:,2) > horzLines(3).point1(:,2)) )  ...
                && (abs(lines(i).point2(:,2) - lines(i).point1(:,2)) < (3*height)) )
%             disp('este mi bemol');
            x = -2;
            continue;
            
        end
        
        if((x == -2) && (abs(lines(i).point2(:,2) - horzLines(2).point1(:,2)) < ceil(height/2) )  ...
                && ((lines(i).point2(:,2) - lines(i).point1(:,2)) < (3*height)))
%             disp('este la bemol');
            x = -3;
            continue;
            
        end
        
        if((x == -3) && ((abs(lines(i).point2(:,2) - horzLines(3).point1(:,2)) - round(height/4)) < ceil(height/2) ) ...
                && ((lines(i).point2(:,2) - lines(i).point1(:,2)) < (3*height)))
%             disp('este re bemol');
            x = -4;
            continue;
            
        end
        
        if((x == -4) && ((abs(lines(i).point2(:,2) - horzLines(5).point1(:,2)) < ceil(height/2) ) ) ...
                && ((lines(i).point2(:,2) - lines(i).point1(:,2)) < (3*height)) )
%             disp('este sol bemol');
            x = -5;
            continue;
            
        end
        
        if((x == -5) && (abs(lines(i).point2(:,2) - horzLines(3).point1(:,2)) < ceil(height/2)) ...
                && ((lines(i).point2(:,2) - lines(i).point1(:,2)) < (3*height)) )
%             disp('este do bemol');
            x = -6;
            continue;
            
        end
        
        if((x == -6) && (abs(lines(i).point2(:,2) - horzLines.point1(:,1) - round(height/4)) < ceil(height/2))  ...
                && ((lines(i).point2(:,2) - lines(i).point1(:,2)) < (3*height)) )
%             disp('este fa bemol');
            x = -7;
            continue; 
        end 
    end
end

% afisareLinii(lines,dilateBW);
fprintf('Avem raspunsul %d\n',x);
% keyboard();

end

