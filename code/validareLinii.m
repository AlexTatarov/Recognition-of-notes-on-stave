function [lines,answer] = validareLinii( lines )
%In case there are more than 5 lines for the formation of stave there will
%be eliminated the lines that are 
d = length(lines);
i = 1;
while(i < d)
    
    d = length(lines);
    
    
    
    delete = false;
    
    for j = i+1:d
        diff1 = abs(lines(i).point1(:,2) - lines(j).point1(:,2));
        diff2 = abs(lines(i).point2(:,2) - lines(j).point2(:,2));
        disp(lines(i).point1(:,2));
        disp(lines(j).point1(:,2));
        disp(lines(i).point2(:,2));
        disp(lines(j).point2(:,2));
        if((diff1 < 3) && (diff2 < 3))   
            disp('ultimele 4 au fost sterse');
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

if(length(lines) ~= 5)
    answer = false;
else 
    answer = true;
end

end

