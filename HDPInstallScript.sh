//HOST_NAME=hdp.learningjournal.local
//SHORT_NAME=hdp
//read dummy IP_ADDRESS <<< $(hostname -I)
//echo $IP_ADDRESS $HOST_NAME $SHORT_NAME >> /etc/hosts
//sed -i "s/HOSTNAME=localhost.localdomain/HOSTNAME=$HOST_NAME/g" /etc/sysconfig/network
//hostname $HOST_NAME
//service network restart

sudo yum install ntpd httpd wget git -y
sudo systemctl start httpd
sudo systemctl start ntpd
sudo systemctl enable httpd
sudo systemctl enable ntpd

wget http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.6.0.0/ambari-2.6.0.0-centos7.tar.gz
wget http://public-repo-1.hortonworks.com/HDP/centos7/2.x/updates/2.6.3.0/HDP-2.6.3.0-centos7-rpm.tar.gz
wget http://public-repo-1.hortonworks.com/HDP-UTILS-1.1.0.21/repos/centos7/HDP-UTILS-1.1.0.21-centos7.tar.gz

tar -zxvf ambari-2.6.0.0-centos7.tar.gz -C /var/www/html/
tar -zxvf HDP-2.6.3.0-centos7-rpm.tar.gz -C /var/www/html/
mkdir /var/www/html/HDP-UTILS
tar -zxvf HDP-UTILS-1.1.0.21-centos7.tar.gz -C /var/www/html/HDP-UTILS/

yum localinstall /var/www/html/ambari/centos7/2.6.0.0-267/ambari/ambari-server-2.6.0.0-267.x86_64.rpm

sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
service sshd restart

ssh-keygen
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

ulimit -n 10000

systemctl disable firewalld
systemctl stop firewalld
//service iptables stop
//chkconfig iptables off
//service ip6tables stop
//chkconfig ip6tables off

setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

cp *.repo /etc/yum.repos.d/
cat thp.txt >> /etc/rc.local
