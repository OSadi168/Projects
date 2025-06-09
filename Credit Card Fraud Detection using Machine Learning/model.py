import pickle

import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier, VotingClassifier


credit_card_data = pd.read_csv('creditcard_2023.csv')

Real = credit_card_data[credit_card_data.Class == 0]
Fraud = credit_card_data[credit_card_data.Class == 1]

credit_card_data.groupby('Class').mean()

#Data Split
df_sample, _ = train_test_split(credit_card_data, train_size=0.5, stratify=credit_card_data['Class'], random_state=42)

X = df_sample.drop (columns ='Class', axis = 1)
Y = df_sample['Class']

#Split Data into train and test set
X_train, X_test, Y_train, Y_test = train_test_split(X,Y, test_size =0.2, stratify =Y, random_state = 2 )

ranf = RandomForestClassifier(n_estimators=100, random_state=42)
gbc = GradientBoostingClassifier(n_estimators=100, learning_rate=0.1, random_state=42)

ranf.fit(X_train, Y_train)  # Unscaled data
gbc.fit(X_train, Y_train)    # Unscaled data


ensemble = VotingClassifier(estimators=[
 #   ('lr', log_reg),
    ('rf', ranf),
    ('gb', gbc)
], voting='hard')

ensemble.fit(X_train, Y_train)

pickle.dump(ensemble, open("model.pkl", "wb"))
