function randomsolutionCVRPcreator(instance)
    global solution = Array{Int64}(undef, 0)
    n = size(instance.nodes)[2]
    clients = Set{Int64}(1:n)
    for i = 1:n
        v = rand(rng, clients)
        push!(solution, v)
        delete!(clients,v)
    end
    push!(solution,0)
    pushfirst!(solution,0)
    return solution
end
