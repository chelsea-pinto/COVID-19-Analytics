# COVID-19: Impact and Response Analytics

## Summary
This dataset contains comprehensive data on COVID-19, including deaths, cases, vaccinations, stringency measures, general health indicators, and life expectancy metrics. Our goal is to develop a dashboard that provides insights into the current pandemic situation on a country or global scale. The analysis also covers factors influencing mortality, countermeasures in place, and their effectiveness. This project utilizes **SQL Server**, **Python**, and **Tableau** for data processing and visualization.

## Key Details
### SQL

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;◦ Executed queries on SQL Server to identify and handle invalid values.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;◦ Measured Case Fatality Rate (CFR) and Incidence Rate, on a country and global level, across different time periods.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;◦  Measured the percentage of vaccinated populations at local and global levels.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;◦ Identified countries with the highest COVID-19 cases.

### Python

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;◦ Used the pyodbc library to connect to the SQL database.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;◦ Examined factors affecting COVID-19 mortality by measuring and analyzing correlations between vaccination rates and death rates.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;◦ Investigated variations in correlation across countries, considering factors such as population density, government policies, and healthcare infrastructure.

### Tableau

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;◦ Designed visualizations to illustrate the effect of the Stringency Index (government policy strictness) on virus incidence rates.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;◦ Created interactive graphs depicting key COVID-19 impact and response metrics derived from SQL calculations.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;◦ Developed a dynamic dashboard summarizing Python-driven analytical findings.

## Dataset

**Source:** Our World in Data

**Size:** 81,060 rows

## Tech Stack

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ◦**Python**: pyodbc, matplotlib, seaborn, pandas

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ◦**SQL Server**

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ◦**Tableau**


## Analysis & Results

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ◦**Vaccination & Mortality:** An inverse correlation exists between vaccination rates and COVID-19 mortality in most countries. However, this relationship is influenced by factors such as population density, healthcare quality, and accessibility.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ◦**Stringency & Incidence Rate:** For countries like India and the U.S., findings indicate that increased government stringency measures contributed to a decline in virus spread when implemented effectively.

This project provides actionable insights into the pandemic's impact and response strategies, offering valuable information for policymakers, healthcare professionals, and researchers.

