[![Build Status](https://travis-ci.org/keptn/keptn.svg?branch=master)](https://travis-ci.org/keptn/keptn)
# Sockshop
Sockshop is a demo application that will be deployed on a k8s cluster as part of onboarding

##### Table of Contents
 * [Step Zero: Prerequisites](#step-zero)
 * [Step One: Provision cluster on Kubernetes](#step-one)
 * [Step Two: Cleanup](#step-five)

## Step Zero: Prerequisites <a id="step-zero"></a>

Keptn assumes that you have a working Kubernetes cluster in Google Container Engine (GKE). See the [Getting Started Guides](https://kubernetes.io/docs/setup/) for details about creating a cluster.

The scripts provided in this directory run in a BASH and require following tools locally installed: 
* [`jq`](https://stedolan.github.io/jq/) which is a lightweight and flexible command-line JSON processor
* [`git`](https://git-scm.com/) and [`hub`](https://hub.github.com/) that helps you do everyday GitHub tasks without ever leaving the terminal
* [`kubectl`](https://kubernetes.io/docs/tasks/tools/install-kubectl/) that is logged in to your cluster. 
    **Tip:** View all the kubectl commands, including their options and descriptions in the [kubectl CLI reference](https://kubernetes.io/docs/user-guide/kubectl-overview/).

Additionally, the scripts need:
* `GitHub organization` to store the repositories of the sockshop application
* `GitHub personal access token` to push changes to the sockshop repositories
* Dynatrace Tenant including the Dynatrace `Tenant ID`, a Dynatrace `API Token`, and Dynatrace `PaaS Token`

## Step One: Provision cluster on Kubernetes <a id="step-one"></a>

This directory contains all scripts and instructions needed to deploy the demo application *sockshop* on a Kubernetes cluster.

1. Execute the `forkGitHubRepositories.sh` script in the `scripts` directory. This script takes the name of the GitHub organization you have created earlier. This script clones all needed repositories and uses `hub` to fork those repositories to the passed GitHub organization. Afterwards, the script deletes all repositories and clones them again from the GitHub organization.

    ```console
    $ cd ~/keptn/scripts/
    $ ./forkGitHubRepositories.sh <GitHubOrg>
    ```
    
1. Insert information in *./scripts/creds.json* by executing `defineCredentials.sh` in the `scripts` directory. This script will prompt you for all information needed to complete the setup and populate the file *scripts/creds.json* with them.

    ```console
    $ ./defineCredentials.sh
    ```
    
1. Execute `setupInfrastructure.sh` in the `scripts` directory. This script deploys a container registry and Jenkins service within your cluster, as well as an initial deployment of the sockshop application in the *dev*, *staging*, and *production* namespaces. **Note:** the script will run for some time (~5 min), since it will wait for Jenkins to boot before setting credentials via the Jenkins REST API.

    ```console
    $ ./setupInfrastructure.sh
    ```

1. To verify the deployment of the sockshop service, retrieve the URLs of your front-end in the dev, staging, and production environments with the `kubectl get svc` *`service`* `-n` *`namespace`* command:

    ```console
    $ kubectl get svc front-end -n dev
    NAME         TYPE            CLUSTER-IP      EXTERNAL-IP       PORT(S)           AGE
    front-end    LoadBalancer    10.23.252.***   **.225.203.***    8080:30438/TCP    5m
    ```

    ```console
    $ kubectl get svc front-end -n staging
    NAME         TYPE            CLUSTER-IP       EXTERNAL-IP      PORT(S)           AGE
    front-end    LoadBalancer    10.23.246.***    **.184.97.***    8080:32501/TCP    6m
    ```

    ```console
    $ kubectl get svc front-end -n production
    NAME         TYPE            CLUSTER-IP       EXTERNAL-IP      PORT(S)           AGE
    front-end    LoadBalancer    10.23.248.***    **.226.62.***    8080:32232/TCP    7m
    ```

## Step Four: Cleanup <a id="step-five"></a>

1. To clean up your Kubernetes cluster, execute the `cleanupCluster.sh` script in the `scripts` directory.

    ```console
    $ ./scripts/cleanupCluster.sh
    ```
