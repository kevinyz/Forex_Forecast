
### Read All Currency Pairs

currency_pairs <- list.files(data_path)

print("Loading Currency Pairs..")

### Hourly Data
print("Hourly Data..")

df_list <- lapply(currency_pairs, function(cp) {
  print(paste0("Loading ", cp))
  file_list <- list.files(paste0(data_path, "/", cp, "/"))
  
  lapply(file_list, function(f) {
    ### Read CSV
    df <- read_csv(file = file.path(paste0(data_path, "/", cp, "/", f)),
                   col_names = c("Date","Time","Open","High","Low","Close"),
                   col_types = "?tdddd-") %>%
      mutate(Date = lubridate::as_date(Date),
             Hour = lubridate::hour(Time)) %>%
      arrange(Date, Time) %>%
      group_by(Date, Hour) %>%
      summarise(Open = first(Open),
                High = first(High),
                Low = first(Low),
                Close = first(Close))
    
    ### Date Padding
    time_seq <- seq(as.POSIXct("2010-01-01 00:00:00"), as.POSIXct("2018-12-31 23:00:00"), by="hour")
    time_df <- data.frame(Date = lubridate::as_date(time_seq),
                          Hour = lubridate::hour(time_seq))
    df <- time_df %>%
      left_join(df, by = c("Date","Hour"))
    
    ### Column Names
    df[,paste0(cp,"_Open")] <- df$Open
    df[,paste0(cp,"_High")] <- df$High
    df[,paste0(cp,"_Low")] <- df$Low
    df[,paste0(cp,"_Close")] <- df$Close
    
    df %>%
      select(-Open, -High, -Low, -Close)
  }) %>% bind_rows()
})

all_pairs_hourly <- df_list %>%
  bind_cols() %>%
  drop_na()

rownames(all_pairs_hourly) <- NULL

all_pairs_hourly <- all_pairs_hourly[, -c(grep("Date.", names(all_pairs_hourly)),
                                         grep("Hour.", names(all_pairs_hourly)))]






### Daily Data
print("Daily Data..")

df_list <- lapply(currency_pairs, function(cp) {
  print(paste0("Loading ", cp))
  file_list <- list.files(paste0(data_path, "/", cp, "/"))
  
  lapply(file_list, function(f) {
    ### Read CSV
    df <- read_csv(file = file.path(paste0(data_path, "/", cp, "/", f)),
                   col_names = c("Date","Time","Open","High","Low","Close"),
                   col_types = "?tdddd-") %>%
      mutate(Date = lubridate::as_date(Date),
             Hour = lubridate::hour(Time)) %>%
      arrange(Date, Time) %>%
      group_by(Date) %>%
      summarise(Open = first(Open),
                High = first(High),
                Low = first(Low),
                Close = first(Close))
    
    ### Column Names
    df[,paste0(cp,"_Open")] <- df$Open
    df[,paste0(cp,"_High")] <- df$High
    df[,paste0(cp,"_Low")] <- df$Low
    df[,paste0(cp,"_Close")] <- df$Close
    
    df %>%
      select(-Open, -High, -Low, -Close)
  }) %>% bind_rows()
})

all_pairs_daily <- df_list %>%
  bind_cols() %>%
  drop_na()

all_pairs_daily <- all_pairs_daily[, -c(grep("Date.", names(all_pairs_daily)),
                                        grep("Hour.", names(all_pairs_daily)))]