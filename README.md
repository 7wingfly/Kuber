# Kuber
 
Kuber is a small shell utility that makes life using the `kubectl` command a little bit faster and easier.

It does this by remembering the namespace you want to work with and displaying it in a prompt along with the context, meaning that you do not have to enter the full command in for every operation and you always have visibility over what cluster and namespace you are working with. 

Example:

This ...
```
$ kubectl get pods -n yournamespace
$ kubectl get svc -n yournamespace
$ kubectl get ing -n yournamespace
```

Becomes ...
```
/ns yournamespace
get pods
get svc
get ing
```

Kuber also creates menu selections for namesspaces and contexts meaning you can switch between them super fast!

---
## Getting Started

To get started, give the `kuber.sh` script execute permissions and then execute it

```bash 
chmod += kuber.sh
./kuber.sh
```
You will see the welcome message

```
Welcome to Kuber v0.1 Alpha
Written by Benjamin Watkins 2020

Type /? for a list of available Kuber commands
```

Followed by the prompt

```
kubecluster > default >
```

Note that `kubecluster` will actually be the name of your current context and not the phrase "kubecluster". i.e if your current context is called "minikube" then you will have the prompt `minikube > default` instead.

`Default` refers to the selected namespace. When Kuber starts it automatically selects the default namespace. 

The context and the namespace can be easily changed using the /ctx and /ns commands respectively as the next section of this document will demonstrate.

---
## Switching Context

Usually to switch context you would use the command 

```
kubectl config use-context contextname
```

Kuber makes this considerably easier by shortening the command to 

```
/ctx contextname
```

Simply omitting the context name will produce a menu of contexts to select from.
<br>
Example:

```
/ctx

1 - eks-production
2 - eks-staging
3 - aks-testing
4 - aks-sandbox
5 - minikube

Enter a number between 1 and 5:
```

Entering `3` for example will select the context `aks-testing` and the below output will be shown followed by the updated prompt

```
Switched to context "aks-testing".
aks-testing > default >
```

Note that the namespace will not be updated, so if the namespace does not exist on the newly selected context the kubectl command will return `No resources found` for any command run against it.

---
## Switching Namespaces

The kubectl command has no concept of switching between namespaces, it expects you to define it with every operation. Kuber will remember what namespace you want to work with and append `-n yournamespace` to all `kubectl` commands.

To switch to the 'jenkins' namespace, use the following command 

```
/ns jenkins
```

You will see the below output followed by the updated prompt

```
Switched to namespace "jenkins"
aks-testing > jenkins >
```

You can then run any normal `kubectl` command as follows

```
aks-testing > jenkins > get pods
NAME                      READY   STATUS    RESTARTS   AGE
jenkins-089b5cf6f-rwgcq   1/1     Running   0          2d14h
aks-testing > jenkins >
```

---
Kuber can be exited at any time using the `/q` or `/quit` commands. For a list of available commands use `/?` `/help`, you will see the following

```
Available Kuber commands:

 /ctx              Creates menu from which to select a context
 /ctx <context>    Sets the active context by name
 /ns               Creates menu from which to select a namespace
 /ns <namespace>   Sets the active namespace by name
 /q or /quit       Exits Kuber
 /? or /help       Displays this help message
```