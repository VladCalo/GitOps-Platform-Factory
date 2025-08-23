#!/bin/bash

set -x

if [ $# -ne 1 ]; then
    echo "Usage: $0 <multipass|aks>"
    exit 1
fi

TYPE=$1

check_kubeconfig() {
    case $TYPE in
        multipass)
            if [ ! -f ~/.kube/admin.conf ]; then
                echo "Kubeconfig not found: ~/.kube/admin.conf"
                echo "Please deploy cluster first with Ephemeral-Environment-Factory"
                exit 1
            fi
            export KUBECONFIG=~/.kube/admin.conf
            ;;
        aks)
            if [ ! -f ~/.kube/azure.conf ]; then
                echo "Kubeconfig not found: ~/.kube/azure.conf"
                echo "Please deploy AKS cluster first with Ephemeral-Environment-Factory"
                exit 1
            fi
            export KUBECONFIG=~/.kube/azure.conf
            ;;
        *)
            echo "Invalid type: $TYPE. Use multipass or aks"
            exit 1
            ;;
    esac
}

generate_templates() {
    cd go
    go build -o generator main.go
    
    cd ..
    for chart in helm/*/; do
        if [ -d "$chart" ]; then
            chart_name=$(basename "$chart")
            app_name="${chart_name%-chart}-app"
            echo "Generating template for $chart_name"
            ./go/generator "$app_name" "$chart_name" default
        fi
    done
}

deploy_argocd() {
    cd ansible/playbooks
    if ! ansible-playbook argo.yaml -e "kubeconfig_path=$KUBECONFIG"; then
        echo "ArgoCD installation failed! Exiting."
        exit 1
    fi

    echo "Waiting for ArgoCD server pod to be ready..."
    while true; do
        if KUBECONFIG=$KUBECONFIG kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server --no-headers | grep -q "1/1.*Running"; then
            echo "ArgoCD server pod is ready!"
            break
        fi
        echo "ArgoCD server pod still starting... waiting 10 seconds"
        sleep 10
    done
    
    KUBECONFIG=$KUBECONFIG kubectl port-forward svc/argocd-server -n argocd 8080:443 &
    PORT_FORWARD_PID=$!
    
    echo "ArgoCD UI: https://localhost:8080"
    echo "Username: admin"
    echo "Password: $(KUBECONFIG=$KUBECONFIG kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath='{.data.password}' | base64 -d)"
    echo "Port-forward PID: $PORT_FORWARD_PID (use 'kill $PORT_FORWARD_PID' to stop)"
}

main() {
    check_kubeconfig
    generate_templates
    deploy_argocd
}

main
