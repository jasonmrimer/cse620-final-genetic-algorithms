% option is for the function selection
% option=1: for M1 function
% option=4: for M4 function
% sigmash, alpha are the parameters for sharing

function [population, Fmax, Fmin, Faver, fitness_function]=genetic( ...
    population_size, ...
    genome_length, ...
    domain_start, ...
    domain_end,...
    option, ...
    probability_of_crossover, ...
    probability_of_mutation, ...
    total_generations, ...
    does_crowding, ...
    does_sharing, ...
    does_elite, ...
    eliteSize, ...
    does_hybrid, ...
    sigmash, ...
    alpha,handles)


    [x, y] = initialize_graph_axes(option, domain_start, domain_end, handles);
    fitness_function = setup_benchmark(option);
    plot(x,fitness_function(x));
    
    elites = [];
    Fmax = zeros(1, total_generations);
    Fmin = zeros(1, total_generations);
    Faver = zeros(1, total_generations);
    
    population = initialise(population_size, genome_length, domain_start, domain_end, fitness_function, option);
    plot_baseline_benchmark(option, population, genome_length);

    for j=1:total_generations
        if does_crowding==1
            population=crowding(population, population_size, genome_length, domain_start, domain_end, fitness_function, option);
        end
        
        if does_sharing==1
            population = sharing(population, population_size, genome_length, option, sigmash, alpha);
        end
        
        population = calculate_fitness(population, population_size, genome_length, fitness_function);
        [Fmax(j), Fmin(j), Faver(j)] = capture_generation_fitness_measures(population, genome_length);  
    
        [ind1, ind2, wind1, wind2]=roulette(population, population_size, genome_length, option);%Selection methods
        
        parent1=population(ind1,:);
        parent2=population(ind2,:);
    
        [child1, child2] = crossover( ...
            parent1, parent2, ...
            domain_start, domain_end, ...
            fitness_function, genome_length, ...
            probability_of_crossover);

        population = mutate_two_children(population, child1, child2, ...
            domain_start, domain_end, fitness_function, ...
            genome_length, probability_of_mutation, ...
            wind1, wind2);

        if does_hybrid == 1
            population = hybridization( ...
                population, genome_length, fitness_function, ...
                domain_start, domain_end, ...
                wind1, wind2);
        end 

        elites = find_elites_from_pop(population, genome_length, eliteSize, elites);
        if does_elite == 1
           elitism(population, elites, eliteSize, genome_length);
        end

%        population = population_prime;
    end
    
    xlabel('x');
    ylabel('M(x)');
    plot(population(:,genome_length+1),population(:,genome_length+2),'g*');
    hleg1=legend('Function','Initial Optimum','Niche Points','Location','Southeast');
    axes(handles.axes2);
    plot(Fmax), hold on, plot(Faver,'r-'), hold on, plot(Fmin,'g');
    xlabel('Generation')
    ylabel('Fitness')
    title('Fitness Progress')
    legend('Maximum Fitness','Mean Fitness','Minimum Fitness','Location', 'best')

end

%%%%%%%%%%%%%%%%%%
%End of function
%%%%%%%%%%%%%%%%%%

function plot_baseline_benchmark(option, pop, stringlength)
    if option==1 || option==4
        plot(pop(:,stringlength+1),pop(:,stringlength+2),'r*');
    else
        plot3(pop(:,2*stringlength+2),pop(:,2*stringlength+1),pop(:,2*stringlength+3),'w*');
    end
end

function [x, y] = initialize_graph_axes(option, a, b, handles)
    if option==1 || option==4
        x=a:0.01:b;
        y=a:0.01:b;
    else
        x=a:0.5:b;
        y=a:0.5:b;
    end
    
    axes(handles.axes1);
    cla;
end

function benchmark_function = setup_benchmark(option)
    switch option
        case 1
            benchmark_function= @(x) sin(5*pi*x).^6;        
            hold on
        case 4
            benchmark_function= @(x) exp(-2*log(2)*((x-0.08)/0.854).^2).*sin(5*pi*(x.^0.75-0.05)).^6;
            hold on
    end
end

function pop = calculate_fitness(pop, popsize, stringlength, benchmark_function)
    for i=1:popsize
        pop(i,stringlength+2)=benchmark_function(pop(i,stringlength+1));
    end
end

function [Fmax, Fmin, Faver] = capture_generation_fitness_measures(pop, stringlength)
    Fmax=max(pop(:,stringlength+2));
    Fmin=min(pop(:,stringlength+2));
    Faver=mean(pop(:,stringlength+2));
end

function elites = find_elites_from_pop(pop, stringlength, eliteSize, elites);
    maxFitness = maxk(pop(:,stringlength+2), eliteSize);

    for e=1:eliteSize
        for f=1:eliteSize
            if (size(elites, 1) < e || maxFitness(f) > elites(e, stringlength+2))
                matches = pop(pop(:,stringlength+2)==maxFitness(e),:);
                elites(e, :) = matches(1,:);
            end
        end
    end
end

function population = mutate_two_children(population, child1, child2, benchmark_domain_start, benchmark_domain_end, benchmark_function, chromosome_length, probability_of_mutation, wind1, wind2)
    child1m=mutation(child1, benchmark_domain_start, benchmark_domain_end, benchmark_function, chromosome_length, probability_of_mutation);%mutation
    child2m=mutation(child2, benchmark_domain_start, benchmark_domain_end, benchmark_function, chromosome_length, probability_of_mutation);
    
    population(wind1,:)=child1m;
    population(wind2,:)=child2m;
end

function population = mutate_entire_population(population, domain_start, domain_end, fitness_function, chromosome_length, probability_of_mutation)
    for i = 1:size(population,1)
        population(i,:) = mutation(population(i,:), domain_start, domain_end, fitness_function, chromosome_length, probability_of_mutation);
    end
end

function new_population = crossover_entire_population(population, benchmark_domain_start, benchmark_domain_end, benchmark_function, ...
            chromosome_length, probability_of_crossover)
%     new_population = zeros(size(population,1),chromosome_length + 2, 'single');
    new_population = [];
    
    while (parents_remain(population))
        random_indeces = randperm(size(population, 1),2);
        parent1 = population(random_indeces(1),:);
        parent2 = population(random_indeces(2),:);

        population = remove_parents(population, random_indeces);
        

        [child1, child2] = crossover( ...
            parent1, parent2, ...
            benchmark_domain_start, benchmark_domain_end, benchmark_function, ...
            chromosome_length, probability_of_crossover);
        new_population(end+1,:) = child1;
        new_population(end+1,:) = child2;
    end

% pair off those indeces as parents
% pop indeces, crossover parents
    function result = parents_remain(population)
        result = size(population, 1) > 1;
    end
    function population = remove_parents(population, indeces)
        if (first_index_will_exceed_bounds(indeces))
            population(indeces(1),:) = [];
            population(indeces(2),:) = [];
        else
            population(indeces(2),:) = [];
            population(indeces(1),:) = [];
        end
    end
   
    function result = first_index_will_exceed_bounds(indeces)
        result = indeces(1) > indeces(2);
    end
end
