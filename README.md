# arm-generator
Abductive Reasoning Model (ARM) Generator

*ARM Generator* generates the Abductive Reasoning Model of a System Under Test (SUT) by using a template file describing component behaviors.

*ARM Generator* is developed at and copyrighted on [Institute of Software Technology][1] at [Graz University of Technology][2] under GNU General Public License v3.0. See the copyright notice at the end of this document for details.

### Important Features

*ARM Generator* generates ARMs from

1. Combinational Circuits (in gate-level Verilog),
2. Sequential Circuits (in gate-level Verilog), and
3. Finite State Machines (in DOT language).

### System Requirements

* [Perl][3] v5.14 or higher

Above is the only requirement of *ARM Generator*.

### How to Use

```
Usage: perl arm-generator.pl <system-file> <template-file> <output-file>
```

### Example: Stuck At Fault ARM for a Gate-Level Verilog Module

The `examples` folder has 15 example combinational circuits and one sequential circuit design, *Car Window Controller*. For every example, we have the following files.

1. `.pdf`/`.dot` file: Circuit Diagram.
2. `.v` file: Gate-level implementation in Verilog.
3. `.arm` file: Abductive Reasoning Model.

To generate the `.arm` file for the first circuit, execute the following command from the main directory.

```
perl arm-generator.pl examples/c01/c1.v examples/VerilogLogicGates.txt examples/c01/c1.arm
```
Even if the circuit is sequential, *ARM Generator* still generates the `.arm` file as follows.

```
perl arm-generator.pl examples/carwindow/carwindow.v examples/VerilogLogicGates.txt examples/carwindow/carwindow.arm
```

### Example: Behavioral ARM for an FSM

Since *Car Window Controller* is a sequential circuit, it implements a Finite State Machine (FSM). *ARM Generator* generates the `.arm` file for the FSM of *Car Window Controller* as follows.

```
perl arm-generator.pl examples/carwindow/carwindowFSM.dot examples/FSM.txt examples/carwindow/carwindowFSM.arm
```

### Template Files

Template files declare component types used in the System Under Test (SUT). Our template files use the following structure.

```
BEGIN COMPONENT <component-typename>
    <statements>
END COMPONENT
```

*ARM Generator* copies and pastes every statement for every occurrence of the component type. Then, *ARM Generator* replaces the following special characters as follows.

1. `#C` : `instance-name` and
2. `#x` : `parameter #x` where x is a number.

`examples/VerilogLogicGates.txt` is a good example template file.

### Copyright Notice

Abductive Reasoning Model (ARM) Generator
Copyright (C) 2019 Institute for Software Technology at Graz University of Technology

ARM Generator is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

ARM Generator is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with ARM generator. If not, see <https://www.gnu.org/licenses/>.

* **mail:** ykoerogl@ist.tugraz.at
* **address:** Inffeldgasse 16b/II, 8010 Graz/AUSTRIA

[1]: http://www.ist.tugraz.at
[2]: https://www.tugraz.at
[3]: https://www.perl.org/get.html
