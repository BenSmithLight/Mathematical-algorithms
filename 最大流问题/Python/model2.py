# 导入scipy库
import scipy.sparse as sp
import scipy.sparse.csgraph as spg


def get_input():
    print("-" * 80)
    # 读取用户输入
    n = int(input("请输入方阵的阶数 n:"))
    print("请输入%d行%d列的矩阵:（每次输入1行，用空格分隔）" % (n, n))
    # 读取矩阵
    matrix = []
    for i in range(n):
        line = input().split()
        line = [int(x) for x in line]
        matrix.append(line)
    return matrix, n


def ford_fulkerson(matrix, n):
    # 创建一个有向图，每条边有一个非负容量
    # 用一个稀疏矩阵来表示图，其中每个非零元素表示边的容量
    # 0号节点是源点，5号节点是汇点，其他节点是中间节点

    # graph = sp.csr_matrix([
    #     [0, 12, 8, 0, 0, 0, 0],  # 从0号节点出发的边
    #     [0, 0, 2, 4, 5, 0, 0],  # 从1号节点出发的边
    #     [0, 0, 0, 0, 0, 6, 0],  # 从2号节点出发的边
    #     [0, 0, 3, 0, 2, 2, 0],  # 从3号节点出发的边
    #     [0, 0, 0, 0, 0, 0, 10],  # 从4号节点出发的边
    #     [0, 0, 0, 0, 3, 0, 10],  # 从5号节点出发的边
    #     [0, 0, 0, 0, 0, 0, 0],  # 汇点没有出发的边
    # ])

    print("计算中...")
    graph = sp.csr_matrix(matrix)

    # 调用maximum_flow函数，传入图、源点和汇点，返回一个最大流结果对象
    result = spg.maximum_flow(graph, source=0, sink=n - 1)

    # 创建一个残余图，即每条边的残余容量等于原始容量减去流量
    residual = graph - result.flow

    # 定义一个深度优先搜索函数，返回从源点可达的节点集合
    def dfs(residual_graph, source):
        visited = set() # 存储已访问过的节点
        stack = [source] # 存储待访问的节点
        while stack: # 当栈不为空时循环
            node = stack.pop() # 弹出栈顶元素作为当前节点
            if node not in visited: # 如果当前节点没有被访问过
                visited.add(node) # 将当前节点加入已访问集合
                for neighbor in residual_graph[node].indices: # 遍历当前节点在残余图中的邻居节点
                    if residual_graph[node, neighbor] > 0: # 如果邻居节点与当前节点之间有正向残余容量
                        stack.append(neighbor) # 将邻居节点加入待访问栈
        return visited # 返回已访问集合

    # 调用深度优先搜索函数，找出从源点可达的节点集合A
    A = dfs(residual_graph=residual, source=0)

    # 打印集合A中的节点编号
    # print("The reachable nodes from the source are:", A)

    # 初始化一个空集合，用来存储最小割的边
    min_cut = set()

    # 遍历集合A中的每个节点
    for node in A:
        # 遍历原始图中该节点的邻居节点
        for neighbor in graph[node].indices:
            # 如果邻居节点不在集合A中，说明这条边是从集合A到集合A之外的边
            if neighbor not in A:
                # 将这条边加入最小割集合
                min_cut.add((node, neighbor))

    # 打印最小割集合中的边
    print("最小割：")
    for edge in min_cut:
        print("v%d -> v%d" % (edge[0], edge[1]))
    
    return result



def result_print(result):
    # 打印最大流的值和流量分配情况
    print("最大流：\t", result.flow_value)
    print("-" * 80)


def main():
    matrix, n = get_input()
    result = ford_fulkerson(matrix, n)
    result_print(result)


if __name__ == '__main__':
    main()
