function [lines,answer] = validareLinii( lines )
%In case there are more than 5 lines for the formation of stave there will
%be eliminated the lines that are

%Eliminate the lines that are in closer than the neighbourhood set by
%distance parameter
distance = 3;
d = length(lines);
i = 1;
while(i < d)
    d = length(lines);
    delete = false;
    
    for j = i+1:d
        diff1 = abs(lines(i).point1(:,2) - lines(j).point1(:,2));
        diff2 = abs(lines(i).point2(:,2) - lines(j).point2(:,2));
        %disp(lines(i).point1(:,2));
        %disp(lines(j).point1(:,2));
        %disp(lines(i).point2(:,2));
        %disp(lines(j).point2(:,2));
        if((diff1 < distance) && (diff2 < distance))
            lines(j) = [];
            delete = true;
            break;
        end
    end
    
    %If a line is deleted, we search through all the lines from the
    %beginning of the array because of 'Index exceeds matrix dimensions' in Matlab
    if(delete == true)
        d = length(lines);
        continue;
    else
        i = i+1;
    end
    d = length(lines);
end

%Verify that the number of lines is exactly 5, otherwise we return an error that
%shows that we could not find exactly 5 lines of which the stave is made
if(length(lines) ~= 5)
    answer = false;
else
    answer = true;
end

end

