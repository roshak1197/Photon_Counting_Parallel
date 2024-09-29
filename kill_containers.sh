#!/bin/bash

# Stop and remove all the containers that were created using the ds_jupyter_server image
docker ps -a --filter "ancestor=ds_geant4_jupyter_server" --format "{{.ID}}" | xargs docker stop | xargs docker rm