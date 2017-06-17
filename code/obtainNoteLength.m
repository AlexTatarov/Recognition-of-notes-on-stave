function [  ] = obtainNoteLength( original, vertLines, foundLines )
%OBTAINNOTELENGTH Summary of this function goes here
%   Detailed explanation goes here
se = strel('line',9,45);

erodeBW = imerode(original,se);
dilateBW = imdilate(erodeBW,se);

figure,imshow(original);
[H,T,R] = hough(dilateBW,'Theta',[43:47]);
%imshow(dilateBW);
P  = houghpeaks(H,500,'Threshold',0.1*max(H(:)),'NHoodSize',[3 3]);
%x = T(P(:,2)); y = R(P(:,1));

% figure,imshow(dilateBW);
obliqueLines = houghlines(dilateBW,T,R,P,'FillGap',3,'MinLength',9);
% afisareLinii(obliqueLines,dilateBW);
% keyboard();
end

