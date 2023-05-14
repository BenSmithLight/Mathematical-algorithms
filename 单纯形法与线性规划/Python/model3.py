# 导入分数和矩阵模块
from fractions import Fraction as f
import numpy as np


# 获取用户输入的单纯形表
def getinput():
    # 定义全局变量m和n，分别表示约束条件的个数和决策变量的个数
    global m, n
    # 获取用户输入的字符串，以分号分隔每一行，以空格分隔每一列
    print("-" * 80)
    string = input('''
 输入初始单纯形表
 示例：2 2 1 0 0 12;4 0 0 1 0 16;0 5 0 0 1 15;2 3 0 0 0 0
 前m行为约束系数矩阵，最后一行为目标函数系数矩阵。随后依次输入基变量下标3，4，5
 输入：''')
    # 将字符串转化为二维列表，每个元素为分数类型
    data = [list(map(f, row.split())) for row in string.split(';')]
    # 将二维列表转化为矩阵类型，方便进行运算
    matrix = np.array(data)
    # 获取矩阵的行数和列数
    m, n = matrix.shape
    # 减去最后一行和最后一列，得到约束条件的个数和决策变量的个数
    n -= 1
    m -= 1
    # 打印目标函数，最后一行除了最后一列的所有元素为目标函数的系数，负号表示最小化问题
    print('\n输入的目标函数为')
    x = [f'{matrix[-1,j]}*x_{j+1}' for j in range(n)]
    print('max z = ' + ' + '.join(x))
    # 打印约束条件，前m行为约束条件的增广矩阵，最后一列为常数项
    print('\n输入的方程为')
    for i in range(m):
        x = [f'{matrix[i,j]}*x_{j+1}' for j in range(n)]
        print(' + '.join(x), f'={matrix[i,-1]}')
    print("")
    # 返回二维列表data作为输入数据
    return data


# 定义一个函数，用于判断是否达到最优解，即检验数是否都小于等于零
def judge(matrix):
    if max(matrix[-1][:-1]) <= 0:  # 最后一行除了b列的所有检验数
        flag = False  # 如果都小于等于零，返回False表示已经是最优解
    else:
        flag = True  # 如果有大于零的检验数，返回True表示还可以继续迭代
    return flag

# 定义一个函数，用于进行转轴操作，即从一个基可行解转换到相邻的基可行解
def trans(data, matrix, vect):  #转轴
    maxi = max(matrix[-1][:-1])  # 找到最大的检验数
    index = data[-1].index(maxi)  # 找到最大检验数对应的列标，即入基变量的下标
    l = {}  # 定义一个空字典，用于存储每个约束条件的θ值和对应的行标
    for i in data[:-1]:  # 遍历每个约束条件
        if i[index] > 0:  # 如果入基变量的系数大于零，说明可以作为出基变量的候选
            l[i[-1] / i[index]] = data.index(
                i)  # 计算θ值，即b值除以入基变量的系数，并存入字典中，键为θ值，值为行标
    pivot = l[min(l)]  # 找到最小的θ值对应的行标，即出基变量的下标
    matrix[pivot] = matrix[pivot] / matrix[pivot][
        index]  # 将出基变量所在的行除以入基变量的系数，得到新的基变量所在的行
    for i in range(len(data)):  # 遍历每一行
        if i != pivot:  # 如果不是出基变量所在的行
            matrix[i] = matrix[i] - matrix[i][index] * matrix[
                pivot]  # 用高斯消元法将入基变量所在的列消为零
    vect[pivot] = index + 1  # 基变量下标变化，用入基变量替换出基变量
    data = [list(i) for i in matrix]  #把原来的列表也同时变换掉，为了方便索引
    return data, matrix, vect  # 返回新的列表，矩阵和基变量下标


# 定义一个函数，用于打印最优解和最优值
def print_solution(matrix, vect):
    print('\n最优解为：')
    for i in range(1, n + 1):  # 遍历每个决策变量
        if i in vect:  # 如果是基变量
            print(
                'x{}={}'.format(
                    i,
                    f(str(matrix[vect.index(i)]
                          [-1])).limit_denominator()),  # 打印其对应的b值作为最优解，限制分母大小
                end='，')
        else:  # 如果不是基变量
            print('x{}={}'.format(i, 0), end='，')  # 打印0作为最优解
    print('\nz*={}'.format(f(
        str(-matrix[-1][-1])).limit_denominator()))  # 打印最后一行最后一列的负值作为最优值


# 定义一个主函数，用于调用其他函数并执行单纯形法求解过程
def main():
    data = getinput()  # 获取输入数据，返回二维列表a
    matrix = np.array(data, dtype=np.float64)  #将二维列表转化为矩阵类型，方便进行运算
    vect = [int(input('设置基变量下标')) for i in range(m)]  # 获取用户输入的基变量下标，返回一个列表vect
    while judge(matrix):  # 判断是否达到最优解，如果没有，继续迭代
        data, matrix, vect = trans(data, matrix,
                                   vect)  # 进行转轴操作，返回新的列表，矩阵和基变量下标
    print_solution(matrix, vect)  # 打印最优解和最优值
    print("-" * 80)


# 如果当前文件是主文件，执行主函数
if __name__ == '__main__':
    main()
