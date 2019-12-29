#Create a profile with AWS Access Key ID and Secret Access Key.
aws configure --profile myProfileNonDefault
#... AWS Access Key ID [None]: AKIAR5TTEBC52524V3ZV
#... AWS Secret Access Key [None]: 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
#... Default region name [None]: us-east-1
#... Default output format [None]: json
#Test the Configuration: Determine the identity currently used in the order: 
#... Environment variables should be returned.
aws sts get-caller-identity
#Test the profile: run aws sts commands with the profile create above
aws sts get-caller-identity --profile myProfileNonDefault