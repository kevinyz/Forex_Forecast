
df_list <- lapply(list(selected_pairs_hourly, selected_pairs_daily), function(sp_ta) {
  
  for (cp in correlating_pairs) {
    print(paste0("Adding Indicators for ", cp))
    
    ## Moving Averages
    print("Moving Averages")
    
    ### Exponential Moving Average
    for(t_window in 5:20) {
      sp_ta[,paste0(cp,"_EMA_",t_window)] <- TTR::EMA(sp_ta[,paste0(cp,"_Close")], t_window)
    }
    
    ### Simple Moving Average
    for(t_window in 5:20) {
      sp_ta[,paste0(cp,"_SMA_",t_window)] <- TTR::SMA(sp_ta[,paste0(cp,"_Close")], t_window)
    }
    
    ### Double Exponential Moving Average
    for(t_window in 5:20) {
      sp_ta[,paste0(cp,"_DEMA_",t_window)] <- TTR::DEMA(sp_ta[,paste0(cp,"_Close")], t_window)
    }
    
    ## Stop and Reverse
    sp_ta[,paste0(cp,"_SAR")] <- TTR::SAR(sp_ta[,c(paste0(cp,"_High"),paste0(cp,"_Low"))])[,1]
    
    
    ## Trend Indicators
    print("Trend Indicators")
    
    ### Vertical Horizontal Filter
    for(t_window in 5:20) {
      sp_ta[,paste0(cp,"_VHF_",t_window)] <- TTR::VHF(sp_ta[,paste0(cp,"_Close")], t_window)
    }
    
    ### Trend Detection Index
    for(t_window in 5:20) {
      sp_ta[,paste0(cp,"_TDI_",t_window)] <- TTR::TDI(sp_ta[,paste0(cp,"_Close")], t_window)[,1]
    }
    
    ### Commodity Channel Index
    for(t_window in 5:20) {
      sp_ta[,paste0(cp,"_CCI_",t_window)] <- TTR::CCI(sp_ta[,c(paste0(cp,"_High"),paste0(cp,"_Low"),paste0(cp,"_Close"))], t_window)
    }
    
    ### Chaikin Volatility
    for(t_window in 5:20) {
      sp_ta[,paste0(cp,"_CV_",t_window)] <- TTR::chaikinVolatility(sp_ta[,c(paste0(cp,"_High"),paste0(cp,"_Low"))], t_window)
    }
    
    ### De-Trended Price Oscillator
    for(t_window in 5:20) {
      sp_ta[,paste0(cp,"_DPO_",t_window)] <- TTR::DPO(sp_ta[,paste0(cp,"_Close")], t_window)
    }
    
    
    ## Momentum Indicators
    print("Momentum Indicators")
    
    ### Relative Strength Index
    for(t_window in 5:20) {
      sp_ta[,paste0(cp,"_RSI_",t_window)] <- TTR::RSI(sp_ta[,paste0(cp,"_Close")], t_window)
    }
    
    ### Momentum
    for(t_window in 5:20) {
      sp_ta[,paste0(cp,"_MOM_",t_window)] <- TTR::momentum(sp_ta[,paste0(cp,"_Close")], t_window)
    }
    
    ### Rate of Change
    for(t_window in 5:20) {
      sp_ta[,paste0(cp,"_ROC_",t_window)] <- TTR::ROC(sp_ta[,paste0(cp,"_Close")], t_window)
    }
    
    ### Average Directional Movement Index
    for(t_window in 5:20) {
      sp_ta[,paste0(cp,"_ADX_",t_window)] <- TTR::ADX(sp_ta[,c(paste0(cp,"_High"),paste0(cp,"_Low"),paste0(cp,"_Close"))], t_window)[,4]
    }
    
    ### Williams Accumulation/Distribution
    sp_ta[,paste0(cp,"_WILLAD",t_window)] <- TTR::williamsAD(sp_ta[,c(paste0(cp,"_High"),paste0(cp,"_Low"),paste0(cp,"_Close"))])
    
    ### Williams % R
    for(t_window in 5:20) {
      sp_ta[,paste0(cp,"_WPR_",t_window)] <- TTR::WPR(sp_ta[,c(paste0(cp,"_High"),paste0(cp,"_Low"),paste0(cp,"_Close"))], t_window)
    }
    
    ### Ultimate Oscillator
    sp_ta[,paste0(cp,"_UO")] <- TTR::ultimateOscillator(sp_ta[,c(paste0(cp,"_High"),paste0(cp,"_Low"),paste0(cp,"_Close"))])
  }
  
  sp_ta
})


### Drop Rows with no Indicator Values
selected_pairs_hourly_indicators <- df_list[[1]] %>%
  drop_na()
rownames(selected_pairs_hourly_indicators) <- NULL

selected_pairs_daily_indicators <- df_list[[2]] %>%
  drop_na()
rownames(selected_pairs_daily_indicators) <- NULL