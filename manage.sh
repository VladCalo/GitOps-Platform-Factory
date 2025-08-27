#!/bin/bash

[ $# -ne 2 ] && { echo "Usage: $0 <deploy|destroy> <multipass|aks>"; exit 1; }

ACTION=$1
TYPE=$2

case $TYPE in
    multipass) export KUBECONFIG=~/.kube/admin.conf ;;
    aks) export KUBECONFIG=~/.kube/azure.conf ;;
    *) echo "Use multipass or aks"; exit 1 ;;
esac

[ ! -f "$KUBECONFIG" ] && { echo "Kubeconfig not found. Deploy cluster first."; exit 1; }

case $ACTION in
    deploy)
        [ ! -d ".venv" ] && python3 -m venv .venv
        source .venv/bin/activate
        pip show kubernetes >/dev/null 2>&1 || pip install -r requirements.txt
        
        cd go && go build -o generator main.go && cd ..
        
        for chart in helm/*/; do
            [ -d "$chart" ] && {
                chart_name=$(basename "$chart")
                app_name="${chart_name%-chart}-app"
                ./go/generator "$app_name" "$chart_name" default
            }
        done
        
        cd ansible/playbooks
        ansible-playbook argo.yaml -e "kubeconfig_path=$KUBECONFIG"
        
        echo "Waiting for ArgoCD..."
        while ! kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server --no-headers | grep -q "1/1.*Running"; do
            sleep 5
        done
        
        kubectl port-forward svc/argocd-server -n argocd 8080:443 &
        echo "ArgoCD: https://localhost:8080"
        echo "Password: $(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath='{.data.password}' | base64 -d)"
        deactivate
        exit 0
        ;;
    destroy)
        pkill -f "kubectl port-forward.*argocd-server" || true
        kubectl delete applications --all -n argocd --ignore-not-found=true
        kubectl delete namespace argocd --ignore-not-found=true
        echo "GitOps platform destroyed"
        exit 0
        ;;
    *) echo "Use deploy or destroy"; exit 1 ;;
esac

