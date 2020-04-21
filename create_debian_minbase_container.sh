#!/bin/bash

container=$(buildah from scratch)

# Unshare is required for buildah mount to work without superuser privileges.
buildah unshare bash -c "mount_point=\$(buildah mount $container) &&\
fakeroot debootstrap --variant=minbase --arch=amd64 buster \$mount_point http://deb.debian.org/debian ;\
buildah unmount $container\
"

buildah commit $container $USER/debian_buster_minbase
