FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update &&\
 apt-get -y install\
 python3\
 python3-pip\
 python3-numpy\
 python3-pandas\
 git

RUN wget https://raw.githubusercontent.com/jotsap/msds_hpc/main/assignments/assignment_04.sh

RUN wget https://raw.githubusercontent.com/jotsap/msds_hpc/main/assignments/prime.py

RUN chmod +x assignment_04.sh

RUN chmod +x prime.py

RUN bash assignment_04.sh
