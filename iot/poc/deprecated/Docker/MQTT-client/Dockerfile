FROM ubuntu:latest
RUN apt-get update && apt-get install -y mosquitto-clients
COPY mqtt_client.sh /mqtt_client.sh
CMD ["bash", "/mqtt_client.sh"]