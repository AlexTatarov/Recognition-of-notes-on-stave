%% aceasta este prima pagina a licentei


parameters.dataPath = '../data/' ;
parameters.imageFolder = fullfile(parameters.dataPath, 'images');
parameters.annotations = 1;
parameters.img = imread('../data/images/hallelujah.jpg');
parameters.clef = imread('../data/images/signature-0.png');
parameters.whiteUp = imread('../data/images/whiteUp.png');
parameters.whiteDown = imread('../data/images/whiteDown.png');
parameters.blackUp = imread('../data/images/blackUp.png');
parameters.blackDown = imread('../data/images/blackDown.png');
parameters.stave = imread('../data/images/Portativ4.png');
% parameters.diez = imread('../data/images/diez.png');
parameters.bemol = imread('../data/images/bemol.png');
parameters.becar = imread('../data/images/becar.png');
parameters.bigBlackEllipse = imread('../data/images/blackB.png');
parameters.smallBlackEllipse = imread('../data/images/blackS.png');
parameters.superSmallBlackEllipse = imread('../data/images/blackSS.png');
parameters.extraSmallBlackEllipse = imread('../data/images/blackXS.png');

parameters.bigHalf = imread('../data/images/halfB.png');
parameters.mediumHalf = imread('../data/images/halfM.png');
parameters.smallHalf = imread('../data/images/halfS.png');
parameters.extraSmallHalf = imread('../data/images/halfXS.png');

parameters.bigDiez = imread('../data/images/diezB.png');
parameters.mediumDiez = imread('../data/images/diezM.png');
parameters.smallDiez = imread('../data/images/diezS.png');
parameters.extraSmallDiez = imread('../data/images/diezXS.png');

parameters.bigWhole = imread('../data/images/wholeB.png');
parameters.mediumWhole = imread('../data/images/wholeM.png');
% parameters.mediumWhole = imread('../data/images/nota_alba_paint3.png');
parameters.smallWhole = imread('../data/images/wholeS.png');
parameters.extraSmallWhole = imread('../data/images/wholeXS.png');

parameters.cheie = imread('../data/images/signature-0.png');



img = imread('../data/images/jingle-bells-2.jpeg');
% img = imread('../data/images/Simple.jpg');
% img = imread('../data/images/Joy.jpg');
% img = imread('../data/images/House.jpg');
% img = imread('../data/images/hallelujah.jpg');
% img = imread('../data/images/Cobzar.png');
% img = imread('../data/images/Lion.jpg');
% img = imread('../data/images/Bohemian.jpg');
% img = imread('../data/images/Vivaldi.jpg');
img = imread('../data/images/Scale1.jpg');
% img = imread('../data/images/Scale3.png');
% img = imread('../data/images/Twinkle.jpg');
% size(img);
% img = rgb2gray(img);
% imtool(img);
% img = imread('peppers.png');
% img = rgb2gray(img);
% imtool(img);
% keyboard();
%vom afisa anotarile aici
%marcheazaAnotari(img);

parameters.img = img;
disp(size(img));

[row, col, clefHeight, clefWidth] = obtinePozitiaCheii(parameters);

treshold = size(img,2)/4;
[row, col, clefHeight, clefWidth] = eliminaCheiFalse(row,col,clefHeight,clefWidth,treshold);

% figure()

% figure, imshow(img);

% hold on;


% for i = 1:size(row,1)
%     x = [ row(i,1), row(i,2), row(i,2) , row(i,1), row(i,1)];
%     y = [ col(i,1), col(i,1), col(i,2) , col(i,2), col(i,1)];
%     plot( y, x, 'b-','linewidth',1);
% end
% hold off;

% sort all clefs
for i = 1:size(row,1)
    for j = i+1:size(row,1)
        if((i ~= j) && (row(i,1) > row(j,1)))
            row([i,j],:) = row([j,i],:);
            col([i,j],:) = col([j,i],:);
        end
    end
end
disp(row);
disp(col);

d1 = size(img,1);
d2 = size(img,2);
gap = 5;
for i = 1:size(row,1)
    sus = min(row(i,2) + round(clefHeight(i)/2),size(img,1));
    jos = max(row(i,1) - round(clefHeight(i)/2),1);
    lineImg = img(jos:sus,col(i,2)-3:d2);
    validation = false;
    
    while(validation == false)
        [lines, imgBW] = obtinePozitiaPortativului(lineImg,gap);
%         afisareLinii(lines,imgBW);

        [lines,validation] = validareLinii(lines);
        gap = gap + 5;
        if(gap > 50)
            break;
        end
    end
%     afisareLinii(lines,imgBW);
    % sort lines in ascending order
    for k = 1:length(lines)
        for j = k+1:length(lines)
           if(lines(k).point1(:,2) > lines(j).point1(:,2))
               lines([k,j]) = lines([j,k]);
           end
        end
    end
    if(i==1)
       parameters.noteHeigth = obtineInaltimeNota(lines); 
    end
    if((size(row,1) == 1) || (i == 2))
        parameters.firstLines = lines;
        parameters.firstImg = lineImg;
        disp(i);
        figure,imshow(parameters.firstImg);
        % obtain the height of a note
        
        x = obtineSemneCheie(parameters,row,col,clefWidth);
%         disp(x);
        disp('S-a trecut pe aici');
    end
    
%     for k = 1:length(lines)
%        disp(lines(k).point1);
%     end
    fprintf('Linii verticale sunt %d\n',length(lines));
    parameters.horizontalLines = lines;
    parameters.currentClefHeight = clefHeight(i);
    parameters.currentClefWidth = clefWidth(i);
    
    
    
    
    
    tic;
    % obtain the position of notes on that stave
    obtinePozitiaNotelor(parameters,lineImg);
    toc;
end







% result = obtinePozitiaNotelorNegre(parameters);
% result = obtinePozitiaNotelorAlbe(parameters);






