function [ lines,dilateBW ] = obtinePozitiaPortativului( imag,gapSize )

if(size(imag,3) > 1)
    imag = rgb2gray(imag);
else
    imag = imag;
end
originalBW = imag;
threshold = mean(originalBW(:));
originalBW = originalBW < threshold;

%figure, imshow(originalBW);
%keyboard;
%originalBW = imcomplement(originalBW);
%originalBW = edge(imag,0.2);
%originalBW = imcomplement(originalBW);
se = strel('line',13,3);
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


% max_len = 0;
% for i = 1:length(lines)
%     disp(getfield(lines(i),'point1'));
%     disp(getfield(lines(i),'point2'));
%     disp(getfield(lines(i),'theta'));
%     disp(getfield(lines(i),'rho'));
% end

%afisareLinii(lines,dilateBW);





end