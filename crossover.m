function [child1, child2]=crossover( ...
    parent1, ...
    parent2, ...
    domain_start, ...
    domain_end, ...
    fitness_function, ...
    chromosome_length, ...
    probability_of_crossover ...
)
%%% Description: crossover algorithm
%%% parent1, parent2 represents two operators 
%%% [a,b] is the range of real values 
%%% option=1,4,6 corresponds to M1, M4, M6 functions in the slides
%%% stringlenrth is the length of chromesome which is used to present single
%%%value
%%% pc is the probability of crossover
    if (rand<probability_of_crossover)
        cpoint=round(rand*(chromosome_length-2))+1;
        child1=[parent1(1:cpoint) parent2(cpoint+1:chromosome_length)];
        child2=[parent2(1:cpoint) parent1(cpoint+1:chromosome_length)];
        child1( chromosome_length+1)=sum(2.^(size(child1(1:chromosome_length),2)-1:-1:0).*child1(1:chromosome_length))*(domain_end-domain_start)/(2.^chromosome_length-1)+domain_start;
        child2( chromosome_length+1)=sum(2.^(size(child2(1:chromosome_length),2)-1:-1:0).*child2(1:chromosome_length))*(domain_end-domain_start)/(2.^chromosome_length-1)+domain_start;
        child1( chromosome_length+2)=fitness_function(child1( chromosome_length+1));
        child2( chromosome_length+2)=fitness_function(child2( chromosome_length+1));
    else
        child1=parent1;
        child2=parent2;
    end
end
%%%%%%%%%%%%%%%%%%%
%End of function
%%%%%%%%%%%%%%%%%%%