function [  ] = obtinePozitiaPortativului( imag )

if(size(imag,3) > 1)
    imag = rgb2gray(imag);
else
    imag = imag;
end
originalBW = imag;
threshold = mean(originalBW(:));
originalBW = originalBW < threshold;
figure, imshow(originalBW);
%keyboard;
%originalBW = imcomplement(originalBW);
%originalBW = edge(imag,0.2);
%originalBW = imcomplement(originalBW);
se = strel('line',15,3);
%originalBW = edge(originalBW,0.1);
erodeBW = imerode(originalBW,se);
dilateBW = imdilate(erodeBW,se);

% se = strel('line',4,4);
% %originalBW = edge(originalBW,0.1);
% erodeBW = imerode(dilateBW,se);
% dilateBW = imdilate(erodeBW,se);

[H,T,R] = hough(dilateBW);
%imshow(dilateBW);
P  = houghpeaks(H,25,'threshold',ceil(0.07*max(H(:))),'NHoodSize',[1 1]);
%x = T(P(:,2)); y = R(P(:,1));
figure, imagesc(H);

lines = houghlines(dilateBW,T,R,P,'FillGap',5,'MinLength',size(originalBW,2)/2);
%figure, imshow(erodeBW), hold on
figure, imshow(dilateBW), hold all
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end

keyboard;



end