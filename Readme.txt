This folder contains all queries and MATLAB scripts developed for the similarity-based cohort identification task. The queries are written in Microsoft SQL Server Management Studio and the code for data pre-processing and modeling is written in MATLAB. The queries (in sub-folder "Queries") are to be used to extract patient data for the set of m seed patients and n unknown test patients from the EHR. 

The number m denotes the sample size of the already identified cases (or seed patients) for the cohort identification task. The list of n unknown test patients can be generated using the query "GenerateRandomtestpatientlist.sql" in the "Query" sub-folder or the user can use a set of test patients that they already have. These n unknown test patients should be mutually exclusive with the seed patient set, i.e. there should not be any overlapping patients between the seed patient set and the random test patient set. We used n=30,000 in our experiments and this is the recommended number. But n=1000 can be used for inital experiments. 

If the user has previously extracted seed patient data and test patient data in the OMOP CDM version 5.0 format to build and test this algorithm on and does not need to extract them using our queries, then the user can directly use the code in the "Modeling" sub-folder. Detailed descriptions of each of the scripts are provided within the sub-folder. In this case, the extracted data should be converted to the following format and saved as the following .csv files in the folder "Modeling" prior to running the scripts:

Demographics for the seed patients and the test patients should be stored as "Seedpatients_demo.csv" and "Randomsample_demo.csv" with the following columns:
[person_id],[year_of_birth],[month_of_birth],[gender_source_value]

Conditions for the seed patients and the test patients should be stored as "Seedpatients_cond.csv" and "Randomsample_cond.csv" with the following columns:
[person_id],[condition_concept_id] 

Drugs for the seed patients and the test patients should be stored as "Seedpatients_drugs.csv" and "Randomsample_drugs.csv" with the following columns: 
[person_id],[drug_concept_id]

Labs for the seed patients and the test patients should be stored as "Seedpatients_labs.csv" and "Randomsample_labs.csv" with the following columns:
[person_id],[value_as_number],[measurement_concept_id] 

Procedures for the seed patients and the test patients should be stored as "Seedpatients_proc.csv" and "Randomsample_proc.csv" with the following columns:
[person_id],[procedure_concept_id] 

Following this conversion, the 10 .csv files named as above should be stored in the "Modeling" sub-folder. The MATLAB codes (in the sub-folder "Modeling") will then be used to (1) pre-process the extracted data (both for the seed patients as well as for the test patients) and (2) build a target patient and test it using a two-fold cross-validation. In each fold, the target patient is built using a randomly selected half of the seed patients and tested using the other half of the seed patients and the random EHR sample. Detailed description of each MATLAB script and the order in which they should be run is presented in a Readme file in the sub-folder "Modeling".

We have included an additional sub-folder “Modeling_withoutlabs” which performs the same data preprocessing, modeling, and testing for the cohort identification task in the case when the user’s site doesn’t support labs as part of the OMOP CDM version 5 database. This may be the case for claims based datasets. In this case, the MATLAB scripts in “Modeling_withoutlabs” expect the files "Seedpatients_demo.csv”, “Randomsample_demo.csv”, "Seedpatients_cond.csv”, “Randomsample_cond.csv”, "Seedpatients_drugs.csv”, “Randomsample_drugs.csv”, "Seedpatients_proc.csv”, and "Randomsample_proc.csv" to be saved in the “Modeling_withoutlabs” sub-folder prior to running the scripts. These .csv files should follow the same column format as is specified in the previous section for the scripts in the “Modeling” sub-folder. 