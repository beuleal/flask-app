# Python API using Flusk

This is a Python API Application created using Flask and deployed to AWS Account using Docker and Terraform.

It has a production usage with nginx and WSGI Server.

The AWS infrasctucture created by Terraform is quite simple, it has:
* ECS
  * Cluster
  * Task Definitions
  * Container Configuration
  * Service

* IAM
  * Roles
  * Policies

* Application Load Balancer
  * Target Group
  * Listener

* Security Group

![Infrastructure Diagram](/images/diagram.io.png)

*IMPORTANT:* This documentation assumes you already have an AWS Account and its configured in your computer.

## Virtual Environment

This project was developed using the virtual environment and I _recommend_ to use it if possible.

Make sure you have it installed, if not run:

```
sudo apt-get install virtualenv
```

## Docker image

This project has a dockerfile that creates an docker image for API application.

We are using the well know docker image `uwsgi-nginx-flask` as it already have the `wsgi` server to host your application in a production mode with ngnix as well. 

### Build Docker Image

Run the following commmand to build the docker image:

```
docker build -t api .
```

### Run a container using the Docker Image

Run the following command to run the container:

```
docker run -p 5000:5000 api
```

### Push Docker image to ECR

This project uses a personal ECR created by Terraform and it has a section under Terraform explaining how to create the resources by code.

To push an image to ECR, the developer must tag the image and then push to AWS according with its account details.

1. Get ECR Access _(Replace values)_:
```
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.<region>.amazonaws.com
```

2. Tag the image according with AWS Account Registry ID:
```
docker tag api <aws_account_id>.dkr.ecr.eu-west-1.amazonaws.com/api
```

3. Push the image:
```
docker push <aws-account-id>.dkr.ecr.eu-west-1.amazonaws.com/api
```

## Run Unit Tests

For unit test, this project is using `pytest`. To test the application, run the following command:

```
$ cd api && pytest
```

As we have only one endpoint with two method allowed, the tests will test if:

- The return was sucess looking for the HTPP code
- The json returned was the one expected
- The name parameter was provided

## Terraform

Take a note that this project deploys the infrastructure using terraform.

Set the environment variable `AWS_DEFAULT_REGION='eu-west-1'`

For ECR and API AWS Application resources, the commands are the same, however the files are in its own directory under _./terraform_.

*Commands Explained:*
- _terraform init_: generates the terraform state files
- _terraform plan_: check if the files are correct and ready to run.
- _terraform apply_: apply the changes in the infrastructure.

### ECR

The API Docker Image is hosted in ECR. To create the ECR, run the following code:

```
cd terraform/ecr && \
terraform init && \
terraform plan && \
terraform apply 
```

The last command will prompt you asking to type "yes" if you want to procced with the resource creation.

### Resources for API

To create the infrasctucture in AWS for this API, run the following code:

```
cd terraform/app && \
terraform init && \
terraform plan && \
terraform apply 
```

The last command will prompt you asking to type "yes" if you want to procced with the resource creation.

### Teardown

For ECR and AWS Resources for API, the developer must access the respective terraform folder and run:
```
terraform destroy
```
## Requirements

The environment must have:
- python 3
- pip
- virtualenv

The required dependencies for Flask Application can be found in `requirement.txt` file and can be installed running the following command:

```pip install -r requirements.txt```

## Useful Links

https://hub.docker.com/r/tiangolo/uwsgi-nginx-flask
https://flask.palletsprojects.com/en/2.0.x/
https://virtualenv.pypa.io/en/stable/
https://docs.aws.amazon.com/AmazonECR/latest/userguide/getting-started-cli.html
https://registry.terraform.io/providers/hashicorp/aws/latest


---

Created by Brenno Leal
