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


img = imread('../data/images/jingle-bells-2.jpeg');

size(img);
%img = rgb2gray(img);
%imtool(img);

%vom afisa anotarile aici
%marcheazaAnotari(img);

parameters.img = img;

parameters.cheie = imread('../data/images/cheia_sol.png');

%result = obtinePozitiaCheii(parameters);
%result = obtinePozitiaNotelorNegre(parameters);
result = obtinePozitiaNotelorAlbe(parameters);
%result = obtinePozitiaPortativului(parameters);
%imshow(img);





