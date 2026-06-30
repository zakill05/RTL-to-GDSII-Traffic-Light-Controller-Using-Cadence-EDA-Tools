####################################
####################################
###                              ###
###   Student: LY VINH KHANG	 ###
###   HCMUTE			 ###
###				 ###
####################################
####################################
###############################################################
###################### IMPORT DESIGN ##########################
###############################################################

# MMMC
set init_mmmc_file /home/buet/Documents/NEW_TRAFFIC_LIGHT/mmmc.tcl
# Top module
set init_top_cell top_module
# Netlist
set init_verilog /home/buet/Documents/NEW_TRAFFIC_LIGHT/Synthesis/top_module_slow.v
# LEF
set init_lef_file {/home/buet/cadence/EDI/share/FoundationFlows/EXAMPLES/PROTO/LIBS/GPDK/LIBS/GPDK045/gsclib045.lef}
# Power/Ground
set init_pwr_net VDD
set init_gnd_net VSS
# Import design
init_design

###############################################################
###################### ANALYSIS MODE ##########################
###############################################################
setAnalysisMode \
    -analysisType onChipVariation \
    -cppr both
checkDesign -all
###############################################################
###################### FLOORPLAN ##############################
###############################################################
# Check site name
dbGet top.fPlan.coreSite.name
# Floorplan
floorPlan -site CoreSite -r 1.0 0.7 10 10 10 10
#------------------------------------------------
#| Tham số              | Ý nghĩa                      |
#| ------------- | ---------------------------- |
#| `CoreSite`    | site của standard cell       |
#| `1.0`         | aspect ratio                 |
#| `0.7`         | utilization = 70%            |
#| `10 10 10 10` | margin left right top bottom |
#Check site name: thường coresite vì thư viện 45nm

###############################################################
###################### POWER PLAN #############################
###############################################################

# Check routing layer names
dbGet [dbGet head.layers.type routing -p].name

###############################################################
# GLOBAL NET CONNECT
###############################################################

globalNetConnect VDD -type pgpin -pin VDD -all
globalNetConnect VSS -type pgpin -pin VSS -all
globalNetConnect VDD -type tiehi -all
globalNetConnect VSS -type tielo -all

###############################################################
# ADD POWER RING
###############################################################

addRing -nets {VDD VSS} \
    	-type core_rings \
   	-layer {top Metal5 bottom Metal5 left Metal6 right Metal6} \
    	-width 3 \
    	-spacing 2\
    	-offset 0.5

###############################################################
# ADD STRIPES
###############################################################

addStripe \
    -nets {VDD VSS} \
    -layer Metal6 \

    -direction vertical \
    -width 2 \
    -spacing 2 \
    -set_to_set_distance 30 \
    -start_from left \
    -start_x 20

###############################################################
# SPECIAL ROUTE POWER
###############################################################

sroute \
    -connect {corePin} \
    -layerChangeRange {Metal1 Metal6} \
    -nets {VDD VSS} \
    -allowJogging true \
    -allowLayerChange true

###############################################################
###################### CHECK POWER ############################
###############################################################

verifyConnectivity -type special -nets {VDD VSS}

verifyGeometry -report ./reports/preplace_drc.rpt

###############################################################
###################### PLACEMENT ##############################
###############################################################

setPlaceMode \
    -timingDriven true \
    -congEffort auto
placeDesign
setDrawView place

###############################################################
# CHECK PLACEMENT
###############################################################

checkPlace

###############################################################
# TIMING REPORT PRE-CTS (truoc khi CTS)
###############################################################

timeDesign \
    -preCTS \
    -outDir ./reports/preCTS \
    -prefix preCTS

###############################################################
# OPTIMIZE PRE-CTS (opt placement)
###############################################################
optDesign \
    -preCTS \
    -outDir ./reports/optPreCTS \
    -prefix optPreCTS
###############################################################
# TIMING AFTER OPT PRE-CTS
###############################################################
timeDesign \
    -preCTS \
    -outDir ./reports/preCTS_opt \
    -prefix preCTS_opt
###############################################################
# UTILIZATION REPORT
###############################################################

redirect ./reports/preCTS/utilization.rpt {
    reportDensity
}

###############################################################
# SUMMARY REPORT
###############################################################

summaryReport \
    -outfile ./reports/preCTS/summary.rpt

###############################################################
###################### CTS ####################################
##############################################################
clockDesign -specFile ./cts.spec \
            -outDir ./CTS \
            -fixedInstBeforeCTS

###############################################################
# CHECK DESIGN AFTER CTS
###############################################################

checkDesign -all

###############################################################
# POST CTS TIMING
###############################################################
timeDesign \
    -postCTS \
    -outDir ./reports/postCTS \
    -prefix postCTS

###############################################################
# OPTIMIZE POST CTS
###############################################################

optDesign \
    -postCTS \
    -outDir ./reports/optPostCTS \
    -prefix optPostCTS

###############################################################
# TIMING AFTER POST CTS OPT
###############################################################

timeDesign \
    -postCTS \
    -outDir ./reports/postCTS_opt \
    -prefix postCTS_opt

###############################################################
# DETAILED TIMING REPORT
###############################################################

redirect ./reports/postCTS_opt/timing_detail.rpt {
    report_timing \
        -path_type full \
        -max_paths 10
}

###############################################################
###################### ROUTING ###############################
###############################################################

###############################################################
# NANOROUTE SETTINGS
###############################################################

setNanoRouteMode -routeWithTimingDriven true
setNanoRouteMode -routeWithSiDriven true
setNanoRouteMode -drouteFixAntenna true
setNanoRouteMode -routeInsertAntennaDiode true

###############################################################
# ROUTE DESIGN
###############################################################

routeDesign

###############################################################
# ECO ROUTE
###############################################################

ecoRoute

###############################################################
###################### FILLER CELLS ###########################
###############################################################

# Check filler cells
dbGet [dbGet head.libCells.subClass coreSpacer -p].name

# Example filler cells
set fillerCells {FILL1 FILL2 FILL4 FILL8 FILL16 FILL32 FILL64}

set BASENAME top_module

setFillerMode \
    -corePrefix ${BASENAME}_FILL \
    -core $fillerCells

addFiller \
    -cell $fillerCells \
    -prefix ${BASENAME}_FILL \
    -markFixed

###############################################################
###################### VERIFY #################################
###############################################################

verifyConnectivity -type all

verifyProcessAntenna

verifyGeometry \
    -report ./reports/postRoute_drc.rpt

###############################################################
###################### POST ROUTE TIMING ######################
###############################################################

timeDesign \
    -postRoute \
    -outDir ./reports/postRoute \
    -prefix postRoute

###############################################################
# OPTIMIZE POST ROUTE
###############################################################

optDesign \
    -postRoute \
    -outDir ./reports/optPostRoute \
    -prefix optPostRoute

###############################################################
# FINAL DRC CHECK
###############################################################
`
verifyGeometry \
    -report ./reports/final_drc.rpt

###############################################################
# FINAL CONNECTIVITY CHECK
###############################################################
verifyConnectivity -type all
###############################################################
# FINAL TIMING
###############################################################
timeDesign \
    -postRoute \
    -outDir ./reports/postRoute_opt \
    -prefix postRoute_opt
###############################################################
# FINAL DETAILED TIMING REPORT
###############################################################
redirect ./reports/postRoute_opt/timing_detail.rpt {
    report_timing \
        -path_type full \
        -max_paths 10
}
###################### SAVE DESIGN ############################
saveDesign ./final_encounter.enc

###############################################################
###################### STREAM OUT GDS #########################
###############################################################

streamOut ./top_module.gds \
    -mapFile ./streamOut.map \
    -libName top_module \
    -units 1000 \
    -mode ALL

###############################################################
###################### FINAL CHECK ############################
###############################################################

verifyGeometry \
    -report ./reports/final_stream_drc.rpt

puts "========== FLOW COMPLETED =========="
######################## REPORT CHECK #########################

cat ./reports/final_stream_drc.rpt

KIỂM TRA DRC  # Kiểm tra DRC routing
verify_drc

# Xuất report
verify_drc -report output/drc.rpt

# Kiểm tra connectivity (LVS nhẹ)
verify_connectivity -report output/connectivity.rpt

