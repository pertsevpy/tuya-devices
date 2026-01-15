startDriver TuyaMCU
tuyaMcu_setBaudRate 9600
tuyaMcu_defWiFiState 4

// Main circuit breaker switch (dp16 - controls the relay directly)
setChannelType 1 toggle
setChannelLabel 1 "Switch"
linkTuyaMCUOutputToChannel 16 bool 1

// Voltage, Current, Power from Phase A (dp6 raw packet: 2B voltage *0.1V, 3B current *0.001A, 3B power *0.0001kW)
setChannelType 2 Voltage_div10
setChannelLabel 2 "Voltage"
setChannelType 3 Current_div1000
setChannelLabel 3 "Current"
setChannelType 4 Power_div100
setChannelLabel 4 "Power"
linkTuyaMCUOutputToChannel 6 RAW_V2C3P3 2

// Total consumed energy (dp1 - total_forward_energy)
setChannelType 5 EnergyTotal_kWh_div100
setChannelLabel 5 "Total Energy"
linkTuyaMCUOutputToChannel 1 val 5

// Prepaid energy balance (dp13 - balance_energy, read-only remaining)
setChannelType 6 EnergyTotal_kWh_div100
setChannelLabel 6 "Prepaid Energy"
linkTuyaMCUOutputToChannel 13 val 6

// Leakage current (dp15 - in mA, displayed as A)
setChannelType 7 Current_div1000
setChannelLabel 7 "Leakage Current"
linkTuyaMCUOutputToChannel 15 val 7

// Internal temperature (dp103 - temp_current)
setChannelType 8 Temperature
setChannelLabel 8 "Temperature"
linkTuyaMCUOutputToChannel 103 val 8

// Fault/alarm bitmap (dp9 - fault, shown as HEX number)
setChannelType 9 ReadOnly
setChannelLabel 9 "Fault Bitmap (HEX)"
linkTuyaMCUOutputToChannel 9 bitmap 9

// Prepayment mode (dp11 - switch_prepayment, enables prepaid logic; may auto-trip relay if balance <=0)
setChannelType 10 toggle
setChannelLabel 10 "Prepayment Mode"
linkTuyaMCUOutputToChannel 11 bool 10

// Clear remaining energy balance (dp12 - clear_energy bool; or energy_reset enum if device uses that, but treat as bool pulse)
setChannelType 11 toggle
setChannelLabel 11 "Clear Balance"
linkTuyaMCUOutputToChannel 12 bool 11

// Recharge energy (dp14 - charge_energy, add to balance; enter in kWh ×100)
setChannelType 12 TextField
setChannelLabel 12 "Top up Energy (kWh×100)"
linkTuyaMCUOutputToChannel 14 val 12

// Alarm settings 1 (dp17 - alarm_set_1 raw HEX)
setChannelType 20 RawBytes
setChannelLabel 20 "Alarm Set 1 (HEX)"
linkTuyaMCUOutputToChannel 17 raw 20

// Alarm settings 2 (dp18 - alarm_set_2 raw HEX)
setChannelType 21 RawBytes
setChannelLabel 21 "Alarm Set 2 (HEX)"
linkTuyaMCUOutputToChannel 18 raw 21

// Countdown timer (dp105 - countdown_1, seconds)
setChannelType 30 ReadWriteValue
setChannelLabel 30 "Countdown Timer (s)"
linkTuyaMCUOutputToChannel 105 val 30

// Cycle timer (dp106 - cycle_time string, format per device docs)
setChannelType 31 TextField
setChannelLabel 31 "Cycle timer"
linkTuyaMCUOutputToChannel 106 string 31

// Random timer (dp108? - random_time string; assuming dp108 from original JSON)
setChannelType 32 TextField
setChannelLabel 32 "Random Timer"
linkTuyaMCUOutputToChannel 108 string 32

// Immediate query state after startup to sync all values including relay
tuyaMcu_sendQueryState

backlog startDriver NTP; startDriver HassDiscovery