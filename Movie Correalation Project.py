#!/usr/bin/env python
# coding: utf-8

# In[7]:


# import libraries

import pandas as pd
import seaborn as sns
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
plt.style.use('ggplot')
from matplotlib.pyplot import figure

get_ipython().run_line_magic('matplotlib', 'inline')
matplotlib.rcParams['figure.figsize'] = (12,8) # Adjust the configuration of the plots crate


# Read in the data

df = pd.read_csv('/Users/kimip/Desktop/movies.csv')


# In[11]:


# Look at the data

#Top 5
df.head()


# In[17]:


# Look for missing data if there is

for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    print('{} - {}%'.format(col, pct_missing))
    
    
# finding null data


# Drop null data
df = df.dropna()

# Double Check > no null

for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    print('{} - {}%'.format(col, pct_missing))
    


# In[18]:


# Data types for our columns

df.dtypes


# In[21]:


# change data type of colums budget & gross

df['budget'] = df['budget'].astype('int64')

df['gross'] = df['gross'].astype('int64')

df


# In[29]:


# Create correct Year Column based on Released year

df['yearcorrect'] = df['released'].str.extract(pat = '([0-9]{4})').astype(int)

df


# In[71]:


#Sorting 


df.sort_values(by=['gross'], inplace = False, ascending = False)
pd.set_option('display.max_rows', None)
df


# In[36]:


# Drop any duplicates

df['company'].drop_duplicates().sort_values(ascending = False)


# In[70]:





# In[51]:


# Hypothesis
# Budget high correlation on gross
# Large/well-known Company will have highe correlation on gross

# Scatter plot with budget vs gross

plt.scatter(x = df['budget'], y = df['gross'])
plt.title('Budget vd Gross Earnings')
plt.xlabel('Budget')
plt.ylabel('Gross Earnings')
plt.show()


# In[58]:


# Plot budget vs gross using seaborn

sns.regplot( x = 'budget', y = 'gross', data = df, scatter_kws = {'color':'red'}, line_kws = {'color':'blue'})


# In[62]:


# Looking for Correlation
df.corr() #pearson, kendall, spearman


# In[64]:


# High Correlation between budget and gross 0.740247
correlation_matrix = df.corr()

# Visualize Correlation
sns.heatmap(correlation_matrix, annot = True)
plt.title('Correlation Matrix for Numeric Features')
plt.xlabel('Movie Features')
plt.ylabel('Movie Features')
plt.show()


# In[73]:


# Looking for Company Correlation between Gross

#Part 1
#numerized company name as number
df_numerized = df

for col_name in df_numerized.columns:
    if(df_numerized[col_name].dtype == 'object'):
        df_numerized[col_name]= df_numerized[col_name].astype('category')
        df_numerized[col_name]= df_numerized[col_name].cat.codes
        
df_numerized

#Part 2


# In[72]:


df


# In[74]:


# Correlation between Company and gross 
correlation_matrix = df_numerized.corr()

# Visualize Correlation
sns.heatmap(correlation_matrix, annot = True)
plt.title('Correlation Matrix for Numeric Features')
plt.xlabel('Movie Features')
plt.ylabel('Movie Features')
plt.show()


# In[83]:


# Filiter for highest Correaltion

correlation_mat = df_numerized.corr()

corr_pairs = correlation_mat.unstack()

sorted_pairs = corr_pairs.sort_values()

high_corr = sorted_pairs[(sorted_pairs) > 0.5]

high_corr

# No relation between company and gross earnings

# But Votes and gross have good correlation


# In[ ]:




