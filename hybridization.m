function population_after_local_search = run_local_search_on_offspring( ...
            population, ...
            chromosome_length, ...
            fitness_function, ...
            wind1, wind2)
%     evaluate offspring fitness
% for each chromosome
% mutate
% evaluate fitness
% keep if better
    child_indeces = [wind1, wind2];
    for child=1:2
        for chromosome=1:chromosome_length
            original_member = population(child_indeces(child));
            neighbor = original_member;
            neighbor(chromosome) = abs(parent(mpoint)-1);
            if fitness_function()
        end
    end
end
