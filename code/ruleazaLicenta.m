%% aceasta este prima pagina a licentei
%%la moment are loc doar afisarea imaginii upload-ate

parameters.dataPath = '../data/' ;
parameters.imageFolder = fullfile(parameters.dataPath, 'images');
parameters.annotations = 1;
parameters.img = imread('../data/images/hallelujah.jpg');
parameters.clef = imread('../data/images/cheia_sol.png');
parameters.whiteNote = imread('../data/images/nota_alba_paint4.png');
parameters.blackNote = imread('../data/images/BlackDown3.png');
parameters.stave = imread('../data/images/Portativ4.png');


%img = imread('../data/images/jingle-bells-2.jpeg');
%img = imread('../data/images/hallelujah.jpg');
img = imread('../data/images/Lion.jpg');
%img = imread('../data/images/Bohemian.jpg');
%size(img);
%img = rgb2gray(img);
%imtool(img);


%vom afisa anotarile aici
%marcheazaAnotari(img);

parameters.img = img;

parameters.cheie = imread('../data/images/cheia_sol.png');

[row,col] = obtinePozitiaCheii(parameters);

treshold = size(img,2)/4;
[row,col] = eliminaCheiFalse(row,col,treshold);

% figure()
% 
% imshow(img);
%imtool(img);
%hold on;


for i = 1:size(row,1)
    x = [ row(i,1), row(i,2), row(i,2) , row(i,1), row(i,1)];
    y = [ col(i,1), col(i,1), col(i,2) , col(i,2), col(i,1)];
    %plot( y, x, 'g-','linewidth',1);
end
%pause();
%hold off;
%disp(size(img));
imshow(img);
size(img)
d1 = size(img,1);
d2 = size(img,2);
gap = 5;
for i = 1:size(row,1)
    sus = min(row(i,2),size(img,1));
    jos = max(row(i,1),0);
    imag = img(jos:sus,1:d2);
    validare = false;
    lines = obtinePozitiaPortativului(imag,gap);
    while(validareLinii(lines) == false)
        gap = gap + 5;
        lines = obtinePozitiaPortativului(imag,gap);
    end
     
end




%result = obtinePozitiaNotelorNegre(parameters);
%result = obtinePozitiaNotelorAlbe(parameters);

%imshow(img);





