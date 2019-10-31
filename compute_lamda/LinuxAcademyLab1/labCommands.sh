mkdir /tmp/lambdafunction
cp lambda_handler.py /tmp/lambdafunction
cd /tmp/lambdafunction
wget https://files.pythonhosted.org/packages/ae/2a/0a0ab2833e5270664fb5fae590717f867ac6319b124160c09f1d3291de28/Pillow-5.4.1-cp37-cp37m-manylinux1_x86_64.whl
unzip Pillow-5.4.1-cp37-cp37m-manylinux1_x86_64.whl
rm -rf Pillow-5.4.1.dist-info
zip -r9 lambda.zip PIL lambda_handler.py