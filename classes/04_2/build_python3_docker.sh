#!/usr/bin/env sh

# Build container image
docker build --platform linux/amd64 -t python3:20.04 -f python3.dockerfile .

# Run default entry point
docker run -it python3:20.04

# See who the default user
docker run --entrypoint /usr/bin/whoami -it python3:20.04

# Running arbitrary commands
docker run --entrypoint /bin/bash -it python3:20.04

# Export, upload, convert, and run on M2 via Singularity
docker save python3:20.04 | ssh m2 'bash -l -c "n=python3_20_04\
 && cat > ~/$n.tar\
 && module load singularity\
 && singularity build -F $n.sif docker-archive:$HOME/$n.tar\
 && singularity exec $n.sif whoami"'

