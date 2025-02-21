#/bin/bash

cd backend
docker-compose up --build -d
cd ../frontend
docker-compose up --build -d