# 导入分数和矩阵模块
from fractions import Fraction as f
import numpy as np


def get_input():
    # 读取用户输入
    print("-" * 80)
    print("请输入增广矩阵:（每次输入1行，用空格分隔，输入结束后回车即可）")

    # 读取矩阵
    matrix = []
    line = input().split()
    while line != []:
        try:
            matrix.append(line)
            line = input().split()
        except EOFError:
            print("输入有误")

    data = [list(map(f, row)) for row in matrix]  # 将字符串分数类型
    matrix = np.array(matrix, dtype='float64')  # 转化为矩阵类型

    global m, n
    m, n = matrix.shape  # 获取矩阵的shape

    base_variables = np.where(matrix[-1, :] == 0)[0] + 1  # 获取基变量下标
    base_variables = np.delete(base_variables, -1)  # 删除最后一个元素，即删除0
    base_variables = base_variables.tolist()  # 将numpy数组转化为列表

    return data, matrix, base_variables  # 返回矩阵和基变量下标


# 判断是否达到最优解，即检验数是否都小于等于零
def judge(matrix):
    if max(matrix[-1][:-1]) <= 0:  # 最后一行除了b列的所有检验数
        result = False  # 如果都小于等于零，返回False表示已经是最优解
    else:
        result = True  # 如果有大于零的检验数，返回True表示还可以继续迭代
    return result


# 转轴操作，从一个基可行解转换到相邻的基可行解
def pivot(data, matrix, base_variables):
    max_value = max(matrix[-1][:-1])  # 找到最大的检验数
    column_index = data[-1].index(max_value)  # 找到最大检验数对应的列标，即入基变量的下标
    theta_values = {}
    for constraint in data[:-1]:
        if constraint[column_index] > 0:  # 如果入基变量的系数大于零，说明可以作为出基变量的候选
            theta = constraint[-1] / constraint[
                column_index]  # 计算θ值，即b值除以入基变量的系数
            theta_values[theta] = data.index(constraint)
    pivot_row = theta_values[min(theta_values)]  # 找到最小的θ值对应的行标，即出基变量的下标
    matrix[pivot_row] = matrix[pivot_row] / matrix[pivot_row][
        column_index]  # 将出基变量所在的行除以入基变量的系数，得到新的基变量所在的行
    for row in range(len(data)):
        if row != pivot_row:
            matrix[row] = matrix[row] - matrix[row][column_index] * matrix[
                pivot_row]  # 用高斯消元法将入基变量所在的列消为零
    base_variables[pivot_row] = column_index + 1
    data = [list(i) for i in matrix]
    return data, matrix, base_variables


# 定义一个函数，用于打印最优解和最优值
def out_put(matrix, base_variables):
    print('\n最优解为：')
    for i in range(1, n + 1):  # 遍历每个决策变量
        if i in base_variables:  # 如果是基变量
            print(
                'x{}={}'.format(
                    i,
                    f(str(matrix[base_variables.index(i)]
                          [-1])).limit_denominator()),  # 打印其对应的b值作为最优解，限制分母大小
                end='，')
        else:  # 如果不是基变量
            print('x{}={}'.format(i, 0), end='，')  # 打印0作为最优解
    print('\nz*={}'.format(f(
        str(-matrix[-1][-1])).limit_denominator()))  # 打印最后一行最后一列的负值作为最优值


# 定义一个主函数，用于调用其他函数并执行单纯形法求解过程
def main():
    data, matrix, base_variables = get_input()  # 获取输入数据

    while judge(matrix):  # 判断是否达到最优解，如果没有，继续迭代
        # 进行转轴操作，返回新的列表，矩阵和基变量下标
        data, matrix, base_variables = pivot(data, matrix, base_variables)

    out_put(matrix, base_variables)  # 打印最优解和最优值
    print("-" * 80)


# 如果当前文件是主文件，执行主函数
if __name__ == '__main__':
    main()
