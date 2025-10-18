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

    %% --- Color coding section ---
    style A fill:#6CB4EE,stroke:#0366d6,stroke-width:2px,color:#fff
    style B fill:#6CB4EE,stroke:#0366d6,stroke-width:2px,color:#fff
    style C fill:#58D68D,stroke:#1D8348,stroke-width:2px,color:#fff

    style D fill:#F4D03F,stroke:#B7950B,stroke-width:2px,color:#000

    style E fill:#58D68D,stroke:#1D8348,stroke-width:2px,color:#fff
    style F fill:#58D68D,stroke:#1D8348,stroke-width:2px,color:#fff
    style G fill:#58D68D,stroke:#1D8348,stroke-width:2px,color:#fff
    style H fill:#58D68D,stroke:#1D8348,stroke-width:2px,color:#fff
    style I fill:#BB8FCE,stroke:#6C3483,stroke-width:2px,color:#fff
    style J fill:#BB8FCE,stroke:#6C3483,stroke-width:2px,color:#fff
    style K fill:#F4D03F,stroke:#B7950B,stroke-width:2px,color:#000
    style L fill:#58D68D,stroke:#1D8348,stroke-width:2px,color:#fff
    style M fill:#E67E22,stroke:#935116,stroke-width:2px,color:#fff
    style N fill:#E74C3C,stroke:#922B21,stroke-width:2px,color:#fff
    style O fill:#E74C3C,stroke:#922B21,stroke-width:2px,color:#fff
    style P fill:#E74C3C,stroke:#922B21,stroke-width:2px,color:#fff
    style Q fill:#6CB4EE,stroke:#0366d6,stroke-width:2px,color:#fff
