#Connect to the Web Server
ssh cloud_user@3.216.133.171
#Test the Configuration: determine the identity currently used in the order:
aws sts get-caller-identity
#Verify access to the bucket we included in the role policy
aws s3 ls
aws s3 ls s3://cfst-2132-48608a52c7761357b08c575664f-s3bucketdev-vo16aap6bef1