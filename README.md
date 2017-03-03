Google Cloud SDK Docker Image
=======

### What is this?
A docker image based on [Alpine Linux](https://alpinelinux.org/) that includes [Google Cloud SDK](https://cloud.google.com/sdk/). To keep it small and minimal, it only installs gcloud core components and kubectl by default, but you can customize it based on your needs.

### Use Cases
* It can be used in CI/CD deployment pipelines or in other automated build/deploy processes where you need `gcloud` or `kubectl` to deploy into [Google Cloud Platform](https://cloud.google.com/) or [Kubernetes](https://kubernetes.io/) clusters.

### Usage
Just execute:
```bash
  $ docker run --rm -it iiriix/gcloud sh
  $ gcloud info
  $ kubectl help
```
You can even mount your configuration files as a volume to skip the authenticate step.

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
      iiriix/gcloud sh
```

### Build
If you need to customize or build it yourself:
```bash
  $ git clone https://github.com/iiriix/gcloud.git
  $ cd gcloud
  $ docker build -t iiriix/gcloud:customized .
  $ docker run --rm -it iiriix/gcloud:customized sh
```

### ToDO
- [ ] Add support for environment variables to initialize the SDK and authenticate to GCP.

### Feedback
For bug reports or suggestion, please open an issue on [GitHub](https://github.com/iiriix/gcloud/issues).
