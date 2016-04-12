Scripts for building and executing go and swift benchmarks. These will work on both Linux and OS X, the former using CPU affinity (requires 'numactl') to emulate the 4-core CPU environment used by http://benchmarksgame.alioth.debian.org/
'time' is used to capture elapsed and CPU time consumed by the benchmark.
Per-CPU load statistics are reported (requires 'mpstat').
