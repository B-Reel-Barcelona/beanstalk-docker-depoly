FROM python:3

RUN apt-get update -qq && apt-get install -y zip awscli gettext-base git
RUN pip install awsebcli --upgrade

COPY ./eb-deploy /eb-deploy

RUN chmod +x /eb-deploy/addAwsCredentials.sh
