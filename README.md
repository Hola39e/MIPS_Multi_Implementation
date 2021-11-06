# MIPS_Multi_Implementation

 ![](https://img.shields.io/github/license/Hola39e/MIPS_Multi_Implementation)

English|[简体中文](./README_CN.md)

This repository contains implementations of **single-cycle/multi-cycle/five-stage pipeline** architectures of simple instructions for 32-bit MIPS processors based on Verilog.

This repository contains:

1. Verilog code implementation of a single-cycle MIPS processor.
2. Verilog code implementation of a multi-cycle MIPS processor.
3. Verilog code implementation of the MIPS processor in the form of a five-stage pipeline.
4. Testbench files for running the above MIPS processors benchmark.


## Table of Contents

- [Background](#background)
- [Install](#install)
- [Run testbench of processor benchmark](#run-testbench-of-processor-benchmark)
	- [Simulation benchmarking of the single-cycle MIPS processor](#simulation-benchmarking-of-the-single-cycle-mips-processor)
	- [Simulation benchmarking of the multi-cycle MIPS processor](#simulation-benchmarking-of-the-multi-cycle-mips-processor)
	- [Simulation benchmarking of the five-stage pipeline MIPS processor](#simulation-benchmarking-of-the-five-stage-pipeline-mips-processor)
	- [Results of simulation benchmark](#results-of-simulation-benchmark)
- [Maintainers](#maintainers)
- [License](#license)

## Background

The module design of the MIPS processor includes a multi-cycle state machine, a five-level pipeline with a conflict detection unit, data bypass, and a blocking unit designed largely with reference to the following books. You could think of this project as a simple implementation of the microarchitecture and pipeline chapters in the following books.

> Patterson, David A., and John L. Hennessy. *Computer organization and design MIPS edition: the hardware software interface*. Morgan Kaufmann, 2016.
>
> Harris, David, and Sarah Harris. *Digital design and computer architecture*. Morgan Kaufmann, 2010.

## Install

```sh
$ git clone https://github.com/Hola39e/MIPS_Multi_Implementation
$ cd ./MIPS_Multi_Implementation
```
## Run testbench of processor benchmark

The benchmark of the MIPS processor comes from Harris, David, and Sarah Harris. *Digital design and computer architecture*. Morgan Kaufmann, 2010.

The MIPS processor runs the corresponding instructions by reading 18 machine codes in`memfile.dat`. Benchmark tests are performed on the `lw,sw,add,addi,sub,or,and,slt,jump,beq` instructions, the final result will write `0x000000071` at `mem[84]`, which can be seen at `MEM_Data.txt`.

Running testbench can use Modelsim, Vivado, iverilog and other simulation environment, here are the instructions for running `iverilog` simulation environment, and observe the simulation waveform through `gtkwave`.

### Simulation benchmarking of the single-cycle MIPS processor
```sh
$ cd ./MIPS_Single_Cycle
$ iverilog -o MIPS_wave -y ./ tb_MIPS_Single_Cycle.v
$ vvp -n MIPS_wave --lxt2
$ gtkwave MIPS_wave.vcd
```
### Simulation benchmarking of the multi-cycle MIPS processor
```sh
$ cd ./MIPS_Multi_Cycle
$ iverilog -o MIPS_wave -y ./ tb_MIPS_Multi_Cycle.v
$ vvp -n MIPS_wave --lxt2
$ gtkwave MIPS_wave.vcd
```
### Simulation benchmarking of the five-stage pipeline MIPS processor
```sh
$ cd ./MIPS_Pipeline
$ iverilog -o MIPS_wave -y ./ tb_MIPS_Pipeline.v
$ vvp -n MIPS_wave --lxt2
$ gtkwave MIPS_wave.vcd
```

### Results of simulation benchmark

When the benchmark successfully running, the result will show in`MEM_data.txt`, which indicates the benchmark test passed.

```txt
The Write Address A is 00000050
DATA_MEM[A] is 00000007
The Write Address A is 00000054
DATA_MEM[A] is 00000007
```

## Maintainers

[@Hola39e](https://github.com/Hola39e).

## License

[MIT](LICENSE) © Hola39e
