function [ average ] = obtineInaltimeNota( lines )
% obtain the height of the note using by calculating the mean of the
% distances between 2 adjascent horizontal lines of the stave

sum = 0;

for i = 1:length(lines)-1
    sum = sum + lines(i+1).point1(:,2) - lines(i).point1(:,2);
end

average = round(sum/(length(lines)-1));


end

