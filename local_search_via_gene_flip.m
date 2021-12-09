% test case
% input
% [0 0 0 0 1 1 1 0 1 1 0.057674 0.2376]
% 10
% @(x) sin(5*pi*x).
% expected result
% [0 1 0 0 1 1 1 0 1 1 0.3079 0.9545]

function best_neighbor = local_search_via_gene_flip( ...
    member, ...
    genome_length, ...
    fitness_function, ...
    domain_start, ...
    domain_end ...
)
    best_neighbor = member;
    for gene=1:genome_length
        neighbor = flip_gene(member, gene);
        best_neighbor = compare_and_swap(neighbor, best_neighbor, fitness_function, genome_length, domain_start, domain_end); 
    end
end

function neighbor = flip_gene(member, gene_index)
    neighbor = member;
    neighbor(gene_index) = abs(neighbor(gene_index)-1);
end

function best_neighbor = compare_and_swap(neighbor, best_neighbor, fitness_function, genome_length, domain_start, domain_end)
    neighbor_decimal = number_converter(neighbor(1:genome_length), domain_start, domain_end);
    neighbor_fitness = fitness_function(neighbor_decimal);    
    best_neighbor_fitness = best_neighbor(genome_length + 2);

    if neighbor_fitness > best_neighbor_fitness
        best_neighbor(1:genome_length) = neighbor(1:genome_length);
        best_neighbor(genome_length + 1) = neighbor_decimal;
        best_neighbor(genome_length + 2) = neighbor_fitness;
    end
end
