# simulationQP934

Install with:

```
] add https://github.com/viniciuspiccoli/simulationQP934.jl

```
Usage:

To use the default data for the simulation use

```
data = Data();

```

Creating inital box for the MD simulation:

```
box  = initial_point(data);

```

Storage of the data in the linked lists

```
nc, fatm, natm = linkedlist(box,data);

```

Total energy of the initial configuration:

```
total_ener     =  utotal(box, data, fatm, natm, nc)

```

...

