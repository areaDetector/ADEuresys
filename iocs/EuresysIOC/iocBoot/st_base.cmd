
# Prefix for all records
epicsEnvSet("PREFIX", "13ES1:")

# The port name for the detector
epicsEnvSet("PORT",   "ES1")
# Really large queue so we can stream to disk at full camera speed
epicsEnvSet("QSIZE",  "2000")   
# The maximum number of time series points in the NDPluginStats plugin
epicsEnvSet("NCHANS", "2048")
# The maximum number of frames buffered in the NDPluginCircularBuff plugin
epicsEnvSet("CBUFFS", "500")
# The search path for database files
# This is for Windows
epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(ADCORE)/db;$(ADGENICAM)/db;$(ADEURESYS)/db")
# This is for Linux
#epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(ADCORE)/db:$(ADGENICAM)/db:$(ADEURESYS)/db")
# Define NELEMENTS to be enough for a 1920x1080 (mono) image
epicsEnvSet("NELEMENTS", "2073600")

# ADEuresysConfig(const char *portName, const char *boardId, int numESBuffers,
#                 size_t maxMemory, int priority, int stackSize)
ADEuresysConfig("$(PORT)", $(BOARD_ID), 100)
asynSetTraceIOMask($(PORT), 0, ESCAPE)
# Set ASYN_TRACE_WARNING and ASYN_TRACE_ERROR
#asynSetTraceMask($(PORT), 0, ERROR|WARNING|FLOW|DRIVER)
#asynSetTraceFile($(PORT), 0, "asynTrace.out")

# Main database.  This just loads and modifies ADBase.template
dbLoadRecords("$(ADEURESYS)/db/Euresys.template", "P=$(PREFIX),R=cam1:,PORT=$(PORT)")

# Load the autogenerated files of GenICam features
dbLoadRecords("$(GENICAM_DB_FILE)",                                     "P=$(PREFIX),R=cam1:,PORT=$(PORT)")
dbLoadRecords("$(ADGENICAM)/db/Euresys_Coaxlink_TLDevice.template",     "P=$(PREFIX),R=cam1:,PORT=$(PORT)")
dbLoadRecords("$(ADGENICAM)/db/Euresys_Coaxlink_TLDataStream.template", "P=$(PREFIX),R=cam1:,PORT=$(PORT)")
dbLoadRecords("$(ADGENICAM)/db/Euresys_Coaxlink_TLInterface.template",  "P=$(PREFIX),R=cam1:,PORT=$(PORT)")
dbLoadRecords("$(ADGENICAM)/db/Euresys_Coaxlink_TLSystem.template",     "P=$(PREFIX),R=cam1:,PORT=$(PORT)")

# Create a standard arrays plugin
NDStdArraysConfigure("Image1", 5, 0, "$(PORT)", 0, 0)
# Use this line for 8-bit data only
dbLoadRecords("$(ADCORE)/db/NDStdArrays.template", "P=$(PREFIX),R=image1:,PORT=Image1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),TYPE=Int8,FTVL=CHAR,NELEMENTS=$(NELEMENTS)")
# Use this line for 8-bit or 16-bit data
#dbLoadRecords("$(ADCORE)/db/NDStdArrays.template", "P=$(PREFIX),R=image1:,PORT=Image1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),TYPE=Int16,FTVL=SHORT,NELEMENTS=$(NELEMENTS)")

# Load all other plugins using commonPlugins.cmd
< $(ADCORE)/iocBoot/commonPlugins.cmd
set_requestfile_path("$(ADGENICAM)/db")
set_requestfile_path("$(ADEURESYS)/db")

# Load a second HDF5 plugin for parallel file writing using NDPluginScatter
#NDFileHDF5Configure("FileHDF2", $(QSIZE), 0, "$(PORT)", 0)
#dbLoadRecords("NDFileHDF5.template",  "P=$(PREFIX),R=HDF2:,PORT=FileHDF2,ADDR=0,TIMEOUT=1,XMLSIZE=2048,NDARRAY_PORT=$(PORT)")

# Load a second JRaw plugin for parallel file writing using NDPluginScatter
#NDFileJRawConfigure("FileJRaw2", $(QSIZE), 0, "$(PORT)", 0)
#dbLoadRecords("NDFileJRaw.template","P=$(PREFIX),R=JRaw2:,PORT=FileJRaw2,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")

iocInit()

# save things every thirty seconds
create_monitor_set("auto_settings.req", 30,"P=$(PREFIX)")


