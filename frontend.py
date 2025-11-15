# ============================================================
# ⚡ Subscription Tier Optimization Engine (Final Version with Correlated Query)
# ============================================================

import streamlit as st
import pandas as pd
import mysql.connector
import plotly.express as px

# ============================================================
# DATABASE CONNECTION
# ============================================================

def get_connection():
    """Establish connection to MySQL."""
    return mysql.connector.connect(
        host="localhost",
        user="root",              # your MySQL username
        password="santoryu3",     # your MySQL password
        database="subsys_db"      # your database name
    )

# ============================================================
# PAGE CONFIG
# ============================================================

st.set_page_config(
    page_title="Subscription Tier Optimization Engine",
    page_icon="📊",
    layout="wide"
)

st.title("⚡ Subscription Tier Optimization Engine")
st.markdown(
    "Real-time analytics engine providing insights into feature usage, user engagement, and upgrade recommendations."
)

# ============================================================
# SIDEBAR NAVIGATION
# ============================================================

st.sidebar.header("🔍 Navigation Panel")
choice = st.sidebar.radio(
    "Select a section:",
    [
        "📊 Feature Insights",
        "👥 User Insights",
        "💰 Upgrade Recommendations",
        "🧠 Correlation & Retention Analysis",
        "🔥 Activity Segmentation",
        "⚙ System Logs",
        "⏱ Session Analytics",
        "🎯 Above-Average Features (Correlated Query)"
    ]
)

# ============================================================
# SECTION 1: FEATURE INSIGHTS (Query 2)
# ============================================================

if choice == "📊 Feature Insights":
    st.subheader("🔥 Top Engaging Features (Query 2)")
    conn = get_connection()
    query = """
        SELECT 
            f.feature_name, 
            SUM(a.duration) AS total_time,
            COUNT(a.activity_id) AS total_sessions
        FROM Feature f
        JOIN User_Activity a ON f.feature_id = a.feature_id
        GROUP BY f.feature_id
        ORDER BY total_time DESC
        LIMIT 5;
    """
    df = pd.read_sql(query, conn)
    conn.close()

    if not df.empty:
        fig = px.bar(df, x="feature_name", y="total_time", color="feature_name", text_auto=True,
                     title="Top 5 Most Engaging Features")
        st.plotly_chart(fig, use_container_width=True)
        st.dataframe(df)
    else:
        st.warning("No feature usage data available yet.")

# ============================================================
# SECTION 2: USER INSIGHTS (Query 3)
# ============================================================

elif choice == "👥 User Insights":
    st.subheader("👤 Segment-Wise User Engagement (Query 3)")
    conn = get_connection()
    query = """
        SELECT 
            m.segment_name,
            ROUND(AVG(a.duration), 2) AS avg_engagement,
            RANK() OVER (ORDER BY AVG(a.duration) DESC) AS rank_seg
        FROM Market_Segment m
        JOIN User u ON m.segment_id = u.current_segment_id
        JOIN User_Activity a ON a.user_id = u.user_id
        GROUP BY m.segment_id;
    """
    df = pd.read_sql(query, conn)
    conn.close()

    if not df.empty:
        fig = px.bar(df, x="segment_name", y="avg_engagement", color="segment_name", text_auto=True,
                     title="Market Segment Ranking by Engagement")
        st.plotly_chart(fig, use_container_width=True)
        st.dataframe(df)
    else:
        st.warning("No user engagement data available.")

# ============================================================
# SECTION 3: UPGRADE RECOMMENDATIONS (Procedure)
# ============================================================

elif choice == "💰 Upgrade Recommendations":
    st.subheader("💡 High-Engagement Users (Stored Procedure)")
    conn = get_connection()
    query = "CALL recommend_upgrade();"
    df = pd.read_sql(query, conn)
    conn.close()

    if not df.empty:
        st.dataframe(df)
        st.success("✅ These users are highly engaged — ideal candidates for upgrade campaigns.")
    else:
        st.info("No users currently meet the engagement threshold for upgrade.")

# ============================================================
# SECTION 4: CORRELATION & RETENTION ANALYSIS (Query 1 & 5)
# ============================================================

elif choice == "🧠 Correlation & Retention Analysis":
    col1, col2 = st.columns(2)

    # Query 1 - Tier-based Correlation Insight
    with col1:
        st.subheader("💎 Tier-based Engagement & Revenue (Query 1)")
        conn = get_connection()
        query1 = """
            SELECT 
                t.tier_name AS tier,
                ROUND(AVG(a.duration), 2) AS avg_engagement,
                t.price AS tier_price,
                COUNT(DISTINCT u.user_id) AS user_count
            FROM Tier t
            JOIN User u ON t.tier_id = u.current_tier_id
            JOIN User_Activity a ON a.user_id = u.user_id
            GROUP BY t.tier_id
            ORDER BY avg_engagement DESC;
        """
        df1 = pd.read_sql(query1, conn)
        conn.close()

        if not df1.empty:
            fig1 = px.scatter(
                df1,
                x="tier_price",
                y="avg_engagement",
                size="user_count",
                color="tier",
                text="tier",
                title="💰 Tier Price vs Average Engagement (Revenue Correlation)"
            )
            fig1.update_traces(textposition="top center")
            st.plotly_chart(fig1, use_container_width=True)
            st.dataframe(df1)
        else:
            st.warning("No tier-based data available.")

    # Query 5 - Feature Retention Analysis
    with col2:
        st.subheader("🔁 Feature Retention (Query 5)")
        conn = get_connection()
        query5 = """
            SELECT 
                f.feature_name,
                COUNT(DISTINCT a.user_id) AS unique_users,
                ROUND((COUNT(DISTINCT a.user_id) / (SELECT COUNT(*) FROM User)) * 100, 2) AS retention_rate
            FROM Feature f
            JOIN User_Activity a ON f.feature_id = a.feature_id
            GROUP BY f.feature_id
            ORDER BY retention_rate DESC;
        """
        df5 = pd.read_sql(query5, conn)
        conn.close()

        if not df5.empty:
            fig2 = px.bar(df5, x="feature_name", y="retention_rate", color="feature_name", text_auto=True,
                          title="Feature Retention Rate (%)")
            st.plotly_chart(fig2, use_container_width=True)
            st.dataframe(df5)
        else:
            st.warning("No retention data available.")

# ============================================================
# SECTION 5: ACTIVITY SEGMENTATION (Query 4)
# ============================================================

elif choice == "🔥 Activity Segmentation":
    st.subheader("🧩 Active vs Inactive User Distribution (Query 4)")
    conn = get_connection()
    query = """
        SELECT 
            activity_level,
            COUNT(DISTINCT user_id) AS total_users
        FROM (
            SELECT 
                user_id,
                CASE 
                    WHEN SUM(duration) > 100 THEN 'Highly Active'
                    WHEN SUM(duration) BETWEEN 50 AND 100 THEN 'Moderately Active'
                    ELSE 'Low Activity'
                END AS activity_level
            FROM User_Activity
            GROUP BY user_id
        ) AS sub
        GROUP BY activity_level
        ORDER BY total_users DESC;
    """
    df = pd.read_sql(query, conn)
    conn.close()

    if not df.empty:
        fig = px.pie(df, names="activity_level", values="total_users", title="User Activity Segmentation")
        st.plotly_chart(fig, use_container_width=True)
        st.dataframe(df)
    else:
        st.warning("No user activity found.")

# ============================================================
# SECTION 6: SYSTEM LOGS (Trigger)
# ============================================================

elif choice == "⚙ System Logs":
    st.subheader("🪵 Recent System Logs (Trigger)")
    conn = get_connection()
    query = "SELECT activities_id, timestamp, time_spent, action_details FROM System_Log ORDER BY timestamp DESC LIMIT 15;"
    df = pd.read_sql(query, conn)
    conn.close()

    if not df.empty:
        st.dataframe(df)
        st.info("⚡ Logs automatically created by trigger trg_feature_usage after each feature use.")
    else:
        st.warning("No system logs available yet.")

# ============================================================
# SECTION 7: SESSION ANALYTICS (Function)
# ============================================================

elif choice == "⏱ Session Analytics":
    st.subheader("🧠 Average Session Duration per User (MySQL Function)")
    st.markdown(
        "Use this tool to calculate the average time a user spends interacting with features — powered by the SQL function avg_session_duration()."
    )

    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("""
        SELECT COUNT(*) 
        FROM information_schema.ROUTINES 
        WHERE ROUTINE_SCHEMA = 'subsys_db' AND ROUTINE_NAME = 'avg_session_duration';
    """)
    exists = cursor.fetchone()[0]

    if exists == 0:
        cursor.execute("""
            DROP FUNCTION IF EXISTS avg_session_duration;
        """)
        cursor.execute("""
            CREATE FUNCTION avg_session_duration(uid INT)
            RETURNS DECIMAL(10,2)
            DETERMINISTIC
            BEGIN
                DECLARE avg_dur DECIMAL(10,2);
                SELECT AVG(duration)
                INTO avg_dur
                FROM User_Activity
                WHERE user_id = uid;
                RETURN IFNULL(avg_dur, 0);
            END;
        """)

    conn.commit()

    user_id = st.number_input("Enter User ID:", min_value=1, step=1)
    if st.button("Get Average Duration"):
        cursor.execute(f"SELECT avg_session_duration({user_id});")
        result = cursor.fetchone()
        if result and result[0] is not None:
            st.success(f"Average Session Duration for User {user_id}: {round(result[0], 2)} minutes")
        else:
            st.warning("No activity data found for this user.")

    cursor.close()
    conn.close()

# ============================================================
# SECTION 8: ABOVE-AVERAGE FEATURES (Correlated Subquery)
# ============================================================

elif choice == "🎯 Above-Average Features (Correlated Query)":
    st.subheader("🎯 Above-Average Features by Engagement (Query 6)")
    st.markdown(
        "This correlated subquery finds features whose *average engagement duration* is greater than the *overall average* across all features."
    )

    conn = get_connection()
    query6 = """
        SELECT 
            f.feature_name,
            ROUND(AVG(a.duration), 2) AS avg_duration
        FROM Feature f
        JOIN User_Activity a ON f.feature_id = a.feature_id
        GROUP BY f.feature_id, f.feature_name
        HAVING AVG(a.duration) > (
            SELECT AVG(duration)
            FROM User_Activity
        );
    """
    df6 = pd.read_sql(query6, conn)
    conn.close()

    if not df6.empty:
        fig = px.bar(df6, x="feature_name", y="avg_duration", color="feature_name", text_auto=True,
                     title="Features with Above-Average Engagement")
        st.plotly_chart(fig, use_container_width=True)
        st.dataframe(df6)
    else:
        st.warning("No features exceed the average engagement level.")
