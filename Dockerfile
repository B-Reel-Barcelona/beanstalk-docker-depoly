FROM docker:dind

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
        openssh \
        && \
    pip install --upgrade awscli s3cmd awsebcli python-magic ecs-deploy && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/*

RUN node -v
COPY ./eb-deploy /eb-deploy

RUN chmod +x /eb-deploy/addAwsCredentials.sh
