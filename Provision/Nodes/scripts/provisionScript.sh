RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
  echo "Machine booted!"
  sudo hostnamectl set-hostname $1
  echo "$BLUE INFO - $NC Enable Required Ports"
       sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
       sudo iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT
       sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
       sudo iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
       sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
       sudo iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT
        
       sudo iptables -A INPUT -p tcp --dport 2376 -j ACCEPT
       sudo iptables -A OUTPUT -p tcp --dport 2376 -j ACCEPT
       sudo iptables -A INPUT -p tcp --dport 2377 -j ACCEPT
       sudo iptables -A OUTPUT -p tcp --dport 2377 -j ACCEPT
       sudo iptables -A INPUT -p tcp --dport 2379 -j ACCEPT
       sudo iptables -A OUTPUT -p tcp --dport 2379 -j ACCEPT
       sudo iptables -A INPUT -p tcp --dport 2380 -j ACCEPT
       sudo iptables -A OUTPUT -p tcp --dport 2380 -j ACCEPT
       
       sudo iptables -A INPUT -p udp --dport 4789 -j ACCEPT
       sudo iptables -A OUTPUT -p udp --dport 4789 -j ACCEPT
       sudo iptables -A INPUT -p tcp --dport 6443 -j ACCEPT
       sudo iptables -A OUTPUT -p tcp --dport 6443 -j ACCEPT
       sudo iptables -A INPUT -p tcp --dport 7946 -j ACCEPT
       sudo iptables -A OUTPUT -p tcp --dport 7946 -j ACCEPT
       sudo iptables -A INPUT -p tcp --dport 8443 -j ACCEPT
       sudo iptables -A OUTPUT -p tcp --dport 8443 -j ACCEPT
       sudo iptables -A INPUT -p tcp --dport 8472 -j ACCEPT
       sudo iptables -A OUTPUT -p tcp --dport 8472 -j ACCEPT
       
       sudo iptables -A INPUT -p tcp --dport 10250 -j ACCEPT
       sudo iptables -A OUTPUT -p tcp --dport 10250 -j ACCEPT
       sudo iptables -A INPUT -p tcp --dport 10251 -j ACCEPT
       sudo iptables -A OUTPUT -p tcp --dport 10251 -j ACCEPT
       sudo iptables -A INPUT -p tcp --dport 10252 -j ACCEPT
       sudo iptables -A OUTPUT -p tcp --dport 10252 -j ACCEPT
       sudo iptables -A INPUT -p tcp --dport 10255 -j ACCEPT
       sudo iptables -A OUTPUT -p tcp --dport 10255 -j ACCEPT
       sudo iptables -A INPUT -p tcp --dport 10256 -j ACCEPT
       sudo iptables -A OUTPUT -p tcp --dport 10256 -j ACCEPT