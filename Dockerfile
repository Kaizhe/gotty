FROM ubuntu

RUN apt-get update

RUN apt-get install -y software-properties-common git jq net-tools netcat curl wget

RUN apt-get update

RUN add-apt-repository ppa:longsleep/golang-backports && apt update && apt -y install golang-go

ENV GOPATH /home/go

ENV PATH /home/go/bin:$PATH

RUN go get github.com/yudai/gotty

RUN apt-get install -y dialog apt-utils

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get install -y -q awscli

RUN aws --version

ENV AWS_METADATA_IP 169.254.170.2

RUN apt-get install -y vim nmap

RUN echo 'export AWS_ACCESS_KEY_ID=$(curl http://$AWS_METADATA_IP$AWS_CONTAINER_CREDENTIALS_RELATIVE_URI | jq .AccessKeyId -r)' >> ~/.bashrc

RUN echo 'export AWS_SECRET_ACCESS_KEY=$(curl http://$AWS_METADATA_IP$AWS_CONTAINER_CREDENTIALS_RELATIVE_URI | jq .SecretAccessKey -r)' >> ~/.bashrc

RUN echo 'export AWS_SESSION_TOKEN=$(curl http://$AWS_METADATA_IP$AWS_CONTAINER_CREDENTIALS_RELATIVE_URI | jq .Token -r)' >> ~/.bashrc

RUN apt-get install -y lsof libcap2-bin

ENTRYPOINT ["gotty", "-w", "/bin/bash"]
