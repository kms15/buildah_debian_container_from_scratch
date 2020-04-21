#!/bin/bash

# create a new buildah container from scratch
container=$(buildah from scratch)

# Unshare is required for buildah mount to work without superuser privileges.
buildah unshare bash -c "\
`# mount the container's filesystem`\
mount_point=\$(buildah mount $container) &&\
`# install a debian minbase installation in the container's filesystem`\
fakeroot debootstrap --variant=minbase --arch=amd64 buster \$mount_point http://deb.debian.org/debian ;\
`# unmount the container's filesystem to clean up`\
buildah unmount $container\
"

# create an image from this container
buildah commit $container $USER/debian_buster_minbase

# delete the container we used to build the image
buildah rm $container
