function D = charpath_B(W)
    D = distance_bin(W);
    D = charpath(D, 0, 0);      % not inclueding inf nodes = not connected nodes

    % source: GraphVar