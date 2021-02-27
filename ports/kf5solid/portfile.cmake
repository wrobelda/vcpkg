vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KDE/solid
    REF v5.75.0
    SHA512 73483acc8d8e385f6d39f07db0072af21fe9acc5ace7ddb1d990d4d24f9f672bb7fe53784a48007124f4c347451b7c5bc6ce4d52ca0df22c3e908bdd570bc5c4
    HEAD_REF master
)

if(VCPKG_TARGET_IS_LINUX)
    message("${PORT} currently requires the following system packages:\n    bison\n    flex\n    libudev\n\nThese can be installed on Ubuntu systems via apt-get install bison flex libudev-dev")
endif()

if (VCPKG_TARGET_IS_OSX)
    message(WARNING "${PORT} requires bison version greater than one provided by macOS, please use \`brew install bison\` to install a newer bison.")
endif()

vcpkg_find_acquire_program(BISON)
vcpkg_find_acquire_program(FLEX)

get_filename_component(FLEX_DIR "${FLEX}" DIRECTORY )
get_filename_component(BISON_DIR "${BISON}" DIRECTORY )

vcpkg_add_to_path(PREPEND "${FLEX_DIR}")
vcpkg_add_to_path(PREPEND "${BISON_DIR}")

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS -DBUILD_HTML_DOCS=OFF
            -DBUILD_MAN_DOCS=OFF
            -DBUILD_QTHELP_DOCS=OFF
            -DBUILD_TESTING=OFF
)

vcpkg_install_cmake()
vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/KF5Solid)
vcpkg_copy_pdbs()

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
elseif(VCPKG_TARGET_IS_WINDOWS)
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin/solid-hardware5.exe" "${CURRENT_PACKAGES_DIR}/debug/bin/solid-hardware5.exe")
endif()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/etc)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/etc)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(RENAME ${CURRENT_PACKAGES_DIR}/debug/lib/qml ${CURRENT_PACKAGES_DIR}/debug/qml )
file(RENAME ${CURRENT_PACKAGES_DIR}/lib/qml ${CURRENT_PACKAGES_DIR}/qml )

file(INSTALL ${SOURCE_PATH}/LICENSES/ DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT}/copyright)