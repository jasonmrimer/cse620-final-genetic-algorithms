function [child]=mutation( ...
    parent, ...
    domain_start, ...
    domain_end, ...
    fitness_function, ...
    chromosome_length, ...
    probability_of_mutation)
%%% Description: mutation algorithm
%%% parent is the parent population
%%% [a,b] is the range of real values
%%% option=1,4,6 corresponds to M1, M4, M6 functions in the slides
%%% stringlenrth is the length of chromesome which is used to present single
%%%value
%%% pm is the probability of mutation
    
if (rand<probability_of_mutation)
    mpoint=round(rand*(chromosome_length-1))+1;
    child=parent;
    child(mpoint)=abs(parent(mpoint)-1);
    child(:, chromosome_length+1)=sum(2.^(size(child(:,1:chromosome_length),2)-1:-1:0).*child(:,1:chromosome_length))*(domain_end-domain_start)/ (2.^chromosome_length-1)+domain_start;
    child(:, chromosome_length+2)=fitness_function(child(:, chromosome_length+1));
    display("p: " + parent);
    display("c: " + child);
else
    child=parent;
end
%%%%%%%%%%%%%%%%%%%
%End of function
%%%%%%%%%%%%%%%%%%%