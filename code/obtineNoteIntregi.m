function [ row,col ] = obtineNoteIntregi( parameters,img )
%OBTINENOTEINTREGI Summary of this function goes here
%   Detailed explanation goes here

if(parameters.noteHeight >= 20)
    type = 0;
    black = rgb2gray(parameters.bigWhite);
    maxThreshold = 0.65;
    repetitions = 100;
    
elseif((parameters.noteHeight > 13) && (parameters.noteHeight < 20))
    type = 1;
    black = rgb2gray(parameters.mediumWhite);
    maxThreshold = 0.65;
    repetitions = 7;
    
elseif((parameters.noteHeight > 5 ) && (parameters.noteHeight <= 13))
    type = 2;
    black = rgb2gray(parameters.smallWhite);
    maxThreshold = 0.65;
    repetitions = 7;
    
else
    type = 3;
    black = rgb2gray(parameters.extraSmallWhite);
    repetitions = 1;
    maxThreshold = 0.8;
    
end
end
