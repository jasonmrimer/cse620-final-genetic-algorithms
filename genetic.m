function [pop Fmax Fmin Faver benchmark_function]=genetic(popsize, stringlength, a, b,...
    option, pc, pm, total_generations, crowd, shar, elite, eliteSize, hybrid, sigmash, alpha,handles)

% popsize is the population size
% stringlength is the length of the binary string to represent a real
% variable
% [a, b] is the function's domain
% option is for the function selection
% option=1: for M1 function
% option=4: for M4 function
% option=6: for M6 function
% pc & pm are the crossover and the mutation probabilities
% num_iter is the number of iterations
% crowd is to specify whether or not to do crowding (1 or 0)
% shar is to specify whether or not to do sharing (1 or 0)
% sigmash, alpha are the parameters for sharing

[x, y] = initialize_graph_axes(option, a, b, handles);
benchmark_function = setup_benchmark(option);
plot(x,benchmark_function(x));

elites = [];
Fmax = zeros(1, total_generations);
Fmin = zeros(1, total_generations);
Faver = zeros(1, total_generations);

pop = initialise(popsize, stringlength, a, b, benchmark_function, option); %Initialization
plot_baseline_benchmark(option, pop, stringlength);

for j=1:total_generations
    if crowd==1
        pop=crowding(pop, popsize, stringlength, a, b, benchmark_function, option);
    end
    
    if shar==1
        pop = sharing(pop, popsize, stringlength, option, sigmash, alpha);
    end
    
    pop = calculate_fitness(pop, popsize, stringlength, benchmark_function);
    [Fmax(j), Fmin(j), Faver(j)] = capture_generation_fitness_measures(pop, stringlength);
    
    maxFitness = maxk(pop(:,stringlength+2), eliteSize);

    for e=1:eliteSize
        for f=1:eliteSize
            if (size(elites, 1) < e || maxFitness(f) > elites(e, stringlength+2))
                matches = pop(pop(:,stringlength+2)==maxFitness(e),:);
                elites(e, :) = matches(1,:);
            end
        end
    end

    [ind1 ind2 wind1 wind2]=roulette(pop, popsize, stringlength, option);%Selection methods
    parent1=pop(ind1,:);
    parent2=pop(ind2,:);

    child1 = parent1;
    child2 = parent2;
    
    if crowd~=1
        [child1, child2]=crossover(parent1, parent2, a, b, option, benchmark_function, stringlength, pc);%crossover
    end
    
    child1m=mutation(child1, a, b, benchmark_function, option, stringlength, pm);%mutation
    child2m=mutation(child2, a, b, benchmark_function, option, stringlength, pm);
    
    pop(wind1,:)=child1m;
    pop(wind2,:)=child2m;
    
    if elite == 1
       elitism(pop, elites, eliteSize, stringlength);
    end
end
    if option==1 || option==4
        xlabel('x');
        ylabel('M(x)');
        plot(pop(:,stringlength+1),pop(:,stringlength+2),'g*');
        hleg1=legend('Function','Initial Optimum','Niche Points','Location','Southeast');
    else
        xlabel('x');
        ylabel('M(x)');
        plot3(pop(:,2*stringlength+2),pop(:,2*stringlength+1),pop(:,2*stringlength+3),'g*');
        title('Function and Population (initial,niched) plot')
        hleg1=legend('Function','Initial Optimum','Niche Points','Location','SoutheastOutside');
        
    end

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
