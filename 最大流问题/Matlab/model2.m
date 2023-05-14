% 最大流问题求解
clc;
clear;

%% 用户输入
disp('请输入方向图：')
disp('方向图示例1：')
disp('[1 1 2 2 3 4 4 5 5]')
disp('[2 3 3 4 5 3 6 4 6]')
disp('[8 7 5 9 9 2 5 6 10]')

disp('方向图示例2：')
disp('[1 1 2 2 2 3 4 4 4 5 6 6]')
disp('[2 3 3 4 5 6 3 5 6 7 5 7]')
disp('[12 8 2 4 5 6 3 2 2 10 3 10]')

disp("上述三个数按列对应，例如第一列表示：从1到2流量为8（1为起始节点，最大编号为终点）")

s = input('');
t = input('');
weights = input('');
n = max(t);

G = digraph(s,t,weights);
plot(G,'EdgeLabel',G.Edges.Weight,'Layout','layered');

[mf,~,cs,ct] = maxflow(G,1,n,"augmentpath");
H = plot(G,'Layout','layered','Sources',cs,'Sinks',ct, ...
    'EdgeLabel',G.Edges.Weight);
highlight(H,cs,'NodeColor','red')
highlight(H,ct,'NodeColor','green')
disp(['最大流：', num2str(mf)]);
endnodes = G.Edges.EndNodes;
disp('最小割：')
for i = 1:length(ct)
    if(find(endnodes(:,2) == ct(i)))
        [x, y] = find(endnodes(:,2) == ct(i));
        for j = 1:length(x)
            if(find(ct == endnodes(x(j), 1)))
                
            else
                disp([num2str(endnodes(x(j), 1)), '-->', num2str(endnodes(x(j), 2))]);
            end
        end
    end
end