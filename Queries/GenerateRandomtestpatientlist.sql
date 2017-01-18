SELECT * FROM (
SELECT DISTINCT [person_id], DENSE_RANK() OVER (order by person_id) as rnk 
  /* Enter appropriate OMOP data table name below*/ 
  FROM [ohdsi].[west].[person]
  WHERE person_id NOT in (
  /* Insert list of seed patients in the following format for m seed patients*/
  /*'person_id1','person_id2',...'person_idm'*/
  )
  ) U
  /* Enter appropriate number of testing patients, n below.
   We have used 30,000 in our experiments and hence have retained that number here */
  WHERE rnk <=30000
  order by rnks