set(MMCM_GENERATE_SCRIPT "gen_random_cases.py")
set(MMCM_DESIGN_COUNT 10)
set(MMCM_DESIGN_NAME "mmcm_random_case")
set(MMCM_DESIGN_TEMPLATE "mmcm_random_case.tpl")

add_custom_target(all_xc7_mmcm_vivado_diff_fasm)

# Generate designs
set(VERILOG_FILES )
math(EXPR MMCM_DESIGN_MAX "${MMCM_DESIGN_COUNT}-1")
foreach(N RANGE ${MMCM_DESIGN_MAX})
  set(VERILOG_FILE ${MMCM_DESIGN_NAME}${N}.v)
  add_file_target(FILE ${VERILOG_FILE} GENERATED)
  list(APPEND VERILOG_FILES ${VERILOG_FILE})
endforeach()

add_custom_command(
  OUTPUT ${VERILOG_FILES}
  COMMAND ${PYTHON3} ${CMAKE_CURRENT_SOURCE_DIR}/${MMCM_GENERATE_SCRIPT}
    --template ${CMAKE_CURRENT_SOURCE_DIR}/${MMCM_DESIGN_TEMPLATE}
    --output ${MMCM_DESIGN_NAME}{:d}.v
    --count ${MMCM_DESIGN_COUNT}
  DEPENDS ${PYTHON3} ${PYTHON3_TARGET} ${MMCM_GENERATE_SCRIPT} ${MMCM_DESIGN_TEMPLATE}
)

# Add FPGA targets
foreach(VERILOG_FILE ${VERILOG_FILES})

  string(REPLACE ".v" "" DESIGN ${VERILOG_FILE})

  add_fpga_target(
    NAME ${DESIGN}
    BOARD basys3-bottom
    SOURCES ${VERILOG_FILE}
    INPUT_IO_FILE ${COMMON}/basys3_bottom.pcf
    EXPLICIT_ADD_FILE_TARGET
    )

  add_vivado_target(
    NAME ${DESIGN}_vivado
    PARENT_NAME ${DESIGN}
    CLOCK_PINS clk
    CLOCK_PERIODS 10.0
    )

  if(TARGET ${DESIGN}_vivado_diff_fasm)
      add_dependencies(all_xc7_mmcm_vivado_diff_fasm ${DESIGN}_vivado_diff_fasm)
  endif()

  add_dependencies(all_xc7_tests ${DESIGN}_bit)

endforeach()

# =============================================================================

add_file_target(FILE mmcm_packing.v SCANNER_TYPE verilog)

add_file_target(FILE mmcme2_test.v SCANNER_TYPE verilog)
add_file_target(FILE mmcm_int_basys3_bottom.v SCANNER_TYPE verilog)
add_file_target(FILE mmcm_none_basys3_bottom.v SCANNER_TYPE verilog)
add_file_target(FILE mmcm_buf_basys3_bottom.v SCANNER_TYPE verilog)
add_file_target(FILE mmcm_ext_basys3_bottom.v SCANNER_TYPE verilog)
add_file_target(FILE mmcm_int_frac_basys3_bottom.v SCANNER_TYPE verilog)

add_fpga_target(
  NAME mmcm_packing
  BOARD basys3-bottom
  SOURCES mmcm_packing.v
  INPUT_IO_FILE ${COMMON}/basys3_bottom_pmod.pcf
  EXPLICIT_ADD_FILE_TARGET
  )

add_fpga_target(
  NAME mmcm_int_basys3
  BOARD basys3-bottom
  SOURCES mmcm_int_basys3_bottom.v
  INPUT_IO_FILE ${COMMON}/basys3_bottom_pmod.pcf
  EXPLICIT_ADD_FILE_TARGET
  )

add_fpga_target(
  NAME mmcm_none_basys3
  BOARD basys3-bottom
  SOURCES mmcm_none_basys3_bottom.v
  INPUT_IO_FILE ${COMMON}/basys3_bottom_pmod.pcf
  EXPLICIT_ADD_FILE_TARGET
  )

add_fpga_target(
  NAME mmcm_buf_basys3
  BOARD basys3-bottom
  SOURCES mmcm_buf_basys3_bottom.v
  INPUT_IO_FILE ${COMMON}/basys3_bottom_pmod.pcf
  EXPLICIT_ADD_FILE_TARGET
  )

add_fpga_target(
  NAME mmcm_ext_basys3
  BOARD basys3-bottom
  SOURCES mmcm_ext_basys3_bottom.v
  INPUT_IO_FILE ${COMMON}/basys3_bottom_pmod.pcf
  EXPLICIT_ADD_FILE_TARGET
  )

add_fpga_target(
  NAME mmcm_int_frac_basys3
  BOARD basys3-bottom
  SOURCES mmcm_int_frac_basys3_bottom.v
  INPUT_IO_FILE ${COMMON}/basys3_bottom_pmod.pcf
  EXPLICIT_ADD_FILE_TARGET
  )


add_vivado_target(
  NAME mmcm_packing_vivado
  PARENT_NAME mmcm_packing
  CLOCK_PINS clk
  CLOCK_PERIODS 10.0
  )

add_vivado_target(
  NAME mmcm_int_basys3_vivado
  PARENT_NAME mmcm_int_basys3
  CLOCK_PINS clk
  CLOCK_PERIODS 10.0
  )

add_vivado_target(
  NAME mmcm_none_basys3_vivado
  PARENT_NAME mmcm_none_basys3
  CLOCK_PINS clk
  CLOCK_PERIODS 10.0
  )

add_vivado_target(
  NAME mmcm_buf_basys3_vivado
  PARENT_NAME mmcm_buf_basys3
  CLOCK_PINS clk
  CLOCK_PERIODS 10.0
  # Diff test disabled due to https://github.com/SymbiFlow/symbiflow-arch-defs/issues/1862
  DISABLE_DIFF_TEST
  )

add_vivado_target(
  NAME mmcm_ext_basys3_vivado
  PARENT_NAME mmcm_ext_basys3
  CLOCK_PINS clk
  CLOCK_PERIODS 10.0
  # Diff test disabled due to https://github.com/SymbiFlow/symbiflow-arch-defs/issues/1925
  DISABLE_DIFF_TEST
  )

add_vivado_target(
  NAME mmcm_int_frac_basys3_vivado
  PARENT_NAME mmcm_int_frac_basys3
  CLOCK_PINS clk
  CLOCK_PERIODS 10.0
  )

# =============================================================================

set(TEST_TARGETS
  mmcm_packing
  mmcm_int_basys3
  mmcm_none_basys3
  mmcm_int_frac_basys3
  mmcm_buf_basys3
  mmcm_ext_basys3
)

foreach(TEST_TARGET ${TEST_TARGETS})
  if(TARGET ${TEST_TARGET}_vivado_diff_fasm)
    add_dependencies(all_xc7_mmcm_vivado_diff_fasm ${TEST_TARGET}_vivado_diff_fasm)
  endif()
  add_dependencies(all_xc7_tests ${TEST_TARGET}_bit)
endforeach()
