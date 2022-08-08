import pandas as pd
import matplotlib.pyplot as plt

algorithms = ['hrm', 'hrm-bt-rs', 'hrm-rs', 'hrm-rs-bt-rs', 'hrm-rs-wpk', 'hrm-wpk' ] # ['crm', 'crm-rs', 'hrm', 'hrm-rs', 'ql', 'ql-rs'] # 
for plot_index in range(len(algorithms)):
    for i in range(10):
        df = pd.read_csv('../../results/my_results_bt_rs/' + algorithms[plot_index] +'/office-single/M1/' + str(i) + '/progress.csv')
        df = df[{'steps', 'total reward'}]
        df.rename(columns = {'total reward':str(i)}, inplace = True)
        if i == 0:
            df_last = df
        else:
            df_last = pd.merge(df_last, df, on='steps')
    steps = df_last['steps'].copy()
    df_last = df_last.drop(columns = ['steps'])
    df_last['mean'] = df_last.mean(axis = 1)
    df_last['std'] = df_last.std(axis = 1)
    df_last['x'] = pd.DataFrame(data=steps)
    # print(df_last)

    plt.plot(df_last['x'], df_last['mean'], label=algorithms[plot_index])
    plt.fill_between(df_last['x'], df_last['mean'] + df_last['std'], df_last['mean'] - df_last['std'], alpha=0.2)

plt.legend()
plt.show()
