Sample Nginx Deployment for Kubernetes
=======

Sample repo to show how you can use [`iiriix/gcloud`](https://github.com/iiriix/gcloud) to mount your code as a volume into the container and build, push and deploy your containers in your infrastructure.

Simply name your deploy script as [`ci.sh`](https://github.com/iiriix/gcloud/blob/master/sample-nginx/ci.sh). When the container starts, it will look for /code/ci.sh and runs it if it exists.
