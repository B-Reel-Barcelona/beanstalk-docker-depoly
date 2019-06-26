FROM python:3

RUN apt-get update && apt-get install -y curl software-properties-common
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main' >  /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update -qq && apt-get install -y zip awscli gettext-base git postgresql-client-10 dnsutils nodejs
RUN apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   xenial \
   stable"
RUN apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io
RUN pip install --upgrade pip
RUN pip install awsebcli ecs-deploy --upgrade
RUN node -v
COPY ./eb-deploy /eb-deploy

RUN chmod +x /eb-deploy/addAwsCredentials.sh
