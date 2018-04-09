# Occupancy analysis
# R script for full occupancy models


library(tidyverse)
library(lubridate)
library(readr)
library(forcats)
library(camtrapR)
library(unmarked)
library(standardize)

# I also read data files from BC Agricultural Land Use Inventory (ALUI) for cover type and land use data. It is necessary to make the following formatting adjustments to the .csv data:  
#  - DateTimeOriginal column is formatted as YYYY-MM-DD hh:mm:ss in Excel before saving, then read into R using `format = "%Y-%m-%d %H:%M:%S`  

#I made the following edits to "all_sitecovs.csv":
#  - added BC ALUI landcovers   
#  - added elevation from DEM   
#  - changes Site names for NABat sites with year prefix
#  - removed sites with NA start dates   
#  - Added 14 iterations of the observation covariates: GLA and LAI.4  

all_sitecovs <- read_csv("./r_scripts/t2_dataanaly/t2a_occupancy/data/all_sitecovs_2016.csv")
all_sitecovs$D.1 <- yday(as.Date(all_sitecovs$D.1, "%Y-%m-%d")) # converts date to Julian number
all_sitecovs$D.2 <- yday(as.Date(all_sitecovs$D.2, "%Y-%m-%d"))
all_sitecovs$D.3 <- yday(as.Date(all_sitecovs$D.3, "%Y-%m-%d"))
all_sitecovs$D.4 <- yday(as.Date(all_sitecovs$D.4, "%Y-%m-%d"))
all_sitecovs$D.5 <- yday(as.Date(all_sitecovs$D.5, "%Y-%m-%d"))
all_sitecovs$D.6 <- yday(as.Date(all_sitecovs$D.6, "%Y-%m-%d"))
all_sitecovs$D.7 <- yday(as.Date(all_sitecovs$D.7, "%Y-%m-%d"))
all_sitecovs$D.8 <- yday(as.Date(all_sitecovs$D.8, "%Y-%m-%d"))
all_sitecovs$D.9 <- yday(as.Date(all_sitecovs$D.9, "%Y-%m-%d"))
all_sitecovs$D.10 <- yday(as.Date(all_sitecovs$D.10, "%Y-%m-%d"))
all_sitecovs$D.11 <- yday(as.Date(all_sitecovs$D.11, "%Y-%m-%d"))
all_sitecovs$D.12 <- yday(as.Date(all_sitecovs$D.12, "%Y-%m-%d"))
all_sitecovs$D.13 <- yday(as.Date(all_sitecovs$D.13, "%Y-%m-%d"))
all_sitecovs$D.14 <- yday(as.Date(all_sitecovs$D.14, "%Y-%m-%d"))
edit_sitecovs <- select(all_sitecovs,Station=Site,Project=Proj,GLA,LAI_4,Elev,Shape_Leng,Shape_Area,Region,
                        PrimaryLandUse,COVER,W.1,W.2,W.3,W.4,W.5,W.6,W.7,W.8,W.9,W.10,W.11,W.12,W.13,W.14,
                        T.1,T.2,T.3,T.4,T.5,T.6,T.7,T.8,T.9,T.10,T.11,T.12,T.13,T.14,
                        P.1,P.2,P.3,P.4,P.5,P.6,P.7,P.8,P.9,P.10,P.11,P.12,P.13,P.14,
                        D.1,D.2,D.3,D.4,D.5,D.6,D.7,D.8,D.9,D.10,D.11,D.12,D.13,D.14)

sites.df <- read_csv("./r_scripts/t2_dataanaly/t2a_occupancy/data/all_sites.csv")

sites <- left_join(sites.df,edit_sitecovs,"Station")
sites_2016 <- sites %>%
  filter(SurvYr == 2016)
sites_2016[c("DetMod", "MicTyp")][is.na(sites_2016[c("DetMod", "MicTyp")])] <- "UNKNOWN"
write_csv(sites_2016, "./r_scripts/t2_dataanaly/t2a_occupancy/data/sitecovs_2016.csv")

all_obs_full_read <- readRDS("./r_scripts/t2_dataanaly/t2a_occupancy/data/all_obs_comp.rds")
sitecovs_2016 <- read_csv("./r_scripts/t2_dataanaly/t2a_occupancy/data/sitecovs_2016.csv")

all_obs_ungroup <- ungroup(all_obs_full_read)
all_obs_df <- as.data.frame(all_obs_ungroup) %>%
  mutate(DateTime_fmt = as.Date(DateTime, format = "%Y-%m-%d %H:%M:%S"))
#write_csv(all_obs_df,"datecheck.csv")

#all_obs_df %>%
#  group_by(Sp_final) %>%
#  summarize(max(length(Count)))


## Detector operation Periods
det_op_2016 <- data.frame(lapply(sitecovs_2016, as.character), stringsAsFactors=FALSE)

detop <- cameraOperation(CTtable = det_op_2016,           # Update with problems
                         stationCol = "Station",
                         setupCol = "DateStart",
                         retrievalCol = "DateEnd",
                         writecsv = F,
                         hasProblems = F,     
                         dateFormat = "%Y-%m-%d"
)

camopPlot <- function(camOp){
  which.tmp <- grep(as.Date(colnames(camOp)), pattern = "01$")
  label.tmp <- format(as.Date(colnames(camOp))[which.tmp], "%Yâ€%m")
  at.tmp <- which.tmp / ncol(camOp)
  image(t(as.matrix(camOp)), xaxt = "n", yaxt = "n", col = c("red", "grey70"))
  axis(1, at = at.tmp, labels = label.tmp)
  axis(2, at = seq(from = 0, to = 1, length.out = nrow(camOp)), labels = rownames(camOp), las = 1)
  abline(v = at.tmp, col = rgb(0,0,0, 0.2))
  box()
}
camopPlot(camOp = detop)


## Detection Histories
#Need to check for:   
#  - missing data   
#  - detector not working 


# 01 Detection history for MYLU
DetHist_Mylu <- detectionHistory(recordTable = all_obs_df,
                                 camOp = detop,
                                 stationCol = "Station",
                                 speciesCol = "Species",
                                 recordDateTimeCol = "DateTime",
                                 recordDateTimeFormat = "%Y-%m-%d %H:%M:%S",
                                 species = "MYLU",
                                 occasionLength = 4,
                                 day1 = "station",
                                 timeZone = "America/Vancouver",
                                 includeEffort = T,
                                 datesAsOccasionNames = F,
                                 scaleEffort = T,
                                 writecsv = T,
                                 outDir = "./r_output")

# 02 Detection history for MYYU
DetHist_Myyu <- detectionHistory(recordTable = all_obs_df,
                                 camOp = detop,
                                 stationCol = "Station",
                                 speciesCol = "Species",
                                 recordDateTimeCol = "DateTime",
                                 recordDateTimeFormat = "%Y-%m-%d %H:%M:%S",
                                 species = "MYYU",
                                 occasionLength = 4,
                                 day1 = "station",
                                 timeZone = "America/Vancouver",
                                 includeEffort = T,
                                 datesAsOccasionNames = F,
                                 scaleEffort = T,
                                 writecsv = T,
                                 outDir = "./r_output")

# 03 Detection history for MYEV
DetHist_Myev <- detectionHistory(recordTable = all_obs_df,
                                 camOp = detop,
                                 stationCol = "Station",
                                 speciesCol = "Species",
                                 recordDateTimeCol = "DateTime",
                                 recordDateTimeFormat = "%Y-%m-%d %H:%M:%S",
                                 species = "MYEV",
                                 occasionLength = 4,
                                 day1 = "station",
                                 timeZone = "America/Vancouver",
                                 includeEffort = T,
                                 datesAsOccasionNames = F,
                                 scaleEffort = T,
                                 writecsv = T,
                                 outDir = "./r_output")

# 04 Detection history for LACI
DetHist_Laci <- detectionHistory(recordTable = all_obs_df,
                                 camOp = detop,
                                 stationCol = "Station",
                                 speciesCol = "Species",
                                 recordDateTimeCol = "DateTime",
                                 recordDateTimeFormat = "%Y-%m-%d %H:%M:%S",
                                 species = "LACI",
                                 occasionLength = 4,
                                 day1 = "station",
                                 timeZone = "America/Vancouver",
                                 includeEffort = T,
                                 datesAsOccasionNames = F,
                                 scaleEffort = T,
                                 writecsv = T,
                                 outDir = "./r_output")

# Set up covariate matrices
siteCovs <- sites_2016[,c("Station","LAI_4","GLA","Elev","DetMod","MicTyp")]
siteCovs[,2] <- scale(siteCovs$LAI_4) # standardize covariates
siteCovs[,3] <- scale(siteCovs$GLA)
siteCovs[,4] <- scale(siteCovs$Elev)
#siteCovs[,8] <- scale(siteCovs$mic_ht)
siteCovs_df <- as.data.frame(siteCovs)

#Remove rows without fisheye images for GLA/LAI
#siteCovs_subset <- filter(siteCovs, GLA.x != "NA")

wind <- scale(sites_2016[,c("W.1","W.2","W.3","W.4","W.5","W.6","W.7","W.8","W.9","W.10","W.11","W.12","W.13","W.14")])
#wind_ungroup <- ungroup(wind)
wind_df <- as.data.frame(wind)

temp <- scale(sites_2016[,c("T.1","T.2","T.3","T.4","T.5","T.6","T.7","T.8","T.9","T.10","T.11","T.12","T.13","T.14")])
#temp_ungroup <- ungroup(temp)
temp_df <- as.data.frame(temp)

precip <- scale(sites_2016[,c("P.1","P.2","P.3","P.4","P.5","P.6","P.7","P.8","P.9","P.10","P.11","P.12","P.13","P.14")])
#precip_ungroup <- ungroup(precip)
precip_df <- as.data.frame(precip)

date <- scale(sites_2016[,c("D.1","D.2","D.3","D.4","D.5","D.6","D.7","D.8","D.9","D.10","D.11","D.12","D.13","D.14")])
#date_ungroup <- ungroup(date)
date_df <- as.data.frame(date)

obsCovs <- list(wind=wind_df, temp=temp_df, precip=precip_df, date=date_df)

# Clean up Environment
rm(siteCovs)
rm(temp)
rm(temp_df)
rm(wind)
rm(wind_df)
rm(precip)
rm(precip_df)
rm(date)
rm(date_df)


## Occupancy models
occMYLU <- read_csv("./r_output/DetHist/DetHist_MYLU.csv", col_names = TRUE, 
                    col_types = cols(
                      X1 = col_character(),
                      o1 = col_logical(),
                      o2 = col_logical(),
                      o3 = col_logical(),
                      o4 = col_logical(),
                      o5 = col_logical(),
                      o6 = col_logical(),
                      o7 = col_logical(),
                      o8 = col_logical(),
                      o9 = col_logical(),
                      o10 = col_logical(),
                      o11 = col_logical(), 
                      o12 = col_logical(),
                      o13 = col_logical(),
                      o14 = col_logical()), locale = default_locale(), na = c("", "NA"))
y <- occMYLU[,2:15]

names(obsCovs) <- c("wind","temp","precip","date")

MyluUMF <- unmarkedFrameOccu(y = y, siteCovs = siteCovs_df, obsCovs = obsCovs)

summary(MyluUMF)
plot(MyluUMF, panels = 4)
# Double right-hand side formula describing covariates of detection and occupancy in that order
fm0101 <- occu(~ 1 ~ 1, MyluUMF)
fm0102 <- occu(~ 1 ~ Elev, MyluUMF)
fm0103 <- occu(~ Elev ~ 1, MyluUMF)
fm0104 <- occu(~ 1 ~ LAI_4, MyluUMF)
fm0105 <- occu(~ 1 ~ GLA, MyluUMF)
fm0106 <- occu(~ 1 ~ LAI_4 + GLA, MyluUMF)
fm0107 <- occu(~ DetMod ~ 1, MyluUMF)
fm0108 <- occu(~ MicTyp ~ 1, MyluUMF)
fm0109 <- occu(~ DetMod + MicTyp ~ 1, MyluUMF)
#fm0110 <- occu(~ mic_ht ~ 1, MyluUMF)
fm0111 <- occu(~ precip ~ 1, MyluUMF)
fm0112 <- occu(~ temp ~ 1, MyluUMF)
fm0113 <- occu(~ wind ~ 1, MyluUMF)
fm0114 <- occu(~ date ~ 1, MyluUMF)

#fm5 <- occu(~ 1 ~ Elev, myluUMF, starts=c(100,1000,0))# how to improve starting values?
#fm6 <- occu(~ 1 ~ habitat, myluUMF)

## Model Selection
fmsMYLU <- fitList('psi(.)p(.)' = fm0101,
                   'psi(elevation)p(.)' = fm0102,
                   'psi(.)p(elevation)' = fm0103,
                   'psi(leaf area index 4)p(.)' = fm0104,
                   'psi(gap light)p(.)' = fm0105,
                   'psi(leaf area index 4 + gap light)p(.)' = fm0106,
                   'psi(.)p(detector model)' = fm0107,
                   'psi(.)p(mic type)' = fm0108,
                   'psi(.)p(detector + mic)' = fm0109,
                   #'psi(.)p(mic height)' = fm0110,
                   'psi(.)p(precipitation)' = fm0111,
                   'psi(.)p(temperature)' = fm0112,
                   'psi(.)p(wind gust)' = fm0113,
                   'psi(.)p(date)' = fm0114
)
modSel(fmsMYLU)

# Top model
fm0110