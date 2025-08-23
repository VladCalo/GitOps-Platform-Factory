# GitOps Platform Factory

**⚠️ Project Status: Work in Progress**  
This project is currently under active development and is not yet complete. Some features may be incomplete or require additional configuration.

**🚀 Quick Start Workflow**:

1. **Update your Helm charts** in `helm/` directory
2. **Generate ArgoCD manifests** using the Go template generator
3. **Deploy ArgoCD** to your Kubernetes cluster
4. **ArgoCD syncs** your applications from Git

## Overview

The GitOps Platform Factory is a **plug-and-play solution** that automatically deploys your applications to Kubernetes clusters using GitOps principles. Deploy ArgoCD and your Helm charts with a single command - perfect for rapid application deployment and management.

**Purpose**: Application deployment and GitOps workflows for Kubernetes clusters. This repository works with clusters provisioned by [Ephemeral-Environment-Factory](https://github.com/vladcalo/Ephemeral-Environment-Factory).

## Quick Summary

**What it does**: Automatically deploys ArgoCD and your Helm chart applications  
**How to use**: `./build.sh multipass` or `./build.sh aks`  
**Time to deploy**: ~2-3 minutes for ArgoCD + application deployment  
**What you get**: Fully configured GitOps platform with your apps running

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

### Plug-and-Play Application Deployment

- **Single Command**: `./build.sh multipass` or `./build.sh aks`
- **Automatic Discovery**: Scans Helm directory and generates ArgoCD manifests
- **Zero Configuration**: Deploys ArgoCD and your applications automatically

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

### Automated Deployment

Use the build script to automate the entire GitOps setup:

```bash
# Deploy to multipass cluster
./build.sh multipass

# Deploy to AKS cluster
./build.sh aks
```

### What the Build Script Does

1. **Checks kubeconfig** - Verifies cluster access (admin.conf for multipass, azure.conf for AKS)
2. **Generates templates** - Automatically discovers all Helm charts and generates ArgoCD manifests
3. **Deploys ArgoCD** - Installs and configures ArgoCD on your cluster
4. **Port-forward setup** - Backgrounds port-forward and outputs UI access details

### Manual Steps (if needed)

**Update Helm Charts:**

```bash
cd helm/
# Edit chart values and templates for your applications
```

**Current Sample Charts:**

- `nginx-chart/` - Basic nginx web server (update for your web app)
- `whoami-chart/` - HTTP info server (update for your API/service)

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

## Kubectl Configuration

The build script automatically detects and uses the correct kubeconfig based on your cluster type:

### Local Cluster (Multipass)

- **Kubeconfig location**: `~/.kube/admin.conf`
- **Build script usage**: `./build.sh multipass`
- **Automatic detection**: Script uses `admin.conf` for multipass clusters

### Azure Cluster (AKS)

- **Kubeconfig location**: `~/.kube/azure.conf`
- **Build script usage**: `./build.sh aks`
- **Automatic detection**: Script uses `azure.conf` for AKS clusters

### Manual Usage

```bash
# For multipass cluster
export KUBECONFIG=~/.kube/admin.conf
kubectl get nodes

# For AKS cluster
export KUBECONFIG=~/.kube/azure.conf
kubectl get nodes
```

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
- ❌ **Environment Management**: Staging, production, etc.
- ❌ **Security**: Enhanced security configurations and RBAC
- ❌ **Monitoring**: Integration with monitoring and logging solutions

## Related Repositories

- **[Ephemeral-Environment-Factory](https://github.com/vladcalo/Ephemeral-Environment-Factory)**: Infrastructure provisioning and cluster setup
