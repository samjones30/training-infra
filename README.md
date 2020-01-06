# Overview
Management tier for remote terraform state and lock management.

## Purpose
The terraform plan will create the following:
- An S3 bucket for state.
- A DynamoDB table for locks.
