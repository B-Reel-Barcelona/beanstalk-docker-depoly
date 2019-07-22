FROM docker:latest

RUN apk -v --update add \
   python \
   py-pip \
   groff \
   less \
   mailcap \
   nodejs \
   nodejs-npm \
   bash \
   git \
   ca-certificates \
   curl \
   jq \
   openssh \
   curl \
   && \
   pip install --upgrade awscli s3cmd awsebcli python-magic ecs-deploy setuptools && \
   rm /var/cache/apk/*

RUN curl -o /usr/local/bin/ecs-cli https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-linux-amd64-latest
RUN chmod +x /usr/local/bin/ecs-cli

RUN python -v
RUN node -v
RUN npm install ecs-deployment-monitor -g
RUN aws --version

COPY ./eb-deploy /eb-deploy

RUN chmod +x /eb-deploy/addAwsCredentials.sh
