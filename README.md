# GitOps Platform Factory

**⚠️ Project Status: Work in Progress**  
This project is currently under active development and is not yet complete. Some features may be incomplete or require additional configuration.

**🚀 Quick Start Workflow**:

1. **Update your Helm charts** in `helm/` directory
2. **Generate ArgoCD manifests** using the Go template generator
3. **Deploy ArgoCD** to your Kubernetes cluster
4. **ArgoCD syncs** your applications from Git

## Overview

The GitOps Platform Factory handles application deployment, Helm chart management, and ArgoCD configuration for Kubernetes clusters. This repository is designed to work in conjunction with the [Ephemeral-Environment-Factory](https://github.com/vladcalo/Ephemeral-Environment-Factory) which provides the underlying infrastructure.

**Note**: This repository focuses on the application layer and GitOps workflows. For infrastructure provisioning and cluster setup, see the companion [Ephemeral-Environment-Factory](https://github.com/vladcalo/Ephemeral-Environment-Factory) repository.

## Architecture

The project consists of three main layers:

### Application Layer

- **Go Template Generator**: Automated ArgoCD application manifest generation
- **Helm Charts**: Application packaging and deployment templates
- **ArgoCD**: GitOps-based application deployment and management

### Configuration Management

- **Ansible Playbooks**: ArgoCD deployment and configuration
- **Application Manifests**: Generated ArgoCD Application resources

## Project Structure

```
GitOps-Platform-Factory/
├── ansible/                    # Ansible configuration for ArgoCD
├── argocd/                    # Generated ArgoCD application manifests
│   ├── nginx-app.yaml        # Sample nginx application
│   └── whoami-app.yaml       # Sample whoami application
├── go/                        # Go template generator
│   ├── templates/             # Application manifest templates
│   ├── main.go               # Template generation logic
│   └── go.mod                # Go module dependencies
├── helm/                      # Helm charts for applications
│   ├── nginx-chart/          # Sample nginx application
│   │   ├── Chart.yaml        # Chart metadata
│   │   ├── templates/        # Kubernetes manifests
│   │   └── values.yaml       # Default values
│   └── whoami-chart/         # Sample whoami application
│       ├── Chart.yaml        # Chart metadata
│       ├── templates/        # Kubernetes manifests
│       └── values.yaml       # Default values
└── README.md                 # This file
```

## Key Features

### GitOps Workflow

- **Automated Deployment**: ArgoCD manages application lifecycle
- **Template Generation**: Go-based manifest generation from Helm charts
- **Version Control**: All configurations tracked in Git

### Application Management

- **Helm Charts**: Standardized application packaging
- **ArgoCD Applications**: Declarative application definitions
- **Multi-Environment**: Support for different deployment targets

## Prerequisites

### System Requirements

- **Go** >= 1.19 (for template generation)
- **Helm** >= 3.8.0
- **kubectl** >= 1.28
- **ArgoCD CLI** (optional, for management)

### Dependencies

```bash
# Install Go dependencies
cd go && go mod tidy
```

## Quick Start

**⚠️ Important Workflow Order**: You must first generate the Go templates and then deploy ArgoCD. The current samples in the `helm/` directory are examples that you need to update for your specific applications.

### 1. Update Helm Charts (Required First Step)

The `helm/` directory contains sample charts that you need to customize for your applications:

```bash
# Update the sample charts or add your own charts
cd helm/
# Edit nginx-chart/values.yaml, whoami-chart/values.yaml, or create new charts
# Update Chart.yaml files with your application details
# Modify templates/ to match your application requirements
```

**Current Sample Charts**:

- `nginx-chart/` - Basic nginx web server (update for your web app)
- `whoami-chart/` - HTTP info server (update for your API/service)

### 2. Generate Application Manifests

After updating your Helm charts, generate the ArgoCD Application manifests:

```bash
cd go
go build -o generator main.go
./generator nginx-app nginx-chart default
./generator whoami-app whoami-chart default
# Add more applications as needed
```

### 3. Deploy ArgoCD to Your Cluster

First, ensure you have a Kubernetes cluster running (provisioned by Ephemeral-Environment-Factory):

```bash
# Deploy ArgoCD
cd ../ansible/playbooks/
ansible-playbook argo.yaml -e kubeconfig_path=/Users/vladcalomfirescu/.kube/[admin/azure].conf

# Access ArgoCD UI
# Wait for Status=Pending
KUBECONFIG=~/.kube/[admin/azure].conf kubectl port-forward svc/argocd-server -n argocd 8080:443

# Get admin password
KUBECONFIG=~/.kube/[admin/azure].conf kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d && echo

#Go to localhost:8080
```

## Go Template Generator

The Go template generator creates ArgoCD Application manifests from Helm charts:

### Usage

```bash
# Build the generator
cd go
go build -o generator main.go

# Run from project root (not from go/ directory)
./go/generator <app-name> <chart-name> <namespace>
```

This generates an ArgoCD Application manifest that:

- References the specified Helm chart
- Deploys to the specified namespace
- Uses GitOps workflow for deployment

## Helm Charts

The repository includes sample Helm charts:

### nginx-chart

Basic nginx web server with configurable:

- Replica count
- Image version
- Service type
- Resource limits

### whoami-chart

HTTP server returning request information, useful for:

- Load balancer testing
- Network debugging
- Health check endpoints

## ArgoCD Applications

Applications are automatically generated from Helm charts using the Go template generator:

- **Declarative Configuration**: All settings defined in Git
- **Automated Sync**: ArgoCD automatically deploys changes
- **Rollback Support**: Easy rollback to previous versions
- **Health Monitoring**: Built-in health checks and status reporting

## Integration with Ephemeral Environment Factory

This repository works with clusters provisioned by the Ephemeral-Environment-Factory:

1. **Provision Cluster**: Use Ephemeral-Environment-Factory to create Kubernetes cluster
2. **Deploy ArgoCD**: Install ArgoCD on the provisioned cluster
3. **Deploy Applications**: Use this repository to deploy applications via GitOps

## Customization

### Working with Current Samples

**Before proceeding, you must update the sample charts**:

- The `nginx-chart/` and `whoami-chart/` are examples that need customization
- Update `values.yaml`, `Chart.yaml`, and templates to match your application requirements
- These samples demonstrate the structure but are not production-ready

### Adding New Applications

1. **Option A**: Update existing sample charts in `helm/` for your applications
2. **Option B**: Create a new Helm chart in `helm/`
3. Use the Go generator to create ArgoCD Application manifest
4. Commit and push both the Helm chart and generated manifest

### Modifying Existing Applications

1. Update the Helm chart in `helm/`
2. Regenerate the ArgoCD Application manifest using the Go generator
3. Commit and push both the updated chart and regenerated manifest

## Current Limitations

**Project is not yet finished** - The following areas need completion:

- ✅ **Basic Template Generation**: Go-based manifest generation
- ✅ **Sample Helm Charts**: nginx and whoami examples
- ❌ **Advanced Templating**: Support for complex application configurations
- ❌ **Multi-Cluster Support**: Deployment across multiple clusters
- ❌ **Environment Management**: Staging, production, etc.
- ❌ **Security**: Enhanced security configurations and RBAC
- ❌ **Monitoring**: Integration with monitoring and logging solutions

## Related Repositories

- **[Ephemeral-Environment-Factory](https://github.com/vladcalo/Ephemeral-Environment-Factory)**: Infrastructure provisioning and cluster setup
