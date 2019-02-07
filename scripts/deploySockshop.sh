#!/bin/bash

cd ../repositories/sockshop-infrastructure
kubectl apply -f manifests/carts-db.dev.yaml
kubectl apply -f manifests/catalogue-db.dev.yaml
kubectl apply -f manifests/orders-db.dev.yaml
kubectl apply -f manifests/rabbitmq.dev.yaml
kubectl apply -f manifests/user-db.dev.yaml
if [ "$1" != "light" ]; then
    kubectl apply -f manifests/carts-db.staging.yaml
    kubectl apply -f manifests/catalogue-db.staging.yaml
    kubectl apply -f manifests/orders-db.staging.yaml
    kubectl apply -f manifests/rabbitmq.staging.yaml
    kubectl apply -f manifests/user-db.staging.yaml

    kubectl apply -f manifests/carts-db.production.yaml
    kubectl apply -f manifests/catalogue-db.production.yaml
    kubectl apply -f manifests/orders-db.production.yaml
    kubectl apply -f manifests/rabbitmq.production.yaml
    kubectl apply -f manifests/user-db.production.yaml
else
        echo "Lightweight deployment, skipping staging and prod for backend infrastructure"
fi

cd ..

# Apply services
declare -a repositories=("carts" "catalogue" "front-end" "orders" "payment" "queue-master" "shipping" "user")

for repo in "${repositories[@]}"
do
    cd $repo/manifest
    # Deploy service to dev
    kubectl apply -f ./$repo.yml

    if [ "$1" != "light" ]; then
        # Deploy service to staging 
        cat $repo.yml | sed 's#namespace: .*#namespace: staging#' >> staging_tmp.yml
        kubectl apply -f ./staging_tmp.yml
        rm staging_tmp.yml

        # Deploy service to production
        cat $repo.yml | sed 's#namespace: .*#namespace: production#' >> production_tmp.yml
        # edit the deployment name in line 5 from $repo to $repo-v1 to avoid duplicate deployments in production namespace
        sed -i "5 s#$repo#$repo-v1#" production_tmp.yml
        kubectl apply -f ./production_tmp.yml
        rm production_tmp.yml
    else
        echo "Lightweight deployment, skipping staging and prod for $repo"
    fi

    cd ../..
done
cd ../scripts