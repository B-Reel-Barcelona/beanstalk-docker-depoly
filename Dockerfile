FROM python:3

RUN apt-get update -qq && apt-get install -y zip awscli gettext-base git
RUN pip install awsebcli --upgrade

ADD ./eb-deploy /eb-deploy

WORKDIR /eb-deploy
RUN chmod +x addAwsCredentials.sh
