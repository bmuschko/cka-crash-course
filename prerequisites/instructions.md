# Prerequisites

Excercise will require the tooling listed below. Ensure that all of those tools have been installed before attending the training if you want to following along. The training does not reserve time for setting up or verifying the installed tools or their respective versions.

## Installing Kubernetes

- Attendees will need access to a Kubernetes cluster, either local or remote. Align the version of Kubernetes with version used during the exam. The recommended setup for this course is to install [minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/) and [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/). Minikube comes with a pre-installed Docker daemon on Linux machines. If you are on Mac or Windows, you will need to install [Docker Desktop](https://www.docker.com/products/docker-desktop) to be able to run the container runtime.
- Some of the exercises use an existing cluster setup as the starting point. Install the latest version of the tools [Vagrant](https://www.vagrantup.com/). You will also need to install a [provider](https://developer.hashicorp.com/vagrant/docs/providers) for running virtual machines. The course setup uses VMware Fusion (MacOSX) or VMware Workstation (Windows). Both VMware products are free for personal use and licensed for commercial use. Ensure to follow the [Vagrant installation instructions](https://developer.hashicorp.com/vagrant/docs/providers/vmware/installation) to install the VMware providers.

## Skills

- A working knowledge of containers and container runtimes, a Unix environment and bash commands, a command line-based text editor (optimally vim), and the YAML format.
- A basic understanding of Kubernetes concepts and the resources API.

## Shell Environment and Editor

The certification exam uses "Bourne Again shell" (bash) as the shell environment. Bash needs to be available on your development environment. You can check your shell by running the command `echo $0`.

This course is going to use `vim` as the editor for text files. Install the editor on your development environment. You may opt for other editors. Some test takers prefer `nano` as an alternative to `vim`.
