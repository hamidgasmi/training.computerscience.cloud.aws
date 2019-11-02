ssh -i "DOCKEREC2MANUAL.pem" ec2-user@ec2-3-219-215-73.compute-1.amazonaws.com
#1. Install Docker on EC2
sudo amazon-linux-extras install docker
#2. Start Docker.
sudo service docker start
#3. Give ec2-user permissions to interact with the doctor service: it is by adding the user the docker group.
sudo usermod -a -G docker ec2-user 
#4. Exit and Reconnect
exit

ssh -i "DOCKEREC2MANUAL.pem" ec2-user@ec2-3-219-215-73.compute-1.amazonaws.com
#5. test configuration
docker ps

sudo yum install git
git clone https://github.com/linuxacademy/content-aws-csa2019.git
ls -la 

#6. Move to the folder that is containing the docker file
cd content-aws-csa2019/lesson_files/03_compute/Topic5_Containers/Docker/
#7. Build a docker image from the current directory (".": current folder contain the Docker folder)
docker build -t containercat .
#8. Check that the image is created
docker images --filter reference=containercat
#9. Run the container
docker run -t -i -p 80:80 containercat

#10. Register the image on dockerhub
docker login --username YOUR_USER
docker images
docker tag IMAGEID YOUR_USER/containercat
docker push YOUR_USER/containercat