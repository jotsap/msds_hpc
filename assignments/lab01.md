As far as selecting the target, when looking at cpuinfo I saw the following version:  
"model name      : Intel(R) Xeon(R) CPU E5-2680 v4 @ 2.40GHz"
  
https://ark.intel.com/content/www/us/en/ark/products/91754/intel-xeon-processor-e52680-v4-35m-cache-2-40-ghz.html
  
shows the CPU is from the **Broadwell** family hence the selection for the target
  
YAML files is available in my $WORK directory    
/work/users/jotsap/spack/var/spack/environments/lab01
  
When trying to use **spack spec ---** on a module I get the following error message:  
Warning: Spack will not check SSL certificates. You need to update your Python to enable certificate verification  
Error: Exception occured in writer daemon!  
  
Reason I wanted to do this was to examine dependecies to help inform modules choices

