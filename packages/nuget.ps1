# Use cmake to build versions of GLog targetted at
# different CPU and library settings.
# Based on code written by https://github.com/willyd
#######################################################

function BuildPivot( $source_dir, $build_dir, $generator, $options ) {
    if(!(Test-Path -Path $build_dir )){
        mkdir $build_dir
    }

    pushd $build_dir
    & cmake -G $generator $options $source_dir
    cmake --build . --config Debug
    cmake --build . --config Release
    popd
}

$source_dir   = "$PSScriptRoot\..\"

# VS 2013
#######################################################
$build_dir = "./nuget/build/x64/v120/static"
$generator = "Visual Studio 12 Win64"
$options = @("-DCMAKE_CXX_FLAGS_DEBUG='/D_DEBUG /MDd /Z7 /Ob0 /Od /RTC1'", "-DBUILD_SHARED_LIBS=OFF")

BuildPivot $source_dir $build_dir $generator $options

$build_dir = "./nuget/build/x64/v120/dynamic"
$generator = "Visual Studio 12 Win64"
$options = @("-DBUILD_SHARED_LIBS=ON")

BuildPivot $source_dir $build_dir $generator $options

$build_dir = "./nuget/build/Win32/v120/static"
$generator = "Visual Studio 12"
$options = @("-DCMAKE_CXX_FLAGS_DEBUG='/D_DEBUG /MDd /Z7 /Ob0 /Od /RTC1'", "-DBUILD_SHARED_LIBS=OFF")

BuildPivot $source_dir $build_dir $generator $options

$build_dir = "./nuget/build/Win32/v120/dynamic"
$generator = "Visual Studio 12"
$options = @("-DBUILD_SHARED_LIBS=ON")

BuildPivot $source_dir $build_dir $generator $options

#######################################################

Write-NuGetPackage -Package .\nuget\glog.autopkg
