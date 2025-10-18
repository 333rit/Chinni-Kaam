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
  Core logic and analytics functions

- [**functions_process_control.R**](functions_process_control.R)  
  Functions for statistical process control helpers

- [**hospital_dashboard.R**](hospital_dashboard.R)  
  Main R Shiny application file containing the user interface (UI) and server logic.

- [**README.md**](README.md)  
  This file!. Main project documentation —- setup instructions, overview, and feature guide.

- [**CODEME.md**](CODE_ME.md)  
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

---

## ▶️ Running the App Locally

To run the **Hospital Wait-Time Monitoring Dashboard**, follow these three simple steps:

### **1️⃣ Set Your Working Directory**

Open R or RStudio and navigate to the folder containing the project files:

```r
setwd("path/to/hospital_wait_times_dashboard")
```

### **2️⃣ Source the Helper Functions**

Load the backend functions that support the dashboard’s analytics:

```r
source("dashboard_functions.R")
```

### **3️⃣ Launch the Shiny App**

Run the Shiny dashboard locally:

```r
shiny::runApp("hospital_dashboard.R")
```

---

## 📊 Example Workflow

This example demonstrates how to use the **Hospital Wait-Time Monitoring Dashboard** from start to finish.

---

### **1️⃣ Launch the App**

Run the following command in R or RStudio to open the dashboard:

```r
shiny::runApp("hospital_dashboard.R")
```
Once executed, the app will automatically open in your default web browser.
<img width="1440" height="725" alt="Screenshot 2025-10-18 at 13 34 23" src="https://github.com/user-attachments/assets/99f4b138-3110-4778-b0e1-f72519adeb9d" />


### **2️⃣ Enter Patient Metrics**

Navigate to the **“Enter Patient Metrics”** tab on the dashboard and input the following details for each new patient entry:
<img width="1440" height="730" alt="Screenshot 2025-10-18 at 13 35 05" src="https://github.com/user-attachments/assets/c6d10639-6ac6-40fa-ace7-319fb59c896e" />


Once all fields are filled, click **Enter** to record the new data entry.

The system will automatically:
- Assign the appropriate **shift and section** based on the current time  
- Calculate the **next expected check-in time** based on severity and treatment type  
- Append the record to the **Patient Log** for real-time monitoring

### **3️⃣ Review the Patient Log**

Navigate to the **“Patient Log”** tab in the dashboard.

Here you can review all patient entries that have been recorded.  
After entering new data in the previous step, verify that your patient record appears in the table.
<img width="1439" height="701" alt="Screenshot 2025-10-18 at 13 30 56" src="https://github.com/user-attachments/assets/9251dfcc-0ef0-4a82-8dd4-f1164708b402" />

This tab acts as the central **data log** for monitoring ongoing hospital operations, providing visibility into patient flow and timing across departments.

### **4️⃣ Analyze Process Capability**

Open the **“Process Capability”** tab to evaluate overall system performance and stability.

This section visualizes patient wait-time data using **Statistical Process Control (SPC)** charts to help identify trends, deviations, and potential problem areas.
<img width="1440" height="701" alt="Screenshot 2025-10-18 at 13 31 16" src="https://github.com/user-attachments/assets/9ffcc540-cc5b-4fd9-9eae-a313926c0a45" />


Here you can:
- **Choose a Grouping Variable** – such as *Department*, *Patient Acuity*, *Treatment*, or *Shift*  
- **View X-bar Control Charts** – displaying average deviations and ±3 σ control limits  
- **Detect Special Causes of Variation** – identify abnormal patterns or spikes in wait times  
- **Assess Process Stability** – determine whether variations are random (common cause) or due to specific issues (special cause)  
- **Support Corrective Actions** – use the insights to guide workflow improvements, resource allocation, or staffing adjustments  


---

## ⚙️ Troubleshooting Guide

| 🧩 Issue | 💡 Possible Cause | 🛠️ Recommended Solution |
|-----------|-------------------|--------------------------|
| App fails to start | Missing or outdated R packages | Re-install packages and make sure all necessary packages are installed |
| “object 'get_info' not found” | Function file not sourced | Ensure the helper file is loaded |
| “functions_process_control' not found” | Function file not sourced | Ensure the helper file is loaded |
| Blank or missing plots | `ggplot2` or `ggpubr` not installed | Reinstall required packages |
| Timestamps not displaying correctly | Incorrect time format or locale settings | Verify respective conversions using |
| Error: *cannot find shiny app* | Wrong working directory | Set directory to project root |
| Dashboard not opening in browser | R session blocked or firewall issue | Try running again or open manually |
| Data not updating in table | Reactive data not refreshing | Check `observeEvent()` logic and ensure reactive objects are used properly |
| Slow dashboard loading | Large datasets or too many render calls | Sample smaller data or optimize reactive blocks |

---


