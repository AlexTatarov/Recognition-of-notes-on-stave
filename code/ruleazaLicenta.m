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
parameters.rezultat = fopen('../data/rezultat.txt','w');
parameters.afisare = 1;
parameters.sound = 0;


% disp(trebuie de perfectat notele);

parameters.bigBlackEllipse = imread('../data/images/blackB.png');
parameters.mediumBlackEllipse = imread('../data/images/blackMM.png');
parameters.smallBlackEllipse = imread('../data/images/blackS.png');
parameters.superSmallBlackEllipse = imread('../data/images/blackSS.png');
parameters.extraSmallBlackEllipse = imread('../data/images/blackXS.png');

parameters.note24 = imread('../data/images/note24.png');
parameters.note20 = imread('../data/images/note20.png');
parameters.note18 = imread('../data/images/note18.png');
parameters.note15 = imread('../data/images/note15.png');
parameters.note12 = imread('../data/images/note12.png');
parameters.note10 = imread('../data/images/note10.png');
parameters.note8  = imread('../data/images/note8.png');
parameters.note5  = imread('../data/images/note5.png');
parameters.note4  = imread('../data/images/note4.png');

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

% noteHeight = 11
% img = imread('../data/images/Simple.jpg');

% noteHeight = 9
% img = imread('../data/images/Joy.jpg');
% img = imread('../data/images/Twinkle.jpg');
% img = imread('../data/images/Battle.png');
% img = imread('../data/images/House.jpg');
% img = imread('../data/images/Scale3.png');

% noteHeight = 8
% img = imread('../data/images/jingle-bells-2.jpeg');
% img = imread('../data/images/silence.jpg');

% noteHeight = 7
% img = imread('../data/images/Scale1.jpg');

% noteHeight = 6
% img = imread('../data/images/Let.jpg');
% img = imread('../data/images/Cobzar.png');

% noteHeight = 5
% img = imread('../data/images/Lion.jpg');
% img = imread('../data/images/Bohemian.jpg');
% img = imread('../data/images/Vivaldi.jpg');

% noteHeight = 3
% img = imread('../data/images/hallelujah.jpg');

% noteHeight = ?
% img = imread('../data/images/Happy5.jpg');
% img = imread('../data/images/Bridal.png');




%vom afisa anotarile aici
%marcheazaAnotari(img);
M = [];
L = [];
parameters.img = img;

[row, col, clefHeight, clefWidth] = obtinePozitiaCheii(parameters);

treshold = size(img,2)/4;
[row, col, clefHeight, clefWidth] = eliminaCheiFalse(row,col,clefHeight,clefWidth,treshold);


if(parameters.afisare == 1)
    figure, imshow(img);
    hold on;
    for i = 1:size(row,1)
        x = [ row(i,1), row(i,2), row(i,2) , row(i,1), row(i,1)];
        y = [ col(i,1), col(i,1), col(i,2) , col(i,2), col(i,1)];
        plot( y, x, 'b-','linewidth',1);
    end
    hold off;
end

% sort all clefs
for i = 1:size(row,1)
    for j = i+1:size(row,1)
        if((i ~= j) && (row(i,1) > row(j,1)))
            row([i,j],:) = row([j,i],:);
            col([i,j],:) = col([j,i],:);
        end
    end
end

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
        
        [lines,validation] = validareLinii(lines);
        gap = gap + 5;
        if(gap > 50)
            break;
        end
    end
    
    if(length(lines) ~= 5)
        disp('Error');
    end
    if(parameters.afisare == 1)
        afisareLinii(lines,imgBW);
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
        parameters.noteHeight = obtineInaltimeNota(lines);
        
        parameters.firstLines = lines;
        parameters.firstImg = lineImg;
%         disp(i);
%         figure,imshow(parameters.firstImg);
        % obtain the height of a note
        
        x = obtineSemneCheie(parameters,row,col,clefWidth);
%         disp(x);
    end
    
    %     for k = 1:length(lines)
    %        disp(lines(k).point1);
    %     end
%     fprintf('Linii verticale sunt %d\n',length(lines));
    parameters.horizontalLines = lines;
    parameters.currentClefHeight = clefHeight(i);
    parameters.currentClefWidth = clefWidth(i);
    
    
    
    
    
    % obtain the position of notes on that stave
    [M_aux,L_aux] = obtinePozitiaNotelor(parameters,lineImg,x);
    M = [M;M_aux];
    L = [L; L_aux];
end


if(parameters.sound == 1)
    fprintf('Please wait a couple of seconds while your song is loaded...\n');
    l = sum(L);
    marime=numel(M);
    y=zeros(marime* 22050*l,1);
%     Note will decay on 1 second
%     to make it 5 seconds
%     y=zeros(size* 22050*5,1); and make inner loop for j=1: 22050*5
    lastpos = 0;
    for i=1:marime
        for j=1:22050*L(i)
            lastpos = lastpos + 1;
            if(M(i)==1)
                y( lastpos)=sin(2*pi*61*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==2)
                y( lastpos)=sin(2*pi*65*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==3)
                y( lastpos)=sin(2*pi*69*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==4)
                y( lastpos)=sin(2*pi*69*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==5)
                y( lastpos)=sin(2*pi*73*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==6)
                y( lastpos)=sin(2*pi*77*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==7)
                y( lastpos)=sin(2*pi*77*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==8)
                y( lastpos)=sin(2*pi*82*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==9)
                y( lastpos)=sin(2*pi*87*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==10)
                y( lastpos)=sin(2*pi*82*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==11)
                y( lastpos)=sin(2*pi*87*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==12)
                y( lastpos)=sin(2*pi*92*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==13)
                y( lastpos)=sin(2*pi*92*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==14)
                y( lastpos)=sin(2*pi*98*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==15)
                y( lastpos)=sin(2*pi*103*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==16)
                y( lastpos)=sin(2*pi*103*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==17)
                y( lastpos)=sin(2*pi*110*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==18)
                y( lastpos)=sin(2*pi*116*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==19)
                y( lastpos)=sin(2*pi*116*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==20)
                y( lastpos)=sin(2*pi*123*j/ 22050) .* exp(-2*j/ 22050);
                
                
                
                
            elseif(M(i)==21)
                y( lastpos)=sin(2*pi*130*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==22)
                y( lastpos)=sin(2*pi*138*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==23)
                y( lastpos)=sin(2*pi*130*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==24)
                y( lastpos)=sin(2*pi*138*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==25)
                y( lastpos)=sin(2*pi*138*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==26)
                y( lastpos)=sin(2*pi*146*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==27)
                y( lastpos)=sin(2*pi*155*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==28)
                y( lastpos)=sin(2*pi*155*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==29)
                y( lastpos)=sin(2*pi*164*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==30)
                y( lastpos)=sin(2*pi*174*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==31)
                y( lastpos)=sin(2*pi*164*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==32)
                y( lastpos)=sin(2*pi*174*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==33)
                y( lastpos)=sin(2*pi*185*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==34)
                y( lastpos)=sin(2*pi*185*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==35)
                y( lastpos)=sin(2*pi*196*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==36)
                y( lastpos)=sin(2*pi*207*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==37)
                y( lastpos)=sin(2*pi*207*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==38)
                y( lastpos)=sin(2*pi*220*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==39)
                y( lastpos)=sin(2*pi*233*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==40)
                y( lastpos)=sin(2*pi*233*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==41)
                y( lastpos)=sin(2*pi*246*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==42)
                y( lastpos)=sin(2*pi*261*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==43)
                y( lastpos)=sin(2*pi*246*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==44)
                y( lastpos)=sin(2*pi*261*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==45)
                y( lastpos)=sin(2*pi*277*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==46)
                y( lastpos)=sin(2*pi*277*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==47)
                y( lastpos)=sin(2*pi*293*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==48)
                y( lastpos)=sin(2*pi*311*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==49)
                y( lastpos)=sin(2*pi*311*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==50)
                y( lastpos)=sin(2*pi*329*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==51)
                y( lastpos)=sin(2*pi*349*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==52)
                y( lastpos)=sin(2*pi*329*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==53)
                y( lastpos)=sin(2*pi*349*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==54)
                y( lastpos)=sin(2*pi*370*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==55)
                y( lastpos)=sin(2*pi*370*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==56)
                y( lastpos)=sin(2*pi*392*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==57)
                y( lastpos)=sin(2*pi*415*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==58)
                y( lastpos)=sin(2*pi*415*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==59)
                y( lastpos)=sin(2*pi*440*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==60)
                y( lastpos)=sin(2*pi*466*j/ 22050) .* exp(-2*j/ 22050);
                %
            elseif(M(i)==61)
                y( lastpos)=sin(2*pi*466*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==62)
                y( lastpos)=sin(2*pi*494*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==63)
                y( lastpos)=sin(2*pi*523*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==64)
                y( lastpos)=sin(2*pi*494*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==65)
                y( lastpos)=sin(2*pi*523*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==66)
                y( lastpos)=sin(2*pi*554*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==67)
                y( lastpos)=sin(2*pi*554*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==68)
                y( lastpos)=sin(2*pi*587*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==69)
                y( lastpos)=sin(2*pi*622*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==70)
                y( lastpos)=sin(2*pi*622*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==71)
                y( lastpos)=sin(2*pi*659*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==72)
                y( lastpos)=sin(2*pi*698*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==73)
                y( lastpos)=sin(2*pi*659*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==74)
                y( lastpos)=sin(2*pi*698*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==75)
                y( lastpos)=sin(2*pi*740*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==76)
                y( lastpos)=sin(2*pi*740*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==77)
                y( lastpos)=sin(2*pi*783*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==78)
                y( lastpos)=sin(2*pi*830*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==79)
                y( lastpos)=sin(2*pi*830*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==80)
                y( lastpos)=sin(2*pi*880*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==81)
                y( lastpos)=sin(2*pi*932*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==82)
                y( lastpos)=sin(2*pi*932*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==83)
                y( lastpos)=sin(2*pi*987*j/ 22050) .* exp(-2*j/ 22050);
            elseif(M(i)==84)
                y( lastpos)=sin(2*pi*1046*j/ 22050) .* exp(-2*j/ 22050);
            end
        end
    end
    player = audioplayer(y, 22050);
    player.play();
end



% result = obtinePozitiaNotelorNegre(parameters);
% result = obtinePozitiaNotelorAlbe(parameters);






