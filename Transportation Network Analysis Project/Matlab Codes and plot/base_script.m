nodes = dlmread('Austin_sdb_node.txt', '	', 1, 0);

%plot all links
% flows = dlmread('Austin_sdb_flows.txt', ' ', 1, 0);

%plot reduced links
flows = dlmread('Austin_sdb_flows_reduced.txt', '	', 1, 0);


links = flows(:, [1,2]);

adjacency = accumarray(links,1);
gplot(adjacency,nodes(:,[2,3]),'-o');

%compile nodes of interest
i35 = i35nodes();
sh130 = sh130nodes();
hwy45 = hwy45nodes();
rt21 = rt21nodes();
hwy = nodes([i35; sh130; hwy45; rt21],:);

%plot limited node labels to determine nodes of interest
% ind = (nodes(:,2) > -9.795*10^7);
% nodes = nodes(ind,:);
% ind = nodes(:,2) < -9.765*10^7;
% nodes = nodes(ind,:);
% ind = nodes(:,3) < 3.012*10^7;
% nodes = nodes(ind,:);
% ind = nodes(:,3) > 3.006*10^7;
% nodes = nodes(ind,:);
% ind = flows(nodes(:,1),3) > 100;
% pairs = flows(ind, [1,2]);
% [m,n] = size(pairs);
% pairs = reshape(pairs,2*m,1);

for i=1:length(hwy)
    %label all nodes
%     text(nodes((i),2), nodes((i),3), sprintf('<--%d', nodes(i,1)) );
%     text(nodes(pairs(i),2), nodes(pairs(i),3), sprintf('<--%d', nodes(pairs(i),1)) );

%label nodes of interest
%     text(hwy((i),2), hwy((i),3), sprintf('<--%d', hwy(i,1)) );
    hold on
    plot(nodes(hwy(:,1),2),nodes(hwy(:,1),3),'r*');
end