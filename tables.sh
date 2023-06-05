#Set default policies for INPUT, FORWARD, and OUTPUT chains to DROP
sudo ip netns exec ns_firewall iptables -P INPUT DROP
#sudo ip netns exec ns_firewall iptables -P FORWARD DROP
#sudo ip netns exec ns_firewall iptables -P OUTPUT DROP

#Allow traffic on loopback interface
sudo ip netns exec ns_firewall iptables -A INPUT -i lo -j ACCEPT
sudo ip netns exec ns_firewall iptables -A OUTPUT -o lo -j ACCEPT

#Allow traffic related to established connections
sudo ip netns exec ns_firewall iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
sudo ip netns exec ns_firewall iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
sudo ip netns exec ns_firewall iptables -A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

#Allow traffic to/from specified ports or services
# Rule 1: Client1 can ping to server
sudo ip netns exec ns_firewall iptables -A INPUT -i v_firewall1 -s 192.0.2.10 -d 192.0.2.130 -p icmp -m state --state NEW,ESTABLISHED -j ACCEPT
sudo ip netns exec ns_firewall iptables -A OUTPUT -o v_firewall1 -s 192.0.2.10 -d 192.0.2.130 -p icmp -m state --state ESTABLISHED -j ACCEPT

#sudo ip netns exec ns_firewall iptables -A INPUT -i v_firewall1 -s 192.0.2.0/26 -d 192.0.2.128/26 -p icmp -m state --state NEW,ESTABLISHED -j ACCEPT
#sudo ip netns exec ns_firewall iptables -A OUTPUT -o v_firewall1 -s 192.0.2.0/26 -d 192.0.2.128/26 -p icmp -m state --state ESTABLISHED -j ACCEPT

# Rule 3: Client2 can ping to firewall
sudo ip netns exec ns_firewall iptables -A INPUT -i v_firewall2 -s 192.0.2.70 -d 192.0.2.200 -p icmp -m state --state NEW,ESTABLISHED -j ACCEPT
sudo ip netns exec ns_firewall iptables -A OUTPUT -o v_firewall2 -s 192.0.2.70 -d 192.0.2.200 -p icmp -m state --state ESTABLISHED -j ACCEPT

# Rule 2: Client2 can access to server for http
sudo ip netns exec ns_firewall iptables -A INPUT -i v_firewall2 -p tcp -s 192.0.2.70 --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
sudo ip netns exec ns_firewall iptables -A OUTPUT -o v_firewall2 -p tcp -s 192.0.2.70 --sport 80 -m state --state ESTABLISHED -j ACCEPT

# Rule 5: Client and server networks are can be access to the internet from firewall namespace via your host machine.
sudo ip netns exec ns_firewall iptables -A INPUT -i v_firewall2 -p tcp -s 192.0.2.70 -m multiport --dports 80,443 -m state --state NEW,ESTABLISHED -j ACCEPT
sudo ip netns exec ns_firewall iptables -A OUTPUT -o v_firewall2 -p tcp -s 192.0.2.70 -m multiport --sports 80,443 -m state --state ESTABLISHED -j ACCEPT

sudo ip netns exec ns_firewall iptables -A INPUT -i v_firewall1 -p tcp -s 192.0.2.10 -m multiport --dports 80,443 -m state --state NEW,ESTABLISHED -j ACCEPT
sudo ip netns exec ns_firewall iptables -A OUTPUT -o v_firewall1 -p tcp -s 192.0.2.10 -m multiport --sports 80,443 -m state --state ESTABLISHED -j ACCEPT

sudo ip netns exec ns_firewall iptables -A INPUT -i v_firewall3 -p tcp -s 192.0.2.130 -m multiport --dports 80,443 -m state --state NEW,ESTABLISHED -j ACCEPT
sudo ip netns exec ns_firewall iptables -A OUTPUT -o v_firewall3 -p tcp -s 192.0.2.130 -m multiport --sports 80,443 -m state --state ESTABLISHED -j ACCEPT


