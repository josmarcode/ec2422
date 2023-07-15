function entropy = calcularEntropia(p, M)
    if M == 1
        entropy = -(1 - p) * log2(1 - p) - p * log2(p);
    else
        combinations = dec2bin(0:(2^M - 1)) - '0';
        % disp(combinations);

        probabilities = p .^ sum(combinations, 2) .* (1 - p) .^ (M - sum(combinations, 2));
        % disp(probabilities);
        entropy = -sum(probabilities .* log2(probabilities));
    end
end