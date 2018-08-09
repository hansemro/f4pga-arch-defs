# This CMake include defines the following functions:
#
# * DEFINE_ARCH - Define an FPGA architecture and tools to use that
#   architecture.
# * DEFINE_DEVICE_TYPE - Define a device type within an FPGA architecture.
# * DEFINE_DEVICE - Define a device and packaging for a specific device type and
#   FPGA architecture.
# * DEFINE_BOARD - Define a board that uses specific device and package.
# * ADD_FPGA_TARGET - Creates a FPGA image build against a specific board.

function(DEFINE_ARCH)
  # ~~~
  # DEFINE_ARCH(
  #    ARCH <arch>
  #    YOSYS_SCRIPT <yosys_script>
  #    BITSTREAM_EXTENSION <ext>
  #    RR_PATCH_TOOL <path to rr_patch tool>
  #    RR_PATCH_CMD <command to run RR_PATCH_TOOL>
  #    PLACE_TOOL <path to place tool>
  #    PLACE_TOOL_CMD <command to run PLACE_TOOL>
  #    CELLS_SIM <path to verilog file used for simulation>
  #    HLC_TO_BIT <path to HLC to bitstream converter>
  #    HLC_TO_BIT_CMD <command to run HLC_TO_BIT>
  #    BIT_TO_V <path to bitstream to verilog converter>
  #    BIT_TO_V_CMD <command to run BIT_TO_V>
  #    BIT_TO_BIN <path to bitstream to binary>
  #    BIT_TO_BIN_CMD <command to run BIT_TO_BIN>
  #   )
  # ~~~
  #
  # DEFINE_ARCH defines an FPGA architecture. All arguments are required.
  #
  # RR_PATCH_CMD, PLACE_TOOL_CMD and HLC_TO_BIT_CMD will all be called with
  # string(CONFIGURE) to substitute variables.
  #
  # RR_PATCH_CMD variables:
  #
  # * RR_PATCH_TOOL - Value of RR_PATCH_TOOL property of <arch>.
  # * DEVICE - What device is being patch (see DEFINE_DEVICE).
  # * OUT_RRXML_VIRT - Input virtual rr_graph file for device.
  # * OUT_RRXML_REAL - Out real rr_graph file for device.
  #
  # PLACE_TOOL_CMD variables:
  #
  # * PLACE_TOOL - Value of PLACE_TOOL property of <arch>.
  # * PINMAP - Path to pinmap file.  This file will be retrieved from the
  #   ${PACKAGE}_PINMAP property of the ${DEVICE}.  ${DEVICE} and ${PACKAGE}
  #   will be defined by the BOARD being used. See DEFINE_BOARD.
  # * OUT_EBLIF - Input path to EBLIF file.
  # * INPUT_IO_FILE - Path to input io file, as specified by ADD_FPGA_TARGET.
  #
  # HLC_TO_BIT_CMD variables:
  #
  # * HLC_TO_BIT - Value of HLC_TO_BIT property of <arch>.
  # * OUT_HLC - Input path to HLC file.
  # * OUT_BITSTREAM - Output path to bitstream file.
  #
  # BIT_TO_V variables:
  #
  # * BIT_TO_V - Value of BIT_TO_V property of <arch>.
  # * TOP - Name of top module.
  # * INPUT_IO_FILE - Logic to IO pad constraint file.
  # * PACKAGE - Package of bitstream.
  # * OUT_BITSTREAM - Input path to bitstream.
  # * OUT_BIT_VERILOG - Output path to verilog version of bitstream.
  set(options)
  set(
    oneValueArgs
    ARCH
    YOSYS_SCRIPT
    BITSTREAM_EXTENSION
    RR_PATCH_TOOL
    RR_PATCH_CMD
    PLACE_TOOL
    PLACE_TOOL_CMD
    CELLS_SIM
    HLC_TO_BIT
    HLC_TO_BIT_CMD
    BIT_TO_V
    BIT_TO_V_CMD
    BIT_TO_BIN
    BIT_TO_BIN_CMD
  )
  set(multiValueArgs)
  cmake_parse_arguments(
    DEFINE_ARCH
    "${options}"
    "${oneValueArgs}"
    "${multiValueArgs}"
    ${ARGN}
  )

  add_custom_target(${DEFINE_ARCH_ARCH})
  foreach(
    ARG
    YOSYS_SCRIPT
    BITSTREAM_EXTENSION
    RR_PATCH_TOOL
    RR_PATCH_CMD
    PLACE_TOOL
    PLACE_TOOL_CMD
    CELLS_SIM
    HLC_TO_BIT
    HLC_TO_BIT_CMD
    BIT_TO_V
    BIT_TO_V_CMD
    BIT_TO_BIN
    BIT_TO_BIN_CMD
  )
    if("${DEFINE_ARCH_${ARG}}" STREQUAL "")
      message(FATAL_ERROR "Required argument ${ARG} is the empty string.")
    endif()
    set_target_properties(
      ${DEFINE_ARCH_ARCH}
      PROPERTIES ${ARG} "${DEFINE_ARCH_${ARG}}"
    )
  endforeach()
endfunction()

function(DEFINE_DEVICE_TYPE)
  # ~~~
  # DEFINE_DEVICE_TYPE(
  #   DEVICE_TYPE <device_type>
  #   ARCH <arch>
  #   ARCH_XML <arch.xml>
  #   )
  # ~~~
  #
  # Defines a device type with the specified architecture.  ARCH_XML argument
  # must be a file target (see ADD_FILE_TARGET).
  #
  # DEFINE_DEVICE_TYPE defines a dummy target <arch>_<device_type>_arch that
  # will build the merged architecture file for the device type.
  set(options)
  set(oneValueArgs DEVICE_TYPE ARCH ARCH_XML)
  set(multiValueArgs)
  cmake_parse_arguments(
    DEFINE_DEVICE_TYPE
    "${options}"
    "${oneValueArgs}"
    "${multiValueArgs}"
    ${ARGN}
  )

  add_custom_target(${DEFINE_DEVICE_TYPE_DEVICE_TYPE})
  foreach(ARG ARCH)
    if("${DEFINE_DEVICE_TYPE_${ARG}}" STREQUAL "")
      message(FATAL_ERROR "Required argument ${ARG} is the empty string.")
    endif()
    set_target_properties(
      ${DEFINE_DEVICE_TYPE_DEVICE_TYPE}
      PROPERTIES ${ARG} ${DEFINE_DEVICE_TYPE_${ARG}}
    )
  endforeach()

  #
  # Generate a arch.xml for a device.
  #
  set(DEVICE_MERGED_FILE arch.merged.xml)

  set(MERGE_XML_XSL ${symbiflow-arch-defs_SOURCE_DIR}/common/xml/xmlsort.xsl)
  set(
    MERGE_XML_INPUT ${CMAKE_CURRENT_BINARY_DIR}/${DEFINE_DEVICE_TYPE_ARCH_XML}
  )
  get_file_target(MERGE_XML_INPUT_TARGET ${DEFINE_DEVICE_TYPE_ARCH_XML})
  set(MERGE_XML_OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${DEVICE_MERGED_FILE})

  get_target_property_required(XSLTPROC env XSLTPROC)
  add_custom_command(
    OUTPUT ${MERGE_XML_OUTPUT}
    DEPENDS ${MERGE_XML_XSL} ${MERGE_XML_INPUT} ${MERGE_XML_INPUT_TARGET}
    COMMAND
      ${CMAKE_COMMAND} -E make_directory
      ${CMAKE_CURRENT_BINARY_DIR}/${OUT_DEVICE_DIR}
    COMMAND
      ${XSLTPROC}
      --nomkdir
      --nonet
      --xinclude
      --output ${MERGE_XML_OUTPUT} ${MERGE_XML_XSL} ${MERGE_XML_INPUT}
  )
  add_custom_target(
    ${DEFINE_DEVICE_TYPE_ARCH}_${DEFINE_DEVICE_TYPE_DEVICE_TYPE}_arch
    DEPENDS ${DEVICE_MERGED_FILE}
  )
  add_dependencies(all_merged_arch_xmls
    ${DEFINE_DEVICE_TYPE_ARCH}_${DEFINE_DEVICE_TYPE_DEVICE_TYPE}_arch)

  add_file_target(FILE ${DEVICE_MERGED_FILE} GENERATED)

  set_target_properties(
    ${DEFINE_DEVICE_TYPE_DEVICE_TYPE}
    PROPERTIES
      DEVICE_MERGED_FILE ${CMAKE_CURRENT_SOURCE_DIR}/${DEVICE_MERGED_FILE}
  )

endfunction()

function(DEFINE_DEVICE)
  # ~~~
  # DEFINE_DEVICE(
  #   DEVICE <device>
  #   ARCH <arch>
  #   DEVICE_TYPE <device_type>
  #   PACKAGES <list of packages>
  #   )
  # ~~~
  #
  # Defines a device within a specified FPGA architecture.
  #
  # Creates dummy targets <arch>_<device>_<package>_rrxml_virt and
  # <arch>_<device>_<package>_rrxml_virt  that generates the the virtual and
  # real rr_graph for a specific device and package.
  #
  # In order to use a device with ADD_FPGA_TARGET, the property
  # ${PACKAGE}_PINMAP on target <device> must be set.
  set(options)
  set(oneValueArgs DEVICE ARCH DEVICE_TYPE PACKAGES)
  set(multiValueArgs)
  cmake_parse_arguments(
    DEFINE_DEVICE
    "${options}"
    "${oneValueArgs}"
    "${multiValueArgs}"
    ${ARGN}
  )

  add_custom_target(${DEFINE_DEVICE_DEVICE})
  foreach(ARG ARCH DEVICE_TYPE PACKAGES)
    if("${DEFINE_DEVICE_${ARG}}" STREQUAL "")
      message(FATAL_ERROR "Required argument ${ARG} is the empty string.")
    endif()
    set_target_properties(
      ${DEFINE_DEVICE_DEVICE}
      PROPERTIES ${ARG} ${DEFINE_DEVICE_${ARG}}
    )
  endforeach()

  get_target_property_required(
    RR_PATCH_TOOL ${DEFINE_DEVICE_ARCH} RR_PATCH_TOOL
  )
  get_target_property_required(RR_PATCH_CMD ${DEFINE_DEVICE_ARCH} RR_PATCH_CMD)

  get_target_property_required(
    VIRT_DEVICE_MERGED_FILE ${DEFINE_DEVICE_DEVICE_TYPE} DEVICE_MERGED_FILE
  )
  get_file_target(DEVICE_MERGED_FILE_TARGET ${VIRT_DEVICE_MERGED_FILE})
  get_file_location(DEVICE_MERGED_FILE ${VIRT_DEVICE_MERGED_FILE})
  get_target_property_required(VPR env VPR)

  set(DEVICE ${DEFINE_DEVICE_DEVICE})
  foreach(PACKAGE ${DEFINE_DEVICE_PACKAGES})
    set(DEVICE_FULL ${DEVICE}-${PACKAGE})
    set(OUT_RRXML_VIRT_FILENAME rr_graph_${DEVICE}_${PACKAGE}.rr_graph.virt.xml)
    set(OUT_RRXML_REAL_FILENAME rr_graph_${DEVICE}_${PACKAGE}.rr_graph.real.xml)
    set(OUT_RRXML_VIRT ${CMAKE_CURRENT_BINARY_DIR}/${OUT_RRXML_VIRT_FILENAME})
    set(OUT_RRXML_REAL ${CMAKE_CURRENT_BINARY_DIR}/${OUT_RRXML_REAL_FILENAME})

    #
    # Generate a rr_graph for a device.
    #

    # Generate the "default" rr_graph.xml we are going to patch using wire.
    add_custom_command(
      OUTPUT ${OUT_RRXML_VIRT} rr_graph_${DEVICE}_${PACKAGE}.virt.out
      DEPENDS
        ${symbiflow-arch-defs_SOURCE_DIR}/common/wire.eblif
        ${DEVICE_MERGED_FILE} ${DEVICE_MERGED_FILE_TARGET}
      COMMAND
        ${VPR} ${DEVICE_MERGED_FILE}
        --device ${DEVICE}-${PACKAGE}
        ${symbiflow-arch-defs_SOURCE_DIR}/common/wire.eblif
        --route_chan_width 100
        --echo_file on
        --min_route_chan_width_hint 1
        --write_rr_graph ${OUT_RRXML_VIRT}
      COMMAND
        ${CMAKE_COMMAND} -E remove wire.{net,place,route}
      COMMAND
        ${CMAKE_COMMAND} -E copy vpr_stdout.log
        rr_graph_${DEVICE}_${PACKAGE}.virt.out
      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    )
    add_custom_target(
      ${DEFINE_DEVICE_ARCH}_${DEFINE_DEVICE_DEVICE}_${PACKAGE}_rrxml_virt
      DEPENDS ${OUT_RRXML_VIRT}
    )

    add_file_target(FILE ${OUT_RRXML_VIRT_FILENAME} GENERATED)

    set_target_properties(
      ${DEFINE_DEVICE_DEVICE}
      PROPERTIES
        OUT_RRXML_VIRT ${CMAKE_CURRENT_SOURCE_DIR}/${OUT_RRXML_VIRT_FILENAME}
    )

    set(RR_PATCH_DEPS "")
    list(APPEND RR_PATCH_DEPS ${DEVICE_MERGED_FILE})
    list(APPEND RR_PATCH_DEPS ${DEVICE_MERGED_FILE_TARGET})

    # Generate the "real" rr_graph.xml from the default rr_graph.xml file
    string(CONFIGURE ${RR_PATCH_CMD} RR_PATCH_CMD_FOR_TARGET)
    separate_arguments(
      RR_PATCH_CMD_FOR_TARGET_LIST UNIX_COMMAND ${RR_PATCH_CMD_FOR_TARGET}
    )
    add_custom_command(
      OUTPUT ${OUT_RRXML_REAL}
      DEPENDS ${RR_PATCH_DEPS} ${RR_PATCH_TOOL} ${OUT_RRXML_VIRT}
      COMMAND ${RR_PATCH_CMD_FOR_TARGET_LIST}
      VERBATIM
    )

    add_file_target(FILE ${OUT_RRXML_REAL_FILENAME} GENERATED)

    set_target_properties(
      ${DEFINE_DEVICE_DEVICE}
      PROPERTIES
        ${PACKAGE}_OUT_RRXML_REAL
        ${CMAKE_CURRENT_SOURCE_DIR}/${OUT_RRXML_REAL_FILENAME}
    )

    add_custom_target(
      ${DEFINE_DEVICE_ARCH}_${DEFINE_DEVICE_DEVICE}_${PACKAGE}_rrxml_real
      DEPENDS ${OUT_RRXML_REAL}
    )

    # Define dummy boards.  PROG_TOOL is set to false to disallow programming.
    define_board(
      BOARD dummy_${DEFINE_DEVICE_ARCH}_${DEFINE_DEVICE_DEVICE}_${PACKAGE}
      DEVICE ${DEFINE_DEVICE_DEVICE}
      PACKAGE ${PACKAGE}
      PROG_TOOL false
      )
  endforeach()
endfunction()

function(DEFINE_BOARD)
  # ~~~
  # DEFINE_BOARD(
  #   BOARD <board>
  #   DEVICE <device>
  #   PACKAGE <package>
  #   PROG_TOOL <prog_tool>
  #   [PROG_CMD <command to use PROG_TOOL>
  #   )
  # ~~~
  #
  # Defines a target board for a project.  The listed device and package must
  # have been defined using DEFINE_DEVICE.
  #
  # PROG_TOOL should be an executable that will program a bitstream to the
  # specified board. PROG_CMD is an optional command string.  If PROG_CMD is not
  # provided, PROG_CMD will simply be ${PROG_TOOL}.
  #
  set(options)
  set(oneValueArgs BOARD DEVICE PACKAGE PROG_TOOL PROG_CMD)
  set(multiValueArgs)
  cmake_parse_arguments(
    DEFINE_BOARD
    "${options}"
    "${oneValueArgs}"
    "${multiValueArgs}"
    ${ARGN}
  )

  add_custom_target(${DEFINE_BOARD_BOARD})
  foreach(ARG DEVICE PACKAGE PROG_TOOL PROG_CMD)
    set_target_properties(
      ${DEFINE_BOARD_BOARD}
      PROPERTIES ${ARG} "${DEFINE_BOARD_${ARG}}"
    )
  endforeach()
endfunction()

function(ADD_OUTPUT_TO_FPGA_TARGET name property file)
  add_file_target(FILE ${file} GENERATED)
  set_target_properties(${name} PROPERTIES ${property} ${file})
endfunction()

function(ADD_FPGA_TARGET_BOARDS)
  # ~~~
  # ADD_FPGA_TARGET_BOARDS(
  #   NAME <name>
  #   [TOP <top>]
  #   BOARDS <board list>
  #   SOURCES <source list>
  #   TESTBENCH_SOURCES <testbench source list>
  #   [IMPLICIT_INPUT_IO_FILES]
  #   [INPUT_IO_FILES <input_io_file list>]
  #   [EXPLICIT_ADD_FILE_TARGET]
  #   [EMIT_CHECK_TESTS EQUIV_CHECK_SCRIPT <yosys to script verify two bitstreams gold and gate>]
  #   )
  # ~~~
  # Version of ADD_FPGA_TARGET that emits targets for multiple boards.
  #
  # If INPUT_IO_FILES is supplied, BOARDS[i] will use INPUT_IO_FILES[i].
  #
  # If IMPLICIT_INPUT_IO_FILES is supplied, INPUT_IO_FILES[i] will be set to
  # "BOARDS[i].pcf".
  #
  # Targets will be named <name>_<board>.
  #
  set(options EXPLICIT_ADD_FILE_TARGET EMIT_CHECK_TESTS IMPLICIT_INPUT_IO_FILES)
  set(oneValueArgs NAME TOP  EQUIV_CHECK_SCRIPT)
  set(multiValueArgs SOURCES BOARDS INPUT_IO_FILE TESTBENCH_SOURCES)
  cmake_parse_arguments(
    ADD_FPGA_TARGET_BOARDS
    "${options}"
    "${oneValueArgs}"
    "${multiValueArgs}"
    ${ARGN}
  )

  set(INPUT_IO_FILES ${ADD_FPGA_TARGET_BOARDS_INPUT_IO_FILES})
  if(NOT "${INPUT_IO_FILES}" STREQUAL "" AND ${ADD_FPGA_TARGET_BOARDS_IMPLICIT_INPUT_IO_FILES})
    message(FATAL_ERROR "Cannot request implicit IO files and supply explicit IO file list")
  endif()

  set(BOARDS ${ADD_FPGA_TARGET_BOARDS_BOARDS})
  list(LENGTH BOARDS NUM_BOARDS)
  if(${ADD_FPGA_TARGET_BOARDS_IMPLICIT_INPUT_IO_FILES})
    foreach(BOARD ${BOARDS})
      list(APPEND INPUT_IO_FILES ${BOARD}.pcf)
    endforeach()
    set(HAVE_IO_FILES TRUE)
  else()
    list(LENGTH INPUT_IO_FILES NUM_INPUT_IO_FILES)
    if(${NUM_INPUT_IO_FILES} GREATER 0)
      set(HAVE_IO_FILES TRUE)
    else()
      set(HAVE_IO_FILES FALSE)
    endif()
    if(${HAVE_IO_FILES} AND NOT ${NUM_INPUT_IO_FILES} EQUAL ${NUM_BOARDS})
      message(FATAL_ERROR "Provide ${NUM_BOARDS} boards and ${NUM_INPUT_IO_FILES} io files, must be equal.")
    endif()
  endif()

  if(NOT ${ADD_FPGA_TARGET_BOARDS_EXPLICIT_ADD_FILE_TARGET})
    set(FILE_LIST  "")
    foreach(SRC ${ADD_FPGA_TARGET_BOARDS_SOURCES} ${ADD_FPGA_TARGET_BOARDS_TESTBENCH_SOURCES})
      add_file_target(FILE ${SRC} SCANNER_TYPE verilog)
    endforeach()
    foreach(SRC ${INPUT_IO_FILES})
      add_file_target(FILE ${SRC})
    endforeach()
  endif()

  set(OPT_ARGS "")
  foreach(OPT_STR_ARG TOP EQUIV_CHECK_SCRIPT)
    if("${ADD_FPGA_TARGET_BOARDS_${OPT_STR_ARG}}" STREQUAL "")
      list(APPEND OPT_ARGS ${OPT_STR_ARG} ${ADD_FPGA_TARGET_BOARDS_${OPT_STR_ARG}})
    endif()
  endforeach()
  foreach(OPT_OPTION_ARG EMIT_CHECK_TESTS)
    if(${ADD_FPGA_TARGET_BOARDS_${OPT_OPTION_ARG}})
      list(APPEND OPT_ARGS ${OPT_OPTION_ARG})
    endif()
  endforeach()
  list(LENGTH ADD_FPGA_TARGET_BOARDS_TESTBENCH_SOURCES NUM_TESTBENCH_SOURCES)
  if($NUM_TESTBENCH_SOURCES} GREATER 0)
    list(APPEND OPT_ARGS TESTBENCH_SOURCES ${ADD_FPGA_TARGET_BOARDS_TESTBENCH_SOURCES})
  endif()

  math(EXPR NUM_BOARDS_MINUS_1 ${NUM_BOARDS}-1)
  foreach(IDX RANGE ${NUM_BOARDS_MINUS_1})
    list(GET BOARDS ${IDX} BOARD)
    set(BOARD_OPT_ARGS ${OPT_ARGS})
    if(${HAVE_IO_FILES})
      list(GET INPUT_IO_FILES ${IDX} INPUT_IO_FILE)
      list(APPEND BOARD_OPT_ARGS INPUT_IO_FILE ${INPUT_IO_FILE})
    endif()
    add_fpga_target(
      NAME ${ADD_FPGA_TARGET_BOARDS_NAME}_${BOARD}
      BOARD ${BOARD}
      SOURCES ${ADD_FPGA_TARGET_BOARDS_SOURCES}
      EXPLICIT_ADD_FILE_TARGET
      ${BOARD_OPT_ARGS}
      )
  endforeach()
endfunction()

function(ADD_FPGA_TARGET)
  # ~~~
  # ADD_FPGA_TARGET(
  #   NAME <name>
  #   [TOP <top>]
  #   BOARD <board>
  #   SOURCES <source list>
  #   TESTBENCH_SOURCES <testbench source list>
  #   [INPUT_IO_FILE <input_io_file>]
  #   [EXPLICIT_ADD_FILE_TARGET]
  #   [EMIT_CHECK_TESTS EQUIV_CHECK_SCRIPT <yosys to script verify two bitstreams gold and gate>]
  #   )
  # ~~~
  #
  # ADD_FPGA_TARGET defines a FPGA build targetting a specific board.  By
  # default input files (SOURCES, TESTBENCH_SOURCES, INPUT_IO_FILE) will be
  # implicitly passed to ADD_FILE_TARGET.  If EXPLICIT_ADD_FILE_TARGET is
  # supplied, this behavior is supressed.
  #
  # TOP is the name of the top-level module in the design.  If no supplied,
  # TOP is set to "top".
  #
  # The SOURCES file list will be used to synthesize the FPGA images.
  # INPUT_IO_FILE is required to define an io map. TESTBENCH_SOURCES will be
  # used to run test benches.
  #
  # Targets generated:
  #
  # * <name>_eblif - Generate eblif file.
  # * <name>_synth - Alias of <name>_eblif.
  # * <name>_route - Generate place and routing synthesized design.
  # * <name>_bit - Generate output bitstream.
  #
  # Outputs for this target will all be located in
  # ~~~
  # ${CMAKE_CURRENT_BINARY_DIR}/${NAME}/${ARCH}-${DEVICE_TYPE}-${DEVICE}-${PACKAGE}
  # ~~~
  #
  # Output files:
  #
  # * ${TOP}.eblif - Synthesized design (http://docs.verilogtorouting.org/en/latest/vpr/file_formats/#extended-blif-eblif)
  # * ${TOP}_io.place - IO placement.
  # * ${TOP}.route - Place and routed design (http://docs.verilogtorouting.org/en/latest/vpr/file_formats/#routing-file-format-route)
  # * ${TOP}.${BITSTREAM_EXTENSION} - Bitstream for target.
  #
  set(options EXPLICIT_ADD_FILE_TARGET EMIT_CHECK_TESTS)
  set(oneValueArgs NAME TOP BOARD INPUT_IO_FILE EQUIV_CHECK_SCRIPT)
  set(multiValueArgs SOURCES TESTBENCH_SOURCES)
  cmake_parse_arguments(
    ADD_FPGA_TARGET
    "${options}"
    "${oneValueArgs}"
    "${multiValueArgs}"
    ${ARGN}
  )

  set(TOP "top")
  if(NOT "${ADD_FPGA_TARGET_TOP}" STREQUAL "")
    set(TOP ${ADD_FPGA_TARGET_TOP})
  endif()

  set(BOARD ${ADD_FPGA_TARGET_BOARD})
  if("${BOARD}" STREQUAL "")
    message(FATAL_ERROR "BOARD is a required parameters.")
  endif()

  get_target_property_required(DEVICE ${BOARD} DEVICE)
  get_target_property_required(PACKAGE ${BOARD} PACKAGE)

  get_target_property_required(ARCH ${DEVICE} ARCH)
  get_target_property_required(DEVICE_TYPE ${DEVICE} DEVICE_TYPE)

  get_target_property_required(BITSTREAM_EXTENSION ${ARCH} BITSTREAM_EXTENSION)
  get_target_property_required(YOSYS env YOSYS)
  get_target_property_required(YOSYS_SCRIPT ${ARCH} YOSYS_SCRIPT)

  get_target_property_required(
    DEVICE_MERGED_FILE ${DEVICE_TYPE} DEVICE_MERGED_FILE
  )
  get_target_property_required(
    OUT_RRXML_REAL ${DEVICE} ${PACKAGE}_OUT_RRXML_REAL
  )

  set(NAME ${ADD_FPGA_TARGET_NAME})
  set(DEVICE_FULL ${DEVICE}-${PACKAGE})
  set(FQDN ${ARCH}-${DEVICE_TYPE}-${DEVICE}-${PACKAGE})
  set(OUT_LOCAL_REL ${NAME}/${FQDN})
  set(OUT_LOCAL ${CMAKE_CURRENT_BINARY_DIR}/${OUT_LOCAL_REL})
  set(DIRECTORY_TARGET ${NAME}-${FQDN}-make-directory)
  add_custom_target(
    ${DIRECTORY_TARGET} ALL
    COMMAND
      ${CMAKE_COMMAND} -E make_directory ${OUT_LOCAL}
  )

  # Create target to handle all output paths of off
  add_custom_target(${NAME})
  set(VPR_ROUTE_CHAN_WIDTH 100)
  set(VPR_ROUTE_CHAN_MINWIDTH_HINT ${VPR_ROUTE_CHAN_WIDTH})

  if(NOT ${ADD_FPGA_TARGET_EXPLICIT_ADD_FILE_TARGET})
    foreach(SRC ${ADD_FPGA_TARGET_SOURCES})
      add_file_target(FILE ${SRC} SCANNER_TYPE verilog)
    endforeach()
    foreach(SRC ${ADD_FPGA_TARGET_TESTBENCH_SOURCES})
      add_file_target(FILE ${SRC} SCANNER_TYPE verilog)
    endforeach()

    if(NOT "${ADD_FPGA_TARGET_INPUT_IO_FILE}" STREQUAL "")
      add_file_target(FILE ${ADD_FPGA_TARGET_INPUT_IO_FILE})
    endif()
  endif()

  #
  # Generate BLIF as start of vpr input.
  #
  set(OUT_EBLIF ${OUT_LOCAL}/${TOP}.eblif)

  set(SOURCE_FILES_DEPS "")
  set(SOURCE_FILES "")
  foreach(SRC ${ADD_FPGA_TARGET_SOURCES})
    get_file_location(SRC_LOCATION ${SRC})
    get_file_target(SRC_TARGET ${SRC})
    list(APPEND SOURCE_FILES ${SRC_LOCATION})
    list(APPEND SOURCE_FILES_DEPS ${SRC_TARGET})
  endforeach()

  set(
    COMPLETE_YOSYS_SCRIPT
    "${YOSYS_SCRIPT} $<SEMICOLON> write_blif -attr -cname -param ${OUT_EBLIF}"
  )

  add_custom_command(
    OUTPUT ${OUT_EBLIF}
    DEPENDS ${SOURCE_FILES} ${SOURCE_FILES_DEPS} ${DIRECTORY_TARGET}
    COMMAND
      ${YOSYS} -p "${COMPLETE_YOSYS_SCRIPT}" ${SOURCE_FILES}
    VERBATIM
  )
  add_custom_target(${NAME}_eblif DEPENDS ${OUT_EBLIF})
  add_custom_target(${NAME}_synth DEPENDS ${OUT_EBLIF})
  add_output_to_fpga_target(${NAME} EBLIF ${OUT_LOCAL_REL}/${TOP}.eblif)

  # Generate routing and generate HLC.
  set(OUT_ROUTE ${OUT_LOCAL}/${TOP}.route)
  set(OUT_HLC ${OUT_LOCAL}/${TOP}.hlc)

  set(VPR_DEPS "")
  list(APPEND VPR_DEPS ${OUT_EBLIF})

  get_file_location(OUT_RRXML_REAL_LOCATION ${OUT_RRXML_REAL})
  get_file_location(DEVICE_MERGED_FILE_LOCATION ${DEVICE_MERGED_FILE})

  foreach(SRC ${DEVICE_MERGED_FILE} ${OUT_RRXML_REAL})
    get_file_location(SRC_LOCATION ${SRC})
    get_file_target(SRC_TARGET ${SRC})
    list(APPEND VPR_DEPS ${SRC_LOCATION})
    list(APPEND VPR_DEPS ${SRC_TARGET})
  endforeach()

  get_target_property_required(VPR env VPR)
  set(
    VPR_CMD
    ${VPR}
    ${DEVICE_MERGED_FILE_LOCATION}
    ${OUT_EBLIF}
    --device ${DEVICE_FULL}
    --min_route_chan_width_hint ${VPR_ROUTE_CHAN_MINWIDTH_HINT}
    --route_chan_width ${VPR_ROUTE_CHAN_WIDTH}
    --read_rr_graph ${OUT_RRXML_REAL_LOCATION}
    --verbose_sweep on
    --allow_unrelated_clustering off
    --max_criticality 0.0
    --target_ext_pin_util 0.7
    --max_router_iterations 500
    --routing_failure_predictor off
    --clock_modeling route
    --constant_net_method route
  )

  # Generate IO constraints file.
  # -------------------------------------------------------------------------
  set(OUT_IO "")
  set(FIX_PINS_ARG "")
  if(NOT ${ADD_FPGA_TARGET_INPUT_IO_FILE} STREQUAL "")
    get_file_location(INPUT_IO_FILE ${ADD_FPGA_TARGET_INPUT_IO_FILE})
    get_file_target(INPUT_IO_FILE_TARGET ${ADD_FPGA_TARGET_INPUT_IO_FILE})
    get_target_property_required(PLACE_TOOL ${ARCH} PLACE_TOOL)
    get_target_property_required(PLACE_TOOL_CMD ${ARCH} PLACE_TOOL_CMD)
    get_target_property_required(PINMAP_FILE ${DEVICE} ${PACKAGE}_PINMAP)
    get_file_location(PINMAP ${PINMAP_FILE})
    get_file_target(PINMAP_TARGET ${PINMAP_FILE})
    set(OUT_IO ${OUT_LOCAL}/${TOP}_io.place)
    string(CONFIGURE ${PLACE_TOOL_CMD} PLACE_TOOL_CMD_FOR_TARGET)
    separate_arguments(
      PLACE_TOOL_CMD_FOR_TARGET_LIST UNIX_COMMAND ${PLACE_TOOL_CMD_FOR_TARGET}
    )
    add_custom_command(
      OUTPUT ${OUT_IO}
      DEPENDS
        ${OUT_EBLIF}
        ${INPUT_IO_FILE}
        ${INPUT_IO_FILE_TARGET}
        ${PINMAP}
        ${PINMAP_TARGET}
        ${VPR_DEPS}
      COMMAND ${PLACE_TOOL_CMD_FOR_TARGET_LIST} --out ${OUT_IO}
      WORKING_DIRECTORY ${OUT_LOCAL}
    )

    set(FIX_PINS_ARG --fix_pins ${OUT_IO})

    add_output_to_fpga_target(${NAME} IO_PLACE ${OUT_LOCAL_REL}/${TOP}_io.place)
  endif()

  # Generate packing.
  # -------------------------------------------------------------------------
  set(OUT_NET ${OUT_LOCAL}/${TOP}.net)
  add_custom_command(
    OUTPUT ${OUT_NET}
    DEPENDS ${OUT_EBLIF} ${OUT_IO} ${VPR_DEPS}
    COMMAND ${VPR_CMD} --pack
    COMMAND
      ${CMAKE_COMMAND} -E copy ${OUT_LOCAL}/vpr_stdout.log ${OUT_LOCAL}/pack.log
    WORKING_DIRECTORY ${OUT_LOCAL}
  )

  # Generate placement.
  # -------------------------------------------------------------------------
  set(OUT_PLACE ${OUT_LOCAL}/${TOP}.place)
  add_custom_command(
    OUTPUT ${OUT_PLACE}
    DEPENDS ${OUT_NET} ${OUT_IO} ${VPR_DEPS}
    COMMAND ${VPR_CMD} ${FIX_PINS_ARG} --place
    COMMAND
      ${CMAKE_COMMAND} -E copy ${OUT_LOCAL}/vpr_stdout.log
      ${OUT_LOCAL}/place.log
    WORKING_DIRECTORY ${OUT_LOCAL}
  )

  # Generate routing.
  # -------------------------------------------------------------------------
  add_custom_command(
    OUTPUT ${OUT_ROUTE} ${OUT_HLC}
    DEPENDS ${OUT_PLACE} ${OUT_IO} ${VPR_DEPS}
    COMMAND ${VPR_CMD} --route
    WORKING_DIRECTORY ${OUT_LOCAL}
  )

  add_custom_target(${NAME}_route DEPENDS ${OUT_ROUTE})

  # Generate bitstream
  # -------------------------------------------------------------------------
  set(OUT_BITSTREAM ${OUT_LOCAL}/${TOP}.${BITSTREAM_EXTENSION})

  get_target_property_required(HLC_TO_BIT ${ARCH} HLC_TO_BIT)
  get_target_property_required(HLC_TO_BIT_CMD ${ARCH} HLC_TO_BIT_CMD)
  string(CONFIGURE ${HLC_TO_BIT_CMD} HLC_TO_BIT_CMD_FOR_TARGET)
  separate_arguments(
    HLC_TO_BIT_CMD_FOR_TARGET_LIST UNIX_COMMAND ${HLC_TO_BIT_CMD_FOR_TARGET}
  )
  add_custom_command(
    OUTPUT ${OUT_BITSTREAM}
    DEPENDS ${OUT_HLC} ${HLC_TO_BIT}
    COMMAND ${HLC_TO_BIT_CMD_FOR_TARGET_LIST}
  )

  add_custom_target(${NAME}_bit ALL DEPENDS ${OUT_BITSTREAM})
  add_output_to_fpga_target(${NAME} BIT ${OUT_LOCAL_REL}/${TOP}.${BITSTREAM_EXTENSION})

  # Generate verilog from bitstream
  # -------------------------------------------------------------------------
  set(OUT_BIT_VERILOG ${OUT_LOCAL}/${TOP}_bit.v)
  get_target_property_required(BIT_TO_V ${ARCH} BIT_TO_V)
  get_target_property_required(BIT_TO_V_CMD ${ARCH} BIT_TO_V_CMD)
  string(CONFIGURE ${BIT_TO_V_CMD} BIT_TO_V_CMD_FOR_TARGET)
  separate_arguments(
    BIT_TO_V_CMD_FOR_TARGET_LIST UNIX_COMMAND ${BIT_TO_V_CMD_FOR_TARGET}
  )

  add_custom_command(
    OUTPUT ${OUT_BIT_VERILOG}
    COMMAND ${BIT_TO_V_CMD_FOR_TARGET_LIST}
    DEPENDS ${BIT_TO_V} ${OUT_BITSTREAM}
    )

  add_custom_target(${NAME}_bit_v DEPENDS ${OUT_BIT_VERILOG})
  add_output_to_fpga_target(${NAME} BIT_V ${OUT_LOCAL_REL}/${TOP}_bit.v)

  set(OUT_BIN ${OUT_LOCAL}/${TOP}.bin)
  get_target_property_required(BIT_TO_BIN ${ARCH} BIT_TO_BIN)
  get_target_property_required(BIT_TO_BIN_CMD ${ARCH} BIT_TO_BIN_CMD)
  string(CONFIGURE ${BIT_TO_BIN_CMD} BIT_TO_BIN_CMD_FOR_TARGET)
  separate_arguments(
    BIT_TO_BIN_CMD_FOR_TARGET_LIST UNIX_COMMAND ${BIT_TO_BIN_CMD_FOR_TARGET}
  )
  add_custom_command(
    OUTPUT ${OUT_BIN}
    COMMAND ${BIT_TO_BIN_CMD_FOR_TARGET_LIST}
    DEPENDS ${BIT_TO_BIN} ${OUT_BITSTREAM}
    )

  add_custom_target(${NAME}_bin DEPENDS ${OUT_BIN})
  add_output_to_fpga_target(${NAME} BIN ${OUT_LOCAL_REL}/${TOP}.bin)

  get_target_property_required(PROG_TOOL ${BOARD} PROG_TOOL)
  get_target_property(PROG_CMD ${BOARD} PROG_CMD)
  separate_arguments(
    PROG_CMD_LIST UNIX_COMMAND ${PROG_CMD}
  )

  if("${PROG_CMD}" STREQUAL "NOTFOUND")
    set(PROG_CMD ${PROG_TOOL})
  endif()

  add_custom_target(
    ${NAME}_prog
    COMMAND ${PROG_CMD_LIST} ${OUT_BIN}
    DEPENDS ${OUT_BIN} ${PROG_TOOL}
    )

  # Add test bench targets
  # -------------------------------------------------------------------------
  foreach(TESTBENCH ${ADD_FPGA_TARGET_TESTBENCH_SOURCES})
    get_filename_component(TESTBENCH_NAME ${TESTBENCH} NAME_WE)
    add_testbench(
      NAME testbench_${TESTBENCH_NAME}
      ARCH ${ARCH}
      SOURCES ${ADD_FPGA_TARGET_SOURCES} ${TESTBENCH}
      )
    add_testbench(
      NAME testbinch_${TESTBENCH_NAME}
      ARCH ${ARCH}
      SOURCES ${OUT_LOCAL_REL}/${TOP}_bit.v ${TESTBENCH}
      )
  endforeach()

  if(${ADD_FPGA_TARGET_EMIT_CHECK_TESTS})
    if("${ADD_FPGA_TARGET_EQUIV_CHECK_SCRIPT}" STREQUAL "")
      message(FATAL_ERROR "EQUIV_CHECK_SCRIPT is required if EMIT_CHECK_TESTS is set.")
    endif()

    add_check_test(
      NAME ${NAME}_check
      ARCH ${ARCH}
      READ_GOLD "read_verilog ${SOURCE_FILES} $<SEMICOLON> rename ${TOP} gold"
      READ_GATE "read_verilog ${OUT_BIT_VERILOG} $<SEMICOLON> rename ${TOP} gate"
      EQUIV_CHECK_SCRIPT ${ADD_FPGA_TARGET_EQUIV_CHECK_SCRIPT}
      DEPENDS ${SOURCE_FILES} ${SOURCE_FILES_DEPS} ${OUT_BIT_VERILOG}
      )
    add_check_test(
      NAME ${NAME}_check_eblif
      ARCH ${ARCH}
      READ_GOLD "read_verilog ${SOURCE_FILES} $<SEMICOLON> rename ${TOP} gold"
      READ_GATE "read_blif -wideports ${OUT_EBLIF} $<SEMICOLON> rename ${TOP} gate"
      EQUIV_CHECK_SCRIPT ${ADD_FPGA_TARGET_EQUIV_CHECK_SCRIPT}
      DEPENDS ${SOURCE_FILES} ${SOURCE_FILES_DEPS} ${OUT_EBLIF}
      )
  endif()
endfunction()

function(add_check_test)
  # ~~~
  # ADD_CHECK_TEST(
  #    NAME <name>
  #    ARCH <arch>
  #    READ_GOLD <yosys script>
  #    READ_GATE <yosys script>
  #    EQUIV_CHECK_SCRIPT <yosys to script verify two bitstreams gold and gate>
  #    DEPENDS <files and targets>
  #   )
  # ~~~
  #
  # ADD_CHECK_TEST defines a cmake test to compare analytically two modules.
  # READ_GOLD should be a yosys script that puts the truth module in a module
  # named gold. READ_GATE should be a yosys script that puts the gate module
  # in a module named gate.
  #
  # DEPENDS should the be complete list of dependencies to add to the check
  # target.
  set(options)
  set(oneValueArgs NAME ARCH READ_GOLD READ_GATE EQUIV_CHECK_SCRIPT)
  set(multiValueArgs DEPENDS)
  cmake_parse_arguments(
    ADD_CHECK_TEST
    "${options}"
    "${oneValueArgs}"
    "${multiValueArgs}"
    ${ARGN}
  )

  get_target_property_required(YOSYS env YOSYS)
  get_target_property_required(CELLS_SIM ${ADD_CHECK_TEST_ARCH} CELLS_SIM)
  set(EQUIV_CHECK_SCRIPT ${ADD_CHECK_TEST_EQUIV_CHECK_SCRIPT})
  if("${EQUIV_CHECK_SCRIPT}" STREQUAL "")
    message(FATAL_ERROR "EQUIV_CHECK_SCRIPT is not optional to add_check_test.")
  endif()

  get_file_location(EQUIV_CHECK_SCRIPT_LOCATION ${EQUIV_CHECK_SCRIPT})
  get_file_target(EQUIV_CHECK_SCRIPT_TARGET ${EQUIV_CHECK_SCRIPT})

  set(PATH_TO_CELLS_SIM ${symbiflow-arch-defs_SOURCE_DIR}/env/conda/share/yosys/${CELLS_SIM})
  # CTest doesn't support build target dependencies, so we have to manually
  # make them.
  #
  # See https://stackoverflow.com/questions/733475/cmake-ctest-make-test-doesnt-build-tests
  add_custom_target(_target_${ADD_CHECK_TEST_NAME}_build_depends
    DEPENDS ${ADD_CHECK_TEST_DEPENDS} ${PATH_TO_CELLS_SIM} ${EQUIV_CHECK_SCRIPT_TARGET} ${EQUIV_CHECK_SCRIPT_LOCATION})
  add_test(
    NAME _test_${ADD_CHECK_TEST_NAME}_build
    COMMAND "${CMAKE_COMMAND}" --build ${CMAKE_BINARY_DIR} --target _target_${ADD_CHECK_TEST_NAME}_build_depends --config $<CONFIG>
    )
  # Make sure only one build is running at a time, ninja (and probably make)
  # output doesn't support multiple calls into it from seperate processes.
  set_tests_properties(
    _test_${ADD_CHECK_TEST_NAME}_build PROPERTIES RESOURCE_LOCK cmake
    )
  add_test(
    NAME ${ADD_CHECK_TEST_NAME}
    COMMAND ${YOSYS} -p "${ADD_CHECK_TEST_READ_GOLD} $<SEMICOLON> ${ADD_CHECK_TEST_READ_GATE} $<SEMICOLON> script ${EQUIV_CHECK_SCRIPT_LOCATION}" ${PATH_TO_CELLS_SIM}
    )
  set_tests_properties(
    ${ADD_CHECK_TEST_NAME} PROPERTIES DEPENDS _test_${ADD_CHECK_TEST_NAME}_build
    )

  # Also provide a make target that runs the analysis.
  add_custom_target(
    ${ADD_CHECK_TEST_NAME}
    COMMAND ${YOSYS} -p "${ADD_CHECK_TEST_READ_GOLD} $<SEMICOLON> ${ADD_CHECK_TEST_READ_GATE} $<SEMICOLON> script ${EQUIV_CHECK_SCRIPT_LOCATION}" ${PATH_TO_CELLS_SIM}
    DEPENDS ${ADD_CHECK_TEST_DEPENDS} ${PATH_TO_CELLS_SIM} ${EQUIV_CHECK_SCRIPT_TARGET} ${EQUIV_CHECK_SCRIPT_LOCATION}
    VERBATIM
    )

  # Add this check list to the catch all target "all_check_tests".
  add_dependencies(all_check_tests ${ADD_CHECK_TEST_NAME})
endfunction()

function(add_testbench)
  # ~~~
  #   ADD_TESTBENCH(
  #     NAME <name of testbench>
  #     ARCH <arch>
  #     SOURCES <source list>
  #   )
  # ~~~
  #
  # ADD_TESTBENCH emits two custom targets, ${NAME} and ${NAME}_view.  ${NAME}
  # builds and executes a testbench with iverilog.
  #
  # ${NAME}_view launches GTKWAVE on the output wave file. For wave viewing, it
  # is assumed that all testbenches will output some variable dump and dump
  # to a file defined by VCDFILE.  If this is not true, the ${NAME}_view target
  # will not work.

  set(options)
  set(oneValueArgs NAME ARCH)
  set(multiValueArgs SOURCES)
  cmake_parse_arguments(
    ADD_TESTBENCH
    "${options}"
    "${oneValueArgs}"
    "${multiValueArgs}"
    ${ARGN}
  )

  get_target_property_required(IVERILOG env IVERILOG)
  get_target_property_required(VVP env VVP)
  set(SOURCE_LOCATIONS "")
  set(FILE_DEPENDS "")
  foreach(SRC ${ADD_TESTBENCH_SOURCES})
    append_file_location(SOURCE_LOCATIONS ${SRC})
    append_file_dependency(FILE_DEPENDS ${SRC})
  endforeach()

  get_target_property_required(CELLS_SIM ${ADD_TESTBENCH_ARCH} CELLS_SIM)

  set(NAME ${ADD_TESTBENCH_NAME})

  add_custom_command(
    OUTPUT ${NAME}.vpp
    COMMAND
      ${IVERILOG} -v -DVCDFILE=\"${NAME}.vcd\"
      -DCLK_MHZ=0.001 -o ${CMAKE_CURRENT_BINARY_DIR}/${NAME}.vpp
      ${SOURCE_LOCATIONS}
      ${symbiflow-arch-defs_SOURCE_DIR}/env/conda/share/yosys/${CELLS_SIM}
    DEPENDS ${IVERILOG} ${FILE_DEPENDS}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    VERBATIM
    )

  # This target always just executes the testbench.  If the user wants to view
  # waves generated from this executation, they should just build ${NAME}_view
  # not ${NAME}.
  add_custom_target(
    ${NAME}
    COMMAND ${VVP} -v -N ${NAME}.vpp
    DEPENDS ${VVP} ${NAME}.vpp
    )

  get_target_property_required(GTKWAVE env GTKWAVE)
  add_custom_command(
    OUTPUT ${NAME}.vcd
    COMMAND ${VVP} -v -N ${NAME}.vpp
    DEPENDS ${VVP} ${NAME}.vpp
    )
  add_custom_target(
    ${NAME}_view
    DEPENDS ${NAME}.vcd
    COMMAND ${GTKWAVE} ${NAME}.vcd
    )
endfunction()

function(generate_pinmap)
  # ~~~
  #   GENERATE_PINMAP(
  #     NAME <name of file to output pinmap file>
  #     TOP <module name to generate pinmap for>
  #     BOARD <board to generate pinmap for>
  #     SOURCES <list of sources to load>
  #   )
  # ~~~
  #
  # Generate pinmap blindly assigns each input and output from the module
  # ${TOP} to valid pins for the specified board. In its current version,
  # GENERATE_PINMAP may assign IO to global wire.
  #
  # TODO: Consider adding knowledge of global wires and be able to assign
  # specific wires to global wires (e.g. clock or reset lines).
  #
  # SOURCES must contain a module that matches ${TOP}.
  set(options)
  set(oneValueArgs NAME TOP BOARD)
  set(multiValueArgs SOURCES)

  cmake_parse_arguments(
    GENERATE_PINMAP
    "${options}"
    "${oneValueArgs}"
    "${multiValueArgs}"
    ${ARGN}
  )

  get_target_property_required(YOSYS env YOSYS)
  get_target_property_required(PYTHON3 env PYTHON3)

  set(BOARD ${GENERATE_PINMAP_BOARD})
  get_target_property_required(DEVICE ${BOARD} DEVICE)
  get_target_property_required(PACKAGE ${BOARD} PACKAGE)
  get_target_property_required(PINMAP_FILE ${DEVICE} ${PACKAGE}_PINMAP)
  get_file_location(PINMAP ${PINMAP_FILE})
  get_file_target(PINMAP_TARGET ${PINMAP_FILE})

  set(CREATE_PINMAP ${symbiflow-arch-defs_SOURCE_DIR}/utils/create_pinmap.py)

  set(SOURCE_FILES "")
  set(SOURCE_FILES_DEPS "")
  foreach(SRC ${GENERATE_PINMAP_SOURCES})
    get_file_location(SRC_LOCATION ${SRC})
    get_file_target(SRC_TARGET ${SRC})
    list(APPEND SOURCE_FILES ${SRC_LOCATION})
    list(APPEND SOURCE_FILES_DEPS ${SRC_TARGET})
  endforeach()

  add_custom_command(
    OUTPUT ${GENERATE_PINMAP_NAME}.json
    COMMAND ${YOSYS} -p "write_json ${CMAKE_CURRENT_BINARY_DIR}/${GENERATE_PINMAP_NAME}.json" ${SOURCE_FILES}
    DEPENDS ${YOSYS} ${SOURCE_FILES} ${SOURCE_FILES_DEPS}
    )

  add_custom_command(
    OUTPUT ${GENERATE_PINMAP_NAME}
    COMMAND ${PYTHON3} ${CREATE_PINMAP}
      --design_json ${CMAKE_CURRENT_BINARY_DIR}/${GENERATE_PINMAP_NAME}.json
      --pinmap_csv ${PINMAP}
      --module ${GENERATE_PINMAP_TOP} > ${CMAKE_CURRENT_BINARY_DIR}/${GENERATE_PINMAP_NAME}
    DEPENDS ${GENERATE_PINMAP_NAME}.json ${CREATE_PINMAP} ${PINMAP} ${PINMAP_TARGET}
    )

  add_file_target(FILE ${GENERATE_PINMAP_NAME} GENERATED)
endfunction()