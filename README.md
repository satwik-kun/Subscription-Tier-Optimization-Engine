# Subscription-Tier-Optimization-Engine

# ⚡ InsightEdge - Feature Intelligence Dashboard

A comprehensive subscription management and analytics platform built with **Streamlit**, **MySQL**, and **Plotly** for real-time feature usage insights, user engagement tracking, and intelligent upgrade recommendations.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Database Schema](#database-schema)
- [Technology Stack](#technology-stack)
- [Prerequisites](#prerequisites)
- [Installation & Setup](#installation--setup)
- [Usage](#usage)
- [Dashboard Sections](#dashboard-sections)
- [SQL Highlights](#sql-highlights)
- [Project Structure](#project-structure)
- [Contributing](#contributing)
- [License](#license)

---

## 🎯 Overview

**InsightEdge** is a feature intelligence dashboard designed for subscription-based platforms. It provides actionable insights into:

- **Feature Usage Analytics**: Track which features are most engaging
- **User Segmentation**: Analyze user behavior across market segments
- **Revenue Correlation**: Understand tier-based engagement vs pricing
- **Upgrade Recommendations**: Identify high-engagement users for upselling
- **Retention Metrics**: Monitor feature retention rates
- **Activity Tracking**: Categorize users by engagement levels

This project demonstrates advanced database management techniques including triggers, stored procedures, user-defined functions, and complex SQL queries.

---

## ✨ Features

### 📊 Analytics & Visualization
- **Interactive Dashboards** with Plotly charts (bar charts, pie charts, scatter plots)
- **Real-time Data** fetched directly from MySQL database
- **8 Analytical Sections** covering different business intelligence aspects

### 🔍 Business Intelligence
- Top 5 most engaging features by total usage time
- Market segment ranking by average engagement
- Tier-price vs engagement correlation analysis
- User activity segmentation (Highly Active, Moderately Active, Low Activity)
- Feature retention rate calculations
- Above-average feature performance analysis (correlated subquery)

### 🛠️ Advanced SQL Features
- **Triggers**: Automatic system logging on user insertion
- **Stored Procedures**: `recommend_upgrade()` for high-engagement users
- **User-Defined Functions**: `avg_session_duration()`, `total_time_spent()`
- **Window Functions**: RANK() for segment performance
- **Correlated Subqueries**: Above-average feature detection
- **Access Control**: Role-based permissions (admin, analyst)

---

## 🗄️ Database Schema

The database `subsys_db` contains **9 core tables**:

### Core Tables

| Table | Description |
|-------|-------------|
| `User` | User profiles with tier and segment assignments |
| `Tier` | Subscription tiers (Free, Silver, Gold, Platinum, etc.) |
| `Feature` | Platform features (Analytics, API Access, Cloud Backup, etc.) |
| `Market_Segment` | User segments (Tech Enthusiasts, Students, Businesses, etc.) |
| `User_Activity` | Feature usage logs with timestamps and duration |
| `Tier_Features` | Many-to-many relationship between tiers and features |
| `User_Friends` | Social connections between users |
| `System_Log` | Automated activity logging via triggers |
| `Recommendation` | Personalized feature/tier recommendations |

### Key Relationships
- Users belong to one **Tier** and one **Market Segment**
- Tiers have multiple **Features** with usage restrictions
- User activities are tracked per **Feature**
- System logs are auto-generated via **trigger** on user insertion

---

## 💻 Technology Stack

| Layer | Technology |
|-------|-----------|
| **Frontend** | Streamlit 1.x |
| **Visualization** | Plotly Express |
| **Database** | MySQL 8.0+ |
| **Backend Logic** | Python 3.8+ |
| **Data Processing** | Pandas |
| **Connector** | mysql-connector-python |

---

## 📦 Prerequisites

Before running this project, ensure you have:

- **Python 3.8+** installed
- **MySQL Server 8.0+** running locally
- **pip** package manager

---

## 🚀 Installation & Setup

### 1. Clone the Repository
```bash
git clone <repository-url>
cd dbms-proj
```

### 2. Install Python Dependencies
```bash
pip install streamlit pandas mysql-connector-python plotly
```

### 3. Setup MySQL Database

#### Option A: Using SQL File
```bash
mysql -u root -p < subsys_project_full(1).sql
```

#### Option B: Manual Setup
1. Open MySQL Workbench or command line client
2. Run the SQL file `subsys_project_full(1).sql`
3. Verify database creation:
```sql
SHOW DATABASES;
USE subsys_db;
SHOW TABLES;
```

### 4. Configure Database Credentials

Edit `frontend.py` lines 16-19:
```python
def get_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",              # ← Your MySQL username
        password="your_password", # ← Your MySQL password
        database="subsys_db"
    )
```

### 5. Run the Application
```bash
streamlit run frontend.py
```

The dashboard will open automatically at `http://localhost:8501`

---

## 📖 Usage

### Starting the Dashboard
```bash
streamlit run frontend.py
```

### Navigation
Use the **sidebar** to navigate between 8 analytical sections:

1. 📊 **Feature Insights** - Top engaging features
2. 👥 **User Insights** - Segment-wise engagement
3. 💰 **Upgrade Recommendations** - High-engagement users
4. 🧠 **Correlation & Retention** - Tier-revenue correlation & feature retention
5. 🔥 **Activity Segmentation** - User activity distribution
6. ⚙ **System Logs** - Automated trigger logs
7. ⏱ **Session Analytics** - Average session duration calculator
8. 🎯 **Above-Average Features** - Correlated subquery analysis

---

## 📊 Dashboard Sections

### 1. Feature Insights (Query #2)
**Purpose**: Identify the top 5 most engaging features  
**Visualization**: Bar chart of total time spent per feature  
**Business Value**: Prioritize development resources

### 2. User Insights (Query #3)
**Purpose**: Rank market segments by engagement  
**Visualization**: Bar chart with RANK() window function  
**Business Value**: Target marketing campaigns

### 3. Upgrade Recommendations (Stored Procedure)
**Purpose**: Find users with >50 min avg engagement  
**SQL Feature**: `CALL recommend_upgrade()`  
**Business Value**: Identify upsell candidates

### 4. Correlation & Retention Analysis (Query #1 & #5)
**Purpose**: Correlate tier pricing with engagement + feature retention rates  
**Visualization**: Scatter plot (price vs engagement) + retention bar chart  
**Business Value**: Optimize pricing strategy

### 5. Activity Segmentation (Query #4)
**Purpose**: Categorize users by total activity  
**Visualization**: Pie chart of activity levels  
**Business Value**: Re-engagement campaigns for low-activity users

### 6. System Logs (Trigger)
**Purpose**: View auto-generated activity logs  
**SQL Feature**: Trigger `trg_feature_usage`  
**Business Value**: Audit trail for compliance

### 7. Session Analytics (Function)
**Purpose**: Calculate average session duration per user  
**SQL Feature**: Function `avg_session_duration(uid)`  
**Business Value**: Personalized engagement metrics

### 8. Above-Average Features (Query #6)
**Purpose**: Find features exceeding overall average engagement  
**SQL Feature**: Correlated subquery with HAVING clause  
**Business Value**: Double down on successful features

---

## 🔧 SQL Highlights

### Trigger Example
```sql
CREATE TRIGGER trg_user_insert
AFTER INSERT ON User
FOR EACH ROW
BEGIN
    INSERT INTO System_Log (activities_id, timestamp, time_spent, action_details)
    VALUES (1, NOW(), 0, CONCAT('New user created: ', NEW.email));
END;
```

### Stored Procedure
```sql
CREATE PROCEDURE recommend_upgrade()
BEGIN
    SELECT u.first_name, u.last_name, AVG(a.duration) AS avg_dur
    FROM User u 
    JOIN User_Activity a ON u.user_id = a.user_id
    GROUP BY u.user_id
    HAVING avg_dur > 50;
END;
```

### User-Defined Function
```sql
CREATE FUNCTION total_time_spent(uid INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT SUM(duration) INTO total FROM User_Activity WHERE user_id = uid;
    RETURN IFNULL(total, 0);
END;
```

### Correlated Subquery
```sql
SELECT f.feature_name, ROUND(AVG(a.duration), 2) AS avg_duration
FROM Feature f
JOIN User_Activity a ON f.feature_id = a.feature_id
GROUP BY f.feature_id
HAVING AVG(a.duration) > (SELECT AVG(duration) FROM User_Activity);
```

---

## 📁 Project Structure

```
dbms-proj/
│
├── frontend.py                      # Streamlit dashboard application
├── subsys_project_full(1).sql      # Complete MySQL database setup
├── README.md                        # Project documentation
│
└── (Future additions)
    ├── requirements.txt             # Python dependencies
    ├── config.py                    # Database configuration
    └── .env                         # Environment variables
```

---

## 🤝 Contributing

Contributions are welcome! To contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📝 License

This project is created for educational purposes as part of a **Database Management Systems (DBMS)** course project.

---

## 👤 Author

**Satwik**  
Project: Subscription Management Analytics Platform  
Course: Database Management Systems

---

## 🐛 Known Issues & Future Enhancements

### Known Issues
- Database credentials hardcoded in `frontend.py` (should use environment variables)
- No authentication/authorization for dashboard access

### Future Enhancements
- [ ] Add user authentication system
- [ ] Implement real-time data refresh
- [ ] Export reports to PDF/Excel
- [ ] Add predictive churn analysis using ML
- [ ] Mobile-responsive dashboard design
- [ ] Multi-tenant support
- [ ] Email notifications for recommendations
- [ ] A/B testing framework for features

---

## 📞 Support

For issues or questions:
1. Check existing [Issues](#) on GitHub
2. Create a new issue with detailed description
3. Contact: `satwik123@gmail.com`

---

## 🙏 Acknowledgments

- **Streamlit** - For the amazing dashboard framework
- **Plotly** - For interactive visualizations
- **MySQL** - For robust database management
- **DBMS Course Instructors** - For project guidance

---

<div align="center">

**⚡ Built with passion for data-driven insights ⚡**

</div>
