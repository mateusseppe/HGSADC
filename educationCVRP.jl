function moveOne(rat,v,u,uPicker)
    deleteat!(rat,uPicker)
    if v > uPicker
        insert!(rat,v,u)
    else
        insert!(rat,v+1,u)
    end
end
function moveTwo(rat,v,u, uPicker)
    x = rat[uPicker + 1]
    if x != 0
        deleteat!(rat,uPicker)
        deleteat!(rat,uPicker)
        if v > uPicker
            insert!(rat,v-1,u)
            insert!(rat,v,x)
        else
            insert!(rat,v+1,u)
            insert!(rat,v+2,x)
        end
    end
end
function moveThree(rat,v,u,uPicker)
    x = rat[uPicker + 1]
    if x != 0
        deleteat!(rat,uPicker)
        deleteat!(rat,uPicker)
        if v > uPicker
            insert!(rat,v-1,x)
            insert!(rat,v,u)
        else
            insert!(rat,v+1,x)
            insert!(rat,v+2,u)
        end
    end
end
function moveFour(rat,v,uPicker)
    if rat[v] != 0
        rat[uPicker],rat[v] = rat[v],rat[uPicker]
    end
end
function moveFive(rat,v,u,uPicker)
    x = rat[uPicker + 1]
    if x != 0 && rat[v] != x
        rat[uPicker],rat[v] = rat[v],rat[uPicker]
        deleteat!(rat,uPicker+1)
        if v > uPicker
            insert!(rat,v,x)
        else
            insert!(rat,v+1,x)
        end
    end
end
function moveSix(rat,v,uPicker)
    x = rat[uPicker + 1]
    y = rat[v + 1]
    if x != 0 && y != 0 && rat[v] != 0
        rat[uPicker],rat[v] = rat[v],rat[uPicker]
        rat[uPicker + 1],rat[v + 1] = rat[v + 1],rat[uPicker + 1]
    end
end
function moveSeven(rat,v,uPicker)
    depotVisits = findall(x->x==0, rat)
    n = size(depotVisits)[1]
    depotIndex = Array{Int64}(undef, n)
    for j = 1:n
        depotIndex[j] = depotVisits[j]
    end
    ruCounter = 0
    rvCounter = 0
    if rat[v] != 0
        for j = 1:n-1
            if uPicker > depotIndex[j]
                ruCounter += 1
            end
        end
        for j = 1:n-1
            if v > depotIndex[j]
                rvCounter += 1
            end
        end
    end
    if ruCounter == rvCounter && ruCounter != 0
        rat[uPicker + 1], rat[v] = rat[v], rat[uPicker + 1]
    end
end
function moveEight(rat,v,uPicker)
    depotVisits = findall(x->x==0, rat)
    n = size(depotVisits)[1]
    depotIndex = Array{Int64}(undef, n)
    for j = 1:n
        depotIndex[j] = depotVisits[j]
    end
    ruCounter = 0
    rvCounter = 0
    if rat[v] != 0
        for j = 1:n-1
            if uPicker > depotIndex[j]
                ruCounter += 1
            end
        end
        for j = 1:n-1
            if v > depotIndex[j]
                rvCounter += 1
            end
        end
    end
    if ruCounter != rvCounter
        rat[uPicker + 1], rat[v] = rat[v], rat[uPicker + 1]
    end
end
function moveNine(rat,v,uPicker)
    depotVisits = findall(x->x==0, rat)
    n = size(depotVisits)[1]
    depotIndex = Array{Int64}(undef, n)
    for j = 1:n
        depotIndex[j] = depotVisits[j]
    end
    ruCounter = 0
    rvCounter = 0
    if rat[v] != 0
        for j = 1:n-1
            if uPicker > depotIndex[j]
                ruCounter += 1
            end
        end
        for j = 1:n-1
            if v > depotIndex[j]
                rvCounter += 1
            end
        end
    end
    if ruCounter != rvCounter
        rat[uPicker + 1], rat[v] = rat[v], rat[uPicker + 1]
        rat[uPicker+1], rat[v + 1] = rat[v + 1], rat[uPicker+1]
    end
end
function NeighborChooser(u,k)
    n = size(C)[1] - 2
    vec = Array{Tuple{Int64,Float64},1}(undef,n)
    global uNeighborhood = Array{Int64}(undef, k)
    for i = 1:n
        vec[i] = tuple(i, instance.timematrix[i,u])
    end
    sort!(vec, by = x -> x[2])
    deleteat!(vec,1)
    for i in 1:k
        uNeighborhood[i] = (vec[i])[1]
    end
    return uNeighborhood
end
function Education(sol)
    rat = deepcopy(sol)
    global educatedsolution = deepcopy(sol)
    controler = 1
    Clients = Set{Int64}(1:size(instance.nodes)[2])
    for controler = 1:size(instance.nodes)[2]
        u = rand(rng,Clients)
        uPicker = findall(x->x==u,sol)[1]
        delete!(Clients,u)
        NeighborChooser(u,20)
        for i = 1:20
            Moves = Set{Int64}(1:9)
            ###delete!(Moves, 9)
            #delete!(Moves, 4)
            #delete!(Moves, 6)
            #delete!(Moves, 1)
            a = 0
            element = uNeighborhood[i]
            v = findall(x->x==element,rat)[1]
            while a == 0
                movPicker = rand(rng, Moves)
                delete!(Moves, movPicker)
                if movPicker == 1
                    moveOne(rat,v,u,uPicker)
                elseif movPicker == 2
                    moveTwo(rat,v,u,uPicker)
                elseif movPicker == 3
                    moveThree(rat,v,u,uPicker)
                elseif movPicker == 4
                    moveFour(rat,v,uPicker)
                elseif movPicker == 5
                    moveFive(rat,v,u,uPicker)
                elseif movPicker == 6
                    moveSix(rat,v,uPicker)
                elseif movPicker == 7
                    moveSeven(rat,v,uPicker)
                elseif movPicker == 8
                    moveEight(rat,v,uPicker)
                elseif movPicker == 9
                    moveNine(rat,v,uPicker)
                end
                if last(rat) != 0
                    push!(rat,0)
                end
                if (isSolFeasible(rat) == true && distanceCalculator(rat) < distanceCalculator(sol)) || (isSolFeasible(rat) == true && isSolFeasible(sol) == false)
                    educatedsolution = deepcopy(rat)
                    sol = deepcopy(rat)
                    uPicker = findall(x->x==u,sol)[1]
                    ##println("$(rat) and movP=$movPicker and uP=$uPicker and u=$u and v=$v")
                    a = 1
                else
                    rat = deepcopy(sol)
                end
                if isempty(Moves) == true
                    a = 1
                end
            end
        end
    end
    return educatedsolution
end
function patternImprovement2(educatedsolution)
    global patterneducatedsolution = deepcopy(educatedsolution)
    rat = deepcopy(patterneducatedsolution)
    rat2 = deepcopy(rat)
    n = size(instance.nodes)[2]
    Clients = Set{Int64}(1:size(instance.nodes)[2])
    b = findall(x->x==0, rat)
    for i = 1:n
        u = rand(rng,Clients)
        uPicker = findall(x->x==u,rat)[1]
        delete!(Clients,u)
        for j = 2:(size(rat)[1] - 2)
            deleteat!(rat,uPicker)
            insert!(rat,j,u)
            if distanceCalculator(rat) <= distanceCalculator(rat2)
                if isSolFeasible(rat) == true || isSolFeasible(rat2) == false
                    rat2 = deepcopy(rat)
                    uPicker = findall(x->x==u,rat)[1]
                else
                    rat = deepcopy(rat2)
                end
            else
                if isSolFeasible(rat) == true && isSolFeasible(rat2) == false
                    rat2 = deepcopy(rat)
                    uPicker = findall(x->x==u,rat)[1]
                else
                    rat = deepcopy(rat2)
                end
            end
        end
    end
    patterneducatedsolution = deepcopy(rat)
    return patterneducatedsolution
end
