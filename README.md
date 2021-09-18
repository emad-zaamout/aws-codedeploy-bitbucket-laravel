# Laravel CI\CD using AWS RDS EC2 S3 CodeDeploy BitBucket and Bash

Laravel Deployment Automation. Using:
- **AWS EC2 Instance** – to host our production server (optional + staging)
- **AWS RDS Instance** – to run MySQL 8 Server for our Laravel project
- **AWS S3 Bucket** – to store our revisions
- **AWS CodeDeploy** – to run deployments
- **AWS Server Manager** – to store and populate our .env file
- **Bitbucket** – to store our code repository and run pipelines
- **Bash** – to create our scripts

Code Files
**[Youtube Tutorial Video](https://www.youtube.com/watch?v=YQsHMbbcIBo)**
**[Blog](https://www.ahtcloud.com/aws-codedeploy-bitbucket-laravel)**
**[Github](https://github.com/eezaamout/aws-codedeploy-bitbucket-laravel)**
**[Bitbucket](https://bitbucket.org/eezaamout/aws-codedeploy-bitbucket-laravel)**

**Complete CI\CD Pipelines.**

Make sure to include the following **repository variables** inside your Bitbucket repository. They are used by the scripts.
- **AWS_SECRET_ACCESS_KEY**: AWS IAM User Security Credentials secret access key.
- **AWS_ACCESS_ID**: AWS IAM User Security Credentials access key id.
- **AWS_DEFAULT_REGION**: Your AWS Resources region. I.e. ca-central-1
- **DEPLOYMENT_GROUP_NAME**: CodeDeploy, Application Deployment Group Name.
- **S3_BUCKET**: S3 Bucket name.


**[./devops/hooks/after-install.sh](./devops/hooks/after-install.sh)**
Once CodeDeploy agent is installed onto your server and a deploy action
is triggered; CodeDeploy triggers hooks  that allow you to run scripts on your
server during certain events. Supported events are: ** ApplicationStop, DownloadBundle, BeforeInstall, Install, AfterInstall,
ApplicationStart, ValidateService.** Used inside inside [./appspec.yml](./bitbucket-pipelines.yml). This script
runs inside our server after our application is installed. We change user owner to ubuntu & fix storage permission issues,
run composer install and load our env file from [AWS Systems Manager](https://aws.amazon.com/systems-manager/).

**[devops/scripts/generate-env.sh](./devops/scripts/generate-env.sh)**
Runs inside [bitbucket-pipelines.yml](./bitbucket-pipelines.yml). Creates a tar bundle for our project and stores it in AWS S3 Bucket. Then creates a new deployment using AWS CodeDeploy. The files are listed inside the [bundle.conf](./bundle.conf) file.

**[devops/build-for-production.sh](./devops/build-for-production.sh)**
Used inside [bitbucket-pipelines.yml](./bitbucket-pipelines.yml). Builds Laravel App for production. Different than testing.

**[devops/build-project.sh](./devops/build-project.sh)**
Used inside Bitbucket pipelines. Builds Laravel project and prepares it for testing. Creates an .env file from [.env.pipelines](./.env.pipelines).

**[devops/build-server.sh](./devops/build-server.sh)**
Used inside [bitbucket-pipelines.yml](./bitbucket-pipelines.yml). Builds server for testing stage.

**[devops/deploy-production.sh](./devops/deploy-production.sh)**
Used inside [bitbucket-pipelines.yml](./bitbucket-pipelines.yml). Creates a tar bundle for our project and stores it in AWS S3 Bucket. Then creates a new deployment using AWS CodeDeploy. The files are listed inside the bundle.conf file.

**[devops/run-tests.sh](./devops/run-tests.sh)**

**[.env.pipelines](./.env.pipelines)**
Runs inside your production server on new deployment. loads your .env file stored inside AWS Systems Manager (Paramater).

**[bitbucket-pipelines.yml](./bitbucket-pipelines.yml)**
Runs inside Bitbucket. Triggers Bitbucket pipelines per your specification.

**[appspec.yml](./appspec.yml)**
Runs inside your production server on deployment. Add this to give CodeDeploy instructions.

**[bundle.conf](./bundle.conf)**
Lists all files or directories that you want to include in the bundle.tar file that we will create and and store inside S3. Used for deployment..

**[devops/scripts/build-production-server.sh](./devops/scripts/build-production-server.sh)**
Not used anywhere. Just helps install all what you need on your production server to run a basic laravel project. Run manually.

**[devops/scripts/configure-apache.sh](./devops/scripts/configure-apache.sh)**
Not used anywhere. Just helps you set up apache2 conf, disable default site and enable new site. Change variables.

