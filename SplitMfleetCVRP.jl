function SplitForMcarsCVRP(C)
    nbNodes = size(instance.nodes)[2]
    m = instance.fleetsize
    global sumDistance = Array{Float64}(undef, nbNodes + 1)
    global sumLoad = Array{Float64}(undef, nbNodes + 1)
    sumDistance[1] = 0
    sumLoad[1] = 0
    global cli = Array{sdata}(undef, nbNodes)
    for i = 1:(size(C)[1] - 3)
        cli[i] = sdata(
        instance.nodes[C[i+1]].demand,
        round(sqrt((instance.nodes[C[i + 1]].x - instance.depot.x)^2 + (instance.nodes[C[i + 1]].y - instance.depot.y)^2),digits=2),
        round(sqrt((instance.nodes[C[i+2]].x - instance.nodes[C[i+1]].x)^2 + (instance.nodes[C[i+2]].y - instance.nodes[C[i+1]].y)^2),digits=2),
        C[i+1]
        )
    end
    cli[nbNodes] = sdata(instance.nodes[C[nbNodes+1]].demand, sqrt((instance.nodes[C[nbNodes + 1]].x - instance.depot.x)^2 + (instance.nodes[C[nbNodes + 1]].y - instance.depot.y)^2), 0, C[nbNodes+1])
    for i = 2:(nbNodes+1)
        sumLoad[i] = sumLoad[i-1] + cli[i-1].demand
        sumDistance[i] = sumDistance[i-1] + cli[i-1].dnext
    end
    verifier = 0
    while verifier == 0
        global potential = Matrix{Float64}(undef,m+1,nbNodes+1)
        pred = Matrix{Float64}(undef,m+1,nbNodes+1)
        for k = 1:m+1
            for j = 1:nbNodes+1
                potential[k,j] = Inf
                pred[k,j] = -1
            end
        end
        potential[1,1] = 0
        queue = Array{Int64}(undef, 0)
        push!(queue,0)
        for k = 1:m
            empty!(queue)
            push!(queue,k)
            for i = (k+1):(nbNodes + 1)
                if isempty(queue) == true
                    break
                end
                if sumLoad[i] - sumLoad[queue[1]] <= instance.fleetcargo
                    potential[k+1,i] = 2*potential[k,queue[1]] + cli[queue[1]].dreturn + sumDistance[i] - sumDistance[queue[1]+1] + cli[i - 1].dreturn
                else
                    potential[k+1,i] = Inf
                end
                pred[k+1,i] = queue[1]
                if i < (nbNodes + 1)
                    if dominates(last(queue),i,k) == false
                        while isempty(queue) == false && dominates(i,last(queue),k) == true
                            deleteat!(queue,size(queue)[1])
                        end
                        push!(queue,i)
                    end
                    while isempty(queue) == false && (sumLoad[i+1] - sumLoad[queue[1]] > instance.fleetcargo)
                        deleteat!(queue,1)
                    end
                    if isempty(queue) == true
                        break
                    end
                end
            end
        end
        if potential[m+1,nbNodes+1] >= Inf
            m+=1
        else
            minCost = Inf
            nbRoutes = 0
            for k = 2:(m+1)
                if potential[k,nbNodes+1] <= minCost
                    minCost  = potential[k,nbNodes+1]
                    nbRoutes = k - 1
                end
            end
            splited = Array{Int64}(undef, nbRoutes)
            fill!(splited,0)
            cour = nbNodes
            for i in reverse(1:(nbRoutes))
                cour = pred[i+1, cour]
                cour = Int(cour)
                splited[i] = cour
            end
            global sol = deepcopy(C)
            for i = 2:(nbRoutes)
                insert!(sol, splited[i] + i - 1, 0)
            end
            global solCost = potential[nbRoutes+1,nbNodes+1]
            return sol
        end
    end
end
function dominates(i,j,k)
    if i <= j
        if (potential[k,i] + cli[i].dreturn - sumDistance[i+1] <= potential[k,j] + cli[j].dreturn - sumDistance[j+1]) && sumLoad[i] == sumLoad[j]
            return true
        else
            return false
        end
    else
        if (potential[k,i] + cli[i].dreturn - sumDistance[i+1] <= potential[k,j] + cli[j].dreturn - sumDistance[j+1])
            return true
        else
            return false
        end
    end
end
