import ipaddress
import os

# Terraform VARs
PRIVATE_SUBNET = '${private-subnet}'
NUM_CPS = ${control-plane-count}
NUM_WORKERS = ${worker-node-count}
CLUSTER_NAME = '${cluster-name}'
SSH_PRIVATE_KEY = '/home/ubuntu/.ssh/id_rsa'

cp_string = ''
worker_string = ''

for i in range(100, 100 + NUM_CPS):
    cp_string += "      - address: {}\n".format(
        list(ipaddress.ip_network(PRIVATE_SUBNET).hosts())[i - 1].compressed)

for i in range(200, 200 + NUM_WORKERS):
    worker_string += "  - address: {}\n".format(
        list(ipaddress.ip_network(PRIVATE_SUBNET).hosts())[i - 1].compressed)

cluster_vip = list(ipaddress.ip_network(PRIVATE_SUBNET).hosts())[-1].compressed
ingress_vip = list(ipaddress.ip_network(PRIVATE_SUBNET).hosts())[-2].compressed
lb_vip_end = list(ipaddress.ip_network(PRIVATE_SUBNET).hosts())[-2].compressed
lb_vip_start = list(ipaddress.ip_network(
    PRIVATE_SUBNET).hosts())[-25].compressed
lb_vip_range = "{}-{}".format(lb_vip_start, lb_vip_end)

file_path = "~/bmctl-workspace/{0}/{0}.yaml".format(CLUSTER_NAME)

# String Replacements
os.system("sed -i 's|sshPrivateKeyPath: <path to SSH private key, used for node access>|sshPrivateKeyPath: {}|g' {}".format(SSH_PRIVATE_KEY, file_path))
os.system("sed -i 's|type: admin|type: standalone|g' {}".format(file_path))
os.system("sed -i 's|      - address: <Machine 1 IP>|{}|g' {}".format(cp_string.rstrip(),
                                                                      file_path).encode("unicode_escape").decode("utf-8"))
os.system("sed -i 's|controlPlaneVIP: 10.0.0.8|controlPlaneVIP: {}|g' {}".format(cluster_vip, file_path))
os.system("sed -i 's|# ingressVIP: 10.0.0.2|ingressVIP: {}|g' {}".format(ingress_vip, file_path))
os.system("sed -i 's|# addressPools:|addressPools:|g' {}".format(file_path))
os.system("sed -i 's|# - name: pool1|- name: pool1|g' {}".format(file_path))
os.system("sed -i 's|#   addresses:|  addresses:|g' {}".format(file_path))
os.system("sed -i 's|#   # Each address must be either in the CIDR form (1.2.3.0/24)|  # Each address must be either in the CIDR form (1.2.3.0/24)|g' {}".format(file_path))
os.system("sed -i 's|#   # or range form (1.2.3.1-1.2.3.5).|  # or range form (1.2.3.1-1.2.3.5).|g' {}".format(file_path))
os.system(
    "sed -i 's|#   - 10.0.0.1-10.0.0.4|  - {}|g' {}".format(lb_vip_range, file_path))
os.system("sed -i 's|# nodeAccess:|nodeAccess:|g' {}".format(file_path))
os.system("sed -i 's|#   loginUser: <login user name>|  loginUser: ubuntu|g' {}".format(file_path))
os.system("sed -i 's|  - address: <Machine 2 IP>|{}|g' {}".format(worker_string.rstrip(),
                                                                  file_path).encode("unicode_escape").decode("utf-8"))
os.system("sed -i 's|  - address: <Machine 3 IP>||g' {}".format(file_path))
