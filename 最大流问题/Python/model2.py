# 导入scipy库
import scipy.sparse as sp
import scipy.sparse.csgraph as spg


def get_input():
    print("-" * 80)
    # 读取用户输入
    n = int(input("请输入方阵的阶数 n:"))
    print("请输入%d行%d列的容量矩阵:（每次输入1行，用空格分隔）" % (n, n))

    # 读取矩阵
    matrix = []
    for i in range(n):
        line = input().split()
        line = [int(x) for x in line]
        matrix.append(line)

    print("请输入%d行%d列的流量矩阵:（每次输入1行，用空格分隔）" % (n, n))
    matrix2 = []
    for i in range(n):
        line = input().split()
        line = [int(x) for x in line]
        matrix2.append(line)
    return matrix, n


def ford_fulkerson(matrix, n):
    graph = sp.csr_matrix(matrix)  # 将矩阵转化为稀疏矩阵，便于函数调用
    # 调用现有的最大流计算函数，传入图、源点和汇点的索引，返回一个最大流结果对象
    result = spg.maximum_flow(graph, source=0, sink=n - 1)

    # 生成残余图，表示正向残余容量
    residual = graph - result.flow

    source = 0

    # 逐个检查节点，找到所有与源点连通的节点
    visited = set()
    stack = [source]  # 存储待检查的节点
    while stack:
        node = stack.pop()
        if node not in visited:
            visited.add(node)
            for neighbor in residual[node].indices:
                if residual[node, neighbor] > 0:  # 如果邻居节点与当前节点之间有正向残余容量
                    stack.append(neighbor)  # 将邻居节点加入待检查栈

    # 存储最小割的边
    min_cut = set()

    # 检查所有已访问的节点
    for node in visited:
        # 遍历原始图中该节点的邻居节点
        for neighbor in graph[node].indices:
            # 如果邻居节点不在集合A中，说明这条边是从集合A到集合A之外的边
            if neighbor not in visited:
                # 将这条边加入最小割集合
                min_cut.add((node, neighbor))

    return result, min_cut


def result_print(result, min_cut):
    # 打印最小割的边
    print("")
    print("最小割：")
    for edge in min_cut:
        print("v%d -> v%d" % (edge[0], edge[1]))
    # 打印最大流的值和流量分配情况
    print("最大流：", result.flow_value)
    print("-" * 80)


def main():
    # 获取用户输入
    matrix, n = get_input()
    # 计算最大流和最小割
    result, min_cut = ford_fulkerson(matrix, n)
    # 输出结果
    result_print(result, min_cut)


if __name__ == '__main__':
    main()
