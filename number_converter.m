function decimal_value = number_converter(gene, domain_start, domain_end)
    decimal_value = sum(2.^(size(gene, 2)-1:-1:0).*gene)*(domain_end-domain_start) / (2.^size(gene, 2)-1)+domain_start;
end