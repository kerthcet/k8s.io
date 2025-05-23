/*
Copyright 2024 The Kubernetes Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

module "iam" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~> 8.1"

  projects = [module.project.project_id]

  mode = "authoritative"

  bindings = {
    "roles/container.admin" = [
      "group:k8s-infra-cluster-admins@kubernetes.io",
      "serviceAccount:argocd@k8s-infra-prow.iam.gserviceaccount.com",
      "serviceAccount:prow-control-plane@k8s-infra-prow.iam.gserviceaccount.com",
      "serviceAccount:prow-deployer@k8s-infra-prow-build-trusted.iam.gserviceaccount.com"
    ]
    "roles/secretmanager.secretAccessor" = [
      "serviceAccount:kubernetes-external-secrets@k8s-infra-prow-build-trusted.iam.gserviceaccount.com",
      "principal://iam.googleapis.com/projects/${module.project.project_number}/locations/global/workloadIdentityPools/${module.project.project_id}.svc.id.goog/subject/ns/external-secrets/sa/external-secrets",
    ]
  }
}
