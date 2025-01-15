
import streamlit as st
import pandas as pd
import altair as alt
import plotly.express as px  # interactive charts


st.set_page_config(
    page_title="Water - contaminants and levels Dashboard",
    #page_icon="",
    layout="wide",
    initial_sidebar_state="expanded")


# dashboard title
st.title("Water - contaminants and levels Dashboard")
st.markdown("---------------------------------------------------------------")


#read the file
Mod_data = pd.read_csv('integrated_water_related_data.csv')


st.markdown("""
<style>
.big-font {  font-size:25px !important; }
</style>
""", unsafe_allow_html=True)

st.markdown("""
<style>
.mid-font {  font-size:20px !important; }
</style>
""", unsafe_allow_html=True)

st.markdown('<p class="mid-font">Study of water contaminants has shed light on the pivotal role of wastewater as the strongest global metric impacting various facets of the environment and human health</p>', unsafe_allow_html=True)

st.markdown('<p class="big-font">Wastewater discharge comprises of three different sources </p>', unsafe_allow_html=True )
st.markdown('<p class="mid-font">1. Agricultural</p>', unsafe_allow_html=True )
st.markdown('<p class="mid-font">2. Urban</p>', unsafe_allow_html=True )
st.markdown('<p class="mid-font">3. Industrial</p>', unsafe_allow_html=True )
st.subheader("")
st.subheader("")

st.markdown('<p class="big-font">Breakdown of Total Wastewater discharged without treatment</p>', unsafe_allow_html=True)

st.bar_chart(Mod_data, x='Entity', y = ["Agricultural (incl. forestry + fisheries) wastewater, all sources, direct discharges(million m3)", "Urban wastewater, all sources, discharged without treatment(million m3)","Industrial wastewater, all sources, discharged without treatment(million m3)"] )


st.subheader("Interconnectedness between Wastewater contamination and adverse impacts")

st.markdown("")
st.markdown("")


button_col1, button_col2 = st.columns(2)
with button_col1:
                if st.button("Public health"):
                    st.switch_page("pages/Public_Health.py")
with button_col2:
                if st.button("Ecosystem"):
                     st.switch_page("pages/Ecosystem.py")




st.markdown("")
st.markdown("")


st.subheader("Countries having Wastewater discharged without treatment")
st.map(Mod_data, size = 100, color='#0044ff')


st.markdown("")


st.subheader("HeatMap and Histogram of Total Wastewater discharged without treatment")


fig_col1, fig_col2 = st.columns(2)

with fig_col1:
    st.markdown("HEATMAP")
    fig = px.density_heatmap(
        data_frame=Mod_data, y="Entity", x="Total Wastewater"
    )
    st.write(fig)
   
with fig_col2:
    st.markdown("HISTOGRAM")
    fig2 = px.histogram(data_frame=Mod_data, x="Total Wastewater")
    st.write(fig2)



st.markdown("")


st.subheader('Thank you for visiting :smiley:')


