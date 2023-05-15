% 最大流问题求解
clc;
clear;

%% 获取用户输入并进行格式转换
[cost_matrix, s, t, weights] = get_input();

%% 开始计算
n = max(t);

G = digraph(s, t, weights);
plot(G, 'EdgeLabel', G.Edges.Weight, 'Layout', 'layered');

[mf, ~, cs, ct] = maxflow(G, 1, n, "augmentpath");
H = plot(G, 'Layout', 'layered', 'Sources', cs, 'Sinks', ct, ...
    'EdgeLabel', G.Edges.Weight);
highlight(H, cs, 'NodeColor', 'red')
highlight(H, ct, 'NodeColor', 'green')
disp(['最大流：', num2str(mf)]);
endnodes = G.Edges.EndNodes;
disp('最小割：')

for i = 1:length(ct)

    if (find(endnodes(:, 2) == ct(i)))
        [x, y] = find(endnodes(:, 2) == ct(i));

        for j = 1:length(x)

            if (find(ct == endnodes(x(j), 1)))

            else
                disp([num2str(endnodes(x(j), 1)), '-->', num2str(endnodes(x(j), 2))]);
            end

        end

    end

end
