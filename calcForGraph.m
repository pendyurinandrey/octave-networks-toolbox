
edges = [1 5 1; 
         1 6 1; 
         5 2 1; 
         5 3 1; 
         5 4 1; 
         5 6 1; 
         6 7 1; 
         7 8 1;
         7 9 1;]

adj = edgeL2adj(edges)

degree = degrees(adj)

betweeness = nodeBetweenness(adj) ./ 2

closeness = closeness(adj)