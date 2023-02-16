# Ansible-Final-Task


### About the task

create a VPC with 4 subnets, 2 availability zones, 2 public and 2 private subnets, a bastion host, 2 private instances, a NAT gateway, an internet-facing load balancer and then configure the private instances with nexus, and sonarqube

### Befor you begin
* config ~/.ssh/config to include your bastion host data as follow

```bash
Host bastion
        hostname bastion_public_ip
        user ubuntu
        port 22
        identityfile /path/to/bastion/key.pem

```
### screenshots

![image](https://user-images.githubusercontent.com/119705658/219452316-fe30ec4d-82c8-4c93-bf63-7ccb00b88f7d.png)

![image](https://user-images.githubusercontent.com/119705658/219452142-19981f60-22b4-456c-944a-836e99ec8dc0.png)
