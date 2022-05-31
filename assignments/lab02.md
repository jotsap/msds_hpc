Jon Paugh and Ricco Ferraro where in my group.  
 
I ran into so many problems and was able to resolve most of them but stuck at the singularity portion.
* the YAML Spack file did not accept the matrix syntax so simplified
* Spack would not download python in any environment or container I created. Eventually it required several things to fix which I typed up in Teams Wiki in the Group Lab channel. gfortran was not installed, and then **spack compiler add** did not update the compilers.yaml file so I needed to udate manually
* build-essentials also was not installed, nor was gzip, unzip, or curl
* the ssh'd lab02.tar file would not run remotely, and trying to run locally gave error about fakeroot being needed
* I tried using the docker hub instead but had challenges getting image pushed properly
