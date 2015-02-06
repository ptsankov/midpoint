# Mid-point framework tutorial #

This tutorial gives instructions on how to use the mid-point framework
in order to synthesize a specification for a mid-point that enforces a
communication protocol.

1. Required tools

  To use the mid-point framework you need to download and install the
  mCRL toolset and the JFLAP tool.
  
  To download the mCRL toolset and read installation instructions visit 
  http://homepages.cwi.nl/~mcrl/.
  
  To download the JFLAP tool visit http://www.cs.duke.edu/csed/jflap/.


2. Mid-point specification synthesis
  
  To synthesize specification for a mid-point you need to perform
  three steps: (1) construction, (2) minimization, (3 optional) expand
  to state machine.

2.1. Construction
  To construct a mid-point, you need to obtain the mCRL specifications
  for the endpoints and the environment. In the channels.mcrl file you
  can find a number of channel specifications. To define the
  end-points you can refer to the TCP case study (located in the
  tcp.mcrl file). For detailed documentation on the mCRL process
  algebraic language visit http://homepages.cwi.nl/~mcrl/.

  The next step is to compute the mid-point's specification; you need
  to use the mcrl as follows:

  $mcrl -tbf example.mcrl

  example.mcrl is the file containing all data sort definitions, the
  specifications of the two end-points, and the environment
  specification (refer to the tcp.mcrl file). The mcrl tool outputs a
  the linear process equation (LPE) describing the behavior of the
  mid-point. The file should be called example.tbf.

  To transform the mid-point's LPE to a labelled transition system
  (LTS) you use the instantiator tool:
  
  ```
  instantiator example.tbf
  ```

  The output is a file (example.aut) describing the state space of the
  mid-point.

2.2. Minimization
To minimize the state space of the mid-point, you can use the ltsmin
tool as follows:
```
ltsmin -o example_min.aut example.aut
```

The tool takes as an input the LTS of the mid-point (example.aut)
and outputs a minimized LTS, stored in the example_min.aut file.

2.3. Expand to state machine
To expand the mid-points LTS to a state machine, you can use the
JFLAP tool to eliminate all internal (tau) actions. The input format
of the JFLAP tool is .jff, you can use the aut2jff.pl script to
transform the mid-points .aut file to .jff file:

```
./aut2jff.pl example_min.aut example_min.jff
```

Next, you open the example_min.jff file with JFLAP and select the
Convert to DFA option from the menu. Note that the aut2jff.pl script
replaces the transition names with integers so that the format is
compatible with the JFLAP tool. To rename back the transitions to
their original names, you can use the rename_transitions.pl script
as follows:

```
./rename_transitions.pl example_min.jff example_min.jff.msgmap
```

The example_min.jff.msgmap file stores the mapping from integers to
transition names and will replace back the original names.


## Example: TCP case study ##

Here we give instructions on how to synthesize a specification for the
mid-point that enforces the TCP protocol.

You need to execute the following commands:

```
mcrl -tbf tcp.mcrl
instantiator tcp.tbf
ltsmin -o tcp_min.aut tcp.aut
aut2jff.pl tcp_min.aut tcp.jff
rename_transitions.pl tcp.jff tcp.jff.msgmap
```

You can visualize the mid-point specification by opening the tcp.jff
file using JFLAP.
