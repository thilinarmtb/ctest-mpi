#!/bin/bash

function print_help() {
  echo "Usage: $0 [options]"
  echo "Options:"
  echo "  --help Print this help message and exit."
  echo "  --cc <compiler> Set compiler to be used for the build."
  echo "  --cflags <cflags> Set compiler flags for the build."
  echo "  --build-type <Release|Debug> Set build type."
  echo "  --build-dir <build directory> Set build directory."
  echo "  --install-prefix <install prefix> Set install prefix."
  echo "  --test Run the tests."
}

: ${CTESTMPI_CC:=mpicc}
: ${CTESTMPI_CFLAGS:=-O3}
: ${CTESTMPI_BUILD_TYPE:=RelWithDebInfo}
: ${CTESTMPI_BUILD_DIR:=`pwd`/build}
: ${CTESTMPI_INSTALL_PREFIX:=`pwd`/install}
: ${CTESTMPI_TEST:="no"}
: ${CTESTMPI_LIB_SUFFIX:=".so"}

while [[ $# -gt 0 ]]; do
  case $1 in
    --help)
      print_help
      exit 0
      ;;
    --cc)
      CTESTMPI_CC="$2"
      shift
      shift
      ;;
    --cflags)
      CTESTMPI_CFLAGS="$2"
      shift
      shift
      ;;
    --build-type)
      CTESTMPI_BUILD_TYPE="$2"
      shift
      shift
      ;;
    --build-dir)
      CTESTMPI_BUILD_DIR="$2"
      shift
      shift
      ;;
    --install-prefix)
      CTESTMPI_INSTALL_PREFIX="$2"
      shift
      shift
      ;;
    --test)
      CTESTMPI_TEST="yes"
      shift
      ;;
    *)
      echo "Error: Unknown option: $1"
      print_help
      exit 1
      ;;
  esac
done

### Don't touch anything that follows this line. ###
if [[ -z "${CTESTMPI_CC}" ]]; then
  echo "Error: CTESTMPI_CC is not set."
  exit 1
fi

export CC=${CTESTMPI_CC}
export CFLAGS="${CTESTMPI_CFLAGS}"

CTESTMPI_CURRENT_DIR=`pwd`
CTESTMPI_CMAKE_CMD="-S ${CTESTMPI_CURRENT_DIR}"

if [[ -z "${CTESTMPI_BUILD_DIR}" ]]; then
  echo "Error: CTESTMPI_BUILD_DIR is not set."
  exit 1
fi
mkdir -p ${CTESTMPI_BUILD_DIR} 2> /dev/null
CTESTMPI_CMAKE_CMD="${CTESTMPI_CMAKE_CMD} -B ${CTESTMPI_BUILD_DIR}"

if [[ ! -z "${CTESTMPI_BUILD_TYPE}" ]]; then
  CTESTMPI_CMAKE_CMD="${CTESTMPI_CMAKE_CMD} -DCMAKE_BUILD_TYPE=${CTESTMPI_BUILD_TYPE}"
fi
if [[ ! -z "${CTESTMPI_INSTALL_PREFIX}" ]]; then
  CTESTMPI_CMAKE_CMD="${CTESTMPI_CMAKE_CMD} -DCMAKE_INSTALL_PREFIX=${CTESTMPI_INSTALL_PREFIX}"
fi

echo "cmake ${CTESTMPI_CMAKE_CMD}"
cmake ${CTESTMPI_CMAKE_CMD}

cmake --build ${CTESTMPI_BUILD_DIR} --target install -j4

if [[ "${CTESTMPI_TEST}" = "yes" ]]; then
  cd ${CTESTMPI_BUILD_DIR}/tests
  ctest
  return_value=$?
  cd ${CTESTMPI_CURRENT_DIR}
  exit ${return_value}
fi
