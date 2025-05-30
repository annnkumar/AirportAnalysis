


# Airport Traffic Analysis Project

report link : https://github.com/user-attachments/assets/0769a7e8-2c75-42a2-b604-939a989131d5

A comprehensive analysis of airport traffic data, including flight statistics, passenger volumes, and route analysis. This project includes data processing, visualization, and interactive dashboards.

## 📊 Project Overview

This project analyzes airport traffic data to provide insights into flight patterns, passenger volumes, and route efficiency. The analysis is presented through interactive visualizations and a web-based dashboard.



## 📈 Datasets

### 1. Flight Data (`Airports2 dataset.csv`)
**Note**: This file is not included in the repository due to size limitations.

**Dataset Description**:
- Contains detailed flight information between various airports
- Includes passenger counts, flight frequencies, and seat availability
- Covers a specific time period (needs to be specified based on your data)

**Columns**:
- `Origin_airport`: IATA code of departure airport
- `Destination_airport`: IATA code of arrival airport
- `Origin_city`: City of departure
- `Destination_city`: City of arrival
- `Passengers`: Number of passengers
- `Seats`: Total seats available
- `Flights`: Number of flights
- `Distance`: Distance between airports (in miles/km)
- `Fly_date`: Date of flight
- `Origin_population`: Population of origin city
- `Destination_population`: Population of destination city
- `Org_airport_lat`: Latitude of origin airport
- `Org_airport_long`: Longitude of origin airport
- `Dest_airport_lat`: Latitude of destination airport
- `Dest_airport_long`: Longitude of destination airport

## 🛠️ Setup and Installation

1. **Prerequisites**:
   - Python 3.7+
   - MySQL Server (for database operations)
   - Required Python packages (install using `pip install -r requirements.txt`)

2. **Installation**:
   ```bash
   # Clone the repository
   git clone https://github.com/annnkumar/AirportAnalysis.git
   cd AirportAnalysis
   
   # Install dependencies
   pip install -r requirements.txt
   
   # Set up the database (see Database Setup section)
   ```

3. **Database Setup**:
   - Create a MySQL database named `AirportAnalysis`
   - Run the SQL script to create necessary tables:
     ```bash
     mysql -u your_username -p AirportAnalysis < AirportAnalysisMysqlFile.sql
     ```
   - Import your flight data into the database

## 🚀 Running the Application

1. Start the Dash web application:
   ```bash
   python app.py
   ```

2. Open your web browser and navigate to:
   ```
   http://127.0.0.1:8050/
   ```

## 📊 Features

- Interactive dashboards with real-time data visualization
- Time series analysis of flight data
- Geographic visualization of flight routes
- Key performance indicators (KPIs) for quick insights
- Responsive design for different screen sizes

## 📝 Jupyter Notebook

The `AirportProject.ipynb` contains the initial data analysis, including:
- Data cleaning and preprocessing
- Exploratory data analysis
- Visualization of key metrics
- Statistical analysis

## 📊 Power BI Report

**Note**: The Power BI report (`airportreport.pbix`) is not included in the repository due to size limitations.

The report includes:
- Interactive dashboards
- Advanced visualizations
- Data modeling and transformations
- Business intelligence insights

