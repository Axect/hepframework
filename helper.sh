echo "# HEP Docker" >> ~/.bashrc
echo 'alias inithepframe="docker run -it --name hepframe axect/hepframework:0.1 /bin/bash"' >> ~/.bashrc
echo 'alias hepframe="docker start hepframe && docker attach hepframe"' >> ~/.bashrc


