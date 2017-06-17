function [ ] = obtainNoteValue( parameters, row, col )
% will detect the value of a note by comparing its middle height point with
% the position of the horizontal lines

linii = parameters.horizontalLines;
distance = parameters.noteHeight;
% fprintf('Numarul de linii este %d\n',length(linii));
% for i = 1:length(linii)
%     fprintf('Valoarea este %d\n',i);
%     disp(linii(i).point1(:,1));
%     disp(linii(i).point1(:,2));
%     disp(linii(i).point2(:,1));
%     disp(linii(i).point2(:,2));
% end
third = round(distance/3);

for i = 1:size(row,1)
    
    middle = (row(i,1) + row(i,2))/2;
    
    if( middle < linii(1).point1(:,2) - third)
        %aici este mai sus de portativ
        
        if( middle >= linii(1).point1(:,2) - distance + third )
            fprintf('sol octava 2\n');
            continue;
        elseif( middle > linii(1).point1(:,2) - distance - third )
            fprintf('la octava 2\n');
            continue;
        elseif( middle >= linii(1).point1(:,2) - 2 * distance + third )
            fprintf('si octava 2\n');
            continue;
        elseif( middle > linii(1).point1(:,2) - 2 * distance - third )
            fprintf('do octava 3\n');
            continue;
        elseif( middle >= linii(1).point1(:,2) - 3 * distance + third )
            fprintf('re octava 3\n');
            continue;
        elseif( middle > linii(1).point1(:,2) - 3 * distance - third )
            fprintf('mi octava 3\n');
            continue;
        elseif( middle >= linii(1).point1(:,2) - 4 * distance + third )
            fprintf('fa octava 3\n');
            continue;
        elseif( middle > linii(1).point1(:,2) - 4 * distance - third )
            fprintf('sol octava 3\n');
            continue;
        elseif( middle >= linii(1).point1(:,2) - 5 * distance + third )
            fprintf('la octava 3\n');
            continue;
        elseif( middle > linii(1).point1(:,2) - 5 * distance - third )
            fprintf('si octava 3\n');
            continue;
        else
            fprintf('it is too high\n');
            continue;
        end
        
    elseif(( middle > (linii(1).point1(:,2) - third)) && ...
            (middle < (linii(5).point1(:,2) + third)))
        % este in interiorul portativului
        
        % fa second octave
        if(( middle > (linii(1).point1(:,2) - third)) && ...
                (middle < (linii(1).point1(:,2) + third)))
            fprintf('fa octava 2\n');
            continue;
        end
        
        % mi second octave
        if(( middle >= (linii(1).point1(:,2) + third)) && ...
                (middle <= (linii(2).point1(:,2) - third)))
            fprintf('mi octava 2\n');
            continue;
        end
        
        % re second octave
        if(( middle > (linii(2).point1(:,2) - third)) && ...
                (middle < (linii(2).point1(:,2) + third)))
            fprintf('re octava 2\n');
            continue;
        end
        
        % do second octave
        if(( middle >= (linii(2).point1(:,2) + third)) && ...
                (middle <= (linii(3).point1(:,2) - third)))
            fprintf('do octava 2\n');
            continue;
        end
        
        % si first octave
        if(( middle > (linii(3).point1(:,2) - third)) && ...
                (middle < (linii(3).point1(:,2) + third)))
            fprintf('si octava 1\n');
            continue;
        end
        
        % la first octave
        if(( middle >= (linii(3).point1(:,2) + third)) && ...
                (middle <= (linii(4).point1(:,2) - third)))
            fprintf('la octava 1\n');
            continue;
        end
        
        % sol first octave
        if(( middle > (linii(4).point1(:,2) - third)) && ...
                (middle < (linii(4).point1(:,2) + third)))
            fprintf('sol octava 1\n');
            continue;
        end
        
        % fa first octave
        if(( middle >= (linii(4).point1(:,2) + third)) && ...
                (middle <= (linii(5).point1(:,2) - third)))
            fprintf('fa octava 1\n');
            continue;
        end
        
        % mi first octave
        if(( middle > (linii(5).point1(:,2) - third)) && ...
                (middle < (linii(5).point1(:,2) + third)))
            fprintf('mi octava 1\n');
            continue;
        end
        
        
    else
        % este in afara portativului
        
        
        if( middle <= linii(5).point1(:,2) + distance - third )
            fprintf('re octava 1\n');
            continue;
        elseif( middle < linii(5).point1(:,2) + distance + third )
            fprintf('do octava 1\n');
            continue;
        elseif( middle <= linii(5).point1(:,2) + 2 * distance - third )
            fprintf('si octava mica\n');
            continue;
        elseif( middle < linii(5).point1(:,2) + 2 * distance + third )
            fprintf('la octava mica\n');
            continue;
        elseif( middle <= linii(5).point1(:,2) + 3 * distance - third )
            fprintf('sol octava mica\n');
            continue;
            elseif( middle < linii(5).point1(:,2) + 3 * distance + third )
            fprintf('fa octava mica\n');
            continue;
        elseif( middle <= linii(5).point1(:,2) + 4 * distance - third )
            fprintf('mi octava mica\n');
            continue;
            elseif( middle < linii(5).point1(:,2) + 4* distance + third )
            fprintf('re octava 1\n');
            continue;
        elseif( middle <= linii(5).point1(:,2) + 5 * distance - third )
            fprintf('do octava mica\n');
            continue;
            
        else
            fprintf('it is too low\n');
            continue;
        end
    end
end


end

