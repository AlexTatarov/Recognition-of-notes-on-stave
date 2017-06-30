function [ counter ] = obtainNoteLength( parameters,original, row,col,vertLines,foundLines,position )
%OBTAINNOTELENGTH Summary of this function goes here
%   Detailed explanation goes here
%%
se = strel('line',9,-45);

erodeBW = imerode(original,se);
dilateBW = imdilate(erodeBW,se);

% figure,imshow(original);
[H,T,R] = hough(dilateBW,'Theta',[-47:-43]);
%imshow(dilateBW);
P  = houghpeaks(H,200,'Threshold',0.01*max(H(:)),'NHoodSize',[5 5]);
%x = T(P(:,2)); y = R(P(:,1));
minLength = round(parameters.noteHeight*1.5);
% fprintf('Lungimea minima este %d\n',minLength);
% figure,imshow(dilateBW);
obliqueLines = houghlines(dilateBW,T,R,P,'FillGap',1,'MinLength',minLength);
% for i = 1:length(obliqueLines)
%     disp(obliqueLines(i));
% end

for i = 1:length(obliqueLines)
   for j = i+1:length(obliqueLines)
      if(obliqueLines(i).point1(:,1) > obliqueLines(j).point1(:,1))
         obliqueLines([i,j]) = obliqueLines([j,i]); 
      end
   end
end

% for i = 1:length(foundLines)
%     disp(vertLines(foundLines(i)));
% end

% for i = 1:size(row,1)
%    fprintf('Avem randul %d %d\n',row(i,1),row(i,2));
% end

counter = zeros(1,size(row,1));
% for every vertical line we will find the horizontal lines that are there
for i = 1:size(row,1)
    % 1 - sus
    % 2 - jos
    if(position(i) == 1)
        sus = round((vertLines(foundLines(i)).point2(:,2) - ...
            (vertLines(foundLines(i)).point2(:,2) - vertLines(foundLines(i)).point1(:,2))/3));
        jos = vertLines(foundLines(i)).point2(:,2);
    elseif(position(i) == 2)
        sus = vertLines(foundLines(i)).point1(:,2);
        jos = round((vertLines(foundLines(i)).point1(:,2) + ...
            (vertLines(foundLines(i)).point2(:,2) - vertLines(foundLines(i)).point1(:,2))/3));
    end
    frozen = zeros(1,jos);
%     fprintf('Avem sus si jos respectiv %d %d \n',sus,jos);
    for j = 1:length(obliqueLines)
        if(position(i) == 1)
%             fprintf('Oblique este %d\n',obliqueLines(j).point2(:,2));
            if((obliqueLines(j).point2(:,2) <= jos) && (obliqueLines(j).point2(:,2) >= sus) ...
                    && ((abs(obliqueLines(j).point2(:,1) - col(i,2)) < floor(parameters.noteHeight/2))))
                if((obliqueLines(j).point2(:,2) > 0) && (obliqueLines(j).point2(:,2) <= jos) && (frozen(obliqueLines(j).point2(:,2)) == 0))
                    start = max(1,obliqueLines(j).point2(:,1)-3);
                    endpoint = min(jos,obliqueLines(j).point2(:,1)+3);
                    frozen(start:endpoint) = 1;
                    counter(i) = counter(i) + 1;
                end
            end
        elseif(position(i) == 2)
%             fprintf('Oblique este %d\n',obliqueLines(j).point1(:,2));
            if((obliqueLines(j).point1(:,2) <= jos) && (obliqueLines(j).point1(:,2) >= sus) ...
                    && (abs(obliqueLines(j).point1(:,1) - vertLines(foundLines(i)).point1(:,1)) ...
                        < floor(parameters.noteHeight/2)))
                if((obliqueLines(j).point1(:,2) > 0) && (frozen(obliqueLines(j).point1(:,2)) == 0))
%                     fprintf('Pentru %d\n',obliqueLines(j).point1(:,2));
                    start = max(1,obliqueLines(j).point1(:,2)-3);
                    endpoint = min(jos,obliqueLines(j).point1(:,2)+3);
                    frozen(start:endpoint) = 1;
                    counter(i) = counter(i) + 1;
                end
            end
        end
    end
end
% disp(counter);
counter_aux = counter;
% afisareLinii(obliqueLines,dilateBW);
% keyboard();

%%

se = strel('line',9,-20);

erodeBW = imerode(original,se);
dilateBW = imdilate(erodeBW,se);

% figure,imshow(original);
[H,T,R] = hough(dilateBW,'Theta',[-82:-78]);
%imshow(dilateBW);
P  = houghpeaks(H,200,'Threshold',0.01*max(H(:)),'NHoodSize',[5 5]);
%x = T(P(:,2)); y = R(P(:,1));
minLength = round(parameters.noteHeight*1.5);
% fprintf('Lungimea minima este %d\n',minLength);
% figure,imshow(dilateBW);
obliqueLines = houghlines(dilateBW,T,R,P,'FillGap',3,'MinLength',minLength);
% for i = 1:length(obliqueLines)
%     disp(obliqueLines(i));
% end
for i = 1:length(obliqueLines)
   for j = i+1:length(obliqueLines)
      if(obliqueLines(i).point1(:,1) > obliqueLines(j).point1(:,1))
         obliqueLines([i,j]) = obliqueLines([j,i]); 
      end
   end
end


% for i = 1:length(obliqueLines)
%    disp(obliqueLines(i)); 
% end
% disp('--------');
% for i = 1:length(foundLines)
%     disp(vertLines(foundLines(i)));
% end


counter = zeros(1,size(row,1));
% for every vertical line we will find the horizontal lines that are there
for i = 1:size(row,1)
    % 1 - sus
    % 2 - jos
    if(position(i) == 1)
        sus = round((vertLines(foundLines(i)).point2(:,2) - ...
            (vertLines(foundLines(i)).point2(:,2) - vertLines(foundLines(i)).point1(:,2))/3));
        jos = vertLines(foundLines(i)).point2(:,2);
    elseif(position(i) == 2)
        sus = vertLines(foundLines(i)).point1(:,2);
        jos = round((vertLines(foundLines(i)).point1(:,2) + ...
            (vertLines(foundLines(i)).point2(:,2) - vertLines(foundLines(i)).point1(:,2))/3));
    end
    frozen = zeros(1,(jos+parameters.noteHeight*2));
    
    
    
%     fprintf('Avem sus si jos respectiv %d %d \n',sus,jos);
%     fprintf('%d\n\n\n',i);
    for j = 1:length(obliqueLines)
        
        if(position(i) == 1)
%             fprintf('Oblique2 este %d %d\n',obliqueLines(j).point2(:,2),obliqueLines(j).point2(:,1));
%             fprintf('Pentru %d %d\n',jos+parameters.noteHeight,sus);
%             fprintf('Avem rezultatele urmatoare %d\n',abs(obliqueLines(j).point2(:,1) - vertLines(i).point2(:,1)));
%             fprintf('Avem pe parti %d %d\n',obliqueLines(j).point2(:,1), vertLines(foundLines(i)).point2(:,1));

            if((obliqueLines(j).point2(:,2) <= (jos + parameters.noteHeight)) && (obliqueLines(j).point2(:,2) >= sus ) ...
                    && ((abs(obliqueLines(j).point2(:,1) - vertLines(foundLines(i)).point2(:,1)) <= floor(parameters.noteHeight))))
               
                if((obliqueLines(j).point2(:,2) > 0) && (frozen(obliqueLines(j).point2(:,2)) == 0))
%                     disp(obliqueLines(j));
                    
                    start = max(1,obliqueLines(j).point2(:,2) - parameters.noteHeight);
                    endpoint = min(jos,obliqueLines(j).point2(:,2) + parameters.noteHeight);
                    frozen(start:endpoint) = 1;
                    counter(i) = counter(i) + 1;
                end
            end
            
%             fprintf('Oblique1 este %d\n',obliqueLines(j).point1(:,2));

            if((obliqueLines(j).point1(:,2) <= (jos + parameters.noteHeight)) && (obliqueLines(j).point1(:,2) >= sus) ...
                    && ((abs(obliqueLines(j).point1(:,1) - vertLines(foundLines(i)).point1(:,1)) <= floor(parameters.noteHeight))))
%                 disp('acolo');
%                     disp(obliqueLines(j));

                if((obliqueLines(j).point1(:,2) > 0) && (frozen(obliqueLines(j).point1(:,2)) == 0))
                    start = max(1,obliqueLines(j).point1(:,2) - parameters.noteHeight);
                    endpoint = min(jos,obliqueLines(j).point1(:,2) + parameters.noteHeight);
                    frozen(start:endpoint) = 1;
                    counter(i) = counter(i) + 1;
                end
            end
%             end



        elseif(position(i) == 2)
%             fprintf('Oblique este %d\n',obliqueLines(j).point1(:,2));
            if((obliqueLines(j).point1(:,2) <= jos) && (obliqueLines(j).point1(:,2) >= sus) ...
                    && (abs(obliqueLines(j).point1(:,1) - vertLines(foundLines(i)).point1(:,1)) ...
                        <= floor(parameters.noteHeight)))
                if((obliqueLines(j).point1(:,2) > 0) && (frozen(obliqueLines(j).point1(:,2)) == 0))
%                     fprintf('Pentru %d\n',obliqueLines(j).point1(:,2));
                    start = max(1,obliqueLines(j).point1(:,2)-3);
                    endpoint = min(jos,obliqueLines(j).point1(:,2)+3);
                    frozen(start:endpoint) = 1;
                    counter(i) = counter(i) + 1;
                end
            end
            
            if((obliqueLines(j).point1(:,2) <= jos) && (obliqueLines(j).point1(:,2) >= sus) ...
                    && (abs(obliqueLines(j).point1(:,1) - vertLines(foundLines(i)).point1(:,1)) ...
                        <= floor(parameters.noteHeight/2)))
                if((obliqueLines(j).point1(:,2) > 0) && (frozen(obliqueLines(j).point1(:,2)) == 0))
%                     fprintf('Pentru %d\n',obliqueLines(j).point1(:,2));
                    start = max(1,obliqueLines(j).point1(:,2)-3);
                    endpoint = min(jos,obliqueLines(j).point1(:,2)+3);
                    frozen(start:endpoint) = 1;
                    counter(i) = counter(i) + 1;
                end
            end
        end
    end
end
% disp(counter);
for i = 1:size(counter,1)
   if(counter_aux(i) == 0)
      counter_aux(i) = counter(i); 
   else
      counter_aux(i) = min(counter(i),counter_aux(i)); 
   end
end

% afisareLinii(obliqueLines,dilateBW);


%%
se = strel('line',9,45);

erodeBW = imerode(original,se);
dilateBW = imdilate(erodeBW,se);

% figure,imshow(original);
[H,T,R] = hough(dilateBW,'Theta',[43:47]);
%imshow(dilateBW);
P  = houghpeaks(H,200,'Threshold',0.01*max(H(:)),'NHoodSize',[5 5]);
%x = T(P(:,2)); y = R(P(:,1));
minLength = round(parameters.noteHeight*1.5);
fprintf('Lungimea minima este %d\n',minLength);
% figure,imshow(dilateBW);
obliqueLines = houghlines(dilateBW,T,R,P,'FillGap',5,'MinLength',minLength);
% for i = 1:length(obliqueLines)
%     disp(obliqueLines(i));
% end

% for i = 1:length(foundLines)
%     disp(vertLines(foundLines(i)));
% end

% for i = 1:size(row,1)
%    fprintf('Avem randul %d %d\n',row(i,1),row(i,2));
% end

counter = zeros(1,size(row,1));
% for every vertical line we will find the horizontal lines that are there
for i = 1:size(row,1)
    % 1 - sus
    % 2 - jos
    if(position(i) == 1)
        sus = round((vertLines(foundLines(i)).point2(:,2) - ...
            (vertLines(foundLines(i)).point2(:,2) - vertLines(foundLines(i)).point1(:,2))/3));
        jos = vertLines(foundLines(i)).point2(:,2);
    elseif(position(i) == 2)
        sus = vertLines(foundLines(i)).point1(:,2);
        jos = round((vertLines(foundLines(i)).point1(:,2) + ...
            (vertLines(foundLines(i)).point2(:,2) - vertLines(foundLines(i)).point1(:,2))/3));
    end
    frozen = zeros(1,jos);
%     fprintf('Avem sus si jos respectiv %d %d \n',sus,jos);
    for j = 1:length(obliqueLines)
        if(position(i) == 1)
%             fprintf('Oblique este %d\n',obliqueLines(j).point2(:,2));
            if((obliqueLines(j).point2(:,2) <= jos) && (obliqueLines(j).point2(:,2) >= sus) ...
                    && ((abs(obliqueLines(j).point2(:,1) - col(i,2)) < floor(parameters.noteHeight/2))))
                if((obliqueLines(j).point2(:,2) > 0) && (obliqueLines(j).point2(:,2) <= jos) && (frozen(obliqueLines(j).point2(:,2)) == 0))
                    start = max(1,obliqueLines(j).point2(:,1)-3);
                    endpoint = min(jos - sus,obliqueLines(j).point2(:,1)+3);
                    frozen(start:endpoint) = 1;
                    counter(i) = counter(i) + 1;
                end
            end
            
        elseif(position(i) == 2)
%             fprintf('Oblique este %d\n',obliqueLines(j).point1(:,2));
            if((obliqueLines(j).point1(:,2) <= jos) && (obliqueLines(j).point1(:,2) >= sus) ...
                    && (abs(obliqueLines(j).point1(:,1) - vertLines(foundLines(i)).point1(:,1)) ...
                        < floor(parameters.noteHeight/2)))
                if((obliqueLines(j).point1(:,2) > 0) && (frozen(obliqueLines(j).point1(:,2)) == 0))
%                     fprintf('Pentru %d\n',obliqueLines(j).point1(:,2));
                    start = max(1,obliqueLines(j).point1(:,2)-3);
                    endpoint = min(jos,obliqueLines(j).point1(:,2)+3);
                    frozen(start:endpoint) = 1;
                    counter(i) = counter(i) + 1;
                end
            end
        end
    end
end
for i = 1:size(counter,1)
   if(counter_aux(i) == 0)
      counter_aux(i) = counter(i);
   else
      counter_aux(i) = min(counter(i),counter_aux(i)); 
   end
end
% disp(counter);
% afisareLinii(obliqueLines,dilateBW);
% keyboard();
end

