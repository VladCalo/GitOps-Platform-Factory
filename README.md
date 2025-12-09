# GitOps Platform Factory

Deploys ArgoCD and Helm chart applications to Kubernetes clusters. Works with clusters from [Ephemeral-Environment-Factory](https://github.com/vladcalo/Ephemeral-Environment-Factory).

## Usage

```bash
./manage.sh deploy multipass   # local cluster
./manage.sh deploy aks         # azure cluster
./manage.sh destroy multipass
./manage.sh destroy aks
```

**Note**: Generate templates first, then deploy. Sample charts in `helm/` are examples - update for your apps.

## Stack

- **Go generator**: Creates ArgoCD Application manifests from Helm charts
- **Helm charts**: App packaging (`helm/nginx-chart`, `helm/whoami-chart`)
- **Ansible**: ArgoCD deployment and configuration
- **ArgoCD**: GitOps-based deployment with auto-sync, rollback, health monitoring

## Go Generator

```bash
cd go
go build -o generator main.go
./generator <app-name> <chart-name> <namespace>
```

Generates ArgoCD Application manifest that references the Helm chart and deploys to the specified namespace.

## Adding Applications

1. Create Helm chart in `helm/` (or update existing samples)
2. Run generator to create ArgoCD manifest
3. Commit and push both chart and manifest

## Workflow

1. Provision cluster with Ephemeral-Environment-Factory
2. Deploy GitOps: `./manage.sh deploy multipass`
3. ArgoCD manages application lifecycle automatically
4. Cleanup: `./manage.sh destroy multipass`

## Prerequisites

- Go >= 1.19
- Helm >= 3.8.0
- kubectl >= 1.28
- ArgoCD CLI (optional)
