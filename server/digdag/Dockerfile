FROM python:3.8-stretch

RUN apt update
RUN apt install default-jdk -y

RUN curl -o /bin/digdag --create-dirs -L "https://dl.digdag.io/digdag-0.9.41"
RUN chmod +x /bin/digdag

WORKDIR /usr/src/app

# The tasks will use this directly
COPY requirements.txt requirements.txt

RUN pip3 install -r requirements.txt

# COPY run.sh run.sh

ENTRYPOINT [ "/bin/bash", "./run.sh" ]
