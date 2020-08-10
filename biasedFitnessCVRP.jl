function penalizedCost(dna)
    ϕ = dna.T
    excess = 0
    if dna.feasible == false
        b = findall(x->x==0, dna.solution)
        a = size(b)[1]
        for i = 1:(a-1)
            if cargoCalculator(dna.solution[b[i]:b[i+1]]) - instance.fleetcargo > 0
                excess += cargoCalculator(dna.solution[b[i]:b[i+1]]) - instance.fleetcargo
            end
        end
        ϕ += ω*excess
        return ϕ
    end
    return ϕ
end
function brokenPairs(x,y)
    i = 1
    brokendistance = 0
    for i = 1:(size(y)[1] - 1)
        v = findall(x->x == y[i], x)
        if v[1] == size(y)[1]
            if x[2] != y[i+1]
                brokendistance += 1
            end
        else
            if x[v[1] + 1] != y[i+1]
                brokendistance += 1
            end
        end
    end
    return brokendistance
end
function diversityContribution(x, n_closest_proportion)
    Δ = 0
    i = 1
    n = size(dna)[1]
    n_closest = Int(floor(n_closest_proportion*n) + 1)
    brokenPairsMatrix = Array{Tuple{Float64,Float64}}(undef, n)
    for i = 1:n
        brokenPairsMatrix[i] = (brokenPairs(x, dna[i].gianttour), i)
    end
    sort!(brokenPairsMatrix, by=first)
    for i = 1:(n_closest + 1)
        Δ += brokenPairsMatrix[i][1]
    end
    Δ = Δ/(2*n_closest*n_closest)
    return Δ
end
function biasedFitness(dna, nbElit)
    i = 2
    a = 0
    costrank = Array{Int64, 1}(undef, 1)
    diversityrank = Array{Int64, 1}(undef, 1)
    costrank[1] = 1
    diversityrank[1] = 1
    empty = Array{Int64,1}(undef, 0)
    for i = 2:size(dna)[1]
        j = 1
        while a == 0
            for j = 1:size(costrank)[1]
                if (penalizedCost(dna[i]) > penalizedCost(dna[costrank[j]]))
                    insert!(costrank, j, i)
                    a = 1
                    break
                end
            end
            if findall(x->x==i, costrank) == empty
                push!(costrank, i)
                a = 1
                break
            end
        end
        a = 0
    end
    a = 0
    for i = 2:size(dna)[1]
        j = 1
        while a == 0
            for j = 1:size(diversityrank)[1]
                if diversityContribution(dna[i].gianttour, 0.2) <= diversityContribution(dna[diversityrank[j]].gianttour, 0.2)
                    insert!(diversityrank, j, i)
                    a = 1
                    break
                end
            end
            if findall(x->x==i, diversityrank) == empty
                push!(diversityrank, i)
                a = 1
                break
            end
        end
        a = 0
    end
    i = 1
    costrank = reverse(costrank)
    diversityrank = reverse(diversityrank)
    for i = 1:size(dna)[1]
        dna[i].BF = findall(x->x == i, costrank)[1] + (1 - nbElit/size(dna)[1])*findall(x->x==i, diversityrank)[1]
    end
end
