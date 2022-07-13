import pandas as pd
import matplotlib.pyplot as plt

algorithms = ['crm', 'crm-rs', 'hrm', 'hrm-rs', 'ql', 'ql-rs']
# plot_index = 4
for plot_index in range(len(algorithms)):
    for i in range(20):
        df = pd.read_csv('../my_results_baseline/' + algorithms[plot_index] +'/office-single/M1/' + str(i) + '/progress.csv')
        df = df[{'steps', 'total reward'}]
        df.rename(columns = {'total reward':str(i)}, inplace = True)
        if i == 0:
            df_last = df
        else:
            df_last = pd.merge(df_last, df, on='steps')
    df_last = df_last.drop(columns = ['steps'])
    steps = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100] # thousands
    df_last['mean'] = df_last.mean(axis = 1)
    df_last['std'] = df_last.std(axis = 1)
    df_last['x'] = pd.DataFrame(data=steps)
    # print(df_last)

    plt.plot(df_last['x'], df_last['mean'], label=algorithms[plot_index])
    plt.fill_between(df_last['x'], df_last['mean'] + df_last['std'], df_last['mean'] - df_last['std'], alpha=0.2)

plt.legend()
plt.show()

# fig, ax = plt.subplots()
# ax.set_title(algorithms[plot_index])
