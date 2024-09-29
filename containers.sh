#!/bin/bash

# Clean Previous Containers
bash kill_containers.sh

# Pull the latest changes from the git repository
git pull ;

# Build the Docker image with the tag "ds_jupyter_server" and no cache
docker build -t ds_geant4_jupyter_server .;

# Run 40 containers, linking port 8888 of each container with a port in 9000-9040
for i in {00..40}
do
  container_name="ds_geant_$i"
  docker run -it \
  --cpus=1 -m=2048m --memory-swap=4096m \
  -d -p 90$i:22 -p 91$i:8888  --name $container_name ds_geant4_jupyter_server
done

echo "Done!"