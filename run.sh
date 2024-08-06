
: '
Approach: Highlevel

1. create an toy HTTP server
2. create an  toy DNS server
3. clone the dns_server server git repository.
4. instruct to change the 1 line of code. 
4. with a bash script, do the following
    - define the HTTP_PORT and DNS_PORT environment variables.
    - run the http server, make use of 
    - run the dns server
    - send the curl request to the http server and store the responses to a .txt file (say file.txt)
    - send a dig request to the dns server and store the responses to the same file.
    - log the network.

'


export DNS_PORT=55
export HTTP_PORT=5000



# clone the repo for toy-dns-server
git clone --depth 1 https://github.com/akapila011/DNS-Server.git temp-repo
# Move the required folders.
mv temp-repo/dns_generator temp-repo/Zones .
# Step 3: Remove the temporary directory
rm -rf temp-repo

PYTHON_PATH=$(which python3)
echo -e "\nUsing the python interpreter @ path $PYTHON_PATH"



REAL_PYTHON_PATH=$(realpath $PYTHON_PATH)
sudo setcap 'cap_net_bind_service=+ep' $REAL_PYTHON_PATH
# This is the capability that allows a process to bind to network ports below 1024 (known as "privileged ports"). 
# By default, only the root user can bind to these ports.

# To ensure the PORTS requested are not already in use.
sudo pkill -9 "python"
echo -e "\nKilled all the  Running Python processes."

# To ensure that log folders are 
mkdir logs
rm -rf logs/*

# sudo $PYTHON_PATH http_server.py & 
nohup $PYTHON_PATH http_server.py --port $HTTP_PORT > logs/http_server.log 2>&1 &
echo -e "\nStarted the HTTP server @ PORT number $HTTP_PORT"
nohup $PYTHON_PATH dns_server.py --port $DNS_PORT > logs/dns_server.log 2>&1 &
echo -e "\nStarted the DNS server @ PORT number $DNS_PORT"


# Withthis , later we can tcpdump without root privilates.
sudo setcap 'cap_net_raw,cap_net_admin=eip' $(which tcpdump)


echo "DNS Network Traffic - logs" > logs/dns_network_logs.log
echo -e "\n\n----------------------------------------------------------------" >> logs/dns_network_logs.log
echo -e "Traffic on DNS PORT ::: \n" >> logs/dns_network_logs.log 
# By default, tcpdump buffers its output, which can cause delays in writing data to the file. This means that the data might not appear in the file until the buffer is full or the process is terminated.
nohup tcpdump -l -i lo port $DNS_PORT >> logs/dns_network_logs.log 2>&1 &
TCPDUMP_DNS_PID=$!
echo "TCPDUMP on DNS : with a process ID $TCPDUMP_DNS_PID"





echo "HTTP Network Traffic - logs" > logs/http_network_logs.log
echo -e "\n\n----------------------------------------------------------------" >> logs/http_network_logs.log
echo -e "Traffic on HTTP PORT ::: \n" >> logs/http_network_logs.log
# By default, tcpdump buffers its output, which can cause delays in writing data to the file. This means that the data might not appear in the file until the buffer is full or the process is terminated.
nohup tcpdump -l -i lo port $HTTP_PORT >> logs/http_network_logs.log 2>&1 &
TCPDUMP_HTTP_PID=$!
echo "TCPDUMP on HTTP : with a process ID $TCPDUMP_HTTP_PID"



sleep 3 # To Make sure the servers are up and running

# Hiting the HTTP server
echo -e "\n################################################\n"

echo -e "\nUsing the GET method to fetch the data from the "/" endpoint"
echo -e "Sending an HTTP request ..."
HTTP_RESPONSE=$(curl http://localhost:$HTTP_PORT/)
echo -e "The response from the HTTP server is : \n\n\n\n $HTTP_RESPONSE"


echo -e "\n################################################\n"

echo -e "\n Querying the DNS server for 'xyz.com'"
echo -e "\n Sending an DNS request/query ..."
# dig : This is the command-line tool used for querying DNS (Domain Name System) servers. 
# It allows you to retrieve DNS records for a specified domain.
DNS_RESPONSE=$(dig @localhost xyz.com -p $DNS_PORT)
echo -e "The response from the DNS server is: \n\n\n\n $DNS_RESPONSE"

sleep 5

echo -e "\n################################################\n"

kill -9 $TCPDUMP_HTTP_PID
kill -9 $TCPDUMP_DNS_PID
echo -e "\n\nKilled the TCPDUMP Processes"
sudo pkill -9 "python"
echo -e "\nKilled all the  Running Python processes."










