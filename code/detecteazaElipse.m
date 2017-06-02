function [ best ] = detecteazaElipse( img,params )
figure,imtool(img);
% figure,imshow(img);
tic;
[Gmag, Gdir] = imgradient(img,'prewitt');
 disp(Gdir(19:25,42:50));

accumulator = zeros(size(img));

figure
imshowpair(Gmag, Gdir, 'montage');
title('Gradient Magnitude, Gmag (left), and Gradient Direction, Gdir (right), using Prewitt method');
disp(size(img));
disp(size(Gmag));
maxim = max(Gmag(:));
disp(maxim);
[x,y] = find(Gmag > round(maxim*2/3));

s = size(x,1);


for i = 1:size(x,1)
    fprintf('Procesam punctul %d din %d\n',i,s);
    for j = 1:size(x,1)
        x1 = y(i);
        x2 = y(j);
        y1 = x(i);
        y2 = x(j);
        teta1 = Gdir(y1,x1);
        teta2 = Gdir(y2,x2);
        
        if((i ~= j) && (sqrt((x1-x2)^2 + (y1-y2)^2) < 30) && ((abs(teta1) < 88) || (abs(teta1) > 92)) && ((abs(teta2) > 92) || (abs(teta2) < 88)))
            
            m1 = round((x1 + x2)/2);
            m2 = round((y1 + y2)/2);
            t1 = (y1 - y2 - x1*teta1 + x2*teta2)/(teta2 - teta1);
            t2 = (teta1 * teta2 * (x2 - x1) - y2*teta1 + y1*teta2)/(teta2 - teta1);
            for k = 1:size(img,2)
               rez = round((k * (t2 - m2) + m2 * t1 - m1 * t2)/(t1 - m1));
               if(rez > 0 && rez <= size(img,1))
                   accumulator(rez,k) = ...
                       accumulator(rez,k) + 1;
               end
            end
            
            
            
        end
    end
end

maxim_acc = max(accumulator(:));

[centre_x,centre_y] = find(accumulator > maxim_acc*4/5);
[c1,c2] = find(accumulator == maxim_acc);
% disp('------');
% disp(size(centre_x));
% disp(centre_x(1:5));
% disp(size(centre_y));
% disp(centre_y(1:5));

figure,imshow(img);
hold all;
for i = 1:size(centre_x,1)
    plot(centre_y(i),centre_x(i),'b*');
end
plot(c2,c1,'r*');
toc;
keyboard();

end

