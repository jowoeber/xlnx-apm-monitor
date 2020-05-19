# Author: WO
# Liest DDR APM um die Anzahl der DDR RAM Transaktionen und übertragenen Bytes von CCI zu DDR Controller zu messen

set APM_DDR_BASE 0xFD0B0000
set CR_0 0x300
set MSR_0 0x44
set MSR_1 0x48

set SIR 0x24
set SICR 0x28
set MCR_0 0x00000100
set MCR_1 0x00000110
set MCR_2 0x00000120
set MCR_3 0x00000130
set MCR_4 0x00000140
set MCR_5 0x00000150
set MCR_6 0x00000160
set MCR_7 0x00000170


set APM_MSR_METRIC_Write_Transaction_Count	   0    
set APM_MSR_METRIC_Read_Transaction_Count	      1    
set APM_MSR_METRIC_Write_Byte_Count	            2
set APM_MSR_METRIC_Read_Byte_Count	            3      

set APM_SICR_LOAD                               2
set APM_SICR_ENABLE                             1
set APM_SICR_MET_CNT_RST                        256

# Set APM to monitor 
# Write Transaction Count on DDR Port 1
# Read Transaction Count on DDR Port 1
# Write Transaction Count on DDR Port 2
# Read Transaction Count on DDR Port 2
set MSR0_val 0
set MSR0_val [ expr [expr $MSR0_val << 8 ] | [expr [expr 1 << 5 ] | $APM_MSR_METRIC_Write_Transaction_Count ] ] 
set MSR0_val [ expr [expr $MSR0_val << 8 ] | [expr [expr 1 << 5 ] | $APM_MSR_METRIC_Read_Transaction_Count ] ] 
set MSR0_val [ expr [expr $MSR0_val << 8 ] | [expr [expr 2 << 5 ] | $APM_MSR_METRIC_Write_Transaction_Count ] ] 
set MSR0_val [ expr [expr $MSR0_val << 8 ] | [expr [expr 2 << 5 ] | $APM_MSR_METRIC_Read_Transaction_Count ] ] 

mwr [expr $APM_DDR_BASE + $MSR_0] $MSR0_val

# Set APM to monitor 
# Write Byte Count on DDR Port 1
# Read Byte Count on DDR Port 1
# Write Byte Count on DDR Port 2
# Read Byte Count on DDR Port 2
set MSR1_val 0
set MSR1_val [ expr [expr $MSR1_val << 8 ] | [expr [expr 1 << 5 ] | $APM_MSR_METRIC_Write_Byte_Count ] ] 
set MSR1_val [ expr [expr $MSR1_val << 8 ] | [expr [expr 1 << 5 ] | $APM_MSR_METRIC_Read_Byte_Count ] ] 
set MSR1_val [ expr [expr $MSR1_val << 8 ] | [expr [expr 2 << 5 ] | $APM_MSR_METRIC_Write_Byte_Count ] ] 
set MSR1_val [ expr [expr $MSR1_val << 8 ] | [expr [expr 2 << 5 ] | $APM_MSR_METRIC_Read_Byte_Count ] ] 
mwr [expr $APM_DDR_BASE + $MSR_1] $MSR1_val

# Reset & Enable APM
mwr [expr $APM_DDR_BASE + $CR_0] 3 
mwr [expr $APM_DDR_BASE + $CR_0] 1

while 1 {
  after 1000
  scan [lindex [split [mrd [expr $APM_DDR_BASE + $MCR_0]] " "] 3] %x MCR0
  scan [lindex [split [mrd [expr $APM_DDR_BASE + $MCR_1]] " "] 3] %x MCR1
  scan [lindex [split [mrd [expr $APM_DDR_BASE + $MCR_2]] " "] 3] %x MCR2
  scan [lindex [split [mrd [expr $APM_DDR_BASE + $MCR_3]] " "] 3] %x MCR3
  scan [lindex [split [mrd [expr $APM_DDR_BASE + $MCR_4]] " "] 3] %x MCR4
  scan [lindex [split [mrd [expr $APM_DDR_BASE + $MCR_5]] " "] 3] %x MCR5
  scan [lindex [split [mrd [expr $APM_DDR_BASE + $MCR_6]] " "] 3] %x MCR6
  scan [lindex [split [mrd [expr $APM_DDR_BASE + $MCR_7]] " "] 3] %x MCR7

  #set MCR0 
  #set MCR1 [lindex [split [mrd [expr $APM_DDR_BASE + $MCR_1]] " "] 3]
  #set MCR2 [lindex [split [mrd [expr $APM_DDR_BASE + $MCR_2]] " "] 3]
  #set MCR3 [lindex [split [mrd [expr $APM_DDR_BASE + $MCR_3]] " "] 3]
    
  puts "Total Write Transactions: [expr $MCR1 + $MCR3]"
  puts "Total Read Transactions: [expr $MCR0 + $MCR2]"
  puts "Total Written Bytes: [expr $MCR5 + $MCR7]"
  puts "Total Read Bytes: [expr $MCR4 + $MCR6]"
  puts "\n"

  # Reset APM
  mwr [expr $APM_DDR_BASE + $CR_0] 3 
  mwr [expr $APM_DDR_BASE + $CR_0] 1
}

