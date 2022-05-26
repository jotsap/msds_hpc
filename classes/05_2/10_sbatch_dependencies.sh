#!/usr/bin/env bash

for step in {1..10}; do
  if [ ${step} -eq 1 ]; then
    dependency_flag=""
    previous_id="no job"
  else
    dependency_flag="--dependency=afterany:${dependency_id}"
  fi
  dependency_id=($(sbatch ${dependency_flag} --mem=1G --wrap "sleep 60"))
  dependency_id=${dependency_id[-1]}
  printf "Job %s is dependent upon %s.\n" ${dependency_id} "${previous_id}"
  previous_id=$(printf "job %s" ${dependency_id})
done

