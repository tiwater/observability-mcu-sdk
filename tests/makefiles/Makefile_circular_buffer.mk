SRC_FILES = \
  $(Tcs_COMPONENTS_DIR)/util/src/ticos_circular_buffer.c

TEST_SRC_FILES = \
  $(Tcs_TEST_SRC_DIR)/test_ticos_circular_buffer.c

include $(CPPUTEST_MAKFILE_INFRA)
