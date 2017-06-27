% This code demonstrates how to differentiate between the different types
% of Acoustic Partial Discharge Signals using the Probability Desnity
% Function (PDF) as a representatibve feature vector.

% The method is computationally simple and achieves a classification
% accuracy of 99.0196% to discriminate between the Corona, Surface and Void
% PD Signals (Three-Classes Problem). The Random Forest Classifier with 66% 
% SPLIT MODE is used to train and test the extracted features.

% Authors: 
% (1) Ramy Hussein, University of British Columbia, Vancouver, BC, Canada.
% Email: ramy@ece.ubc.ca; 
% (2) Khaled Bashir Shaban, Qatar University, Doha, Qatar.
% Email: Khaled.shaban@qu.edu.qa
% (3) Ayman H. El-Hag, American University of Sharjah, Sharjah, UAE.
% Email: aelhag@aus.edu
 
clear; clc; % Clear The Matlab Command Window and Workspace

% load time axis 
load('time_Acoustic.mat');

index = 1; 

numfiles = 100;

for k = 1:numfiles
    
%% Load Corona PD signal
addpath(genpath('/Users/ramyhussein/Documents/SmartGridProject/9th paper_Conference/Matlab/1- Corona_Sharp'))
myfilename = sprintf('sample (%d).mat', k);
mydata{k} = importdata(myfilename);
PD = cell2mat(mydata(k));

% Simple filtering for PD signals (suppress the severe outliers)
PD = smooth(PD);
PD = smooth(PD);
PD = smooth(PD);

% Noisy PD signal Signal (NPD)
% SNR = 0; % Signal to Noise Ratio
% NPD = awgn(PD, SNR, 'measured');

m = mean(PD); % mean absolute value of the PD signal
s = std(PD); % standard deviation of the PD signal
[PDF,xi] = ksdensity(PD); % Probability Distribution Function (PDF) of of the PD signal
% plot(xi,PDF);
data(index,:)=[PDF m s 0]; % Feature Vector

index=index+1;
end

for k = 1:numfiles
%% Load Surface PD signal
addpath(genpath('/Users/ramyhussein/Documents/SmartGridProject/9th paper_Conference/Matlab/2- Surface_Discharge_Sharp'))
myfilename = sprintf('sample (%d).mat', k);
mydata{k} = importdata(myfilename);
PD = cell2mat(mydata(k));

% Simple filtering for PD signals (suppress the severe outliers)
PD = smooth(PD);
PD = smooth(PD);
PD = smooth(PD);

% Noisy PD signal Signal (NPD)
% SNR = 0; % Signal to Noise Ratio
% NPD = awgn(PD, SNR, 'measured');

% Feature Extraction
m = mean(PD); % mean absolute value of the PD signal
s = std(PD); % standard deviation of the PD signal
[PDF,xi] = ksdensity(PD); % Probability Distribution Function (PDF) of the PD signal
% plot(xi,PDF);
data(index,:)=[PDF m s 1]; % Feature Vector

index=index+1;

end

for k = 1:numfiles
%% Load Parallel PD signal
addpath(genpath('/Users/ramyhussein/Documents/SmartGridProject/9th paper_Conference/Matlab/4- Void'))
myfilename = sprintf('sample (%d).mat', k);
mydata{k} = importdata(myfilename);
PD = cell2mat(mydata(k));

% Simple filtering for PD signals (suppress the severe outliers)
PD = smooth(PD);
PD = smooth(PD);
PD = smooth(PD);

% Noisy PD signal (NPD)
% SNR = 0; % Signal-to-Noise Ratio
% NPD = awgn(PD, SNR, 'measured');

% Feature Extraction
m = mean(PD); % mean absolute value of the PD signal
s = std(PD); % standard deviation of the PD signal
[PDF,xi] = ksdensity(PD); % Probability Distribution Function (PDF) of the PD signal
% plot(xi,PDF);
data(index,:)=[PDF m s 2]; % Feature Vector

index=index+1;

end

    Data=data(:,1:end-1);
    % Save the Feature Vector file as .CSV (Can be used in WEKA software)
    csvwrite('PDClassification_PDF.csv',Data,1,0);
   
    