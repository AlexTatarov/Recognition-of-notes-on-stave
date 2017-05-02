function [rows,cols] = eliminaCheiFalse(rows,cols,treshold)

[h,~] = size(rows);
rows_aux = rows;
cols_aux = cols;
m1 = max(cols(:,1));
m2 = max(cols(:,2));
disp(m1);
disp(m2);
fr_array1 = zeros(1,m1);
fr_array2 = zeros(1,m2);
for i = 1:h
    fr_array1(cols(i,1)) = fr_array1(cols(i,1)) + 1;
    fr_array2(cols(i,2)) = fr_array2(cols(i,2)) + 1;
end

sum1 = zeros(1,m1);
sum1(1) = fr_array1(1);
sum2 = zeros(1,m2);
sum2(1) = fr_array2(1);

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

disp('rows');
%disp(rows);
disp('cols');
%disp(cols);
[maxim1,poz1] = max(sum1);
[maxim2,poz2] = max(sum2);
poz1 = poz1 - 3;
poz2 = poz2 - 3;


for j = size(rows,1):-1:1;
    
    if((abs(cols(j,1) - poz1) > 3) || (abs(cols(j,2) - poz2) > 3) || (cols(j,2) > treshold))
       rows(j,:) = [];
       cols(j,:) = [];
    end
end

for i = size(rows,1):-1:1
    i = min(i,size(rows,1));
   for j = i-1:-1:1
       i = min(i,size(rows,1));
       disp(size(rows,1));
       disp(i);
       disp(j);
       
       if((i ~= j) && (abs(cols(j,1) - cols(i,1)) < 11) && (abs(rows(j,1) - rows(i,1)) < 11) && (abs(cols(j,2) - cols(i,2)) < 11) && (abs(rows(j,2) - rows(i,2)) < 11))
           rows(j,:) = [];
           cols(j,:) = [];
       end
   end
end

for i = 1:size(rows,1)
    X = [rows(i,1), rows(i,2),cols(i,1),cols(i,2)];
   disp(X);
end
% disp(rows);
% disp(cols);

end

