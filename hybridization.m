function population_after_local_search = hybridization( ...
            population, ...
            genome_length, ...
            fitness_function, ...
            wind1, wind2)
%     evaluate offspring fitness
% for each chromosome
% mutate
% evaluate fitness
% keep if better
    child_indeces = [wind1, wind2];
    for child=1:2
        best_neighbor = local_search_gene_flip(population(child_indeces(child)), genome_length, fitness_function);
    end
end

