function Selection(subpopulation,totalpopulation,subpopulation2)
    a = 0
    b = 0
    sort!(subpopulation, by = x-> x.distance)
    while a == 0
        for i = 1:(size(subpopulation)[1] - 1)
            if round(subpopulation[i].distance,digits=2) == round(subpopulation[i+1].distance,digits=2)
                deleteat!(subpopulation,i+1)
                b += 1
                break
            end
        end
        if b == 0
            a += 1
        end
        b = 0
    end
    if subpopulation[1].feasible == true
        sort!(subpopulation, by = x-> x.distance)
        for i = 26:size(subpopulation)[1]
            deleteat!(subpopulation,26)
        end
    else
        sort!(subpopulation, by = x-> x.BF)
        for i = 26:size(subpopulation)[1]
            deleteat!(subpopulation,26)
        end
    end
end
function Diversify(subpopulation,totalpopulation,subpopulation2)
    sort!(subpopulation, by = x-> x.distance)
    sort!(subpopulation2, by = x-> x.distance)
    a = 0
    b = 0
    while a == 0
        for i = 1:(size(subpopulation)[1] - 1)
            if round(subpopulation[i].distance,digits=2) == round(subpopulation[i+1].distance,digits=2)
                deleteat!(subpopulation,i+1)
                b += 1
                break
            end
        end
        if b == 0
            a += 1
        end
    end
    a = 0
    b = 0
    while a == 0
        for i = 1:(size(subpopulation2)[1] - 1)
            if round(subpopulation2[i].distance,digits=2) == round(subpopulation2[i+1].distance,digits=2)
                deleteat!(subpopulation2,i+1)
                b += 1
                break
            end
        end
        if b == 0
            a += 1
        end
        b = 0
    end
    sort!(subpopulation, by = x-> x.distance)
    sort!(subpopulation2, by = x-> x.BF)
    for i = 11:size(subpopulation)[1]
        deleteat!(subpopulation,11)
    end
    for i = 11:size(subpopulation2)[1]
        deleteat!(subpopulation2,11)
    end
    for i = 1:100
        generateRandomFeasibleSolution(instance)
        Split(solution)
        dnaMaker(sol)
    end
end
