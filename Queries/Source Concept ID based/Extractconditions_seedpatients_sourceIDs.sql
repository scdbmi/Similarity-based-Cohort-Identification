SELECT [person_id]
      ,[condition_source_value]
  /* Enter appropriate OMOP data table name below*/ 
  FROM [ohdsi].[west].[condition_occurrence]
  WHERE person_id in (
  /* Insert list of seed patients in the following format for m seed patients*/
  /*'person_ids1','person_ids2',...'person_idsm'*/
  )