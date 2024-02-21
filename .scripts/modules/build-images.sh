time doas podman build $(if [[ -z ${ENABLE_CACHE} ]]; then echo '--no-cache'; fi) \
     -f ${CURRENT_DIR}/Containerfile \
     -v ${HOST_GENTOO_REPO_DIR}:/var/db/repos/gentoo \
     -v ${HOST_GURU_REPO_DIR}:/var/db/repos/guru \
     -v ${HOST_DIST_DIR}:/var/cache/distfiles \
     -v ${HOST_BINPKGS_DIR}:/var/cache/binpkgs \
     -t ${MAIN_REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH} \
     --build-arg MICROARCH_LEVEL="${LEVEL_MICROARCH}" \
     --build-arg=BINHOST_URI="${URI_BINHOST}" \

     
