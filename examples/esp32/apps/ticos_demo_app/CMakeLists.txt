# The following lines of boilerplate have to be in your project's CMakeLists
# in this exact order for cmake to work correctly
cmake_minimum_required(VERSION 3.5)

set(PROJECT_NAME ticos-esp32-demo-app)
set(CMAKE_PROJECT_NAME ${PROJECT_NAME})

get_filename_component(ticos_firmare_sdk_dir ../../../../ ABSOLUTE)
include(${ticos_firmare_sdk_dir}/ports/esp_idf/ticos.cmake)

# NOTE: This include also applies global compiler options, make sure
# this happens first before defining other targets!
# The esp-idf project() macro creates a project_name.elf target:
include($ENV{IDF_PATH}/tools/cmake/project.cmake)
project(${PROJECT_NAME})

# Add the Ticos Build ID so each build can have a unique version.
set(IDF_PROJECT_EXECUTABLE ${PROJECT_NAME}.elf)
add_custom_command(TARGET ${IDF_PROJECT_EXECUTABLE}
  POST_BUILD
  # Compute and insert the build id
  COMMAND python ${ticos_firmare_sdk_dir}/scripts/fw_build_id.py ${IDF_PROJECT_EXECUTABLE}
  # Save a copy of the ELF that includes the 'log_fmt' section
  BYPRODUCTS ${IDF_PROJECT_EXECUTABLE}.ticos_log_fmt
  COMMAND ${CMAKE_COMMAND} -E copy ${IDF_PROJECT_EXECUTABLE} ${IDF_PROJECT_EXECUTABLE}.ticos_log_fmt
  COMMAND ${CMAKE_COMMAND} -E echo "*** NOTE: the symbol file to upload to app.ticos.com is ${IDF_PROJECT_EXECUTABLE}.ticos_log_fmt ***"
  # Remove the 'log_fmt' compact log section, which confuses elf2image
  COMMAND ${CMAKE_OBJCOPY} --remove-section log_fmt ${IDF_PROJECT_EXECUTABLE}
)
