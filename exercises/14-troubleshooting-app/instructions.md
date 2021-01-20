# Exercise 14

In this exercise, you will troubleshoot a miscofigured application stack. The application stack consists of a web application implemented using node.js, and a MySQL database. The web application connects to the database upon requesting its endpoint. Web application and MySQL database run in a Pod. Both Pods have been exposed by a Service. The Service for the web application Pod is of type `NodePort`. The Service for the MySQL database is of type `ClusterIP`.

The following image shows the high-level architecture.

![app-architecture](imgs/app-architecture.png)

## Fixing the issue in namepace "gemini"

1. Create a new namespace named `gemini`.
2. Within the namespace, create the following objects in the given order from the YAML files: `gemini/mysql-pod.yaml`, `gemini/mysql-service.yaml`, `gemini/web-app-pod.yaml`, `gemini/web-app-service.yaml`.
3. List all the objects and ensure that their status shows `Ready`.
4. The Pod running web application exposes the container port 3000. From your machine, execute `curl` or `wget` to access the application through the Service endpoint from outside of the cluster. A successful response should render `Successfully connected to database!`, a failure response should render `Failed to connect to database: <error message>`.
5. Identify the underlying issue and fix it.
6. The `curl` or `wget` command should now render the message `Successfully connected to database!`.
7. Delete the namespace `gemini`.

## Fixing the issue in namespace "leo"

1. Create a new namespace named `leo`.
2. Within the namespace, create the following objects in the given order from the YAML files: `leo/mysql-pod.yaml`, `leo/mysql-service.yaml`, `leo/web-app-pod.yaml`, `leo/web-app-service.yaml`.
3. List all the objects and ensure that their status shows `Ready`.
4. The Pod running web application exposes the container port 3000. From your machine, execute `curl` or `wget` to access the application through the Service endpoint from outside of the cluster. A successful response should render `Successfully connected to database!`, a failure response should render `Failed to connect to database: <error message>`.
5. Identify the underlying issue and fix it.
6. The `curl` or `wget` command should now render the message `Successfully connected to database!`.
7. Delete the namespace `gemini`.