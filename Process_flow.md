# 🩺 Hospital Process Flow

```mermaid
flowchart TD
    A[Patient Check-In] --> B[Data Entry in Dashboard]
    B --> C[Call get_info Function]
    C --> D{Patient Status?}
    D -->|Admitted| E[Determine Shift and Section]
    D -->|Discharged| F[Clear Dept, Acuity, Treatment Fields]
    E --> G[Compute Next Check-In Based on Severity and Treatment]
    G --> H[Append Updated Row to Patient Log]
    H --> I[Compute Percent Deviation from Expected Check-In]
    I --> J[Generate X-bar Control Chart]
    J --> K{Deviation Within Limits?}
    K -->|Yes| L[Process Stable - Continue Monitoring]
    K -->|No| M[Identify Special Cause]
    M --> N[Conduct Root Cause Analysis e.g., delay in Imaging or Staffing]
    N --> O[Implement Corrective Action]
    O --> P[Update Process Parameters / Staffing Schedule]
    P --> Q[Continuous Improvement Loop to Dashboard Insights]
    Q --> B
