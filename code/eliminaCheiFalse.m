function [rows,cols,height,width] = eliminaCheiFalse(rows,cols,height,width,threshold)

% initialize variables
[h,~] = size(rows);
m1 = max(cols(:,1));
m2 = max(cols(:,2));
fr_array1 = zeros(1,m1);
fr_array2 = zeros(1,m2);

% display all rows and columns
% for i = 1:h
%     disp('----');
%    disp(rows(i,1));
%    disp(rows(i,2));
%    disp(cols(i,1));
%    disp(cols(i,2));
% end

% create a frequency array
for i = 1:h
    fr_array1(cols(i,1)) = fr_array1(cols(i,1)) + 1;
    fr_array2(cols(i,2)) = fr_array2(cols(i,2)) + 1;
end

sum1 = zeros(1,m1);
sum1(1) = fr_array1(1);
sum2 = zeros(1,m2);
sum2(1) = fr_array2(1);

% calculate the 7 pixel zone that has the highest frequency
for i = 2:m1
    if(i-7 > 0)
        sum1(i) = fr_array1(i) + sum1(i-1) - fr_array1(i-7);
    else
        sum1(i) = fr_array1(i) + sum1(i-1);
    end
end

for i = 2:m2
    if(i-7 > 0)
        sum2(i) = fr_array2(i) + sum2(i-1) - fr_array2(i-7);
    else
        sum2(i) = fr_array2(i) + sum2(i-1);
    end
end

[maxim1,poz1] = max(sum1);
[maxim2,poz2] = max(sum2);
poz1 = poz1 - 3;
poz2 = poz2 - 3;

% eliminate all detections that are not in the search zone and are not
% within limits of a threshold 
for j = size(rows,1):-1:1;
    if((abs(cols(j,1) - poz1) > 3) || (abs(cols(j,2) - poz2) > 3) || (cols(j,2) > threshold))
        disp(size(rows));
        disp(size(cols));
        disp(size(height));
        disp(size(width));
        rows(j,:) = [];
        cols(j,:) = [];
        height(j,:) = [];
        width(j,:) = [];
    end
end

% elimintate detections that overlap each other using the following
% criteria: have two sides that are closer that the 'gap'
gap = 11;
for i = size(rows,1):-1:1
    i = min(i,size(rows,1));
   for j = i-1:-1:1
       i = min(i,size(rows,1));
       
       if((i ~= j) && ...
                (((abs(cols(j,1) - cols(i,1)) < gap) && (abs(rows(j,2) - rows(i,2)) < gap)) ||...
                ((abs(cols(j,1) - cols(i,1)) < gap) && (abs(rows(j,1) - rows(i,1)) < gap)) ||...
                ((abs(cols(j,2) - cols(i,2)) < gap) && (abs(rows(j,2) - rows(i,2)) < gap)) ||...
                ((abs(cols(j,2) - cols(i,2)) < gap) && (abs(rows(j,1) - rows(i,1)) < gap))))
           
           rows(j,:) = [];
           cols(j,:) = [];
           height(j) = [];
           width(j) = [];
       end
   end
end

% create an easy-to-use structure in case it is needed later
for i = 1:size(rows,1)
    X = [rows(i,1), rows(i,2),cols(i,1),cols(i,2)];
end

end

