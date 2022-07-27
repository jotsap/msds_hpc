Jon Paugh and Ricco Ferraro where in my group.  
 
I ran into so many problems and was able to resolve most of them but stuck at the singularity portion.
* the YAML Spack file did not accept the matrix syntax so simplified
* Spack would not download python in any environment or container I created. Eventually it required several things to fix which I typed up in Teams Wiki in the Group Lab channel. gfortran was not installed, and then **spack compiler add** did not update the compilers.yaml file so I needed to udate manually
* build-essentials also was not installed, nor was gzip, unzip, or curl
* the ssh'd lab02.tar file would not run remotely, and trying to run locally gave error about fakeroot being needed
* I tried using the docker hub instead but had challenges getting image pushed properly
  
See images: https://raw.githubusercontent.com/jotsap/msds_hpc/main/assignments/lab02-crash.PNG  
Whenever I try to run the commands it errors  
INFO:    Starting build...
FATAL:   While performing build: conveyor failed to get: Unexpected tar manifest.json: expected 1 item, got 2


Using image and copying to M2 as **lab02.tar**  
docker save lab02 | ssh jotsap@m2.smu.edu 'bash -l -c "cat > $HOME/lab02/lab02.tar\
&& module load singularity\
&& singularity build -F lab02.sif docker-archive:$HOME/lab02/lab02.tar\
&& singularity exec lab02.sif whoami"'
  
Using Docker Hub same thing [NOTE: INSTRUCTIONS COPIED TO TEAMS]
ssh jotsap@m2.smu.edu 'bash -l -c "module load singularity\
&& singularity run docker://jotsap/smulab:latest -c "import numpy as np; print(np.pi)\""'

## #Please See Spack Tutorial on Teams  
In the **Group Lab** teams channel see the WIKI on top  
NOTE: I also copied to **HPC_TEAMS_WIKI.DOCX**
