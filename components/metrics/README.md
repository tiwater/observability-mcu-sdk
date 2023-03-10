# metrics

This API can easily be used to monitor device health over time (i.e.
connectivity, battery life, MCU resource utilization, hardware degradation,
etc.) and configure Alerts with the Ticos backend when things go astray. To
get started, see this [document](https://ticos.io/2D8TRLX).

### Core features

- Allows users to create entries that can be uploaded to the Ticos cloud.
- Coredump info can include interrupt state, SDK info like Ticos log buffers,
  and reset reasons.

### Storage allocations

- `ticos_metrics_boot()`: connects the metrics into the event storage region,
  sets up the metrics timer, starts the timer, and adds an "unexpected reboot"
  counter metric.
