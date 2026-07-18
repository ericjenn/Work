cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(example)
set(XMOS_PLATFORM  conf.xn)
set(APP_SOURCES src/pdm_mics.xc)
set(APP_INCLUDES src)
set(APP_HW_TARGET XK-EVK-XU316)

set(APP_DEPENDENT_MODULES   "lib_board_support"
                            "lib_i2c"
                            "lib_i2s"
                            "lib_xcore_math"
                            "lib_mic_array")


set(XMOS_SANDBOX_DIR ${CMAKE_CURRENT_LIST_DIR}/../..)

XMOS_REGISTER_APP()
