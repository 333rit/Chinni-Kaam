get_info = function(user_data, curr_time, patient_id, status, dept, severity, treatment){
  ## Get Shift 
  # Define your time interval (e.g., 9 AM to 5 PM)
  start_time1 <- hms("09:00:00")
  end_time1 <- hms("16:59:59")
  start_time3 <- hms("01:00:00")
  end_time3 <- hms("8:59:59")
  
  # Extract the time component from the timestamps
  # Attempt: time_only <- hms("2:00:00")
  time_only <- hms(format(curr_time, "%H:%M:%S"))
  
  # Perform the comparison
  if(time_only >= start_time1 & time_only <= end_time1){shift=1}
  else if(time_only >= start_time3 & time_only <= end_time3){shift=3}
  else{shift=2}
  
  ## Get Shift Section
  # Convert the input time to an hms object for time-of-day comparison
  
  # Define your time ranges as hms objects
  beg_start_1 <- hms("09:00:00")
  beg_end_1 <- hms("10:59:59")
  
  beg_start_2 <- hms("17:00:00")
  beg_end_2 <- hms("18:59:59")
  
  beg_start_3 <- hms("01:00:00")
  beg_end_3 <- hms("02:59:59")
  
  mid_start_1 <- hms("11:00:00")
  mid_end_1 <- hms("13:59:59")
  
  mid_start_2 <- hms("19:00:00")
  mid_end_2 <- hms("21:59:59")
  
  mid_start_3 <- hms("03:00:00")
  mid_end_3 <- hms("05:59:59")
  
  # Use logical operators (>= and <=) for comparison
  if(
    (time_only >= beg_start_1 & curr_time <= beg_end_1) |
    (time_only >= beg_start_2 & curr_time <= beg_end_2) |
    (time_only >= beg_start_3 & curr_time <= beg_end_3)
  ){
    section = "Beginning"
  }
  else if(
    (time_only >= mid_start_1 & curr_time <= mid_end_1) |
    (time_only >= mid_start_2 & curr_time <= mid_end_2) |
    (time_only >= mid_start_3 & curr_time <= mid_end_3)
  ){
    section = "Middle"
  }
  else{section = "End"}
  
  ## Get Next Check In
  # Sets ideal next check in time according to severity
  if(severity=="Stable"){
    next_check_s = curr_time + hours(24)
  }
  else if(severity=="Moderate"){
    next_check_s = curr_time + hours(8)
  }
  else{
    next_check_s = curr_time + hours(3)
  }
  
  # Sets ideal next check in time according to treatment
  if(treatment=="Imaging"){
    next_check_t = curr_time + hours(10)
  }
  else if(treatment=="Labs"){
    next_check_t = curr_time + hours(10)
  }
  else if(treatment=="Consultation"){
    next_check_t = curr_time + hours(24)
  }
  else if(treatment=="Rehab"){
    next_check_t = curr_time + hours(24)
  }
  else{next_check_t = curr_time + hours(1)}
  
  next_check = format(min(next_check_s, next_check_t), "%d-%m-%Y %H:%M:%S")
  
  if(status=="Discharged"){
    dept = NA
    severity = NA
    treatment = NA
    shift = NA
    section = NA
    next_check = NA
  }
  
  ## Determine Expected Checkin and Deviation
  curr_patient_hist <- user_data %>%
    filter(Patient_ID == patient_id)
  if (nrow(curr_patient_hist) == 0) {
    exp_check <- NA
    per_dev = NA
  } else {
    # Use slice_tail() to get the last entry in a robust way
    last_entry <- curr_patient_hist %>%
      slice_tail(n = 1)
    
    # Check if the last_entry is not empty before accessing the column
    if (nrow(last_entry) > 0) {
      prev_check_char = last_entry$Time_Stamp
      exp_check_char = last_entry$Next_Checkin
      
      prev_check = strptime(prev_check_char, format = "%d-%m-%Y %H:%M:%S")
      exp_check = strptime(exp_check_char, format = "%d-%m-%Y %H:%M:%S")
      
      curr_check = curr_time # curr_time is already a POSIXct object
      
      # Now, perform the calculations
      exp_dev = as.numeric(exp_check - prev_check, units = "hours")
      real_dev = as.numeric(curr_check - prev_check, units = "hours")
      per_dev = 100*(real_dev/exp_dev - 1)
      exp_check = format(exp_check, "%d-%m-%Y %H:%M:%S")
    } else {
      exp_check <- NA
      per_dev = NA
    }
  }
  
  # Determine if Weekend
  day_of_week <- wday(curr_time, week_start = 1)
  # Check if the day is Saturday (6) or Sunday (7)
  is_weekend <- day_of_week %in% c(6, 7)
  
  ## Construct new row
  new_row = data.frame(
    Patient_ID = patient_id,
    Status = status,
    Department = dept,
    Patient_Acuity = severity,
    Treatment = treatment,
    Expected_Checkin = exp_check,
    Time_Stamp = format(curr_time, "%d-%m-%Y %H:%M:%S"),
    Percent_deviation = per_dev,
    Shift = shift,
    Shift_Section = section,
    Weekend = is_weekend,
    Next_Checkin = next_check
  )
  return(new_row)
}

# Function to create a fake dataset for testing purposes
fake_data = function(){
  set.seed(123)
  
  # Create sample data frame with updated categories and datetime format
  df <- data.frame(
    Patient_ID       = sprintf("P%03d", 1:200),  # character
    
    Status           = sample(c("Admitted", "Discharged"), 200, replace = TRUE),  # character
    
    Department       = sample(c("Cardiology", "Emergency", "General Surgery", "Intensive Care", "Neurology", "Oncology", "Orthopedics"), 200, replace = TRUE),  # character
    
    Patient_Acuity         = sample(c("Critical", "Moderate", "Stable"), 200, replace = TRUE),  # character
    
    Treatment        = sample(c("Procedures", "Imaging", "Physician / Specialized Consultancy", "Labs", "Rehabilitation"), 200, replace = TRUE),  # character
    
    Expected_Checkin = ymd_hms("2025-10-18 07:00:00") + minutes(sample(0:300, 200, replace = TRUE)),  # datetime
    Time_Stamp       = ymd_hms("2025-10-18 07:00:00") + minutes(sample(0:500, 200, replace = TRUE)),  # datetime
    Percent_deviation = round(runif(200, -10, 10), 2),  # numeric
    Shift             = sample(c("1", "2", "3"), 200, replace = TRUE),  # numeric
    Shift_Section     = sample(c("Beginning", "Middle", "End"), 200, replace = TRUE),  # character
    Next_Checkin      = ymd_hms("2025-10-18 10:00:00") + minutes(sample(0:300, 200, replace = TRUE))  # datetime
  )
  
  # Format datetime columns as DD-MM-YYYY HH:MM:SS while keeping POSIXct type
  df <- df %>%
    mutate(
      Expected_Checkin = format(Expected_Checkin, "%d-%m-%Y %H:%M:%S"),
      Time_Stamp       = format(Time_Stamp, "%d-%m-%Y %H:%M:%S"),
      Next_Checkin     = format(Next_Checkin, "%d-%m-%Y %H:%M:%S")
    )
  
  # Convert back to POSIXct to retain datetime data type
  df <- df %>%
    mutate(
      Expected_Checkin = dmy_hms(Expected_Checkin),
      Time_Stamp       = dmy_hms(Time_Stamp),
      Next_Checkin     = dmy_hms(Next_Checkin)
    )
  
  df <- df %>%
    mutate(Subgroup = case_when(
      is.na(Shift) | is.na(Shift_Section) ~ NA_integer_,
      TRUE ~ (as.numeric(Shift) - 1) * 3 + match(Shift_Section, c("Beginning", "Middle", "End"))
    ))
  
  # df <- df %>%
  #   mutate(Subgroup = (Shift - 1) * 3 + 
  #            match(Shift_Section, c("Beginning", "Middle", "End")))
  return(df)
}

# Combines the two plots
format_plots = function(user_data, graph_by){
  # Takes 5 random samples from each subgroup
  take_samples = function(user_data){
    samples <- user_data %>%
      filter(!is.na(Subgroup)) %>%
      group_by(Subgroup) %>%
      slice_sample(n = 5) %>%
      ungroup()
    return(samples)
  }
  
  # Creates an Average Chart for the Overall Data
  ggxbar_overall = function(user_data, xlab = "Time (Subgroups)", ylab = "Average"){
    
    data = tibble(x = user_data$Subgroup, y = user_data$Percent_deviation)
    
    # Get statistics for each subgroup
    stat_s = get_stat_s(x = data$x, y = data$y)
    
    # Generate labels
    labels = stat_s %>%
      reframe(
        x = c(max(x), max(x), max(x)),
        type = c("xbbar", "upper", "lower"),
        name = c("xbbar", "+3 s", "-3 s"),
        value = c(mean(xbbar), max(upper), min(lower))
      ) %>%
      mutate(value = round(value, 2)) %>%
      mutate(text = paste0(name, " = ", value))
    
    # Get overall statistics
    stat_t = get_stat_t(x = data$x, y = data$y)
    
    # Generate plot
    gg = ggplot() +
      geom_hline(data = stat_s, mapping = aes(yintercept = xbbar), color = "red") +
      geom_hline(data = stat_s, mapping = aes(yintercept = xbbar+se), color = "lightgrey") +
      geom_hline(data = stat_s, mapping = aes(yintercept = xbbar+2*se), color = "lightgrey") +
      geom_hline(data = stat_s, mapping = aes(yintercept = xbbar+3*se), color = "lightgrey") +
      geom_hline(data = stat_s, mapping = aes(yintercept = xbbar-se), color = "lightgrey") +
      geom_hline(data = stat_s, mapping = aes(yintercept = xbbar-2*se), color = "lightgrey") +
      geom_hline(data = stat_s, mapping = aes(yintercept = xbbar-3*se), color = "lightgrey") +
      geom_ribbon(
        data = stat_s,
        mapping = aes(x = x, ymin = lower, ymax = upper),
        fill = "steelblue", alpha = 0.2) +
      geom_line(
        data = stat_s,
        mapping = aes(x = x, y = xbar), size = 1
      ) +
      geom_point(
        data = stat_s,
        mapping = aes(x = x, y = xbar), size = 5
      )
    gg = gg + geom_label(
      data = labels,
      mapping = aes(x = x, y = value, label = text),
      hjust = 1 # horizontally justify the labels
    ) +
      # scale_color_manual(values = c("Overall" = "black")) +
      labs(x = xlab, y = ylab, subtitle = "Overall Sample Averages Over Subgroups")
    
    return(gg)
  }
  
  # Creates an overlaid Average Chart grouped by graph_by Selection
  ggxbar_sep = function(user_data, graph_by, xlab = "Time (Subgroups)", ylab = "Average"){
    col_vals = unique(user_data[[graph_by]])
    colors = c("purple", "salmon", "tan", "brown", "turquoise", "darkblue",
               "lightblue", "thistle", "lightpink", "palegreen", "powderblue"
               )
    
    # Get statistics for overall data
    stat_s = get_stat_s(x = user_data$Subgroup, y = user_data$Percent_deviation)
    
    # Generate labels
    labels = stat_s %>%
      reframe(
        x = c(max(x), max(x), max(x)),
        type = c("xbbar", "upper", "lower"),
        name = c("xbbar", "+3 s", "-3 s"),
        value = c(mean(xbbar), max(upper), min(lower))
      ) %>%
      mutate(value = round(value, 2)) %>%
      mutate(text = paste0(name, " = ", value))
    
    # Get overall statistics
    stat_t = get_stat_t(x = user_data$Subgroup, y = user_data$Percent_deviation)
    
    # --- Step 1: Combine all statistics into a single dataframe ---
    all_stats_list <- list()
    for(i in seq_along(col_vals)){
      val <- col_vals[i]
      filtered_df <- user_data %>% filter(!!sym(graph_by) == val)
      curr_data <- tibble(x = filtered_df$Subgroup, y = filtered_df$Percent_deviation)
      curr_stat_s <- get_stat_s(x = curr_data$x, y = curr_data$y)
      
      # Add a column for the legend label
      curr_stat_s[[graph_by]] <- val
      
      all_stats_list[[i]] <- curr_stat_s
    }
    all_stats <- bind_rows(all_stats_list)
    
    # --- Step 2: Generate the plot using the combined data ---
    gg = ggplot() +
      geom_hline(data = stat_s, mapping = aes(yintercept = xbbar), color = "red") +
      geom_ribbon(
        data = stat_s,
        mapping = aes(x = x, ymin = lower, ymax = upper),
        fill = "steelblue", alpha = 0.2) +
      
      # Plot all lines using the single combined dataframe, mapping color inside aes()
      geom_line(
        data = all_stats,
        mapping = aes(x = x, y = xbar, color = !!sym(graph_by)),
        size = 1
      ) +
      geom_point(
        data = all_stats,
        mapping = aes(x = x, y = xbar, color = !!sym(graph_by)),
        size = 3
      ) +
      
      geom_label(
        data = labels,
        mapping = aes(x = x, y = value, label = text),
        hjust = 1
      ) +
      
      scale_color_manual(values = colors[1:length(col_vals)], name = graph_by) +
      labs(x = xlab, y = ylab, subtitle = "Sample Averages Over Subgroups (Grouped by Selection)")
    
    return(gg)
  }
  samples = take_samples(user_data)
  plot_overall = ggxbar_overall(samples)
  plot_sep = ggxbar_sep(samples, graph_by)
  combined_plot <- ggarrange(plot_overall, plot_sep, 
                             ncol = 2,
                             common.legend = TRUE,
                             legend = "bottom"
  )
  combined_plot
}

process_csv = function(df, graph_by){
  init_data = df
  
  # Create Subgroups
  init_data1 <- init_data %>%
    mutate(Subgroup = case_when(
      is.na(Shift) | is.na(Shift_Section) ~ NA_integer_,
      TRUE ~ (as.numeric(Shift) - 1) * 3 + match(Shift_Section, c("Beginning", "Middle", "End"))
    ))
  
  
  # Format
  format_plots(init_data1, graph_by)

}