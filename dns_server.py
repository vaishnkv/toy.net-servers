#!/usr/bin/env python3
import socket
import os
from dns_generator import ClientHandler
from loguru import logger
import argparse

# Global variables
IP = "127.0.0.1"


def main(port : int):
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.bind((IP, port))
    logger.info(f"DNS Listening on {IP}:{port} ...")
    while True:
        data, address = sock.recvfrom(650)
        client = ClientHandler(address, data, sock)
        client.run()


if __name__ == "__main__":
    
    # Create the parser
    parser = argparse.ArgumentParser(description="A simple example script.")

    # Add arguments
    parser.add_argument(
        "--port", type=int, required=False, help="Port to run",default=55
    )
    args = parser.parse_args()
    
    main(args.port)
