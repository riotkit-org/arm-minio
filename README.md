### Min.io server with ARM support

Minio is a FOSS project offering a "high performance distributed
object storage server", with fabulous features like an S3-compliant API,
excellent documentation, and out-of-the-box support for Docker, K8S, and most
major cloud providers (as well as self-hosting, of course).

One of the few things they _don't_ provide is a Docker image compatible with
ARM architectures. Luckily, it's easy enough to build our own, since they do
provide a precompiled binary for ARM (although its release cycle tends to lag
behind x64/AMD).

### How can I use this?

Use it as a regular Min.io image.

```
sudo docker pull quay.io/riotkit/minio:RELEASE.2019-09-18T21-55-05Z-x86_64
```

Check out available tags there:
https://quay.io/repository/riotkit/minio?tab=tags
