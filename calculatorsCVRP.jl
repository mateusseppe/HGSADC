function timeCalculator(sol)
    T = 0
    for i = 1:size(sol)[1] - 1
        if sol[i] == 0
            T += instance.nodes[sol[i+1]].depottime
        elseif sol[i+1] == 0
            T += instance.nodes[sol[i]].depottime
        else
            T += instance.timematrix[sol[i], sol[i+1]]
        end
    end
    return T
end
function cargoCalculator(sol)
    n = size(sol)[1]
    Q = 0
    for i = 1:n
        if sol[i] == 0
        else
            Q += instance.nodes[sol[i]].demand
        end
    end
    return Q
end
function isSolAcceptable(sol)
    if sol[1] != 0 || last(sol) != 0
        return false
    end
    return true
end
function isSolFeasible(sol)
    if isSolAcceptable(sol) == false
        return false
    end
    b = findall(x->x==0, sol)
    for i = 1:(size(b)[1] -1)
        if b[i] +1 == b[i+1]
            deleteat!(sol,b[i])
            break
        end
    end
    b = findall(x->x==0, sol)
    if size(b)[1] > instance.fleetsize + 1
        return false
    end
    for i in 1:size(b)[1]-1
        route = copy(sol[b[i]:b[i+1]])
        if cargoCalculator(route) > instance.fleetcargo
            return false
        end
    end
    return true
end
function isVRPFeasible(dna, maxtime)
    y = 1
    for y = 1:size(dna)[1]
        if isSolFeasible(dna[y].solution) == true && dna[y].T <= maxtime
            dna[y].feasible = true
        else
            dna[y].feasible = false
        end
    end
end
function distanceCalculator(v)
    n = size(v)[1]
    distance = 0
    for i = 1:n-1
        if v[i] == 0 && v[i+1] == 0
        elseif v[i] == 0 && v[i+1] != 0
            distance += round(sqrt((instance.nodes[v[i + 1]].x - instance.depot.x)^2 + (instance.nodes[v[i + 1]].y - instance.depot.y)^2),digits=2)
        elseif v[i+1] == 0
            distance += round(sqrt((instance.nodes[v[i]].x - instance.depot.x)^2 + (instance.nodes[v[i]].y - instance.depot.y)^2),digits=2)
        else
            distance += round(sqrt((instance.nodes[v[i+1]].x - instance.nodes[v[i]].x)^2 + (instance.nodes[v[i+1]].y - instance.nodes[v[i]].y)^2),digits=2)
        end
    end
    return distance
end
