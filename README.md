# F5 BIG-IP Terraform Configuration Example

This repository contains Terraform sample code to configure various types of virtual services and related objects on F5 BIG-IP. These examples were written for Terraform v0.12 or greater. The F5 Terraform provider requires the iControlREST API and is comptatible with BIG-IP v12.1.1 and above.

### Demo contains the following examples
1. HTTP virtual server
 * HTTP pool
 * Custom HTTP profile
 * Custom HTTP monitor
2. HTTPS virtual server
 * HTTPS pool
 * SSL/TLS certificate/pair upload
 * Custom client SSL profile
3. FastL4 virtual server
 * HTTP pool