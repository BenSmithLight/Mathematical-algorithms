% 最大流问题求解
clc;
clear;

%% 获取用户输入并进行格式转换
[costMatrix, source, target, weights] = get_input();

%% 开始计算
n = max(target);

% 创建有向图，从源点到汇点，权重为用户输入的权重
graph = digraph(source, target, weights);

% 使用Ford-Fulkerson算法求解最大流
[maxFlow, ~, cutSource, cutTarget] = maxflow(graph, 1, n, "augmentpath");

%% 输出结果
disp(['最大流：', num2str(maxFlow)]);

% 输出最小割
endNodes = graph.Edges.EndNodes;
disp('最小割：')

% # 逐个检查节点，找到所有与源点连通的节点
for i = 1:length(cutTarget)

    if (find(endNodes(:, 2) == cutTarget(i)))
        [x, y] = find(endNodes(:, 2) == cutTarget(i));

        for j = 1:length(x)

            if (find(cutTarget == endNodes(x(j), 1)))
            else
                % 如果邻居节点不在集合A中，说明这条边是从集合A到集合A之外的边
                disp([num2str(endNodes(x(j), 1)), '-->', num2str(endNodes(x(j), 2))]);
            end

        end

    end

end
