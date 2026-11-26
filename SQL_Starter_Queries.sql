/*
Healthcare Operations Analytics - SQL starter queries

Dialect: SQLite-compatible SQL

Import the project CSVs into SQLite using these table names:
  visits_clean, admissions, bed_census_daily, staffing_daily

The visits_clean table should be created by running the supplied Python notebook first.
All example queries are aggregated. The source data is synthetic.
*/

-- 1. Overall visit KPIs
SELECT
    COUNT(DISTINCT EncounterID) AS total_visits,
    SUM(CASE WHEN VisitStatus = 'Completed' THEN 1 ELSE 0 END) AS completed_visits,
    COUNT(DISTINCT NULLIF(TRIM(PatientID), '')) AS unique_patients
FROM visits_clean;

-- 2. Monthly encounter volume
SELECT
    strftime('%Y-%m', VisitDate) AS year_month,
    COUNT(DISTINCT EncounterID) AS total_visits,
    SUM(CASE WHEN VisitStatus = 'Completed' THEN 1 ELSE 0 END) AS completed_visits
FROM visits_clean
GROUP BY strftime('%Y-%m', VisitDate)
ORDER BY year_month;

-- 3. Encounter volume and waiting time by department
-- Waiting-time figures are limited to completed visits.
SELECT
    Department,
    COUNT(DISTINCT EncounterID) AS total_visits,
    AVG(CASE WHEN VisitStatus = 'Completed' THEN WaitMinutes END) AS average_wait_minutes
FROM visits_clean
GROUP BY Department
ORDER BY total_visits DESC;

-- 4. Admissions and average length of stay by ward
SELECT
    Ward,
    COUNT(*) AS admissions,
    ROUND(AVG(LengthOfStayDays), 2) AS average_length_of_stay_days
FROM admissions
GROUP BY Ward
ORDER BY admissions DESC;

-- 5. Facility-wide weighted bed occupancy
-- This is a weighted calculation across ward-day records, not an average of daily percentages.
SELECT
    SUM(OccupiedBeds) AS occupied_bed_days,
    SUM(BedCapacity) AS capacity_bed_days,
    ROUND(100.0 * SUM(OccupiedBeds) / NULLIF(SUM(BedCapacity), 0), 1) AS weighted_occupancy_percent
FROM bed_census_daily;

-- 6. Weighted occupancy by ward and count of ward-days above the 85% scenario reference
SELECT
    Ward,
    ROUND(100.0 * SUM(OccupiedBeds) / NULLIF(SUM(BedCapacity), 0), 1) AS weighted_occupancy_percent,
    SUM(CASE WHEN OccupancyRate > 0.85 THEN 1 ELSE 0 END) AS ward_days_above_85_percent,
    MAX(OccupancyRate) * 100.0 AS peak_daily_occupancy_percent
FROM bed_census_daily
GROUP BY Ward
ORDER BY weighted_occupancy_percent DESC;

-- 7. Staffing coverage and patient workload by department
SELECT
    Department,
    SUM(PlannedStaff) AS planned_staff_days,
    SUM(StaffOnDuty) AS actual_staff_days,
    ROUND(100.0 * SUM(StaffOnDuty) / NULLIF(SUM(PlannedStaff), 0), 1) AS staff_coverage_percent,
    SUM(PatientsSeen) AS patients_seen,
    ROUND(1.0 * SUM(PatientsSeen) / NULLIF(SUM(StaffOnDuty), 0), 2) AS patients_per_staff_day,
    ROUND(SUM(OvertimeHours), 1) AS overtime_hours
FROM staffing_daily
GROUP BY Department
ORDER BY patients_per_staff_day DESC;

-- 8. Monthly staffing and workload trend
SELECT
    strftime('%Y-%m', Date) AS year_month,
    SUM(PatientsSeen) AS patients_seen,
    SUM(StaffOnDuty) AS staff_duty_days,
    ROUND(1.0 * SUM(PatientsSeen) / NULLIF(SUM(StaffOnDuty), 0), 2) AS patients_per_staff_day,
    ROUND(SUM(OvertimeHours), 1) AS overtime_hours
FROM staffing_daily
GROUP BY strftime('%Y-%m', Date)
ORDER BY year_month;
