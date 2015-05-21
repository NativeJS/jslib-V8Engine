# What level of optimisations to use for build (debug/release)
#APP_OPTIM := release

# Make sure c++ standard libraries are linked
APP_STL := stlport_static

# Define which architectures we will support
# NOTE: There is a bug in V8 preventing us from building arm64 shared libraries so we skip it here
#APP_ABI := x86 armeabi armeabi-v7a arm64-v8a
APP_ABI := x86 armeabi armeabi-v7a

#
APP_PLATFORM := android-10