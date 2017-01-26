This sub-folder contains the code for pre-processing the data extracted using the queries and using this to build and test the cohort identification algorithm. Before running any code in MATLAB, it should be ensured the current directory is set to the "Modeling" sub-folder within the "Cohort Identification Algorithm" folder.

All the extracted data should be in the same directory as the "Modeling" sub-folder for their successful compilation. If the folder containing the extracted data is different, then, in each script, the "folder" variable should point to the path containing all of the extracted .csv files. Detailed annotations are provided in each sub-routine in the lines starting with "%".

The order in which the code should be run is:

1. PreprocessingRandomsample.m
2. PreprocessingSeedpatients.m
3. DataProcessing_Modeling.m
4. TPModelandTest.m

Detailed descriptions of these codes are as follows:

1. PreprocessingRandomsample.m: This code pre-processes the random sample set for the experiments and extracts all the data types from the set of n unknown test patients in the EHR. Before running this code, it should be ensured that the .csv files "Randomsample_demo.csv", "Randomsample_cond.csv", "Randomsample_drugs.csv", "Randomsample_labs.csv", and "Randomsample_proc.csv" have been successfully extracted and saved in the "Modeling" sub-folder (or whichever path variable "folder" points to). This code loads in data from these .csv files and extracts, abstracts, and summarizes all the data in one .mat file called "Randomsample_data.mat". This code also takes the recruitment date (for the cohort identification task) as input from the user, and uses it to compute the age of each patient. The recruitment date is also saved in the .mat file "startdate.mat".

If the user already has previously extracted data to be used and does not extract data using the queries in the "Query" sub-folder, then the format this code expects for each of the data types is as follows:
"Randomsample_demo.csv": [person_id],[year_of_birth],[month_of_birth],[gender_source_value]
"Randomsample_cond.csv": [person_id],[condition_concept_id] 
"Randomsample_drugs.csv": [person_id],[drug_concept_id]
"Randomsample_labs.csv": [person_id],[value_as_number],[measurement_concept_id] 
"Randomsample_proc.csv": [person_id],[procedure_concept_id] 

2. PreprocessingSeedpatients.m: This code pre-processes the seed patient set for the experiments and extracts all the data types from the set of seed patients in the EHR. Before running this code, it should be ensured that the .csv files "Seedpatients_demo.csv",  "Seedpatients_cond.csv", "Seedpatients_drugs.csv", "Seedpatients_labs.csv", and "Seedpatients_proc.csv" have been successfully extracted and saved in the "Modeling" sub-folder (or whichever path variable "folder" points to). Before running this code, it should also be ensured that the file "startdate.mat" (which contains the recruitment date  taken as user input during the execution of the script "PreprocessingRandomsample.m") exists in the "Modeling" sub-folder. This code loads in data from these .csv files and extracts, abstracts, and summarizes all the data in one .mat file called "Seedpatients_data.mat".

If the user already has previously extracted data to be used and does not extract data using the queries in the "Query" sub-folder, then the format this code expects for each of the data types is as follows:
"Seedpatients_demo.csv": [person_id],[year_of_birth],[month_of_birth],[gender_source_value]
"Seedpatients_cond.csv": [person_id],[condition_concept_id] 
"Seedpatients_drugs.csv": [person_id],[drug_concept_id]
"Seedpatients_labs.csv": [person_id],[value_as_number],[measurement_concept_id] 
"Seedpatients_proc.csv": [person_id],[procedure_concept_id] 

3. DataProcessing_Modeling.m: This code loads in data from the "Randomsample_data.mat" and the "Seedpatients_data.mat". After this, only the features that are present in the seed patients are extracted from the test patients. We do this because we are interested in identifying patients who are similar to the seed patient set. We assume the seed patient set to be the gold standard, and are interested in finding other patients who have similar values of features as the seed patient set contains. This feature selection step for the test patients is also important to ensure consistency when modeling the "target patient" representation and testing it using the test patient set, in the "TPModelandTest.m" code. The processed test patient data is stored along with the seed patient data (of identical size) in the file "Data_modeling.mat".

4. TPModelandTest.m: This code loads in the processed seed and test patient data from the file "Data_modeling.mat" and creates a "target patient" representation using half of the seed patients and tests it using the other half of the seed patients and all of the test patients. This code requires the user to input the number of unknown test patients that are in the data set. This is equivalent to the value of n that the user specified when extracting the random list of test patients. A two-fold cross-validation is used to evaluate performance. The metrics of evaluation are Precision at 5, Precision at 10, Precision at 20, Precision at 30, Mean Average Precision (MAP), and the Mean Reciprocal Rate (MRR), optimal AUC (and the value of threshold y corresponding to this AUC). All of these metrics of evaluation are averaged over the two folds and are saved in the file "Results.mat". This is the final output of the algorithm evaluation.
