#!/bin/bash

set -x
read -p "Server_IP " server_name
read -p "User_name " user_name
ssh ${user_name}@$server_name
