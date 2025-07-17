# NYC Transportation: Congestion Pricing Cuts School Bus Delays in Manhattan

Read the story [here](https://ashley-yihui-lee.github.io/school-bus/)

This story looks at how congestion pricing, launched in January 2025, helped reduce school bus delays caused by heavy traffic in Manhattan — but delays continue to plague the city.

Using R, I cleaned and analyzed NYC’s “Bus Breakdown and Delays” dataset from January to June (2024 and 2025), focusing on delays due to heavy traffic. I grouped and compared the data by year, borough, and delay duration.

In `school-bus.R`, I:
- Filtered the data by month, reason, and borough
- Summarized total delays by month and year
- Calculated percent change in delays (Manhattan vs. other boroughs)
- Broke down delays by duration (e.g. 0–15 min, 16–30 min, etc.)
- Created three charts using `ggplot2`

**Limitation:**  
The dataset does not include exact bus routes, so I cannot determine which buses actually passed through the congestion pricing zone.

**Data source:**  
[NYC Open Data – Bus Breakdown and Delays](https://data.cityofnewyork.us/Transportation/Bus-Breakdown-and-Delays/ez4e-fazm)  
File: `Bus_Breakdown_and_Delays_20250707.csv`
