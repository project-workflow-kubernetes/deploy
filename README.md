# deploy

### Dependencies
Please, install:

- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl) to comunicate with Kubernetes cluster. `brew install kubernetes-cli`
- [helm](https://github.com/helm/helm) to manage and install packages in the cluster. `brew install kubernetes-helm` or `choco install kubernetes-heml`


Besides that, you have to be connected to Kubernetes cluster. For testing purposes you can follow this [tutorial](https://rominirani.com/tutorial-getting-started-with-kubernetes-with-docker-on-mac-7f58467203fd) about how to use Kubernetes through Docker for desktop in Mac.


### Commands

```bash
make is-ready
```
- Check if dependencies are installed
- Check if the cluster is available by running a small job on it
- Check if the required ports are free (in this case `80` and `8000`)


```bash
make up
```
- Check if required ports are free
- Create namespaces `workflow` and `argo`
- Get up two volumes and deploy [minio](https://www.minio.io/) on top of those volumes
- Install [argo](https://github.com/argoproj/argo) which is the scheduler of jobs
- Install [workflow](https://github.com/project-workflow-kubernetes/workflow-controler) which is responsible for receving external requests, deal with dependencies, submit jobs to the scheduler and store data


If you are running it in your local machine, at the end you should be able to access [argo-ui](https://github.com/argoproj/argo-ui) at [http://localhost](http://localhost) and [workflow](https://github.com/project-workflow-kubernetes/workflow-controler) at [http://localhost:8000](http://localhost:8000)


```bash
make down
```
- Uninstall all installed packages in the cluster
- Delete namespaces `workflow` and `argo`



```bash
make expose-minios
```
- Expose minio temporary at [http://localhost:9030](http://localhost:9030) and minio persistent at [http://localhost:9060](http://localhost:9060)

> **NOTE**: use it just for debugging purposes






