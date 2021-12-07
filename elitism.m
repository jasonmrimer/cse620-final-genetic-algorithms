function idx = elitism(idx, pop, elites)

% Elitism is taking only the most performant of the population
while true
    c = intersect(pop(idx,:),elites,"rows");
    if isempty(c)
        break;
    end
    idx = idx+1;
    if idx > 50
        idx = 1;
    end
end

end