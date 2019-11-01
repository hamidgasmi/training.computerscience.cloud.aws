#Connect with AWS Access Key ID and Secret Access Key.
aws configure
#... AWS Access Key ID [None]: AKIAR5TTEBC52524V3ZV
#... AWS Secret Access Key [None]: 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
#... Default region name [None]: us-east-1
#... Default output format [None]: json
#Test the Configuration: Determine the identity currently used in the order
aws sts get-caller-identity
#Verify access to the secret S3 bucket:
aws s3 ls
aws s3 ls cfst-2132-48608a52c7761357b08c5756-s3bucketsecret-121yqyi1wzsbk
