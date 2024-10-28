#!/bin/bash

cd ./build
echo "The files can be found in build dir"
echo "This will take some time..."
echo "Next pc is not stuck, it will finish eventually"

echo "Build pc"
iverilog -o pc_TB ../pc/pc.v ../pc/pc_TB.v -I../

echo "Run pc"
./pc_TB > pc.log

echo "Build ula"
iverilog -o ula_TB ../ula/ula.v ../ula/ula_TB.v -I../

echo "Run ula"
./ula_TB > ula.log

echo "Build ula add"
iverilog -o ula_add_TB ../ula/ula.v ../ula/combinatorial_testbenchs/ula_add_TB.v -I../

echo "Run ula add"
./ula_add_TB > ula_add.log

echo "Build ula and"
iverilog -o ula_and_TB ../ula/ula.v ../ula/combinatorial_testbenchs/ula_and_TB.v -I../

echo "Run ula and"
./ula_and_TB > ula_and.log

echo "Build ula left_shift"
iverilog -o ula_left_shift_TB ../ula/ula.v ../ula/combinatorial_testbenchs/ula_left_shift_TB.v -I../

echo "Run ula left_shift"
./ula_left_shift_TB > ula_left_shift.log

echo "Build ula right_shift"
iverilog -o ula_right_shift_TB ../ula/ula.v ../ula/combinatorial_testbenchs/ula_right_shift_TB.v -I../

echo "Run ula rigth_shift"
./ula_right_shift_TB > ula_right_shift.log

echo "Build ula not"
iverilog -o ula_not_TB ../ula/ula.v ../ula/combinatorial_testbenchs/ula_not_TB.v -I../

echo "Run ula not"
./ula_not_TB > ula_not.log

echo "Build ula or"
iverilog -o ula_or_TB ../ula/ula.v ../ula/combinatorial_testbenchs/ula_or_TB.v -I../

echo "Run ula or"
./ula_or_TB > ula_or.log

echo "Build ula sub"
iverilog -o ula_sub_TB ../ula/ula.v ../ula/combinatorial_testbenchs/ula_sub_TB.v -I../

echo "Run ula sub"
./ula_sub_TB > ula_sub.log

echo "Build ula xor"
iverilog -o ula_xor_TB ../ula/ula.v ../ula/combinatorial_testbenchs/ula_xor_TB.v -I../

echo "Run ula xor"
./ula_xor_TB > ula_xor.log

echo "Build reg bank"
iverilog -o reg_bank_TB ../reg_bank/reg_bank.v ../reg_bank/reg_bank_TB.v -I../

echo "Run reg bank"
./reg_bank_TB > reg_bank.log

echo "Build data memory"
iverilog -o data_memory_TB ../data_memory/data_memory.v ../data_memory/data_memory_TB.v -I../

echo "Run data memory"
./data_memory_TB > data_memory.log

echo "Build sp"
iverilog -o sp_TB ../sp/sp.v ../sp/sp_TB.v -I../

echo "Run sp"
./sp_TB > sp.log

echo "Build control unit"
iverilog -o control_unit_TB ../control_unit/control_unit.v ../control_unit/control_unit_TB.v -I../

echo "Run control unit"
./control_unit_TB > control_unit.log

echo "Build next pc"
iverilog -o next_pc_TB ../next_pc/next_pc.v ../next_pc/next_pc_TB.v -I../

echo "Run next pc"
./next_pc_TB > next_pc.log

cp ../mem_programs/algoritmo-base.rom instruction_memory.rom

echo "Build redux v - base"
iverilog -o redux_v_base_TB ../redux_v/redux_v.v ../pc/pc.v ../ula/ula.v ../instruction_memory/instruction_memory.v ../reg_bank/reg_bank.v ../data_memory/data_memory.v ../sp/sp.v ../control_unit/control_unit.v ../next_pc/next_pc.v  ../redux_v/redux_v_TB.v -I../

echo "Run redux v - base"
./redux_v_base_TB > redux_v_base.log

mv redux_v_TB.vcd redux_v_base_TB.vcd

echo "Build instruction memory - base"
iverilog -o instruction_memory_base_TB ../instruction_memory/instruction_memory.v ../instruction_memory/instruction_memory_TB.v -I../

echo "Run instruction memory - base"
./instruction_memory_base_TB > instruction_memory_base.log

mv instruction_memory_TB.vcd instruction_memory_base_TB.vcd

cp ../mem_programs/single_instructions.rom instruction_memory.rom

echo "Build redux v - single instructions"
iverilog -o redux_v_single_instructions_TB ../redux_v/redux_v.v ../pc/pc.v ../ula/ula.v ../instruction_memory/instruction_memory.v ../reg_bank/reg_bank.v ../data_memory/data_memory.v ../sp/sp.v ../control_unit/control_unit.v ../next_pc/next_pc.v  ../redux_v/redux_v_TB.v -I../

echo "Run redux v - single instructions"
./redux_v_single_instructions_TB > redux_v_single_instructions.log

mv redux_v_TB.vcd redux_v_single_instructions_TB.vcd

echo "Build instruction memory - single instructions"
iverilog -o instruction_memory_single_instructions_TB ../instruction_memory/instruction_memory.v ../instruction_memory/instruction_memory_TB.v -I../

echo "Run instruction memory - single instructions"
./instruction_memory_single_instructions_TB > instruction_memory_single_instructions.log

mv instruction_memory_TB.vcd instruction_memory_single_instructions_TB.vcd

cp ../mem_programs/stack.rom instruction_memory.rom

echo "Build redux v - push_pop"
iverilog -o redux_v_push_pop_TB ../redux_v/redux_v.v ../pc/pc.v ../ula/ula.v ../instruction_memory/instruction_memory.v ../reg_bank/reg_bank.v ../data_memory/data_memory.v ../sp/sp.v ../control_unit/control_unit.v ../next_pc/next_pc.v  ../redux_v/redux_v_TB.v -I../

echo "Run redux v - push_pop"
./redux_v_push_pop_TB > redux_v_push_pop.log

mv redux_v_TB.vcd redux_v_push_pop_TB.vcd

echo "Build instruction memory push_pop"
iverilog -o instruction_memory_push_pop_TB ../instruction_memory/instruction_memory.v ../instruction_memory/instruction_memory_TB.v -I../

echo "Run instruction memory - push_pop"
./instruction_memory_push_pop_TB > instruction_memory_push_pop.log

mv instruction_memory_TB.vcd instruction_memory_push_pop_TB.vcd

rm -rf vcd 2>/dev/null
mkdir vcd
mv *.vcd vcd

rm -rf logs 2>/dev/null
mkdir logs
mv *.log logs

cd ..
