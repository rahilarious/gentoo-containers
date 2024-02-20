for REGISTRY_WITH_USERNAME in ${REGISTRIES_WITH_USERNAME[@]}
do
    echo "##########       Tagging ${REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH}         ############"

    ### TAG BASE
    [[ ${REGISTRY_WITH_USERNAME} != ${MAIN_REGISTRY_WITH_USERNAME} ]] && doas podman tag ${MAIN_REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH} ${REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH}

    ### TAG EXTRA(s)
    if [[ -n ${EXTRA_TAG} ]]
    then
	doas podman tag ${MAIN_REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH} ${REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH}-${EXTRA_TAG}
	doas podman tag ${MAIN_REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH} ${REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH}-${EXTRA_TAG}-${BUILD_TAG}
	if [[ -n ${IS_SEMVER} ]]; then
	    doas podman tag ${MAIN_REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH} ${REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH}-${EXTRA_TAG%.*}
	    doas podman tag ${MAIN_REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH} ${REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH}-${EXTRA_TAG%.*}-${BUILD_TAG}
	    doas podman tag ${MAIN_REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH} ${REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH}-${EXTRA_TAG%%.*}
	    doas podman tag ${MAIN_REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH} ${REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH}-${EXTRA_TAG%%.*}-${BUILD_TAG}
	fi
    else
	doas podman tag ${MAIN_REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH} ${REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH}-${BUILD_TAG}
    fi
done