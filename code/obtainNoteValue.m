function [row, col,M,L ] = obtainNoteValue( parameters, row, col, notesLength, x )
% will detect the value of a note by comparing its middle height point with
% the position of the horizontal lines

linii = parameters.horizontalLines;
distance = parameters.noteHeight;
fisier = parameters.rezultat;
M = [];
L = [];
third = round(distance/3);
disp('Note values for this line are:');
i = 0;
while(i<size(row,1)) 
    i = i + 1;
    middle = (row(i,1) + row(i,2))/2;
    fprintf(fisier,'%d ',notesLength(i));
    if(notesLength(i) == 1)
        L = [L; 2];
    elseif(notesLength(i) == 2)
        L = [L; 1];
    elseif(notesLength(i) == 4)
        L = [L; 0.5];
    elseif(notesLength(i) == 8)
        L = [L; 0.25];
    elseif(notesLength(i) == 16)
        L = [L; 0.125];
    end
    
    if( middle <= linii(1).point1(:,2) - third)
        %aici este mai sus de portativ
        
        if( middle >= linii(1).point1(:,2) - distance + third )
            if(x >= 3)
                fprintf(fisier,'Sol D O2\r\n');
                M = [M; 57];
            elseif(x <= -5)
                M = [M; 55'];
                fprintf(fisier,'Sol B O2\r\n');
            else
                M = [M; 56];
                fprintf(fisier,'Sol O2\r\n');
            end
            continue;
        
        elseif( middle > linii(1).point1(:,2) - distance - third )
            if(x >= 5)
                M = [M; 60];
                fprintf(fisier,'La D O2\r\n');
            elseif(x <= -3)
                M = [M; 58];
                fprintf(fisier,'La B O2\r\n');
            else
                M = [M; 59'];
                fprintf(fisier,'La O2\r\n');
            end
            continue;
            
        elseif( middle >= linii(1).point1(:,2) - 2 * distance + third )
            if(x >= 7)
                M = [M; 63];
                fprintf(fisier,'Si D O2\r\n');
            elseif(x <= -1)
                M = [M; 61];
                fprintf(fisier,'Si B O2\r\n');
            else
                M = [M;62];
                fprintf(fisier,'Si O2\r\n');
            end
            continue;
        
        elseif( middle > linii(1).point1(:,2) - 2 * distance - third )
            if(x >= 2)
                M = [M; 66];
                fprintf(fisier,'Do D O3\r\n');
            elseif(x <= -6)
                M = [M; 64'];
                fprintf(fisier,'Do B O3\r\n');
            else
                M = [M; 65];
                fprintf(fisier,'Do O3\r\n');
            end
            continue;
        
        elseif( middle >= linii(1).point1(:,2) - 3 * distance + third )
            if(x >= 4)
                M = [M; 69'];
                fprintf(fisier,'Re D O3\r\n');
            elseif(x <= -4)
                M = [M; 67];
                fprintf(fisier,'Re B O3\r\n');
            else
                M = [M; 68'];
                fprintf(fisier,'Re O3\r\n');
            end    
            continue;
        
        elseif( middle > linii(1).point1(:,2) - 3 * distance - third )
            if(x >= 6)
                M = [M; 72];
                fprintf(fisier,'Mi D O3\r\n');
            elseif(x <= -2)
                M = [M; 70];
                fprintf(fisier,'Mi B O3\r\n');
            else
                M = [M; 71];
                fprintf(fisier,'Mi O3\r\n');
            end
            continue;
        
        elseif( middle >= linii(1).point1(:,2) - 4 * distance + third )
            if(x >= 1)
                M = [M; 75];
                fprintf(fisier,'Fa D O3\r\n');
            elseif(x <= -7)
                M = [M; 73];
                fprintf(fisier,'Fa B O3\r\n');;
            else
                M = [M; 74];
                fprintf(fisier,'Fa O3\r\n');
            end
            continue;
        
        elseif( middle > linii(1).point1(:,2) - 4 * distance - third )
            if(x >= 3)
                M = [M; 78];
                fprintf(fisier,'Sol D O3\r\n');
            elseif(x <= -5)
                M = [M; 76];
                fprintf(fisier,'Sol B O3\r\n');
            else
                M = [M; 77];
                fprintf(fisier,'Sol O3\r\n');
            end
            continue;
            
        elseif( middle >= linii(1).point1(:,2) - 5 * distance + third )
            if(x >= 5)
                M = [M; 81];
                fprintf(fisier,'La D O3\r\n');
            elseif(x <= -3)
                M = [M; 79];
                fprintf(fisier,'La B O3\r\n');
            else
                M = [M; 80'];
                fprintf(fisier,'La O3\r\n');
            end
            continue;
            
        elseif( middle > linii(1).point1(:,2) - 5 * distance - third )
            if(x >= 7)
                M = [M; 84];
                fprintf(fisier,'Si D O3\r\n');
            elseif(x <= -1)
                M = [M; 82];
                fprintf(fisier,'Si B O3\r\n');
            else
                M = [M; 83];
                fprintf(fisier,'Si O3\r\n');
            end
            continue;
            
        else
            row(i,:) = [];
            col(i,:) = [];
            fprintf(fisier,'it is too high\r\n');
            continue;
        end
        
    elseif(( middle > (linii(1).point1(:,2) - third)) && ...
            (middle < (linii(5).point1(:,2) + third)))
        % este in interiorul portativului
        
        % fa second octave
        if(( middle > (linii(1).point1(:,2) - third)) && ...
                (middle < (linii(1).point1(:,2) + third)))
            if(x >= 1)
                M = [M; 54];
                fprintf(fisier,'Fa D O2\r\n');
            elseif(x <= -7)
                M = [M; 52];
                fprintf(fisier,'Fa B O2\r\n');
            else
                fprintf(fisier,'Fa O2\r\n');
                M = [M; 53];
            end
            continue;
            
        end
        
        % mi second octave
        if(( middle >= (linii(1).point1(:,2) + third)) && ...
                (middle <= (linii(2).point1(:,2) - third)))
            if(x >= 6)
                M = [M; 51];
                fprintf(fisier,'Mi D O2\r\n');
            elseif(x <= -2)
                M = [M; 49];
                fprintf(fisier,'Mi B O2\r\n');
            else
                fprintf(fisier,'Mi O2\r\n');
                M = [M; 50'];
            end
            continue;
        end
        
        % re second octave
        if(( middle > (linii(2).point1(:,2) - third)) && ...
                (middle < (linii(2).point1(:,2) + third)))
            if(x >= 4)
                M = [M; 48];
                fprintf(fisier,'Re D O2\r\n');
            elseif(x <= -4)
                M = [M; 46];
                fprintf(fisier,'Re B O2\r\n');
            else
                fprintf(fisier,'Re O2\r\n');
                M = [M; 47'];
            end
            continue;
        end
        
        % do second octave
        if(( middle >= (linii(2).point1(:,2) + third)) && ...
                (middle <= (linii(3).point1(:,2) - third)))
            if(x >= 2)
                M = [M; 45];
                fprintf(fisier,'Do D O2\r\n');
            elseif(x <= -6)
                M = [M; 43];
                fprintf(fisier,'Do B O2\r\n');
            else
                M = [M; 44];
                fprintf(fisier,'Do O2\r\n');
            end
            continue;
        end
        
        % si first octave
        if(( middle > (linii(3).point1(:,2) - third)) && ...
                (middle < (linii(3).point1(:,2) + third)))
            if(x >= 7)
                M = [M; 42];
                fprintf(fisier,'Si D O1\r\n');
            elseif(x <= -1)
                M = [M; 40];
                fprintf(fisier,'Si B O1\r\n');
            else
                fprintf(fisier,'Si O1\r\n');
                M = [M; 41];
            end
            continue;
        end
        
        % la first octave
        if(( middle >= (linii(3).point1(:,2) + third)) && ...
                (middle <= (linii(4).point1(:,2) - third)))
            if(x >= 5)
                M = [M; 39];
                fprintf(fisier,'La D O1\r\n');
            elseif(x <= -3)
                M = [M; 37];
                fprintf(fisier,'La B O1\r\n');
            else
                fprintf(fisier,'La O1\r\n');
                M = [M; 38'];
            end
            continue;
        end
        
        % sol first octave
        if(( middle > (linii(4).point1(:,2) - third)) && ...
                (middle < (linii(4).point1(:,2) + third)))
            if(x >= 3)
                M = [M; 36];
                fprintf(fisier,'Sol D O1\r\n');
            elseif(x <= -5)
                M = [M; 34];
                fprintf(fisier,'Sol B O1\r\n');
            else
                M = [M; 35];
                fprintf(fisier,'Sol O1\r\n');
            end
            continue;
            
        end
        
        % fa first octave
        if(( middle >= (linii(4).point1(:,2) + third)) && ...
                (middle <= (linii(5).point1(:,2) - third)))
            if(x >= 1)
                M = [M; 33];
                fprintf(fisier,'Fa D O1\r\n');
            elseif(x <= -7)
                M = [M; 31'];
                fprintf(fisier,'Fa B O1\r\n');
            else
                fprintf(fisier,'Fa O1\r\n');
                M = [M; 32];
            end
            continue;
        end
        
        % mi first octave
        if(( middle > (linii(5).point1(:,2) - third)) && ...
                (middle < (linii(5).point1(:,2) + third)))
            if(x >= 6)
                M = [M; 30'];
                fprintf(fisier,'Mi D O1\r\n');
            elseif(x <= -2)
                M = [M; 28];
                fprintf(fisier,'Mi B O1\r\n');
            else
                fprintf(fisier,'Mi O1\r\n');
                M = [M; 29];
            end
            continue;
        end
        
        
    else
        % este in afara portativului
        
        
        if( middle <= linii(5).point1(:,2) + distance - third )
            if(x >= 4)
                M = [M; 27];
                fprintf(fisier,'Re D O1\r\n');
            elseif(x <= -4)
                M = [M; 25];
                fprintf(fisier,'Re B O1\r\n');
            else
                M = [M; 26];
                fprintf(fisier,'Re O1\r\n');
            end
            continue;
            
        elseif( middle < linii(5).point1(:,2) + distance + third )
            if(x >= 2)
                M = [M; 24];
                fprintf(fisier,'Do D O1\r\n');
            elseif(x <= -6)
                M = [M; 22];
                fprintf(fisier,'Do B O1\r\n');
            else
                fprintf(fisier,'Do O1\r\n');
                M = [M; 23];
            end
            continue;
            
        elseif( middle <= linii(5).point1(:,2) + 2 * distance - third )
            if(x >= 7)
                M = [M; 21];
                fprintf(fisier,'Si D OM\r\n');
            elseif(x <= -1)
                M = [M; 19];
                fprintf(fisier,'Si B OM\r\n');
            else
                M = [M; 20];
                fprintf(fisier,'Si OM\r\n');
            end
            continue;
            
        elseif( middle < linii(5).point1(:,2) + 2 * distance + third )
            if(x >= 5)
                M = [M; 18];
                fprintf(fisier,'La D OM\r\n');
            elseif(x <= -3)
                M = [M; 16];
                fprintf(fisier,'La B OM\r\n');
            else
                fprintf(fisier,'La OM\r\n');
                M = [M; 17];
            end
            continue;
            
        elseif( middle <= linii(5).point1(:,2) + 3 * distance - third )
            if(x >= 3)
                M = [M; 15];
                fprintf(fisier,'Sol D OM\r\n');
            elseif(x <= -5)
                M = [M; 13];
                fprintf(fisier,'Sol B OM\r\n');
            else
                M = [M; 14'];
                fprintf(fisier,'Sol OM\r\n');
            end
            continue;
        
        elseif( middle < linii(5).point1(:,2) + 3 * distance + third )
            if(x >= 1)
                M = [M; 12];
                fprintf(fisier,'Fa D OM\r\n');
            elseif(x <= -7)
                M = [M; 10];
                fprintf(fisier,'Fa B OM\r\n');
            else
                fprintf(fisier,'Fa OM\r\n');
                M = [M; 11];
            end
            continue;
            
        elseif( middle <= linii(5).point1(:,2) + 4 * distance - third )
            if(x >= 6)
                fprintf(fisier,'Mi D OM\r\n');
                M = [M; 9];
            elseif(x <= -2)
                fprintf(fisier,'Mi B OM\r\n');
                M = [M; 7'];
            else
                fprintf(fisier,'Mi OM\r\n');
                M = [M; 8];
            end
            continue;
            
        elseif( middle < linii(5).point1(:,2) + 4* distance + third )
            if(x >= 4)
                fprintf(fisier,'Re D OM\r\n');
                M = [M; 6];
            elseif(x <= -4)
                fprintf(fisier,'Re B OM\r\n');
                M = [M; 4];
            else
                fprintf(fisier,'Re OM\r\n');
                M = [M; 5];
            end
            continue;
            
        elseif( middle <= linii(5).point1(:,2) + 5 * distance - third )
            if(x >= 2)
                fprintf(fisier,'Do D OM\r\n');
                M = [M; 3];
            elseif(x <= -6)
                fprintf(fisier,'Do B OM\r\n');
                M = [M; 1];
            else
                fprintf(fisier,'Do OM\r\n');
                M = [M; 2];
            end
            continue;
            
        else
            row(i,:) = [];
            col(i,:) = [];
            fprintf(fisier,'it is too low\r\n');
            continue;
        end
    end
end
fprintf(fisier,'\r\n');


end

