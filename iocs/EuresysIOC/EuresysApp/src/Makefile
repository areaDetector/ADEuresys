TOP=../..
include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE

PROD_NAME = EuresysApp
PROD_IOC_WIN32 += $(PROD_NAME)
PROD_IOC_Linux += $(PROD_NAME)

# <name>.dbd will be created from <name>Include.dbd
DBD += $(PROD_NAME).dbd
$(PROD_NAME)_DBD += ADEuresysSupport.dbd

# <name>_registerRecordDeviceDriver.cpp will be created from <name>.dbd
$(PROD_NAME)_SRCS += $(PROD_NAME)_registerRecordDeviceDriver.cpp $(PROD_NAME)Main.cpp

# Add locally compiled object code
PROD_LIBS += ADEuresys
PROD_LIBS += ADGenICam

include $(ADCORE)/ADApp/commonDriverMakefile

#=============================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

