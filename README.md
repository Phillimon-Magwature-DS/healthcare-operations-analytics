# Healthcare Operations Analytics & BI Dashboard

A synthetic-data portfolio project exploring patient flow, waiting times, admissions, bed occupancy and department-level resource utilisation using Python, SQL and Microsoft Power BI.

**Prepared by:** Phillimon Magwature  
**Analysis period:** 1 January 2024 - 31 December 2025  

> **Data disclosure:** All records in this repository are fictional and were generated for learning and portfolio demonstration. An earlier patient-visit workbook was used only as a structural reference. This project does not contain Corporate 24 Healthcare production data and its figures must not be interpreted as the performance of a real healthcare provider.

## Project objectives

- Examine how patient encounter volumes change over time and across departments.
- Compare waiting times among completed encounters.
- Summarise synthetic admissions and length of stay by ward.
- Calculate ward-level and facility-wide weighted bed occupancy.
- Compare planned staffing, staff on duty, patients seen and overtime by department.
- Demonstrate data-quality checks, reproducible preparation and interactive BI reporting.

## Tools

- **Python:** pandas, NumPy, Matplotlib and Seaborn for data preparation and exploratory analysis.
- **Jupyter Notebook:** repeatable analysis workflow.
- **SQL:** example queries for aggregated operational summaries.
- **Power BI:** data model, DAX measures, slicers and four report pages: Executive Overview, Patient Flow, Bed Occupancy and Resource Utilisation.

## Repository structure

```text
healthcare-operations-analytics/
├── README.md
├── .gitignore
├── Data/
│   ├── visits_raw.csv
│   ├── patient_master.csv
│   ├── admissions.csv
│   ├── bed_census_daily.csv
│   ├── staffing_daily.csv
│   ├── service_catalog.csv
│   └── data_dictionary.csv
├── Healthcare_Operations_Analysis.ipynb
├── SQL_Starter_Queries.sql
├── PowerBI/
│   ├── Healthcare_Operations_Dashboard.pbix
│   └── dashboard_export.pdf
├── Report/
│   ├── Healthcare_Operations_Portfolio_Report.docx
│   └── Healthcare_Operations_Portfolio_Report.pdf
└── Output/
    ├── Charts/
    └── Tables/
```

The Power BI files and final report PDF are added by the project owner after completing the dashboard and inserting screenshots into the editable Word report.

## Data inventory

| File | Rows | Description |
|---|---:|---|
| `patient_master.csv` | 11,000 | Synthetic patient dimension. |
| `visits_raw.csv` | 42,150 | Raw encounter export with deliberate data-quality issues. |
| `admissions.csv` | 2,793 | Synthetic inpatient admission records. |
| `bed_census_daily.csv` | 2,924 | Four wards recorded over 731 dates. |
| `staffing_daily.csv` | 4,386 | Six departments recorded over 731 dates. |
| `service_catalog.csv` | 18 | Department and service-line reference data. |
| `data_dictionary.csv` | 54 | Field definitions and data-type notes. |

## Selected reference findings

The following results were calculated from the supplied synthetic dataset using the documented cleaning rules. Clear all dashboard slicers and compare the corresponding measures before publishing if the dashboard uses different DAX logic or filters.

- 42,150 raw visit rows; 150 duplicate encounter rows removed, leaving 42,000 unique encounters.
- 39,441 completed encounters and 10,762 distinct non-blank synthetic patient keys.
- Average waiting time of 34.5 minutes among completed encounters after the documented cleaning and median-imputation process.
- Outpatient accounted for 17,586 encounters (41.9% of the total).
- Surgical Clinic had the highest department average waiting time (43.8 minutes).
- Facility-wide weighted bed occupancy was 64.3%; Medical Ward had the highest ward weighted occupancy (71.5%).
- Overall staffing coverage was 95.9%; Outpatient recorded 1.81 completed encounters per staff-day.
- The staffing table contained 2,933.5 synthetic overtime hours.

These are reference results for fictional data, not evidence about a real facility.

## Reproducing the Python analysis

1. Download or clone this repository.
2. Install Python and Jupyter Notebook or JupyterLab.
3. Install the required libraries:

   ```bash
   py -m pip install pandas numpy matplotlib seaborn jupyter
   ```

4. Open `Healthcare_Operations_Analysis.ipynb` from the repository root.
5. Run the notebook from top to bottom. It expects the `Data` folder to sit beside the notebook.
6. The notebook creates an `Output` folder containing cleaned data, quality audits, summary tables and charts.

## Power BI report

The Power BI report is organised into four views:

1. Executive Overview
2. Patient Flow
3. Bed Occupancy
4. Resource Utilisation

Open the `.pbix` file with Power BI Desktop. Use the PDF export for a static preview; use the `.pbix` file for interactive exploration.

## KPI definitions

- **Total Visits:** count of unique `EncounterID` records after de-duplication.
- **Unique Patients:** distinct, non-blank synthetic `PatientID` values.
- **Average Waiting Time:** mean `WaitMinutes` for completed encounters after validity checks and department-median imputation.
- **Weighted Bed Occupancy:** sum of occupied beds divided by sum of bed capacity across selected ward-day records.
- **Staff Coverage:** sum of `StaffOnDuty` divided by sum of `PlannedStaff` across selected department-day records.
- **Patients per Staff-Day:** sum of `PatientsSeen` divided by sum of `StaffOnDuty` across selected department-day records.

## Limitations and responsible use

The data is synthetic, includes deliberately planted quality issues and does not represent a live health information system. Admissions and bed-census data are not fully reconciled through bed-level movements. Staffing records do not include staff grades, skill mix, shift lengths, leave categories or patient acuity. Descriptive patterns do not establish causation. The 85% occupancy reference is a scenario-planning choice for this exercise, not a universal standard.

Do not upload real or identifiable patient data, confidential screenshots, passwords or API keys to this repository.
