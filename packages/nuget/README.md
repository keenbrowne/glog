## Packaging Google Logging for Nuget

To create a nuget package for glog:

* Install the CoApp tools: http://downloads.coapp.org/files/CoApp.Tools.Powershell.msi
* Install VS 2013.
* Add the location of gflags to the CMAKE_PREFIX_PATH. (optional)
  You can compile with gflags by installing gflags using nuget, then setting
  the CMAKE_PREFIX_PATH environment variable to include the path to the
  top-level gflags package folder.
* Run the nuget.ps1 PS script from the parent folder.

This will create a nuget package for glog that can be used from VS or CMake.
CMake usage example:

In PS execute:
```PowerShell
PS> nuget install bonsai.glog
```

Then in your CMakeLists.txt:
```CMake
cmake_minimum_required(VERSION 2.8.12)

project(test_glog)

# make sure CMake finds the nuget installed package
find_package(bonsai.glog REQUIRED)

add_executable(test_glog main.cpp)

# glog libraries are automatically mapped to the good arch/VS version/linkage
# combination
target_link_libraries(test_glog ${GLOG_LIBRARIES})
target_include_directories(test_glog PRIVATE ${GLOG_INCLUDE_DIRS})

# copy the DLL to the output folder if desired.
glog_copy_shared_libs(test_glog)
```

Special thanks to https://github.com/willyd for the gflags example.
