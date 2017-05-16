function [ lines,dilateBW ] = obtinePozitiaPortativului( imag,gapSize )

if(size(imag,3) > 1)
    imag = rgb2gray(imag);
else
    imag = imag;
end
originalBW = imag;
threshold = mean(originalBW(:));
originalBW = originalBW < threshold;


se = strel('line',13,0);
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
%figure, imagesc(H);

lines = houghlines(dilateBW,T,R,P,'FillGap',gapSize,'MinLength',size(originalBW,2)/2);
%figure, imshow(erodeBW), hold on








end