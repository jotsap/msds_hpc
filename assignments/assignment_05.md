NOTE TO PROFESSOR  
  
I'm still having major problems with Lab 02 using Singularity. As a last desparate act I ssh'd the **lab02.tar** file I created successfully, but **singularity build** gives an error asking for fakeroot. [see screenshot]
  
As a work around I just created the SBATCH file to run the local commands using slurn variables to output the information such as number of nodes, cpu's, etc

Ran a local script **assignment_05.R** using the **R-base** Spack environment
