/****** Script for SelectTopNRows command from SSMS  ******/
SELECT DISTINCT [person_id]
      ,[value_as_number]
	  ,CASE WHEN value_source_value IS NOT NULL
	  THEN [value_source_value]
	  ELSE [measurement_source_value]
	  END AS SourceCode
  /* Enter appropriate OMOP data table name below*/ 
  FROM [ohdsi].[west].[measurement]
  WHERE person_id in (
  /* Insert list of seed patients in the following format for m seed patients*/
  /*'person_ids1','person_ids2',...'person_idsm'*/
  )