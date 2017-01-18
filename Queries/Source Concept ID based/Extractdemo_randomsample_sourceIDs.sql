SELECT [person_id]
      ,[year_of_birth]
      ,[month_of_birth]
      ,[gender_source_value]
  /* Enter appropriate OMOP data table name below*/ 
  FROM [ohdsi].[west].[person]
  WHERE person_id in (
  /* Insert list of test patients in the following format for n test patients*/
  /*'person_idt1','person_idt2',...'person_idtn'*/
  )
  AND person_id NOT in (
  /* Insert list of seed patients in the following format for m seed patients*/
  /*'person_ids1','person_ids2',...'person_idsm'*/
  )