# toy.net-servers

toy.net-servers provides simplified implementations of DNS and HTTP servers with tools to observe and compare their communication patterns.  

## Motivation

I was watching a podcast with Dr. Kailash Nadh , where he explained about the project toy.dns .It made me to think deeper on what happen behind the scenes. This project can help you understand why HTTP is considerd as "Heavy" compared to DNS.

## Documentation

The main objective is to "see" the network-traffic when different types of servers serves their corresponding requests. I have written a bash script (run.sh) which will automate following steps:

    - Run an HTTP server.
    - Run a DNS server.
    - Send a curl request the HTTP server.
    - Send a dig request the DNS server.
    - Using "tcpdump" framework , log the HTTP traffic to logs/http_network_logs.log file.
    - Using "tcpdump" framework , log the DNS traffic to logs/dns_network_logs.log file.

## Usage

    1. Clone the repository.
    2. Create a virtual environment.
    3. Activate the virtual environment.
    4. Install the dependencies.
    5. run ./run.sh in the terminal.
    6. Check the results in the logs folder. 
