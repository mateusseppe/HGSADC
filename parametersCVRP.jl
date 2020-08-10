function calculateRate(instance)
    qo = 0
    co = 0
    n = size(instance.nodes)[2]
    for i = 1:n
        qo += instance.nodes[i].demand
    end
    qo = qo/n
    for i = 1:n
        j = i+1
        for j = (i+1):n
            co += sqrt((instance.nodes[j].x - instance.nodes[i].x)^2 + (instance.nodes[j].y - instance.nodes[i].y)^2)
        end
    end
    pa = (n)*(n-1)/2
    co = co/pa
    global ω = co/qo
    return ω
end
