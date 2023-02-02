//! @file
//!
//! Copyright (c) Ticos, Inc.
//! See License.txt for details
//!
//! The DA145xx SDK executes the "reset_indication" callback to inform the
//! application of the reset reason. This captures the state so it can be
//! saved and published by Ticos

#include "ticos/ports/reboot_reason.h"

#include "ticos/core/platform/reboot_tracking.h"

#include "datasheet.h"

#if defined(__CC_ARM)
// To prevent this array from being initialized when using the ARM compiler it must
// be defined as follows. See https://developer.arm.com/documentation/ka003046/latest
// for further information.
static uint8_t s_reboot_tracking[TICOS_REBOOT_TRACKING_REGION_SIZE]
                 __attribute__((section("retention_mem_area0"), zero_init));
#else
static uint8_t s_reboot_tracking[TICOS_REBOOT_TRACKING_REGION_SIZE]
    __SECTION("retention_mem_area_uninit");
#endif

// Since "reset_indication" is called before ticos_platform_boot()
// is called we store the state in static variables for access later on in the boot
static eTicosRebootReason s_reset_reason;
static uint32_t s_reset_reason_reg;

#if defined (__DA14531__)
void reset_indication(uint16_t reset_status) {
  s_reset_reason_reg = reset_status;

  s_reset_reason = kTcsRebootReason_PowerOnReset;

  if (reset_status & HWRESET_STAT) {
    s_reset_reason =  kTcsRebootReason_PinReset;
  } else if (reset_status & SWRESET_STAT) {
    s_reset_reason =  kTcsRebootReason_SoftwareReset;
  } else if (reset_status & WDOGRESET_STAT) {
    s_reset_reason =  kTcsRebootReason_HardwareWatchdog;
  }
}
#else /* DA14585/6 */
void reset_indication(uint16_t por_time) {
  if (por_time) {
    s_reset_reason = kTcsRebootReason_PowerOnReset;
  } else {
    s_reset_reason = kTcsRebootReason_DeepSleep;
  }
  // Does not exist on DA14585/6 platform
  s_reset_reason_reg = 0;
}
#endif

void ticos_platform_reboot_tracking_boot(void) {
  sResetBootupInfo reset_info = { 0 };
  ticos_reboot_reason_get(&reset_info);
  ticos_reboot_tracking_boot(s_reboot_tracking, &reset_info);
}

void ticos_reboot_reason_get(sResetBootupInfo *info) {
  *info = (sResetBootupInfo) {
    .reset_reason_reg = s_reset_reason_reg,
    .reset_reason = s_reset_reason,
  };
}
