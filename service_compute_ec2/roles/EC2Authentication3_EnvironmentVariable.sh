#Environment Variable Configuration:
export AWS_ACCESS_KEY_ID=AKIAR5TTEBC523CIE3W6
export AWS_SECRET_ACCESS_KEY=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
#Test the Configuration: Determine the identity currently used in the order
aws sts get-caller-identity
#Verify access to the secret S3 bucket:
aws s3 ls
aws s3 ls cfst-2132-48608a52c7761357b08-s3bucketengineering-jlng4dvqpxmx
#Verify access to the secret S3 bucket (it should be denied):
aws s3 ls cfst-2132-48608a52c7761357b08c5756-s3bucketsecret-121yqyi1wzsbk