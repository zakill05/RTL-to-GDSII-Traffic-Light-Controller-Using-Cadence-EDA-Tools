# mmmc.tcl
# tạo file này trong /home/buet/Documents/test_no1/

# Library sets
create_library_set -name slow_set \
    -timing {
       /home/buet/cadence/EDI/share/FoundationFlows/EXAMPLES/PROTO/LIBS/GPDK/LIBS/GPDK045/timing/slow_vdd1v0_basiccells.lib
    }

create_library_set -name typical_set \
    -timing {
        /home/buet/cadence/EDI/share/FoundationFlows/EXAMPLES/PROTO/LIBS/GPDK/LIBS/GPDK045/timing/typical.lib
    }

# Constraint mode
create_constraint_mode -name func \
    -sdc_files {/home/buet/Documents/NEW_TRAFFIC_LIGHT/Synthesis/top_module_slow.sdc}

# Delay corners
create_delay_corner -name slow_corner \
    -library_set slow_set

create_delay_corner -name typical_corner \
    -library_set typical_set

# Analysis views
create_analysis_view -name slow_view \
    -constraint_mode func \
    -delay_corner slow_corner

create_analysis_view -name typical_view \
    -constraint_mode func \
    -delay_corner typical_corner

# Set active views
set_analysis_view \
    -setup {slow_view} \
    -hold  {typical_view}
