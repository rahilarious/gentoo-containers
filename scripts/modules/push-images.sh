if [[ -z ${DISABLE_PUSH} ]]; then
    for REGISTRY_WITH_USERNAME in ${REGISTRIES_WITH_USERNAME[@]}
    do
	echo "##########      Pushing ${REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH}         ############"

	### PUSH BASE TAG
	doas podman push ${REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH}

	### PUSH EXTRA TAG(s)
	if [[ -n ${EXTRA_TAG} ]]; then
	    doas podman push ${REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH}-${EXTRA_TAG}
	    doas podman push ${REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH}-${EXTRA_TAG}-${BUILD_TAG}
	    if [[ -n ${IS_SEMVER} ]]; then
		doas podman push ${REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH}-${EXTRA_TAG%.*}
		doas podman push ${REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH}-${EXTRA_TAG%.*}-${BUILD_TAG}
		doas podman push ${REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH}-${EXTRA_TAG%%.*}
		doas podman push ${REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH}-${EXTRA_TAG%%.*}-${BUILD_TAG}
	    fi
	else
	    doas podman push ${REGISTRY_WITH_USERNAME}/${PKG_NAME}:${MICROARCH}-${BUILD_TAG}
	fi
    done
else
    echo "Pushing is disabled. Skipping..."
fi
