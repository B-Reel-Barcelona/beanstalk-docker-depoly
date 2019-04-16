FROM python:3

RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main' >  /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update -qq && apt-get install -y zip awscli gettext-base git postgresql-client-10
RUN pip install awsebcli --upgrade

COPY ./eb-deploy /eb-deploy

RUN chmod +x /eb-deploy/addAwsCredentials.sh
