# beanstalk-docker-deploy
A docker image that provides tools for deploying an Elastic Beanstalk application.


## Elastic Beanstalk example templates:

__eb/app/.elasticbeanstalk/config.json.sample__

```
branch-defaults:
  feature/my-feature:
    environment: myApp-myFeatureEnv
  staging:
    environment: myApp-staging
  production:
    environment: myApp-production
deploy:
  artifact: artifact.zip
global:
  application_name: myApp
  default_ec2_keyname: myApp
  default_platform: arn:aws:elasticbeanstalk:eu-west-1::platform/Docker running on
    64bit Amazon Linux/2.12.9
  default_region: my-region
  include_git_submodules: true
  instance_profile: null
  platform_name: null
  platform_version: null
  profile: eb-cli
  sc: git
  workspace_type: Application
```

### Mono-container (V1)

__eb/app/Dockerrun.aws.json.template (V1)__

```
{
  "AWSEBDockerrunVersion": 1,
  "Authentication": {
    "Bucket": "${REGISTRY_AUTH_BUCKET}",
    "Key": "${CI_REGISTRY}/.dockercfg"
  },
  "Image": {
    "Name": "${CI_REGISTRY_IMAGE}:${TAG}",
    "Update": "true"
  },
  "Ports": [
    {
      "ContainerPort": 3000,
      "HostPort": 80
    }
  ]
}
```

__eb/app/.ebextensions/options.config.template__
```
{
  "option_settings": [
    {
      "option_name": "DATABASE_URL",
      "value": "${DATABASE_URL}"
    }
  ]
}
```

### Multi-conatiner
__eb/app/DockerrunV2.aws.json.template (V2)__ 
```
{
    "AWSEBDockerrunVersion": 2,
    "authentication": {
        "bucket": "${REGISTRY_AUTH_BUCKET}",
        "key": "${CI_REGISTRY}/.dockercfg"
    },
    "containerDefinitions": [
        {
            "name": "app",
            "image": "${CI_REGISTRY_IMAGE}:${TAG}",
            "environment": [
              {
                "name": "DATABASE_URL",
                "value": "${DATABASE_URL}"
              }
            ],
            "essential": true,
            "memory": 600,
            "portMappings": [
                {
                "hostPort": 80,
                "containerPort": 3000
                }
            ]
        },
        {
            "name": "prometheus-app",
            "image": "prom/prometheus",
            "essential": true,
            "memory": 300,
            "portMappings": [
                {
                    "hostPort": 9090,
                    "containerPort": 9090
                }
            ]
        }
    ]
}
```

## Example usage with GitLab Pipelines and Dockerrun V2

You need to setup the folowing variables in your environement: `$AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY and $AWS_REGION` in order to use `addAwsCredential.sh` script.

```
eb-deploy-dev:
  image: breelbarcelona/beanstalk-deploy
  stage: deploy
  variables:
    GIT_STRATEGY: clone
  environment:
    name: my-env
    url: https://mydomain.com/
  script:
    # set-up AWS configurstion
    - sh eb-deploy/addAwsCredentials.sh
    # Remove slashes form branch name to generate docker tag
    - export IMAGE_TAGNAME=$(echo $CI_BUILD_REF_NAME | sed 's/\//_/g')
    # Copy elasticbeanstalk configuration
    - mkdir -p .elasticbeanstalk
    - cp eb/app/.elasticbeanstalk/config.yml.sample .elasticbeanstalk/config.yml
    # Generate the dockerun configuration file for the deployment (assuming your docker image has been created in another stage)
    - cat eb/app/DockerrunV2.aws.json.template | TAG=${IMAGE_TAGNAME} DATABASE_URL=${DATABASE_URL_DEV} envsubst > Dockerrun.aws.json
    # Generate deployment artifact  .ebextensions
    - zip -r artifact.zip Dockerrun.aws.json
    # Generate a TMP deployment branch for Elastic Beanstalk
    - git checkout -B "$CI_BUILD_REF_NAME" "$CI_BUILD_REF"
    - git add artifact.zip
    - eb deploy myApp-env
```