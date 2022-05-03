## Jeremy Otsap Assignment 2
  
  
**Voyager-EUS2**  
Number 10 spot, and Microsoft Cloud's #1 spot was the Voyager-EUS2 running in US East 2 of Microsoft Azure Cloud. This is huge considering that a cloud computing solution is in the top 10 spot, this introduces opportunities for enormous cost savings for customers who do not have the capital to purchase their own HPC clusters. This system I believe was primarily just performance testing as opposed to being for business use case. Its also worth mentioning that Microsoft Azure is currently the only one of the big three (Microsoft, Amazon, and Google) that actually offers Virtual Machines with both Nvidia GPUs *and* InifiniBand back end connectivity. 
  
* Manufacturer: Microsoft Azure
* System Model: ND96amsr_A100_v4
* CPU: AMD EPYC 7V12 48C 2.45GHz
* CPU Generation: AMD Zen-2 (Rome)
* OS: Ubuntu 18.04 LTS
* Total Cores: 253,440
* Cores per Socket: 48
* Acelerator / Co-Processor: NVIDIA A100 80GB
* Acelerator / Co-Processor Cores: 228,096
* Interconnect: Infiniband
* Rmax [TFlop/s]: 30,050.00
* Rpeak [TFlop/s]: 39,531.15
* Nmax: 4,669,056
  
  
**Descartes Labs Amazon EC2 Instance Cluster**  
#49 spot and #1 AWS workload Amazon EC2 Instance Cluster us-east-1a in the Descartes Labs site. Note that it uses Ethernet instead of InifiniBand for network connectivity. Additionally, instead of using an established Linux Distro, it actually uses AWS's flavor, which I believe have some customer performance enhancements for running on their platform. No GPU's in this cluster, just the Intel Skylake CPU's. Compared to the Azure Cluster above it has relatively low cores per socket: only 18 vs Voyager's 64.
  
* Manufacturer: Amazon
* System Model: EC2 r5.24xlarge
* CPU: Xeon Platinum 8124M 18C 3GHz
* CPU Generation: Intel Skylake
* OS: Amazon Linux 2
* Total Cores: 172,692
* Cores per Socket: 18
* Acelerator / Co-Processor: NA
* Acelerator / Co-Processor Cores: NA
* Interconnect: 25G Ethernet
* Rmax [TFlop/s]: 9,950.26
* Rpeak [TFlop/s]: 15,106.52
* Nmax: 7,864,320
  
  
  
**Perlmutter**  
#5 Spot is Perlmutter which is the fastest cluster that does NOT rely on InfiniBand for network connectivity, but rather standard Ethernet. It is an HPE Cray EX235n using an AMD EPYC 64 Core CPU and NVIDIA GPU copreccessor. Unlike the other two based on a Cluster architecture, this is based on MPP (Massively Parallel Processing), which from what I know, can be extremely difficult to program and are primarly designed for Embarassingly Parallel problems.

* Manufacturer: HPE
* System Model: HPE Cray EX235n
* CPU: AMD EPYC 7763 64C 2.45GHz
* CPU Generation: AMD Zen-3 (Milan)
* OS: HPE Cray OS
* Total Cores: 761,856
* Cores per Socket: 64
* Acelerator / Co-Processor: NVIDIA A100 SXM4 40 GB
* Acelerator / Co-Processor Cores: 663,552
* Interconnect: Slingshot-10 Ethernet
* Rmax [TFlop/s]: 70,870.00
* Rpeak [TFlop/s]: 93,750.00
* Nmax: 5,566,464
