import streamlit as st
import matplotlib.pyplot as plt 
import pandas as pd
import altair as alt
import plotly.express as px  # interactive charts


# Page title
st.title("Ecosystem impacted due to Wastewater")
st.markdown("---------------------------------------------------------------")


#read the file
Mod_data = pd.read_csv("integrated_water_related_data.csv")



#Create a sidebar for year dropdown selection
with st.sidebar:
     st.title('Water - contaminants and levels Dashboard')
    
     years = list(Mod_data.Year.unique())[::-1]
    
     selected_year = st.selectbox('Select year to view', years)
     df_year_selected = Mod_data[Mod_data.Year == selected_year]
     df_year_selected_sorted = df_year_selected.sort_values(by="Entity", ascending=False)


st.markdown("")
st.markdown("")



st.subheader("Correlation between Total Wastewater discharged without treatment and Total discharges to Inland waters for selected year")
st.markdown("")
st.line_chart(df_year_selected, x="Entity", y=["Total Wastewater","Total discharges to Inland waters(million m3)" ], color=["#FF0000", "#0000FF"]  # Optional
)
st.markdown("")
st.markdown("")


st.subheader("Correlation between Total Wastewater discharged without treatment and Total discharges to the sea for selected year")
st.markdown("")
st.line_chart(df_year_selected, x="Entity", y=["Total Wastewater","Total discharges to the sea(million m3)" ], color=["#FF0000", "#0000FF"]  # Optional
)
st.markdown("")
st.markdown("")

st.subheader("Correlation between  Total Wastewater, Total discharges to the sea and Total discharges to Inland waters from 2015-2019")
st.markdown("")
st.scatter_chart(Mod_data, x="Entity", y=["Total Wastewater","Total discharges to the sea(million m3)","Total discharges to Inland waters(million m3)" ], color=["#FF0000", "#0000FF","#0CC80C"]  # Optional
)

st.markdown("")




