% This code pre-processes the data from the randomly selected n test  
% patients and stores them in a single data file "Randomsample_data.mat"
% that will be used in the  "DataProcessing_Modeling.m" code and the cohort 
% identification algorithm script, i.e. "TPModelandTest.m". Please ensure  
% that the path is correctly set to the directory containing all the .csv 
% files containing the OMOP CDM data before running this script. This 
% should be the "Modeling_withoutlabs" sub-folder within the "Cohort 
% Identification Algorithm" folder.

clear all; close all; clc;

% Set the directory to the present working directory. This directory should
% contain all the .csv files containing the OMOP CDM data. It is  
% currently set to the present working directory (pwd). In case the .csv   
% data files are stored in another directory, please provide the path of  
% that directory instead of pwd.
folder=pwd;

% Set the start date of the experiments to the recruitment date
% input by the user.
startdate=input('Enter the recruitment date for the cohort identification task in a mm/dd/yyyy format: \n (This would be today for real-time recruitment) \n','s');
startdate=datetime(startdate);
save('startdate.mat','startdate');

%% Extract data from .csv files for the random sample of patients
% Demographics
    demo=readtable('Randomsample_demo.csv','ReadVariableNames',true);
        if cell2mat(strfind(demo{1,1},'¿'))
              temp=strsplit(num2str(table2array(demo{1,1})),'¿');
              demo{1,1}=temp(2);
        end
        
% Conditions
    cond=readtable('Randomsample_cond.csv','ReadVariableNames',true);
        if cell2mat(strfind(cond{1,1},'¿'))
              temp=strsplit(num2str(table2array(cond{1,1})),'¿');
              cond{1,1}=temp(2);
        end
    condcodes=unique(table2array(cond(:,2)));
    
% Drugs
    drugs=readtable('Randomsample_drugs.csv','ReadVariableNames',true);
        if cell2mat(strfind(drugs{1,1},'¿'))
              temp=strsplit(num2str(table2array(drugs{1,1})),'¿');
              drugs{1,1}=temp(2);
        end
    drugcodes=unique(table2array(drugs(:,2)));

% Procedures       
    proc=readtable('Randomsample_proc.csv','ReadVariableNames',true);
        if cell2mat(strfind(proc{1,1},'¿'))
              temp=strsplit(num2str(table2array(proc{1,1})),'¿');
              proc{1,1}=temp(2);
        end
    proccodes=unique(table2array(proc(:,2)));
        
%% Pre-process all data types and store them in a data file
% Find the number of unique subjects
subs=table2array(demo(:,1));

% Initialize a data matrix for populating later
data=zeros(size(subs,1),3+size(condcodes,1)+size(drugcodes,1)+size(proccodes,1));

% Concatenate concept IDs.
conceptids=cat(2,'Age','M','F',(cellstr(num2str(condcodes)))',(cellstr(num2str(drugcodes)))',(cellstr(num2str(proccodes)))');

% Populate the data matrix with patient specific data abstractions and
% summaries for each patient and each data type
for s=1:size(subs,1)
    clc;fprintf('Subject:');display(s);
    start=0;
    
    % Demographics
    demoind=demo(strmatch(char(subs(s,1)),table2array(demo(:,1))),:);
    DoB=strcat(num2str(table2array(demoind(1,3))),'/1/',num2str(table2array(demoind(1,2))));
    Age=datetime(startdate)-datetime(DoB); Age.Format='y'; Age=years(Age);
    data(s,start+1)=Age;
    if strmatch(table2array(demoind(1,4)),'M')
        data(s,start+2)=1;
    else if strmatch(table2array(demoind(1,4)),'F')
             data(s,start+3)=1;
        end
    end
    start=start+3;
    
    % Conditions
    condind=cond(strmatch(char(subs(s,1)),table2array(cond(:,1))),:);
    for j=1:size(condcodes,1)
        values=strmatch(char(condcodes(j,1)),table2array(condind(:,2)));
        data(s,start+j)= size(values,1);
    end
    start=start+size(condcodes,1);
    
    % Drugs
    drugind=drugs(strmatch(char(subs(s,1)),table2array(drugs(:,1))),:);
    for j=1:size(drugcodes,1)
       values=drugind(strmatch(char(drugcodes(j,1)),table2array(drugind(:,2))),2);
       data(s,start+j)= size(values,1);
    end
    start=start+size(drugcodes,1);
    
    % Procedures
    procind=proc(strmatch(char(subs(s,1)),table2array(proc(:,1))),:);
    for j=1:size(proccodes,1)
        values=strmatch(char(proccodes(j,1)),table2array(procind(:,2)));
        data(s,start+j)= size(values,1);
    end
    start=start+size(proccodes,1);
end

% Separate the different data types from the entire data matrix
datademo=data(:,1:3);
datacond=data(:,3+1:3+size(condcodes,1));
datadrug=data(:,3+size(condcodes,1)+1:3+size(condcodes,1)+size(drugcodes,1));
dataproc=data(:,3+size(condcodes,1)+size(drugcodes,1)+1:3+size(condcodes,1)+size(drugcodes,1)+size(proccodes,1));

% Save the data file created for the random EHR sample.
save('Randomsample_data.mat','data','datademo','datacond','datadrug','dataproc','conceptids');
