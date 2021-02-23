#!/bin/sh
export AWS_PROFILE=personal
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/y8c9h9h4