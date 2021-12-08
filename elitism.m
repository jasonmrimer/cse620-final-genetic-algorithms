function elitism(pop, elites, eliteSize, stringlength)

% Elitism is guaranteeing a position for the most fit individuals in pop

maxFitness = maxk(elites(:,stringlength+2), eliteSize);

for e=1:eliteSize
    arr = pop(pop(:,stringlength+2)>=maxFitness(e),:);

    for a=1:size(arr,1)
        c = intersect(arr(a,:), pop, 'rows');
        if isempty(c)
            [val, idx] = min(pop(:, stringlength+2));
            pop(idx) = arr(a);
        end
    end
end
