function dnaMaker(solutions)
    gianttour = filter(x->x≠0, solutions)
    stopper = 0
    verify = 0
    while stopper == 0
        verify = 0
        for finder = 2:(size(solutions)[1]-1)
            if solutions[finder] == 0 && solutions[finder+1] == 0
                deleteat!(solutions, finder)
                verify += 1
                break
            elseif solutions[finder] == 0 && solutions[finder-1] == 0
                deleteat!(solutions,finder)
                verify += 1
                break
            end
        end
        if verify == 0
            stopper += 1
        end
    end
    push!(gianttour, 0)
    pushfirst!(gianttour, 0)
    newdna = DNA(
    solutions,
    timeCalculator(solutions),
    gianttour,
    round(distanceCalculator(solutions),digits=2),
    isSolFeasible(solutions),
    0)
    push!(dna,newdna)
    if newdna.feasible == true
        push!(feasibledna,newdna)
    else
        push!(unfeasibledna,newdna)
    end
    return dna
end
