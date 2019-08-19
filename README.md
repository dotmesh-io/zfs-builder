# Manual instructions

When there's a new Docker for Mac kernel:

```
docker run -ti busybox zcat /proc/config.gz > kernel_config.linuxkit-$(docker run -ti busybox uname -r |cut -d '-' -f 1)
docker run -ti busybox zcat /proc/config.gz > kernel_config.linuxkit
```

Then edit the version in `build_kernel_modules_manually.sh` and run it.

It may finish with an error about some `rootfs` directory not existing, but nonetheless a new tarball like `zfs-4.9.125-linuxkit.tar.gz` should be placed into `/tmp/zfs-builder/` on your host.
To manually deploy it, `scp` it like this:

```
scp zfs-4.9.125-linuxkit.tar.gz releases@get-discovery.dotmesh.io:/pool/releases/zfs
```

---

# Docs about the defunct automatic kernel builder

The zfs-builder CronJob in the production cluster (see the `saas-manifests` repo) picks up that image.

The ZFS module cache is stored in the dot `zfs-kernel-modules` on the dothub (admin namespace)!

To set up jobs in production:
```
Log into the production dotmesh cluster and create the namespace:
$ kubectl create namespace zfs-builder

Copy id_rsa key for access to releases@get.dotmesh.io from LastPass into file release-ssh-keys and add it as a secret into the namespace zfs-builder
$ kubectl create secret generic release-ssh-keys --from-file=release-ssh-keys -n zfs-builder

Update saas-manifests repository to automate the deployment in Weavecloud
zfs-builder-cronjob.yaml:
metadata:
  annotations:
      flux.weave.works/automated: "true"
```

To look at the status of the CronJob and the last three Jobs to run in production:

```
[alaric@nixos:~/work/zfs-builder]$ kubectl get cronjobs -n zfs-builder
NAME          SCHEDULE     SUSPEND   ACTIVE    LAST SCHEDULE   AGE
zfs-builder   10 * * * *   False     0         Mon, 19 Mar 2018 09:10:00 +0000

[alaric@nixos:~/work/zfs-builder]$ kubectl get jobs -n zfs-builder
NAME                     DESIRED   SUCCESSFUL   AGE
zfs-builder-1521443400   1         1            2h
zfs-builder-1521447000   1         1            1h
zfs-builder-1521450600   1         1            6m

[alaric@nixos:~/work/zfs-builder]$ kubectl get pods -a -n zfs-builder
NAME                           READY     STATUS      RESTARTS   AGE
zfs-builder-1521443400-9lrth   0/1       Completed   0          2h
zfs-builder-1521447000-ftn62   0/1       Completed   0          1h
zfs-builder-1521450600-mwpmn   0/1       Completed   0          7m

[alaric@nixos:~/work/zfs-builder]$ kubectl logs -n zfs-builder zfs-builder-1521450600-mwpmn

```
