import cocotb
from cocotb.triggers import Timer, FallingEdge
from cocotb.clock import Clock

# Set to True for debugging logs
DEBUG = True

@cocotb.test()
async def test_memory_check(dut):
    """
    Test memory locations marked with // CHECK comments (in MemoryUnit.v file) for their expected values.
    """
    # Expected memory values (based on the // CHECK comments in the code)
    # Format: {address: expected_value}
    # We checked ALL OPERATIONS
    expected_memory = {
        0x003: 0x0001,  # CHECK: RESULT = 1
        0x016: 0x000A,  # CHECK: ROUTINE 1: RESULT(A+B) == 10
        0x029: 0x004A,  # CHECK: ROUTINE 2: RESULT(A & B) == 0x004A
        0x02D: 0x0001,  # CHECK: ROUTINE 2: RESULT(A & B) == 0x0001
        0x036: 0xEEEE,  # CHECK: ROUTINE 3: RESULT == EEEE
        0x03A: 0xFFFF,  # CHECK: ROUTINE 3: RESULT == FFFF
        0x058: 0x0000,  # CHECK: ROUTINE CLA: RESULT == 0x0000
        0x059: 0xFFFF,  # CHECK: ROUTINE CMA: RESULT == 0xFFFF
        0x05A: 0xCCCC,  # CHECK: ROUTINE SZE: RESULT == 0xCCCC
        0x05B: 0xCCCC,  # CHECK: ROUTINE SNA: RESULT == 0xCCCC
        0x05C: 0xCCCC,  # CHECK: ROUTINE SPA: RESULT == 0xCCCC
        0x05D: 0xCCCC,  # CHECK: ROUTINE SZA: RESULT == 0xCCCC
        0x05F: 0x0080,  # CHECK: ROUTINE CIL: RESULT == 0x0080
        0x06D: 0x0013,  # CHECK: ROUTINE ISZ: RESULT == 13
        0x08B: 0x8000,  # CHECK: ROUTINE CME: RESULT == 0x8000
        0x08C: 0xEEEE,  # CHECK: ROUTINE CLE: RESULT == 0xEEEE
        0x094: 0x0000   # CHECK: ROUTINE HLT: RESULT == 0x0000
    }

    # Start the clock
    clock = Clock(dut.clk, 100, "us")
    await cocotb.start(clock.start())
    current_Timing_signal = 0

    dut.FGI.value = 0

    S_STATUS = 0
    fetched_PC = 0
    interupt_test_1_set_done = False
    interupt_test_1_reset_done = False
    interupt_test_2_set_done = False
    interupt_test_2_reset_done = False

    cycles_spent_HALTED = 0

    # ONLY COMMENT OUT ONE OF THE WHILE LOOPS AND LEAVE THE OTHER COMMENTED
    
    # COMMENT OUT FOR OBSERVING HALT'S EFFECT
    while cycles_spent_HALTED < 10:  # When HLT opeartion is executed, wait for 20 more cycles to see that BC sops ALL operation

    # COMMENT OUT FOR ENDING TESTBENCH AFTER HALT
    #while S_STATUS == 0:  # When HLT opeartion is given, break from loop
        await FallingEdge(dut.clk)
        current_Timing_signal = dut.CONTROL_UNIT.SC.T.value.integer
        S_STATUS = dut.CONTROL_UNIT.S.value.integer

        if S_STATUS == 1:
            cycles_spent_HALTED += 1
            dut._log.info(
                f"PC={hex(dut.PC.value.integer)}, AR={hex(dut.AR.value.integer)}, IR={hex(dut.IR.value.integer)}, "
                f"AC={hex(dut.AC.value.integer)}, DR={hex(dut.DR.value.integer)}, T={dut.CONTROL_UNIT.SC.T.value.integer}"
            )


        if (dut.PC.value.integer == 0x024) and not interupt_test_1_set_done:
            dut._log.info("SET FGI=1")
            interupt_test_1_set_done = True
            dut.FGI.value = 1
        
        elif interupt_test_1_set_done and (dut.PC.value.integer == 0x004) and not interupt_test_1_reset_done:
            dut._log.info("SET FGI=0")
            interupt_test_1_reset_done = True
            dut.FGI.value = 0

        if (dut.PC.value.integer == 0x071) and not interupt_test_2_set_done:
            dut._log.info("SET FGI=1")
            interupt_test_2_set_done = True
            dut.FGI.value = 1
        
        elif interupt_test_2_set_done and (dut.PC.value.integer == 0x076) and not interupt_test_2_reset_done:
            dut._log.info("SET FGI=0")
            interupt_test_2_reset_done = True
            dut.FGI.value = 0
        
        if current_Timing_signal == 0 and cycles_spent_HALTED < 2:
            # Print out the register content after executing the previous instruction
            executed_PC = fetched_PC
            fetched_PC = hex(dut.PC.value.integer)

            dut._log.info(
                f"T{dut.CONTROL_UNIT.SC.T.value.integer}: AFTER Executing Instruction@M[{executed_PC}]: AR={hex(dut.AR.value.integer)}, IR={hex(dut.IR.value.integer)}, "
                f"AC={hex(dut.AC.value.integer)}, DR={hex(dut.DR.value.integer)}, PC={hex(dut.PC.value.integer)}"
            )
        
        # COMMENT OUT FOR OBSERVING OPERATION CYCLE BY CYCLE
        #dut._log.info(
        #    f"T{dut.CONTROL_UNIT.SC.T.value.integer}: PC={hex(dut.PC.value.integer)}, AR={hex(dut.AR.value.integer)}, IR={hex(dut.IR.value.integer)}, "
        #    f"AC={hex(dut.AC.value.integer)}, DR={hex(dut.DR.value.integer)}"
        #)

    # Validate memory content by checking with expected results
    for address, expected_value in expected_memory.items():
        actual_value = dut.DATAPATH_UNIT.M.memory[address].value.integer
        assert actual_value == expected_value, (
            f"Memory mismatch at address {hex(address)}: "
            f"Expected {hex(expected_value)}, got {hex(actual_value)}"
        )

    dut._log.info("All memory checks passed.\n ALL INSTRUCTIONS WORK PROPERLY!")