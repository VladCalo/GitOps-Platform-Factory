# GitOps Platform Factory

## Overview

The GitOps Platform Factory is a **plug-and-play solution** that automatically deploys your applications to Kubernetes clusters using GitOps principles. Deploy ArgoCD and your Helm charts with a single command - perfect for rapid application deployment and management.

**Purpose**: Application deployment and GitOps workflows for Kubernetes clusters. This repository works with clusters provisioned by [Ephemeral-Environment-Factory](https://github.com/vladcalo/Ephemeral-Environment-Factory).

## Quick Summary

**What it does**: Automatically deploys ArgoCD and your Helm chart applications  
**How to use**: `./manage.sh deploy multipass` or `./manage.sh deploy aks`  
**How to destroy**: `./manage.sh destroy multipass` or `./manage.sh destroy aks`  
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

## Key Features

### Plug-and-Play Application Deployment

- **Single Command**: `./manage.sh deploy multipass` or `./manage.sh deploy aks`
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

Use the manage script to automate the entire GitOps setup:

```bash
# Deploy to multipass cluster
./manage.sh deploy multipass

# Deploy to AKS cluster
./manage.sh deploy aks

# Destroy from multipass cluster
./manage.sh destroy multipass

# Destroy from AKS cluster
./manage.sh destroy aks
```

## Go Template Generator

The Go template generator creates ArgoCD Application manifests from Helm charts:

### Usage

```bash
cd go
go build -o generator main.go

./generator <app-name> <chart-name> <namespace>
```

This generates an ArgoCD Application manifest that:

- References the specified Helm chart
- Deploys to the specified namespace
- Uses GitOps workflow for deployment

## Helm Charts

The repository includes sample Helm charts: **nginx** and **whoami** and you can also use your own

## ArgoCD Applications

Applications are automatically generated from Helm charts using the Go template generator:

- **Declarative Configuration**: All settings defined in Git
- **Automated Sync**: ArgoCD automatically deploys changes
- **Rollback Support**: Easy rollback to previous versions
- **Health Monitoring**: Built-in health checks and status reporting

## Integration with Ephemeral Environment Factory

This repository works with clusters provisioned by the Ephemeral-Environment-Factory:

1. **Provision Cluster**: Use Ephemeral-Environment-Factory to create Kubernetes cluster
2. **Deploy GitOps**
3. **Manage Applications**
4. **Cleanup**

### Adding New Applications

1. **Option A**: Update existing sample charts in `helm/` for your applications
2. **Option B**: Create a new Helm chart in `helm/`
3. Use the Go generator to create ArgoCD Application manifest
4. Commit and push both the Helm chart and generated manifest

## Current Limitations

**Project is not yet finished** - The following areas need completion:

- ✅ **Basic Template Generation**: Go-based manifest generation
- ✅ **Sample Helm Charts**: nginx and whoami examples
- ❌ **Clean code**: 50% needs improvement
- ❌ **Advanced Templating**: Support for complex application configurations
- ❌ **Environment Management**: Staging, production, etc.
- ❌ **Security**: Enhanced security configurations and RBAC
- ❌ **Monitoring**: Integration with monitoring and logging solutions

## Related Repositories

- **[Ephemeral-Environment-Factory](https://github.com/vladcalo/Ephemeral-Environment-Factory)**: Infrastructure provisioning and cluster setup
