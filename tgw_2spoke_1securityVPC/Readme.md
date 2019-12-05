# Service insertion with FortiGateVM

## Description
Spoke VPCs are connected to a transit gateway which enables service insertion to happen. All inter VPC traffic as well as outgoing traffic to the internet is controled by FortiGateVM firewall running in the security VPC.
The transit gateway in this case is attached to all spoke VPCs via VPC connections but it the solution is also open to use also VPN connections to remote VPCs.

The FortiGate-VM si connected to three networks untrust, trust and dedicated management interface. Adding additional spoke VPCs doesn't require more network interfaces. The inter spoke VPC traffic is forwarded through the trust interface.
Additional Spoke VPCs can be attached to the transit gateway either as VPN or VPC connections.

This setup doesn't consider high-availability requirement and consits of only one FortiGate-VM. Another one can be deployed in different availability zones referred to as zone B in the names of networks. These "B" networks are not in use at the moment.
The whole setup was created based on the documentation published by Palo Alto Networks where you can find a detailed step-by-step deployment guide [AWS_Transit_Gateway_ManualBuild.pdf](https://github.com/PaloAltoNetworks/TransitGatewayDeployment/blob/master/Documentation/AWS_Transit_Gateway_ManualBuild.pdf?raw=true).

    

## Deployment by Terraform
The whole setup including the FortiGate-VM EC2 instance and testing VMs in spoke VPCs can be deployed by using terraform.
There are a few input variables customizing the deployment such as the names of the region, availability zones, CIDRs and IP addresses from which it can be the whole setup managed.

Some parameters, such as subnet CIDRs, are already filled in the module variables and can be used also for a real deployment.
The AMI of the FortiGate-VM instance has to be updated accordingly based on the region, the default values used in terraform templates are valid for region Frankfurt.


## Network diagram
![](diagram.jpg)
The diagram can be found also in the pdf file [diagram.pdf](diagram.pdf). It provides all information about subnets and the way the FortiGate-VM is connected to  

## Access
### Test VM in Spoke VPC

There is one test VM deployed in each spoke VPC to perform connectivity tests. These VMs are accessible by using the ssh key created during the deployment. 
All test VMs are accessible from the internet through the internet gateway deployed in spoke VPCs to ease the remote access when there's no connection Direct Connect or VPN connection between on-premise and security VPC yet.
The virtual machines are protected from being accessed from anywhere by the security group allowing access only from a specific IP address defined as the input variable ssh_access_from.  

### FortiGate-VM
The VM can be accessed via SSH or https on the public IP addresses mapped to outside and management interface. Both eth0 and eth1 public IP addresses are returned as outputs by terraform.
Initial setup must be done through the IP address linked to eth0.


## Check connectivity between the endpoints.

Ping from the VM in the VPC-A
```shell
ubuntu@ip-10-1-1-60:~$ ping 10.2.1.143
PING 10.2.1.143 (10.2.1.143) 56(84) bytes of data.
64 bytes from 10.2.1.143: icmp_seq=1 ttl=61 time=2.02 ms
64 bytes from 10.2.1.143: icmp_seq=2 ttl=61 time=1.57 ms
^C
--- 10.2.1.143 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 1.579/1.800/2.021/0.221 ms
ubuntu@ip-10-1-1-60:~$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=47 time=1.89 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=47 time=1.61 ms
^C
--- 8.8.8.8 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 1.618/1.754/1.890/0.136 ms
```
Ping from the VM in the VPC-B
```shell
ubuntu@ip-10-2-1-143:~$ ping 10.1.1.60
PING 10.1.1.60 (10.1.1.60) 56(84) bytes of data.
64 bytes from 10.1.1.60: icmp_seq=1 ttl=61 time=2.13 ms
64 bytes from 10.1.1.60: icmp_seq=2 ttl=61 time=1.75 ms
^C
--- 10.1.1.60 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 1.753/1.942/2.132/0.194 ms
ubuntu@ip-10-2-1-143:~$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=47 time=2.27 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=47 time=2.13 ms
^C
--- 8.8.8.8 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 2.131/2.202/2.274/0.085 ms
```
