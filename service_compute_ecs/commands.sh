sudo amazon-linux-extras install docker
sudo service docker start
sudo usermod -a -G docker ec2-user

sudo yum install git
git clone https://github.com/linuxacademy/content-aws-csa2019.git

cd content-aws-csa2019/lesson_files/03_compute/Topic5_Containers/Docker/
docker build -t containercat .
docker images --filter reference=containercat
docker run -t -i -p 80:80 containercat

docker login --username YOUR_USER
docker images
docker tag IMAGEID YOUR_USER/containercat
docker push YOUR_USER/containercat