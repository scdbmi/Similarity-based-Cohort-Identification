SELECT [person_id]
      ,[procedure_concept_id]
  /* Enter appropriate OMOP data table name below*/ 
  FROM [ohdsi].[west].[procedure_occurrence]
  WHERE person_id in(
  /* Insert list of test patients in the following format for n test patients*/
  /*'MRNt1','MRNt2',...'MRNtn'*/
  )
  AND person_id NOT in (
  /* Insert list of seed patients in the following format for m seed patients*/
  /*'person_ids1','person_ids2',...'person_idsm'*/
  )