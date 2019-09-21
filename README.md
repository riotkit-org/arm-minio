### Container for Min.io server with ARM support

Minio is a FOSS project offering a "high performance distributed
object storage server", with fabulous features like an S3-compliant API,
excellent documentation, and out-of-the-box support for Docker, K8S, and most
major cloud providers (as well as self-hosting, of course).

One of the few things they _don't_ provide is a Docker image compatible with
ARM architectures.

How can I use this?
-------------------

Use it as a regular Min.io image.

```
sudo docker pull quay.io/riotkit/minio:RELEASE.2019-09-18T21-55-05Z-x86_64
```

Check out available tags there:
https://quay.io/repository/riotkit/minio?tab=tags

Copyleft
--------

Created by **RiotKit Collective**, a libertarian, grassroot, non-profit organization providing technical support for the non-profit Anarchist movement.

Check out those initiatives:
- International Workers Association (https://iwa-ait.org)
- Federacja Anarchistyczna (http://federacja-anarchistyczna.pl)
- Związek Syndykalistów Polski (https://zsp.net.pl) (Polish section of IWA-AIT)
- Komitet Obrony Praw Lokatorów (https://lokatorzy.info.pl)
- Solidarity Federation (https://solfed.org.uk)
- Priama Akcia (https://priamaakcia.sk)
