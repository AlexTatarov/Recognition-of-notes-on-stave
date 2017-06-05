function [  ] = obtinePozitiaNotelor(parameters, img )

tic;
if(size(img,3) > 1)
    img = rgb2gray(img);
end
% try to detect black notes(1/4, 1/8, 1/16)
[row,col,type] = obtineNoteNegre(parameters,img);


% try to detect halves(1/2)
% [row, col, type] = obtineNoteDoime(parameters,img);

% try to detect full notes(1/1)
[row,col,type] = obtineNoteIntregi(parameters,img);

end



