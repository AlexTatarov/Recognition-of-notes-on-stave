function [  ] = obtinePozitiaNotelor(parameters, img )

tic;
if(size(img,3) > 1)
    img = rgb2gray(img);
end
% try to detect black notes(1/4, 1/8, 1/16)
rezultat = obtineNoteNegre(parameters,img);


end



