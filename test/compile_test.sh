#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testCompile()
{
  capture ${BUILDPACK_HOME}/bin/compile ${BUILD_DIR} ${CACHE_DIR}
  assertEquals 0 ${rtrn}
  assertEquals "" "`cat ${STD_ERR}`"

  assertContains "-----> Downloading Julia 0.3.0"  "`cat ${STD_OUT}`"
  assertTrue "Should have cached Julia.deb `ls -la ${CACHE_DIR}`" "[ -f ${CACHE_DIR}/julia_0.3.0-1189~ubuntu12.04.1_amd64.deb ]"

  assertContains "-----> Installing Julia 0.3.0"  "`cat ${STD_OUT}`"
  assertTrue "Should have installed julia in build dir: `ls -la ${BUILD_DIR}`" "[ -d ${BUILD_DIR}/.julia ]"

  # Run again to ensure cache is used.
  rm -rf ${BUILD_DIR}/*
  resetCapture

  capture ${BUILDPACK_HOME}/bin/compile ${BUILD_DIR} ${CACHE_DIR}
  assertNotContains "-----> Downloading Julia 0.3.0"  "`cat ${STD_OUT}`"

  assertEquals 0 ${rtrn}
  assertEquals "" "`cat ${STD_ERR}`"
}