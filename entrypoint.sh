#!/bin/bash

# start sshd
mkdir /var/run/sshd
chmod 0755 /var/run/sshd
sudo /usr/sbin/sshd
# Configurar el bashrc de Geant
echo 'source /usr/local/geant4/geant4-v11.1.2-install/bin/geant4.sh' >> /home/geant/.bashrc
echo 'source /home/geant/.env/bin/activate' >> /home/geant/.service.sh
echo 'source /usr/local/geant4/geant4-v11.1.2-install/bin/geant4.sh' >> /home/geant/.service.sh
echo "nohup jupyter-lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --ServerApp.token='Feynman2024' > /tmp/jupyter-lab.log &" >> /home/geant/.service.sh
chmod -x /home/geant/.service.sh
cd /home/geant/ 
sudo su geant -c 'bash /home/geant/.service.sh'
sleep infinity