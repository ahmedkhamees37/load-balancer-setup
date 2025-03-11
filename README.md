# Load-Balanced Web Environment Setup Script

## Overview
This Bash script automates the setup of a secure load-balanced web environment using Apache as the backend web server and Nginx as the frontend load balancer. The script installs and configures the necessary software on specified servers, ensuring a functional and secure deployment.

## Prerequisites
Ensure you meet the following prerequisites before running the script:
- Three Linux servers with SSH access (one for the frontend, two for the backend)
- Root or sudo privileges on all servers
- SELinux enabled with necessary permissions
- FirewallD enabled for managing network services

## Installation & Usage
1. Clone the repository:
   ```sh
   git clone <repository-url>
   cd <repository-folder>
   ```
2. Grant execute permissions to the script:
   ```sh
   chmod +x setup.sh
   ```
3. Run the script with required arguments:
   ```sh
   ./setup.sh <Backend_IP_1> <Backend_IP_2> <Frontend_IP>
   ```
   Example:
   ```sh
   ./setup.sh 192.168.1.10 192.168.1.11 192.168.1.12
   ```

## What This Script Does
- Installs and configures Apache on backend servers
- Enables and starts the Apache service
- Sets up firewall rules to allow HTTP traffic
- Configures SELinux for Apache network connections
- Installs and configures Nginx on the frontend server
- Configures Nginx to load balance requests between backend servers
- Reloads Nginx with the new load balancer configuration

## File Structure
```
├── setup.sh  # The main script to automate the setup
├── README.md # This documentation file
```

## Troubleshooting
- Ensure that all servers are reachable via SSH.
- Verify that SELinux settings and firewall rules are correctly applied.
- Check Nginx and Apache logs for any configuration errors:
  ```sh
  journalctl -u nginx -f
  journalctl -u httpd -f
  ```

## License
This project is open-source and available under the MIT License.

