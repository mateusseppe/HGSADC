using DelimitedFiles
using Random
mutable struct node
    x
    y
    depottime
    demand
end
mutable struct data
    timematrix
    fleetsize
    fleetcargo
    nodes
    depot
end
mutable struct depotax
    x
    y
end
mutable struct DNA
    solution
    T
    gianttour
    distance
    feasible::Bool
    BF
end
mutable struct sdata
    demand
    dreturn
    dnext
    index
end
