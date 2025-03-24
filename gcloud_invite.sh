#!/bin/bash

# Documentation : https://cloud.google.com/kubernetes-engine/docs/concepts/access-control

# Service account : roles/container.defaultNodeServiceAccount
# https://cloud.google.com/iam/docs/understanding-roles#container.defaultNodeServiceAccount

# Check for correct number of arguments.
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <PROJECT_ID> <EMAIL>"
  exit 1
fi

PROJECT_ID="$1"
EMAIL="$2"

echo "Inviting user '$EMAIL' to project '$PROJECT_ID' with the following roles:"
echo "- roles/editor"
echo "- roles/artifactregistry.admin"
echo "- roles/compute.admin"

# Add the Editor role
# https://cloud.google.com/iam/docs/understanding-roles#legacy-basic
gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="user:$EMAIL" \
  --role="roles/editor"

# Add the Artifact Registry Admin role
# https://cloud.google.com/iam/docs/understanding-roles#artifactregistry.admin
gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="user:$EMAIL" \
  --role="roles/artifactregistry.admin"

# Add the Compute Admin role
# https://cloud.google.com/iam/docs/understanding-roles#container.admin
gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="user:$EMAIL" \
  --role="roles/compute.admin"

echo "User '$EMAIL' invitation and role assignment to project '$PROJECT_ID' complete."