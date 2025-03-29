# Makefile
CWD=$(shell pwd)
# defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog

#Add your sources one by one as below or use *.v to add all verilog files
#VERILOG_SOURCES += $(PWD)/BC_I.v
#VERILOG_SOURCES += $(PWD)/ALU.v
VERILOG_SOURCES = $(CWD)/../hdl/BC_I/BC_I.v
VERILOG_SOURCES += $(CWD)/../hdl/BC_I/Datapath.v
VERILOG_SOURCES += $(CWD)/../hdl/BC_I/Controller.v
VERILOG_SOURCES += $(CWD)/../hdl/BC_I/comb_control_logic.v
VERILOG_SOURCES += $(CWD)/../hdl/BC_I/ALU.v
VERILOG_SOURCES += $(CWD)/../hdl/BC_I/decoder_3to8.v
VERILOG_SOURCES += $(CWD)/../hdl/BC_I/decoder_4to16.v
VERILOG_SOURCES += $(CWD)/../hdl/BC_I/generic_register.v
VERILOG_SOURCES += $(CWD)/../hdl/BC_I/MemoryUnit.v
VERILOG_SOURCES += $(CWD)/../hdl/BC_I/MUX_8_1.v
VERILOG_SOURCES += $(CWD)/../hdl/BC_I/sequence_counter.v

#$(info VERILOG_SOURCES=$(VERILOG_SOURCES))


# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
#Should be the name of the basic computer module for you
TOPLEVEL = BC_I

# MODULE is the basename of the Python test file
#Name of your python file
MODULE := cocotb_bc1_test
COCOTB_HDL_TIMEUNIT=1us
COCOTB_HDL_TIMEPRECISION=1us

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim