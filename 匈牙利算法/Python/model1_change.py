import numpy as np
import collections
import time


def calculate(cost_matrix):
    # 初始化变量
    matrix = np.array(cost_matrix)
    col = matrix.shape[1]
    row = matrix.shape[0]
    size = len(matrix)
    shape = matrix.shape
    results = []
    totalPotential = 0
    result_matrix = matrix.copy()

    # Step 1：归约
    for index in range(len(result_matrix)):
        row = result_matrix[index]
        # 每一行减去本行的最小值
        result_matrix[index] -= min(row)

    for index in range(len(result_matrix.T)):
        column = result_matrix.T[index]
        # 每一列减去本行的最小值
        result_matrix[:, index] -= min(column)

    # Step 2：试指派
    total_covered = 0
    while total_covered < size:
        # 初始化参数
        zero_locations = (result_matrix == 0)
        zero_locations_copy = zero_locations.copy()
        zero_shape = result_matrix.shape
        covered_rows = []
        covered_cols = []
        ticked_row = []
        ticked_col = []
        marked_zeros = []

        # 试指派并标记独立零元素
        while True:
            if True not in zero_locations_copy:
                break
            # 扫描矩阵每一行，找到含0元素最少的行，对任意0元素标记（独立零元素），划去标记0元素（独立零元素）所在行和列存在的0元素
            min_row_zero_nums = [9999999, -1]
            for index in range(len(zero_locations_copy)):
                row = zero_locations_copy[index]
                row_zero_nums = collections.Counter(row)[True]
                if row_zero_nums < min_row_zero_nums[0] and row_zero_nums != 0:
                    min_row_zero_nums = [row_zero_nums, index]
            # 最少0元素的行
            row_min = zero_locations_copy[min_row_zero_nums[1], :]
            # 找到此行中任意一个0元素的索引位置即可
            row_indices, = np.where(row_min)
            # 标记该0元素
            marked_zeros.append((min_row_zero_nums[1], row_indices[0]))
            # 划去该0元素所在行和列存在的0元素
            zero_locations_copy[:, row_indices[0]] = np.array(
                [False for _ in range(zero_shape[0])])
            zero_locations_copy[min_row_zero_nums[1], :] = np.array(
                [False for _ in range(zero_shape[0])])

        # 无被标记0（独立零元素）的行打勾
        independent_zero_row_list = []
        for pos in marked_zeros:
            independent_zero_row_list.append(pos[0])
        ticked_row = list(
            set(range(zero_shape[0])) - set(independent_zero_row_list))

        # 重复3,4直到不能再打勾
        TICK_FLAG = True
        while TICK_FLAG:
            TICK_FLAG = False
            # 对打勾的行中所含0元素的列打勾
            for row in ticked_row:
                # 找到此行
                row_array = zero_locations[row, :]
                # 找到此行中0元素的索引位置
                for i in range(len(row_array)):
                    if row_array[i] == True and i not in ticked_col:
                        ticked_col.append(i)
                        TICK_FLAG = True

            # 对打勾的列中所含独立0元素的行打勾
            for row, col in marked_zeros:
                if col in ticked_col and row not in ticked_row:
                    ticked_row.append(row)
                    FLAG = True

        # 对打勾的列和没有打勾的行画画线
        covered_rows = list(set(range(zero_shape[0])) - set(ticked_row))
        covered_cols = ticked_col

        single_zero_pos_list = marked_zeros
        total_covered = len(covered_rows) + len(covered_cols)

        # 如果划线总数不等于矩阵的维度需要进行矩阵调整（需要使用未覆盖处的最小元素）
        if total_covered < size:
            # 计算未被覆盖元素中的最小值（m）
            elements = []
            for row_index, row in enumerate(result_matrix):
                if row_index not in covered_rows:
                    for index, element in enumerate(row):
                        if index not in covered_cols:
                            elements.append(element)
            min_uncovered_num = min(elements)
            #未被覆盖元素减去最小值m
            for row_index, row in enumerate(result_matrix):
                if row_index not in covered_rows:
                    for index, element in enumerate(row):
                        if index not in covered_cols:
                            result_matrix[row_index,
                                          index] -= min_uncovered_num

            #行列划线交叉处加上最小值m
            for row_ in covered_rows:
                for col_ in covered_cols:
                    result_matrix[row_, col_] += min_uncovered_num

    results = single_zero_pos_list
    # 计算总期望结果
    value = 0
    for row, column in single_zero_pos_list:
        value += matrix[row, column]
    totalPotential = value

    return results, totalPotential


def output(results, totalPotential):
    print("\n计算中...")
    print("最优值为：\t", totalPotential)
    print("最优解为：\t ", end="")
    for i in results:
        temp = list(i)
        temp[0] = temp[0] + 1
        temp[1] = temp[1] + 1
        print("x_%d%d=" % (temp[0], temp[1]), end="")
    print("1", end="  ")
    print("其余变量均为0")
    print("-" * 80)


def get_input():
    # 读取用户输入
    print("-" * 80)
    n = int(input("请输入方阵的阶数 n:"))
    print("请输入%d行%d列的矩阵:（每次输入1行，用空格分隔）" % (n, n))
    # 读取矩阵
    matrix = []
    for i in range(n):
        line = input().split()
        line = [int(x) for x in line]
        matrix.append(line)
    return matrix


if __name__ == '__main__':
    # 获取用户输入
    cost_matrix = get_input()
    # 开始计算
    results, totalPotential = calculate(cost_matrix)
    # 输出结果
    output(results, totalPotential)
