#!/bin/sh
#
# ENTRYPOINT script to initialize gcloud and kubectl


# Exit on any error
set -e

# Update the $PATH
export PATH="/google-cloud-sdk/bin:$PATH"

# Needed by kubectl to find default credentials
export GOOGLE_APPLICATION_CREDENTIALS="/cloudsdk_service_account.json"

# Activate GCP service account
if [ -n "${CLOUDSDK_SERVICE_ACCOUNT}" ]; then
  echo ${CLOUDSDK_SERVICE_ACCOUNT} | base64 -d > ${GOOGLE_APPLICATION_CREDENTIALS}
  gcloud auth activate-service-account --key-file ${GOOGLE_APPLICATION_CREDENTIALS}
elif [ -s "${CLOUDSDK_SERVICE_ACCOUNT_FILE}" ]; then
  cat ${CLOUDSDK_SERVICE_ACCOUNT_FILE} > ${GOOGLE_APPLICATION_CREDENTIALS}
  gcloud auth activate-service-account --key-file ${GOOGLE_APPLICATION_CREDENTIALS}
fi

# Set project
if [ -n "${CLOUDSDK_PROJECT_NAME}" ]; then
  gcloud config set project ${CLOUDSDK_PROJECT_NAME}
fi

# Set project zone
if [ -n "${CLOUDSDK_COMPUTE_ZONE}" ]; then
  gcloud config set compute/zone ${CLOUDSDK_COMPUTE_ZONE}
fi

# Set the default kubernetes cluster
if [ -n "${CLOUDSDK_CLUSTER_NAME}" ]; then
  gcloud config set container/cluster ${CLOUDSDK_CLUSTER_NAME}
  # get cluster credentials only when project and zone are set
  if [ -n "${CLOUDSDK_PROJECT_NAME}" ] && [ -n "${CLOUDSDK_COMPUTE_ZONE}" ]; then
    gcloud container clusters get-credentials ${CLOUDSDK_CLUSTER_NAME}
  fi
fi

# Run the parameters
exec "$@"
