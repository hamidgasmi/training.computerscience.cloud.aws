#Clear the Environment Variables
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
#Determine the identity currently used in the order: AWS configure credentials should be returned.
aws sts get-caller-identity
#Remove the ~/.aws/credentials File
rm ~/.aws/credentials
#Determine the identity currently used in the order: the dev role should be returned.
aws sts get-caller-identity