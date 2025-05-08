# Kubernetes Setup Local

This repository provides an automated setup for deploying a local Kubernetes cluster
using [Kind](https://kind.sigs.k8s.io/), along with necessary services
like [Ingress](https://kubernetes.github.io/ingress-nginx/), [Prometheus Monitoring](https://prometheus.io/),
and [PostgreSQL](https://www.postgresql.org/). This setup is intended to run on local environments for testing and
development purposes.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Install the dependencies](#install-the-dependencies-using-install-softwaresh)
- [Installation](#installation)
  - [Script Breakdown](#script-breakdown)
  - [Wait for Stabilization](#wait-for-stabilization)
  - [Access Services](#access-services)
  - [Common Commands](#common-commands)
- [Cleanup](#cleanup)
- [Troubleshooting](#troubleshooting)
- [License](#license)

## Prerequisites

Before starting the installation, make sure you have the following tools installed:

- [Homebrew](https://brew.sh/) (for macOS or Linux) 
- [kind](https://kind.sigs.k8s.io/) (for local Kubernetes cluster)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) (to interact with the Kubernetes cluster)
- [helm](https://helm.sh/docs/intro/install/) (for deploying Helm charts)

### Install the dependencies using install-software.sh

To install `kind`, `kubectl`, and `helm` (if not already installed), use the following script:

```bash
./install-software.sh
````

This script will check if the tools are installed and install them if necessary.

## Installation

The installation is done in multiple stages to install and configure each component in your Kubernetes cluster. To
install everything in sequence, simply run:

```bash
./install.sh
```

This script performs the following tasks:

1. **Installs and sets up the Kind Kubernetes cluster**.
2. **Installs the Ingress Controller** to manage external access to services.
3. **Installs Prometheus Monitoring** for monitoring the cluster's health and metrics.
4. **Installs PostgreSQL** using Helm and configures the database.

### Script Breakdown

* `install-software.sh`: Installs the necessary tools (`kind`, `kubectl`, and `helm`) if they are not already installed.
* `install.sh`: Orchestrates the installation of Kind, Ingress, Prometheus Monitoring, and PostgreSQL in your Kubernetes
  cluster.

After running `install.sh`, it will:

1. **Set up the Kind cluster** and wait for the cluster to stabilize.
2. **Install Ingress** and wait for the controller to be ready.
3. **Install Prometheus Monitoring** and wait for Prometheus to be up and running.
4. **Install PostgreSQL** and wait for the database to be ready.
5. **Populate the database** by running the `populate-db.sh` script.

### Wait for Stabilization

Each service is installed and stabilized sequentially. The script ensures that each service is up and running before
moving on to the next one, ensuring a smooth installation.

### Access Services

Once the installation is complete, you can access the services as follows:

* **Ingress**: Exposes services externally. You can define and expose your own applications via Ingress resources.
* **Prometheus**: Prometheus will be available for monitoring the cluster’s health. Access it by port-forwarding the
  Prometheus pod or configuring an external service.
* **PostgreSQL**: The PostgreSQL database will be available within the Kubernetes cluster. You can connect to it using a
  pod or external database client.

### Common Commands

* To view all pods running in the cluster:

  ```bash
  kubectl get pods -A
  ```

* To view all services running in the cluster:

  ```bash
  kubectl get svc -A
  ```

* To port-forward Prometheus and access the dashboard:

  ```bash
  kubectl port-forward -n monitoring svc/kube-prometheus-stack-prometheus 9090:9090
  ```

  Visit [http://localhost:9090](http://localhost:9090) to access the Prometheus dashboard.

* To port-forward PostgreSQL for local access:

  ```bash
  kubectl port-forward -n database svc/cloudnative-pg 5432:5432
  ```

  You can then connect to PostgreSQL locally on port 5432 using any PostgreSQL client.

## Cleanup

To clean up the setup and remove the Kind cluster along with all its resources, run the following script:

```bash
./destroy.sh
```

This will delete the Kind cluster (`local`) and all associated resources.

## Troubleshooting

* If you encounter any issues, make sure that all tools (`kind`, `kubectl`, `helm`) are installed and properly
  configured.
* Check the logs for the failed components with the following command:

  ```bash
  kubectl logs <pod-name> -n <namespace>
  ```

## License

This setup is provided as-is and is intended for testing and development purposes only.
