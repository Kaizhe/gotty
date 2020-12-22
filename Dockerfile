FROM ubuntu

RUN apt-get update

RUN apt-get install -y software-properties-common git jq net-tools netcat

RUN apt-get update

RUN add-apt-repository ppa:longsleep/golang-backports && apt update && apt -y install golang-go

ENV GOPATH /home/go

ENV PATH /home/go/bin:$PATH

RUN go get github.com/yudai/gotty

RUN which gotty

ENTRYPOINT ["gotty", "-w", "/bin/bash"]
