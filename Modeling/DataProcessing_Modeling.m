% This code creates the same sized feature matrices for both the seed  
% patients and the test patients and stores them in a single data file
% "Data_Modeling.mat".

clear all; close all; clc;

% Set the directory to the present working directory. This directory should
% contain all the .csv files containing the OMOP CDM data. It is  
% currently set to the present working directory (pwd). In case the .csv   
% data files are stored in another directory, please provide the path of  
% that directory instead of pwd.
folder=pwd;

% Load the seed patient data
load([folder '\Seedpatients_data.mat']);
labstart=4;labend=3+size(datalab,2);
conceptidsseed=conceptids;
dataseed=data;

% Load EHR random sample data
load([folder '\Randomsample_data.mat']);
conceptidsrand=conceptids;
datarandold=data;

% Extract the same features from the random patient sample as are present
% for the seed patient set.

datarand=[];
for n=1:size(conceptidsseed,2)
    clear a b;
    [a,b]=ismember(conceptidsseed(n),conceptidsrand);
    if a==0
        if n>labstart-1 && n<labend+1
            datarand=cat(2,datarand,nan(size(datarandold,1),1));
        else
            datarand=cat(2,datarand,zeros(size(datarandold,1),1));
        end
    else
            datarand=cat(2,datarand,datarandold(:,b));
    end
end

% Save the data files created for the seed patient set and the EHR random 
% sample in a single .mat file.
save([folder '\Data_modeling.mat'],'dataseed','datarand','conceptidsseed','conceptidsrand','labstart','labend');
