EMBEDDED_Tcs_SDK_ROOT ?=
STM32_CUBE_DIR ?=

EMBEDDED_Tcs_OBJ_DIR := $(BUILDDIR)/ticos

EMBEDDED_Tcs_PLATFORM_PORT_ROOT ?= $(EMBEDDED_Tcs_SDK_ROOT)/examples/stm32/stm32h743i

TICOS_COMPONENTS := core panics util
TICOS_SDK_ROOT := $(EMBEDDED_Tcs_SDK_ROOT)
include $(TICOS_SDK_ROOT)/makefiles/TicosWorker.mk

TICOS_PLATFORM_SRCS := $(wildcard $(EMBEDDED_Tcs_PLATFORM_PORT_ROOT)/platform_reference_impl/*.c)

STM32_CUBE_HAL_SRC = $(STM32_CUBE_DIR)/Drivers/STM32H7xx_HAL_Driver/Src
TICOS_COREDUMP_FLASH_DRIVER_SRC = \
  $(STM32_CUBE_HAL_SRC)/stm32h7xx_hal_flash_ex.c \
  $(STM32_CUBE_HAL_SRC)/stm32h7xx_hal_flash.c

EMBEDDED_Tcs_SDK_INCLUDES += \
  $(STM32_CUBE_DIR)/Drivers/STM32H7xx_HAL_Driver/Inc/ \
  $(STM32_CUBE_DIR)/Drivers/CMSIS/Device/ST/STM32H7xx/Include \
  $(STM32_CUBE_DIR)/Drivers/CMSIS/Include \
  $(EMBEDDED_Tcs_PLATFORM_PORT_ROOT)/platform_reference_impl \
  $(TICOS_COMPONENTS_INC_FOLDERS)
EMBEDDED_Tcs_SDK_INC   := $(patsubst %,-I%,$(EMBEDDED_Tcs_SDK_INCLUDES))

EMBEDDED_Tcs_SDK_SRCS := \
  $(TICOS_COMPONENTS_SRCS) \
  $(TICOS_PLATFORM_SRCS) \
  $(TICOS_COREDUMP_FLASH_DRIVER_SRC)

EMBEDDED_Tcs_SDK_OBJS = $(addprefix $(EMBEDDED_Tcs_OBJ_DIR)/, $(notdir $(EMBEDDED_Tcs_SDK_SRCS:.c=.o)))
