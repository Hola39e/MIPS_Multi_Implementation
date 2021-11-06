# MIPS微处理器的单周期/多周期/流水线的实现

 ![](https://img.shields.io/github/license/Hola39e/MIPS_Multi_Implementation)

[English](./README.md)|简体中文

本仓库是基于Verilog硬件描述语言对32位MIPS处理器简单指令的单周期、多周期、五级流水线架构的不同实现。

本仓库包含以下内容：

1. 单周期MIPS处理器的Verilog代码实现。
2. 多周期MIPS处理器的Verilog代码实现。
3. 采用五级流水线形式的MIPS处理器Verilog代码实现。
4. 运行以上MIPS处理器基准测试的仿真文件。

## 内容列表

- [背景](#背景)
- [安装](#安装)
- [运行仿真基准测试](#运行仿真基准测试)
	- [单周期MIPS处理器的仿真基准测试](#单周期MIPS处理器的仿真基准测试)
	- [多周期MIPS处理器的仿真基准测试](#多周期MIPS处理器的仿真基准测试)
	- [五级流水线的MIPS处理器的仿真基准测试](#五级流水线的MIPS处理器的仿真基准测试)
	- [仿真基准测试运行结果](#仿真基准测试运行结果)
- [维护者](#维护者)
- [使用许可](#使用许可)

## 背景

MIPS处理器的模块设计包括多周期的状态机、五级流水线的冲突检测单元、数据旁路、阻塞单元设计很大程度上参考了以下书籍，你可以认为本项目是对书中微体系结构与流水线章节部分的简单实现。

> Patterson, David A., and John L. Hennessy. *Computer organization and design MIPS edition: the hardware software interface*. Morgan Kaufmann, 2016.
>
> Harris, David, and Sarah Harris. *Digital design and computer architecture*. Morgan Kaufmann, 2010.

## 安装

```sh
$ git clone https://github.com/Hola39e/MIPS_Multi_Implementation
$ cd ./MIPS_Multi_Implementation
```

## 运行仿真基准测试

MIPS处理器的基准测试来源于Harris, David, and Sarah Harris. *Digital design and computer architecture*. Morgan Kaufmann, 2010.的基准测试指令，MIPS处理器通过读取`memfile.dat`中的18条机器码运行对应指令，基准测试对`lw,sw,add,addi,sub,or,and,slt,jump,beq`指令进行了测试，最终结果将在`mem[84]`中写入`0x000000071`，这一结果将在`MEM_Data.txt`中输出。

运行testbench可以使用Modelsim，Vivado，iverilog等测试环境方式，这里给出基于`iverilog`仿真环境下的运行指令，并通过`gtkwave`观察仿真波形。

### 单周期MIPS处理器的仿真基准测试
```sh
$ cd ./MIPS_Single_Cycle
$ iverilog -o MIPS_wave -y ./ tb_MIPS_Single_Cycle.v
$ vvp -n MIPS_wave --lxt2
$ gtkwave MIPS_wave.vcd
```
### 多周期MIPS处理器的仿真基准测试
```sh
$ cd ./MIPS_Multi_Cycle
$ iverilog -o MIPS_wave -y ./ tb_MIPS_Multi_Cycle.v
$ vvp -n MIPS_wave --lxt2
$ gtkwave MIPS_wave.vcd
```
### 五级流水线的MIPS处理器的仿真基准测试
```sh
$ cd ./MIPS_Pipeline
$ iverilog -o MIPS_wave -y ./ tb_MIPS_Pipeline.v
$ vvp -n MIPS_wave --lxt2
$ gtkwave MIPS_wave.vcd
```

### 仿真基准测试运行结果

基准测试运行成功后，将会在`MEM_data.txt`中看到如下结果，表示基准测试通过。

```txt
The Write Address A is 00000050
DATA_MEM[A] is 00000007
The Write Address A is 00000054
DATA_MEM[A] is 00000007
```
## 维护者

[@Hola39e](https://github.com/Hola39e)。


## 使用许可

[MIT](LICENSE) © Hola39e