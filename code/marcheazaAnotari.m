function [ img ] = marcheazaAnotari( img )
%se vor citi anotarile corespunzatoare din fisierul /data/annotations si se
%vor marca pe imaginea primita

fileID = fopen('../data/annotations/jingle-bells-1.txt');
annotations = textscan(fileID, '%d %d %d %d %d %d');

no_annotations = size(annotations{1},1);

figure(4)
imshow(img);
hold on;
disp(annotations{1}(1));
x = [annotations{1}(1), annotations{3}(1), annotations{3}(1), annotations{1}(1), annotations{1}(1)];
y = [annotations{2}(1), annotations{2}(1), annotations{4}(1), annotations{4}(1), annotations{2}(1)];
plot(x,y,'r-','linewidth',1);
%color the border as given by the annotations
for i = 1:no_annotations
    
    x = [annotations{1}(i), annotations{3}(i), annotations{3}(i), annotations{1}(i), annotations{1}(i)];
    y = [annotations{2}(i), annotations{2}(i), annotations{4}(i), annotations{4}(i), annotations{2}(i)];

   plot(x,y,'r-','linewidth',1);
    
    
end

hold off;






end

