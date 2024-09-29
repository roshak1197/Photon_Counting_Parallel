FROM ubuntu:22.04
USER root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update
#librerias para geant4
RUN apt install -y wget cmake qttools5-dev freeglut3-dev libmotif-dev tk-dev libxpm-dev libxmu-dev libxi-dev libxerces-c-dev libxcb-xinerama0
#construir geant
RUN mkdir -p /usr/local/geant4/geant4-v11.1.2-build 
WORKDIR /usr/local/geant4
RUN wget https://gitlab.cern.ch/geant4/geant4/-/archive/v11.1.2/geant4-v11.1.2.tar.gz && tar -zxvf geant4-v11.1.2.tar.gz 
WORKDIR /usr/local/geant4/geant4-v11.1.2-build
RUN cmake -DCMAKE_INSTALL_PREFIX=/usr/local/geant4/geant4-v11.1.2-install   -DGEANT4_USE_GDML=ON   -DCMAKE_BUILD_TYPE=Debug   -DGEANT4_INSTALL_DATA=ON   -DGEANT4_USE_OPENGL_X11=ON   -DGEANT4_USE_XM=ON   -DGEANT4_USE_QT=ON   -DGEANT4_USE_PYTHON=ON   -DGEANT4_BUILD_MULTITHREADED=ON   /usr/local/geant4/geant4-v11.1.2 
RUN make -j30
RUN make install -j30
RUN echo 'source /usr/local/geant4/geant4-v11.1.2-install/bin/geant4.sh' >> /etc/bashrc
#add geant user
RUN useradd -ms /bin/bash geant
ENV PASSWORD=Feynman2024
RUN echo "geant:$PASSWORD" | chpasswd
#RUN usermod -aG sudo geant
#RUN echo "geant ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers 
#añadir ssh
RUN apt install -y openssh-server curl python-is-python3 gedit unzip
RUN echo "X11Forwarding yes" >> /etc/ssh/sshd_config
RUN ssh-keygen -A
RUN sed -i 's/#X11UseLocalhost yes/X11UseLocalhost no/g' /etc/ssh/sshd_config
# add jupyter
RUN apt-get install -y git curl python3.10-venv
USER geant 
RUN cp -r /usr/local/geant4/geant4-v11.1.2/examples ~/geant4-examples
# create a env of python
RUN python -m venv /home/geant/.env
RUN /home/geant/.env/bin/pip install --upgrade pip
RUN /home/geant/.env/bin/pip install numpy scipy matplotlib pandas jupyterlab opencv-python
COPY PEPI2-main.zip /home/geant/PEPI2-main.zip 
WORKDIR /home/geant/
RUN unzip PEPI2-main.zip
COPY entrypoint.sh /home/geant/entrypoint.sh
USER root
RUN apt install sudo
RUN chmod -x /home/geant/entrypoint.sh
#ENTRYPOINT ["/home/geant/entrypoint.sh"]
CMD ["bash","/home/geant/entrypoint.sh"]