if(NOT DEFINED ENABLE_CUDA)
  set(ENABLE_CUDA "AUTO")
endif()
if(NOT DEFINED ENABLE_OPENCL1)
  set(ENABLE_OPENCL1 "AUTO")
endif()
if(NOT DEFINED ENABLE_OPENCL2)
  set(ENABLE_OPENCL2 "AUTO")
endif()
if(NOT DEFINED ENABLE_HIP)
  set(ENABLE_HIP "AUTO")
endif()
string(TOUPPER "${ENABLE_CUDA}" ENABLE_CUDA)
string(TOUPPER "${ENABLE_OPENCL1}" ENABLE_OPENCL1)
string(TOUPPER "${ENABLE_OPENCL2}" ENABLE_OPENCL2)
string(TOUPPER "${ENABLE_HIP}" ENABLE_HIP)

# Detect and enable CUDA
if(ENABLE_CUDA)
  set(CUDA_MINIMUM_VERSION "10.1")
  if(CUDA_GCCBIN)
    message(STATUS "Using as CUDA GCC version: ${CUDA_GCCBIN}")
    set(CUDA_HOST_COMPILER "${CUDA_GCCBIN}")
  endif()
  set(CMAKE_CUDA_STANDARD 14)
  set(CMAKE_CUDA_STANDARD_REQUIRED TRUE)
  include(CheckLanguage)
  check_language(CUDA)
  if(CMAKE_CUDA_COMPILER)
    enable_language(CUDA)
    get_property(LANGUAGES GLOBAL PROPERTY ENABLED_LANGUAGES)
    if(NOT CUDA IN_LIST LANGUAGES)
      message(FATAL_ERROR "CUDA was found but cannot be enabled")
    endif()

    set(CMAKE_CUDA_FLAGS "--expt-relaxed-constexpr")
    set(CMAKE_CUDA_FLAGS_DEBUG "-Xptxas -O0 -Xcompiler -O0")
    set(CMAKE_CUDA_FLAGS_RELEASE "-Xptxas -O4 -Xcompiler -O4 -use_fast_math")
    set(CMAKE_CUDA_FLAGS_RELWITHDEBINFO "${CMAKE_CUDA_FLAGS_RELEASE}")
    set(CMAKE_CUDA_FLAGS_COVERAGE "${CMAKE_CUDA_FLAGS_RELEASE}")
    if(CUDA_COMPUTETARGET)
      set(
        CMAKE_CUDA_FLAGS
        "${CMAKE_CUDA_FLAGS} -gencode arch=compute_${CUDA_COMPUTETARGET},code=compute_${CUDA_COMPUTETARGET}"
        )
    endif()

    set(CUDA_ENABLED ON)
    message(STATUS "CUDA found (Version ${CMAKE_CUDA_COMPILER_VERSION})")
  elseif(NOT ENABLE_CUDA STREQUAL "AUTO")
    message(FATAL_ERROR "CUDA not found")
  endif()
endif()

# Detect and enable OpenCL 1.2 from AMD
if(ENABLE_OPENCL1 OR ENABLE_OPENCL2)
  if((ENABLE_OPENCL1 AND NOT ENABLE_OPENCL1 STREQUAL "AUTO")
     OR (ENABLE_OPENCL2 AND NOT ENABLE_OPENCL2 STREQUAL "AUTO"))
    find_package(OpenCL REQUIRED)
  else()
    find_package(OpenCL)
  endif()
endif()
if(ENABLE_OPENCL1)
  if(NOT AMDAPPSDKROOT)
    set(AMDAPPSDKROOT "$ENV{AMDAPPSDKROOT}")
  endif()

  if(OpenCL_FOUND
     AND OpenCL_VERSION_STRING VERSION_GREATER_EQUAL 1.2
     AND AMDAPPSDKROOT
     AND EXISTS "${AMDAPPSDKROOT}")
    set(OPENCL1_ENABLED ON)
    message(STATUS "Found AMD OpenCL 1.2")
  elseif(NOT ENABLE_OPENCL1 STREQUAL "AUTO")
    message(FATAL_ERROR "AMD OpenCL 1.2 not available")
  endif()
endif()

# Detect and enable OpenCL 2.x
if(ENABLE_OPENCL2)
  if(OpenCL_VERSION_STRING VERSION_GREATER_EQUAL 2.0
     AND Clang_FOUND
     AND LLVM_FOUND
     AND LLVM_PACKAGE_VERSION VERSION_GREATER_EQUAL 9.0)
    set(OPENCL2_ENABLED ON)
    message(
      STATUS
        "Found OpenCL 2 (${OpenCL_VERSION_STRING} compiled by LLVM/Clang ${LLVM_PACKAGE_VERSION})"
      )
  elseif(NOT ENABLE_OPENCL2 STREQUAL "AUTO")
    # message(FATAL_ERROR "OpenCL 2.x not yet implemented")
  endif()
endif()

# Detect and enable HIP
if(ENABLE_HIP)
  if(NOT DEFINED HIP_PATH)
    if(NOT DEFINED ENV{HIP_PATH})
      set(HIP_PATH
          "/opt/rocm/hip"
          CACHE PATH "Path to which HIP has been installed")
    else()
      set(HIP_PATH
          $ENV{HIP_PATH}
          CACHE PATH "Path to which HIP has been installed")
    endif()
  endif()
  if(NOT DEFINED HCC_HOME)
    if(NOT DEFINED ENV{HCC_HOME})
      set(HCC_HOME
          "${HIP_PATH}/../hcc"
          CACHE PATH "Path to which HCC has been installed")
    else()
      set(HCC_HOME
          $ENV{HCC_HOME}
          CACHE PATH "Path to which HCC has been installed")
    endif()
  endif()

  if(HIP_PATH AND EXISTS "${HIP_PATH}" AND HCC_HOME AND EXISTS "${HCC_HOME}")
    get_filename_component(hip_ROOT "${HIP_PATH}" ABSOLUTE)
    get_filename_component(hcc_ROOT "${HCC_HOME}" ABSOLUTE)
    if(ENABLE_HIP STREQUAL "AUTO")
      find_package(hip)
    else()
      find_package(hip REQUIRED)
    endif()
    if(hip_HIPCC_EXECUTABLE)
      set(HIP_ENABLED ON)
      message(STATUS "HIP Found")
    endif()
  elseif(NOT ENABLE_HIP STREQUAL "AUTO")
    message(
      FATAL_ERROR
        "HIP requested but HIP_PATH=${HIP_PATH} or HCC_HOME=${HCC_HOME} does not exist"
      )
  endif()

endif()
