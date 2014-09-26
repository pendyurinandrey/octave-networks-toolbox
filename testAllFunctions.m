% Test code for "Octave tools for Network Analysis"
% Note: Matlab-style warnings are not silenced; Matlab-style short-circuit operators occur in the code.

clear all
close all
  

% Set of test graphs, in various formats

T = {};  % the test graphs structure
         % name, if any; graph; type of representation; set of nodes; set of edges; number of nodes; number of edges

T{1} = {'one_directed_edge', [0 1; 0 0], 'adjacency', [1 2], [1 2 1], 2, 1};
T{2} = {'one_undirected_edge', [0 1; 1 0], 'adjacency', [1 2], [1 2 1; 2 1 1], 2, 1};
T{3} = {'one_double_edge', [0 2; 2 0], 'adjacency', [1 2], [1 2 2; 2 1 2], 2, 2};

bowtie=[0 1 1 0 0 0; 1 0 1 0 0 0; 1 1 0 1 0 0; 0 0 1 0 1 1; 0 0 0 1 0 1; 0 0 0 1 1 0];
T{4} = {'bowtie', bowtie, 'adjacency', 1:6, [1 2; 2 1; 2 3; 3 2; 1 3; 3 1; 3 4; 4 3; 4 5; 5 4; 4 6; 6 4; 5 6; 6 5], 6, 7};

disconnected_bowtie =[0 1 1 0 0 0; 1 0 1 0 0 0; 1 1 0 0 0 0; 0 0 0 0 1 1; 0 0 0 1 0 1; 0 0 0 1 1 0];
T{5} = {'disconnected_bowtie', disconnected_bowtie, 'adjacency', 1:6, [1 2; 2 1; 2 3; 3 2; 1 3; 3 1; 4 5; 5 4; 4 6; 6 4; 5 6; 6 5], 6, 6}; 

directed_bowtie_edgeL = [1,2,1; 1,3,1; 2,3,1; 3,4,1; 4,5,1; 4,6,1; 5,6,1];
T{6} = {'directed_bowtie_edgeL', directed_bowtie_edgeL, 'edgelist', 1:6, directed_bowtie_edgeL, 1:6, 7};

bowtie_edgeL = sortrows(symmetrizeEdgeL(directed_bowtie_edgeL));
T{7} = {'bowtie_edgeL', bowtie_edgeL, 'edgelist', 1:6, bowtie_edgeL, 1:6, 7};

bowtie_edgeL_loop = [bowtie_edgeL; 4 4 1];
T{8} = {'bowtie_edgeL_loop', bowtie_edgeL_loop, 'edgelist', 1:6, bowtie_edgeL_loop, 1:6, 8};

bowtie_adjL = {[2,3],[1,3],[1,2,4],[3,5,6],[4,6],[4,5]};
T{9} = {'bowtie_adjL', bowtie_adjL, 'adjlist', 1:6, bowtie_edgeL, 1:6, 7};

undirected_tree3 = [1,2,1; 2,1,1; 1,3,1; 3,1,1];
T{10} = {'undirected_tree_3nodes', undirected_tree3, 'edgelist', 1:3, undirected_tree3, 3, 2};

directed_tree3 = [1,2,1; 1,3,1];
T{11} = {'directed_tree_3nodes', directed_tree3, 'edgelist', 1:3, directed_tree3, 3, 2};

directed_tree3_adjL = {}; directed_tree3_adjL{1}=[2,3]; directed_tree3_adjL{2}=[]; directed_tree3_adjL{3}=[];
T{12} = {'directed_tree_3_adjL', directed_tree3_adjL, 'adjlist', 1:3, directed_tree3, 3, 2};


undirected_3cycle=[0 1 1; 1 0 1; 1 1 0];
T{13} = {'undirected_3cycle', undirected_3cycle, 'adjacency', 1:3, [1 2; 2 1; 1 3; 3 1; 2 3; 3 2], 3, 3};

undirected_3cycle_selfloops = [1 1 1; 1 1 1; 1 1 0];
T{14} = {'undirected_3cycle_selfloops', undirected_3cycle_selfloops, 'adjacency', 1:3, [1 1; 1 2; 1 3; 2 1; 2 2; 2 3; 3 1; 3 2], 3, 5};

undirected_3cycle_incidence = [1 1 0; 1 0 1; 0 1 1];
T{15} = {'undirected_3cycle_incidence', undirected_3cycle_incidence, 'incidence', 1:3, [1 2; 2 1; 1 3; 3 1; 2 3; 3 2], 1:3, 3, 3};

directed_3cycle=[0 1 0; 0 0 1; 1 0 0];
T{16} = {'directed_3cycle', directed_3cycle, 'adjacency', 1:3, [1 2; 2 3; 3 1], 3, 3};

directed_3cycle_adjL={[2], [3], [1]};
T{17} = {'directed_3cycle_adjL', directed_3cycle_adjL, 'adjlist', 1:3, [1 2; 2 3; 3 1], 3, 3};

fourCycle = [0 1 0 1; 1 0 1 0; 0 1 0 1; 1 0 1 0];
T{18} = {'4-cycle', fourCycle, 'adjacency', 1:4, [1 2; 1 4; 2 1; 2 3; 3 2; 3 4; 4 1; 4 3], 4, 4};

star = canonicalNets(5,'star');
T{19} = {'5-star', star, 'edgelist', 1:5, [1 2; 1 3; 1 4; 1 5; 2 1; 3 1; 4 1; 5 1], 5, 4};

% add another graph test here ....
% ................................................


% ................................................
% ... graph representation functions .............
% ................................................

% Testing adj2adjL.m .............................
printf('testing adj2adjL.m\n')
assert(adj2adjL( T{4}{2} ),T{9}{2}')     % "bowtie" graph
assert(adj2adjL( T{16}{2} ),T{17}{2}')   % directed 3-cycle
% ................................................


% Testing adjL2adj.m .............................
printf('testing adjL2adj.m\n')
assert(adjL2adj( T{9}{2} ),T{4}{2} )      % "bowtie" graph
assert(adjL2adj( T{17}{2} ),T{16}{2} )    % directed 3-cycle
assert(adjL2adj( T{12}{2} ), edgeL2adj(T{11}{2}) )
% ................................................


% Testing adj2edgeL.m ............................
printf('testing adj2edgeL.m\n')

for i=1:length(T)
    if not(strcmp( T{i}{3}, 'adjacency' )); continue; end
    edgeL1 = sortrows( adj2edgeL(T{i}{2}) );
    edgeL2 = sortrows( T{i}{5} );
    
    assert(edgeL1(:,1:2), edgeL2(:,1:2))
end
% ................................................

% Testing edgeL2adj.m ............................
printf('testing edgeL2adj.m\n')

for i=1:length(T)
    if not(strcmp( T{i}{3}, 'adjacency' )); continue; end
    edgeL = T{i}{5};
    % adding 1s to get the expected edge list dimensions right
    if size(edgeL)(2)==2
        edgeL = [edgeL ones(size(edgeL)(1),1)];
    end
    assert(T{i}{2}, edgeL2adj( edgeL ))
end
% ................................................

% Testing adj2inc.m ..............................
printf('testing adj2inc.m\n')

randint = randi(10)+1;
assert(adj2inc(eye(randint)),eye(randint))

assert(adj2inc(T{13}{2}), T{15}{2})   % directed 3-cycle

% 1->2, 2->2, 3->1
assert(adj2inc([0 1 0; 0 1 0; 1 0 0 ]),[-1 0 1; 1 1 0; 0 0 -1])
assert(adj2inc([0 2; 0 0]),[-1 -1; 1 1])  % directed double edge
assert(adj2inc(T{1}{2}), [-1 1]')          % one directed edge
% ................................................


% Testing inc2adj.m ..............................
printf('testing inc2adj.m\n')

randint = randi(10)+1;
assert(inc2adj(eye(randint))==eye(randint))

adj = ones(3) - eye(3);
assert(inc2adj(adj),adj)

% 1->2, 2->2, 3->1
assert([0 1 0; 0 1 0; 1 0 0 ],inc2adj([-1 0 1; 1 1 0; 0 0 -1]))
assert([0 2; 0 0],inc2adj([-1 -1; 1 1]))  % directed double edge
assert(T{1}{2}, inc2adj([-1 1]'))          % one directed edge

inc = [-1 1; 1 0; 0 -1];  % two edges (1->2, 3->1)
assert(inc2adj(inc)==[0 1 0; 0 0 0; 1 0 0])
% ................................................


% Testing adj2str.m ..............................
printf('testing adj2str.m\n')

assert(adj2str(ones(3)-eye(3)),'.2.3,.1.3,.1.2,')
assert(adj2str(eye(3)),'.1,.2,.3,')
assert(adj2str([0 2; 0 0]),'.2,,')

assert(adj2str(T{4}{2}),'.2.3,.1.3,.1.2.4,.3.5.6,.4.6,.4.5,')
assert(adj2str(T{16}{2}),'.2,.3,.1,')
% ................................................


% Testing str2adj.m ..............................
printf('testing str2adj.m\n')

assert(ones(3)-eye(3),str2adj('.2.3,.1.3,.1.2,'))
assert(eye(3),str2adj('.1,.2,.3,'))
assert([0 1 0; 0 0 0; 1 0 0 ],str2adj('.2,,.1,'))

assert('.2.3,.1.3,.1.2.4,.3.5.6,.4.6,.4.5,', adj2str(T{4}{2}))
assert('.2,.3,.1,', adj2str(T{16}{2}))
% ................................................

% Testing adjL2edgeL.m ...........................
printf('testing adjL2edgeL.m\n')

assert(adjL2edgeL(T{12}{2}),T{11}{5})           % directed 3-tree
assert(sortrows(adjL2edgeL(T{9}{2}))(1:14,1:2),sortrows(T{4}{5}))   % bowtie graph
assert(sortrows(adjL2edgeL(T{17}{2}))(1:3,1:2),T{16}{5})     % directed 3-cycle
% ................................................

% Testing edgeL2adjL.m ...........................
printf('testing edgeL2adjL.m\n')
assert(edgeL2adjL(T{11}{5}),T{12}{2}')
assert(edgeL2adjL(sortrows(T{4}{5})),T{9}{2}')
assert(edgeL2adjL(T{16}{5}),T{17}{2}')
% ................................................

% Testing inc2edgeL.m ............................
printf('testing inc2edgeL.m\n')

assert(inc2edgeL([1 0 0; 0 1 0; 0 0 1]),[1 1 1; 2 2 1; 3 3 1])  % three self-loops
assert(inc2edgeL([-1 -1; 1 0; 0 1]),[1 2 1; 1 3 1])   % tree 3 nodes
assert(inc2edgeL([-1;1]),T{1}{5})                     % one directed edge
assert(inc2edgeL([ 1;1]),T{2}{5})                     % one undirected edge
assert(inc2edgeL([1 1; 1 1]),[1 2 1; 1 2 1; 2 1 1; 2 1 1])     % one double edge
assert(sortrows(inc2edgeL(T{15}{2})(1:length(T{15}{5}),1:2)),sortrows(T{15}{5}))
% ................................................

% Testing adj2simple.m ...........................
printf('testing adj2simple.m\n')

assert(adj2simple(rand(6)),ones(6)-eye(6))
assert(adj2simple([0 2 0; 1 0 0; 1 2 0]),[0 1 1; 1 0 1; 1 1 0])
assert(isSymmetric(adj2simple(rand(7))),true)
% ................................................

% Testing edgeL2simple.m .........................
printf('testing edgeL2simple.m\n')

assert(length(edgeL2simple([1 1 1; 2 2 1; 3 3 1])),0)
assert(sortrows(edgeL2simple([1 2 1; 1 3 2; 4 5 1.4])),[1 2 1; 1 3 1; 2 1 1; 3 1 1; 4 5 1; 5 4 1])
% ................................................

% Testing symmetrize.m ...........................
printf('testing symmetrize.m\n')
for i=1:20
  adj = randomDirectedGraph(randi(10)+3,rand);
  assert(isSymmetric(symmetrize(adj)),true)
end
assert(symmetrize(T{1}{2}),T{2}{2})
assert(symmetrize(edgeL2adj(T{11}{2})),edgeL2adj(T{10}{2}))
assert(symmetrize(T{16}{2}),T{13}{2})
% ................................................


% Testing symmetrizeEdgeL.m ......................
printf('testing symmetrizeEdgeL.m\n')

for x=1:20
  adj = randomDirectedGraph(randi(20)+2,rand); % create a random adjacency
  el = adj2edgeL(adj);
  if isempty(el); continue; end
  elsym = symmetrizeEdgeL(el);
  adjsym = edgeL2adj(elsym);
  assert(isSymmetric(adjsym),true)
end

assert(sortrows(symmetrizeEdgeL(T{1}{5}))(1:2,1:2), sortrows(T{2}{5})(1:2,1:2))
assert(sortrows(symmetrizeEdgeL(T{6}{5}))(1:14,1:2), sortrows(T{4}{5})(1:14,1:2) )
% ................................................

% Testing addEdgeWeights.m .......................
fprintf('testing addEdgeWeights.m\n')

assert([1 2 2; 1 3 1; 3 4 3],addEdgeWeights([1 2 1; 1 2 1; 1 3 1; 3 4 2; 3 4 1]))
assert([1 2 2; 2 3 4],addEdgeWeights([1 2 2; 2 3 4]))
assert([1 2 1; 2 1 1],addEdgeWeights([1 2 1; 2 1 1]))
assert([1 2 1; 2 1 1],addEdgeWeights([1 2 1; 2 1 1]))
assert([1 2 1; 2 1 2],addEdgeWeights([1 2 1; 2 1 1; 2 1 1]))
% ................................................


% ................................................
% ... basic network theory functions .............
% ................................................


% Testing getNodes.m .............................
fprintf('testing getNodes.m\n')

for i=1:length(T); assert( getNodes(T{i}{2},T{i}{3}), T{i}{4} ); end

% randomized test
for i=1:10
    n = randi(100);
    adj = randomDirectedGraph(n);
    assert(getNodes(randomDirectedGraph(n),'adjacency'), 1:n)
    assert(getNodes(randomGraph(n),'adjacency'), 1:n)
end
assert(strcmp(getNodes([],'rgegaerger'),'invalid graph type'))
% ................................................

% Testing getEdges.m ............................
printf('testing getEdges.m\n')

for i=1:length(T)
    edges1 = sortrows( T{i}{5} );
    edges2 = sortrows( getEdges(T{i}{2},T{i}{3}) );
    
    assert( edges1(size(edges1)(1),1:2), edges2(size(edges2)(1),1:2) )
end
assert(strcmp(getEdges([],'rgegfgdfgrger'),'invalid graph type'))
% ...............................................


% Testing numNodes.m ............................
printf('testing numNodes.m\n')

randint = randi(101);
assert(numNodes(randomGraph(randint)),randint)

for i=1:length(T)
    if strcmp(T{i}{3},'adjacency')
        assert( numNodes(T{i}{2}), T{i}{6} )
    end
end
% ...............................................


% Testing numEdges.m ...........................
printf('testing numEdges.m\n')

for i=1:length(T)
    if strcmp(T{i}{3},'adjacency')
        assert( numEdges(T{i}{2}), T{i}{7} )
    end
end
% ...............................................


% Testing linkDensity.m .........................
printf('testing linkDensity.m\n')

randint = randi(101);
assert(linkDensity(edgeL2adj(canonicalNets(randint,'tree',2))),2/randint)

for i=1:length(T)
    if strcmp(T{i}{3},'adjacency')
        coeff = 2;
        if isDirected(T{i}{2}); coeff = 1; end
        assert( linkDensity(T{i}{2}), coeff*T{i}{7}/(T{i}{6}*(T{i}{6}-1)) )
    end
end
% ...............................................


% Testing selfLoops.m ...........................
printf('testing selfLoops.m\n')

assert( selfLoops( edgeL2adj( T{8}{2} ) ), 1 )
assert( selfLoops( T{14}{2} ), 2 )
assert(selfLoops(bowtie),0)
% ...............................................


% Testing multiEdges.m ..........................
printf('testing multiEdges.m\n')

assert(multiEdges(T{3}{2}),1)
assert(multiEdges([0 2 1; 2 0 1; 1 1 0],1))  % triangle with one double edge
assert(multiEdges([0 0 1; 2 0 0; 0 1 0]),1)  % directed triangle with 1 double edge
assert(multiEdges(randomGraph(randi(15))),0)
assert(multiEdges([0 0 1; 2 0 0; 0 2 0]),2)  % directed triangle with 2 double edges
% ...............................................
