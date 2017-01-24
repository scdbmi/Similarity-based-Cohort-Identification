% This code creates the Target Patient model using half of the seed 
% patients, tests this model using the other half of the seed patients and
% all of the test patients. A two-fold cross-validation is used to validate
% this model. The metrics of evaluation of this algorithm are Precision at 
% 5, Precision at 10, Precision at 20, Precision at 30, Mean Average
% Precision (MAP), Mean Reciprocal Rate (MRR),and Optimal Area Under the 
% Curve (AUC), all of which are saved in the "Results.mat" data. This 
% script takes as input the number of patients in the test data set (or n) 
% from the user.

clear all; close all; clc;

% Set the directory to the present working directory. This directory should
% contain all the .csv files containing the OMOP CDM data. It is  
% currently set to the present working directory (pwd). In case the .csv   
% data files are stored in another directory, please provide the path of  
% that directory instead of pwd.
folder=pwd;

% Initialize the measurement metrics
yoptimum=0;
x=0:1:100;
y=0.75:0.01:0.99;
sensitiv=zeros(length(x),1);
specific=zeros(length(x),1);
optimaly=0;
optimalx=0;
optimalAUC=0;
optimaldist=0;
P5=0;
P10=0;
P20=0;
P30=0;
MAP=0;
MRR=0;

% Load data for modeling
load([folder '\Data_modeling.mat']);

% Here, we want to include the presence/absence of each lab as a feature
% in addition to actual value of that lab. Append lab presence/absence 
% matrix to both seed and random patient data and convert nans to zeros. 
dataseedlabpresabs=zeros(size(dataseed,1),(labend-labstart+1));
datarandlabpresabs=zeros(size(datarand,1),(labend-labstart+1));
dataseednew=dataseed;
datarandnew=datarand;
for j=labstart:labend
    presabs=double(~isnan(dataseed(:,j)));
    dataseedlabpresabs(:,j-3)=presabs;
    dataseednew(isnan(dataseed(:,j)),j)=0;
    presabs=double(~isnan(datarand(:,j)));
    datarandlabpresabs(:,j-3)=presabs;
    datarandnew(isnan(datarand(:,j)),j)=0;
end
dataseed=cat(2,dataseednew,dataseedlabpresabs);
datarand=cat(2,datarandnew,datarandlabpresabs);

% We want to see how many features are being selected after feature
% selection, so we save the original number of features.
numfeaturesoriginal=size(dataseed,2);

% Initialize the sensitivity and specificity arrays to the size of the
% number of thresholds being tested here.
sens=zeros(size(x,2),2);spec=zeros(size(x,2),2);

% Enter the number of test patients as input from the user
numtest=input('Enter the number of test patients:');

% Perform 2 fold cross-validation
indices = crossvalind('Kfold',size(dataseed,1),2);
for k=1:2
test = (indices == k); train = ~test;
datatrain=dataseed(train,:);
datatest=dataseed(test,:);

% Combine random sample data with testing data (Testing set)
datatestold=datatest;
datatest=cat(1,datatest,datarand);

% Perform feature selection
ind1=find(sum(datatrain~=0,1)>1);
ind2=find(sum(datatrain~=0,1)>0.5*size(datatrain,1));
if length(ind2)<30
    ind3=ind1;
else
    ind3=ind2;
end
datatestred=datatest(:,ind3);
datatrainred=datatrain(:,ind3);
optimaly=optimaly+yoptimum;

% Re-scale the data in both training and testing data sets to similar
% scales
for j=1:size(datatrainred,2)
 datatrainred(:,j) = (datatrainred(:,j) - min(datatrainred(:,j)))/(max(datatrainred(:,j)) - min(datatrainred(:,j)));
 datatestred(:,j) = (datatestred(:,j) - min(datatestred(:,j)))/(max(datatestred(:,j)) - min(datatestred(:,j)));
end

% Find Target Patient
targetp=nanmean(datatrainred,1);

% Find distance to the Target Patient for each patient in testing set
datatestred(:,find(isnan(targetp)==1))=[];
targetp(:,find(isnan(targetp)==1))=[];
dist=zeros(size(datatestred,1),1);
for j=1:size(datatestred,1)
    dist(j,1)=pdist2(targetp(1,find(isnan(datatestred(j,:))==0)),datatestred(j,find(isnan(datatestred(j,:))==0)),'cosine');
end

% Create training labels
labels=cat(1,ones(size(datatestold,1),1),zeros(numtest,1));

% Compute the true positives, false positives, ROC curve for different thresholds:x
for l=1:size(x,2)
tp=0;fp=0;tn=0;fn=0;
scores=double(dist<prctile(dist,x(l)));
for m=1:size(labels,1)
tp=tp+(scores(m,1)==1&&labels(m,1)==1);
fp=fp+(scores(m,1)==1&&labels(m,1)==0);
tn=tn+(scores(m,1)==0&&labels(m,1)==0);
fn=fn+(scores(m,1)==0&&labels(m,1)==1);
end
sens(l,k)=sens(l,k)+(tp/(tp+fn));
spec(l,k)=spec(l,k)+(tn/(tn+fp));
end
[opt,index]=max(sens(:,k).*(1-spec(:,k)));
optimalAUC=optimalAUC+opt;
optimalx=optimalx+x(index);
optimaldist=optimaldist+prctile(dist,x(index));
[distsorted,ind]=sort(dist,'ascend');
labelssorted=labels(ind);
P5=P5+(length(find(labelssorted(1:5,1)==1))/5);
P10=P10+(length(find(labelssorted(1:10,1)==1))/10);
P20=P20+(length(find(labelssorted(1:20,1)==1))/20);
P30=P30+(length(find(labelssorted(1:30,1)==1))/30);
index=find(labelssorted==1);
map=0;
for j=1:size(index,1)
    map=map+length(find(labelssorted(1:index(j),1)==1))/index(j);
end
MAP=MAP+(map/size(index,1));
MRR=MRR+(1/index(1));
end
 sens=(sens(:,1)+sens(:,2))/2;
 spec=(spec(:,1)+spec(:,2))/2;
 sensitiv=sens;specific=spec;
P5=P5/2;P10=P10/2;P20=P20/2;P30=P30/2;MAP=MAP/2;MRR=MRR/2;
hold on; plot(1-spec,sens,'--k','LineWidth',2);
height=(sens(1)+sens(end))/2;
width=-diff(spec);
AUC=sum(height.*width);
optimalAUC=optimalAUC/2;
optimalx=optimalx/2;
optimaldist=optimaldist/2;
optimaly=optimaly/2;
save([folder '\Results.mat'],'P5','P10','P20','P30','MAP','MRR','optimalAUC','optimaly');
