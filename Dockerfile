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
        && \
    pip install --upgrade awscli s3cmd awsebcli python-magic ecs-deploy setuptools && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/*

RUN python -v
RUN node -v
RUN aws --version

COPY ./eb-deploy /eb-deploy

RUN chmod +x /eb-deploy/addAwsCredentials.sh
