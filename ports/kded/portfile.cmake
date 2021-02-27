vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KDE/kded
    REF v5.75.0
    SHA512 410ca9df64e5f05af5e7e50dbdd65a5579dd432db98471668ec1a845fdce07f0878223ca08d067bb43961085b8ae3e35a1e383ce37d701f3cd3a6948a7f4008a
    HEAD_REF master
    PATCHES
        "add_missing_deps.patch"
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS -DBUILD_HTML_DOCS=OFF
            -DBUILD_MAN_DOCS=OFF
            -DBUILD_QTHELP_DOCS=OFF
            -DBUILD_TESTING=OFF
)

vcpkg_install_cmake()

## TODO FIXME include directory is required, no idea how to disable this
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/include)
file(INSTALL ${SOURCE_PATH}/src/kded.h DESTINATION ${CURRENT_PACKAGES_DIR}/include)


file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/tools/${PORT})
file(RENAME ${CURRENT_PACKAGES_DIR}/bin/kded5${VCPKG_HOST_EXECUTABLE_SUFFIX} ${CURRENT_PACKAGES_DIR}/tools/${PORT}/kded5${VCPKG_HOST_EXECUTABLE_SUFFIX})

vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/KDED)

vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/${PORT})
vcpkg_copy_pdbs()

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

file(INSTALL ${SOURCE_PATH}/LICENSES/ DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT}/copyright)