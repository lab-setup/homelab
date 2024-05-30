# Steps to create VMs

1. Make sure the vhds are created one after the other.
2. Check the mac address assignment is set to auto, and is not in conflict with [details here](../README.md). Change the ip addressing in your router as mentioned in the same file.
3. Install terraform.
4. CD to k8_hard_way. Run ```terraform init```.
5. Run ```terraform plan```.
6. Run ```terraform apply```.
