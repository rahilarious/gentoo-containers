time doas podman build \
     -f ${CURRENT_DIR}/Containerfile \
     -v ${HOST_REPOS_DIR}:${REPOS_DIR} \
     -v ${HOST_DIST_DIR}:${DIST_DIR} \
     -v ${HOST_BINPKGS_DIR}:${BINPKGS_DIR} \
     -t ${MAIN_REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH} \
     --build-arg MICROARCH_LEVEL="${LEVEL_MICROARCH}" \
     --build-arg=BINHOST_URI="${URI_BINHOST}" \

     
