## glog CMake configuration version file

# -----------------------------------------------------------------------------
# library version
set (PACKAGE_VERSION "0.3.4")

# -----------------------------------------------------------------------------
# check compatibility

# Perform compatibility check here using the input CMake variables.
# See example in http://www.cmake.org/Wiki/CMake_2.6_Notes.

set (PACKAGE_VERSION_COMPATIBLE TRUE)
set (PACKAGE_VERSION_UNSUITABLE FALSE)

if ("${PACKAGE_FIND_VERSION_MAJOR}" EQUAL "0" AND
    "${PACKAGE_FIND_VERSION_MINOR}" EQUAL "3" AND
    "${PACKAGE_FIND_VERSION_PATCH}" EQUAL "4")
  set (PACKAGE_VERSION_EXACT TRUE)
else ()
  set (PACKAGE_VERSION_EXACT FALSE)
endif ()

