function Ox(dna)
    garbage = 0
    Solutions = Set{Int64}(1:(size(dna)[1]))
    a = rand(rng, Solutions)
    b = rand(rng, Solutions)
    nonrepetitor = 0
    while nonrepetitor == 0
        if a == b
            b = rand(rng, Solutions)
        else
            nonrepetitor = 1
        end
    end
    if dna[a].feasible == true && dna[b].feasible == false
        P1 = deepcopy(dna[a])
        filter!(x->x!=0,P1.gianttour)
        delete!(Solutions, a)
    elseif dna[b].feasible == true && dna[a].feasible == false
        P1 = deepcopy(dna[b])
        filter!(x->x!=0,P1.gianttour)
        delete!(Solutions, b)
    else
        if dna[a].feasible == false
            if dna[a].BF <= dna[b].BF
                P1 = deepcopy(dna[a])
                filter!(x->x!=0,P1.gianttour)
                delete!(Solutions, a)
            else
                P1 = deepcopy(dna[b])
                filter!(x->x!=0,P1.gianttour)
                delete!(Solutions, b)
            end
        else
            if dna[a].BF >= dna[b].BF
                P1 = deepcopy(dna[b])
                filter!(x->x!=0,P1.gianttour)
                delete!(Solutions, a)
            else
                P1 = deepcopy(dna[a])
                filter!(x->x!=0,P1.gianttour)
                delete!(Solutions, b)
            end
        end
    end
    a = rand(rng, Solutions)
    b = rand(rng, Solutions)
    while nonrepetitor == 0
        if a == b
            b = rand(rng, Solutions)
        else
            nonrepetitor = 1
        end
    end
    if dna[a].feasible == true && dna[b].feasible == false
        P2 = deepcopy(dna[a])
        filter!(x->x!=0,P2.gianttour)
        delete!(Solutions, a)
    elseif dna[b].feasible == true && dna[a].feasible == false
        P2 = deepcopy(dna[b])
        filter!(x->x!=0,P2.gianttour)
        delete!(Solutions, b)
    else
        if dna[a].BF >= dna[b].BF
            P2 = deepcopy(dna[b])
            filter!(x->x!=0,P2.gianttour)
            delete!(Solutions, a)
        else
            P2 = deepcopy(dna[a])
            filter!(x->x!=0,P2.gianttour)
            delete!(Solutions, b)
        end
    end
    global C = Array{Int64}(undef, size(P1.gianttour)[1])
    fill!(C, 0)
    Vertices = Set{Int64}(1:(size(P1.gianttour)[1]))
    i = rand(rng, Vertices)
    j = rand(rng, Vertices)
    if i >= j
        C[j:i] = copy(P1.gianttour[j:i])
    else
        garbage = i
        i = j
        j = garbage
        C[j:i] = copy(P1.gianttour[j:i])
    end
    p2 = setdiff(P2.gianttour, C[j:i])
    for i = 1:size(C)[1]
        if C[i] == 0
            C[i] = p2[1]
            deleteat!(p2,1)
        end
    end
    push!(C,0)
    pushfirst!(C,0)
    return C
end
