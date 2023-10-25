FROM ubuntu:20.04
# On Ubuntu 22.04, we can't have an old vulnerable version of log4j library so easily

# Ignore suggestions and recommendations to keep image small
RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker
RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker

# Install some tools
# - wget and curl to download from Internet
# - nmap to scan the network
# - iproute2 to have the "ip" application to get our local network
# Install vulnerable log4j library and applications
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update \
  && apt-get install -y wget curl nmap iproute2 \
  && apt-get install -y liblog4j2-java=2.11.2-1 \
  && apt-mark hold liblog4j2-java \
  && apt-get install -y igv jabref \
  && rm -rf /var/lib/apt/lists/*

#Download a fake Linux virus for Carbon Black
WORKDIR /app/
RUN wget --no-check-certificate https://github.com/slist/LinuxMalware/raw/main/cctest
RUN chmod +x cctest

# Download and extract xmrig : a very popular cryptominer (Ubuntu Focal is Ubuntu 20.04)
RUN wget https://github.com/xmrig/xmrig/releases/download/v6.18.0/xmrig-6.18.0-focal-x64.tar.gz
RUN tar xzvf xmrig-6.18.0-focal-x64.tar.gz

# Copy a fake SSH private key in container image
# You can create your own key using: ssh-keygen -t ed25519 -C "example@example.com"
COPY id_ed25519 /root/.ssh/id_ed25519

# Copy a fake AWS key in container image
# Keys from AWS documentation
COPY config ~/.aws/config
COPY credentials ~/.aws/credentials

# AWS keys in Environment variables
ENV AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
ENV AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
ENV AWS_DEFAULT_REGION=us-west-2

# devils.sh is the script that will run all malicious activities at runtime
COPY devil.sh /app/
RUN chmod +x /app/devil.sh
CMD /app/devil.sh
