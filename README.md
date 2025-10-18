# Chinni-Kaam
Medical Wait Time Repository 
# 🩺 Hospital Patient Workflow

---

## 📘 Overview  

The **Hospital Wait Time Monitoring Dashboard** is an interactive R Shiny application designed to help hospitals **track, analyze, and reduce patient wait times**.  

It integrates **real-time data entry**, **automated analytics**, and **SPC (Statistical Process Control)** visualizations to help clinicians, nurses, and administrators identify process inefficiencies, monitor patient throughput, and improve care coordination.

This project delivers an interactive **R Shiny** dashboard allowing hospital staff to log patient metric entries, visualise process capability, and identify bottlenecks across departments, treatments, shifts and acuity levels. It supports operational decision-making by tracking deviations from expected check-in times, and highlights where resources or processes may need adjustment. A set of 3 datasets (a test (fake), and 2 real datasets) are used to access the following questions analtically:  
> *“Which departments, clinical interventions or patient actuity levels are causing delays?”*  
> *“Are there special-cause variations across shifts or days?”*

---
 
## 📁 Repository Contents

- [**dashboard_functions.R**](dashboard_functions.R)  
  Core logic and analytics functions — includes statistical process control helpers  

- [**hospital_dashboard.R**](hospital_dashboard.R)  
  Main R Shiny application file containing the user interface (UI) and server logic.

- [**README.md**](README.md)  
  This file!. Main project documentation —- setup instructions, overview, and feature guide.

- [**CODEME.md**](CODEME.md)  
  In-depth code explanations -- breakdown of core functions and Shiny server flow.

- [**Process_flow.md**](Process_flow.md)  
  Root-cause process flow diagram (Mermaid) illustrating patient data and improvement loop.

---

## 🗂️ Data dictionary
The dashboard stores each check‑in event in a structured data frame. The following table summarises the key variables:
| Column                | Description                                                                                             | Example               |
| --------------------- | ------------------------------------------------------------------------------------------------------- | --------------------- |
| `Patient_ID`          | Unique identifier for the patient                                                                       | `P012`                |
| `Status`              | Admitted or Discharged                                                                                  | `Admitted`            |
| `Department`          | Inpatient ward or service (Cardiology, Emergency, General Surgery, etc.)                                | `Neurology`           |
| `Patient_Acuity`      | Patient severity level (Critical, Moderate, Stable)                                                     | `Moderate`            |
| `Treatment`           | Purpose of the visit (Procedures, Imaging, Physician/Specialized Consultancy, Labs, **Rehabilitation**) | `Rehabilitation`      |
| `Expected_Checkin`    | Time when the next check‑in was previously scheduled                                                    | `18-10-2025 14:00:00` |
| `Time_Stamp`          | Timestamp of the current check‑in event                                                                 | `18-10-2025 10:30:00` |
| `Percent_deviation`   | Percentage deviation from the expected interval (positive = delay)                                      | `+25.0`               |
| `Shift`               | Numeric shift label (1 = day, 2 = evening, 3 = night) computed from `curr_time`                         | `1`                   |
| `Shift_Section`       | Segment of the shift (“Beginning”, “Middle”, “End”) used for subgroup analysis                          | `Beginning`           |
| `Weekend`             | Boolean indicating whether the visit occurred on a weekend                                              | `TRUE`                |
| `Next_Checkin`        | Calculated ideal next check‑in time based on severity and treatment                                     | `19-10-2025 10:30:00` |
| `Subgroup` (internal) | Numeric subgroup combining shift and section for SPC analysis 
