function [  ] = obtinePozitiaNotelor( img )

if(size(img,3) > 1)
    img = rgb2gray(img);
end

original = img;
threshold = mean(original(:));
original = original < threshold;


se = strel('line',11,90);

erodeBW = imerode(original,se);
dilateBW = imdilate(erodeBW,se);

imshow(dilateBW);


end



