Google Cloud SDK Docker Image
=======

### What is this?
A docker image based on [Alpine Linux](https://alpinelinux.org/) that includes [Google Cloud SDK](https://cloud.google.com/sdk/). To keep it small and minimal, it only installs gcloud core components and kubectl by default, but you can customize it based on your needs.

### Use Cases
* It can be used in CI/CD deployment pipelines or in other automated build/deploy processes where you need `gcloud` or `kubectl` to deploy into [Google Cloud Platform](https://cloud.google.com/) or [Kubernetes](https://kubernetes.io/) clusters.

### Usage
Just execute:
```bash
  $ docker run -it iiriix/gcloud
```

#### Mounting Configuration Directories
You can mount configuration files as a volume to skip the authenticate step.

* For gcloud:

```bash
  $ docker run --rm -it \
      -v ~/.config/gcloud:/root/.config/gcloud \
      iiriix/gcloud sh
```

* For kubectl:

```bash
  $ docker run --rm -it \
      -v ~/.config/gcloud:/root/.config/gcloud \
      -v ~/.kube:/root/.kube \
      iiriix/gcloud kubectl get pod
```

#### Environment Variables
Set environment variables to the container to initialize and activate service account. Read more about [Google Cloud Service Account](https://cloud.google.com/storage/docs/authentication?hl=en#service_accounts).

Here is the list of variables:

* CLOUDSDK_SERVICE_ACCOUNT: base64 encoded service key
* CLOUDSDK_SERVICE_ACCOUNT_FILE: Service key file path. Note that in addition to this variable, you still need to mount the key file as a volume.
* CLOUDSDK_PROJECT_NAME: Google Cloud project name
* CLOUDSDK_COMPUTE_ZONE: Zone for Compute and Container Engine
* CLOUDSDK_CLUSTER_NAME: Kubernetes cluster name (Container Engine)

```bash
  $ docker run --rm -it \
      -e "CLOUDSDK_SERVICE_ACCOUNT=$(base64 service-key.json)" \
      -e "CLOUDSDK_PROJECT_NAME=myproject" \
      -e "CLOUDSDK_COMPUTE_ZONE=europe-west1-b" \
      -e "CLOUDSDK_CLUSTER_NAME=mycluster" \
      iiriix/gcloud gcloud compute instances list
```

```bash
  $ docker run --rm -it \
      -v $(pwd)/service-key.json:/service-key.json \
      -e "CLOUDSDK_SERVICE_ACCOUNT_FILE=/service-key.json" \
      -e "CLOUDSDK_PROJECT_NAME=myproject" \
      -e "CLOUDSDK_COMPUTE_ZONE=europe-west1-b" \
      -e "CLOUDSDK_CLUSTER_NAME=mycluster" \
      iiriix/gcloud kubectl get deploy
```

#### Docker Inside Docker
Mount docker socket into the container and run docker commands to build, push and etc.

```bash
  $ docker run --rm -it \
      -v /var/run/docker.sock:/var/run/docker.sock \
      iiriix/gcloud docker ps
```

#### Running a Custom Script
The init script looks for a file named `/code/ci.sh` and runs it when the container starts. This can be useful to put whatever you want to run inside the container in this file and just mount it as /code/ci.sh in the container.

```bash
  $ docker run --rm -it \
      -v /your_script.sh:/code/ci.sh \
      iiriix/gcloud
```

#### Real World Example
Mount your code as `/code`. The `/code/ci.sh` script will be run in the container to build, test, push and deploy your code on your infrastructure:

```bash
	$ docker run --rm -it \
      -v $(pwd)/service-key.json:/service-key.json \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v $(pwd)/sample-nginx:/code \
      -e "CLOUDSDK_SERVICE_ACCOUNT_FILE=/service-key.json" \
      -e "CLOUDSDK_PROJECT_NAME=myproject" \
      -e "CLOUDSDK_COMPUTE_ZONE=europe-west1-b" \
      -e "CLOUDSDK_CLUSTER_NAME=mycluster" \
      iiriix/gcloud
```

### Build
If you need to customize or build it yourself:
```bash
  $ git clone https://github.com/iiriix/gcloud.git
  $ cd gcloud
  $ docker build -t iiriix/gcloud:customized .
  $ docker run --rm -it iiriix/gcloud:customized
```

### ToDO
- [x] Add support for environment variables to initialize the SDK and authenticate to GCP.
- [x] Add docker package.
- [x] Add support for running a custom script mounted in a predefined path.
- [ ] Support for different Cloud SDK versions.

### Feedback
For bug reports or suggestion, please open an issue on [GitHub](https://github.com/iiriix/gcloud/issues).
