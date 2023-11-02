RCE = NC.est(years = FIRST_YEAR:LAST_YEAR)
RCR = NC.raw(years = FIRST_YEAR:LAST_YEAR)

C = DB_CONNECT_TO(server = "IOTCS09", database = "IOTDB")

data_IOTC = function(catch_data, species) {
  l_info(paste("Processing", species))
  
  NCS = catch_data[SPECIES_CODE == species]
  
  NCS = NCS[YEAR >= ym & YEAR <= yM]
  
  DQ = data.quality(connection = C, year_from = yM, year_to = yM, species_code = species)
  DQ$NC = as.numeric(as.character(DQ$NC))
  
  CATCH_LAST = round(sum(NCS[YEAR == yM]$CATCH), 0)
  CATCH_AVG  = round(sum(NCS$CATCH / 5), 0)
  
  EST = sum(DQ[YEAR == yM & NC > 0]$CATCH)
  
  PERC_EST = round(EST / CATCH_LAST * 100 * 100, 0) / 100
  
  return(
    data.table(
      LAST_YEAR_MIN = ym,
      LAST_YEAR_MAX = yM,
      SPECIES_CODE  = species,
      CATCH_LAST    = CATCH_LAST,
      CATCH_AVG     = CATCH_AVG,
      PERC_EST      = PERC_EST
    )
  )
}

data_BYCT = function(catch_data, species, nei_species) {
  l_info(paste("Processing", species))
  
  yM = 2021 #max(catch_data$YEAR)
  ym = yM - 4
  
  NCS = catch_data[SPECIES_CODE == species]
  NEI = catch_data[SPECIES_CODE %in% nei_species]
  
  NCS = NCS[YEAR >= ym & YEAR <= yM]
  NEI = NEI[YEAR >= ym & YEAR <= yM]
  
  DQ = data.quality(connection = C, year_from = yM, year_to = yM, species_code = species)
  DQ$NC = as.numeric(as.character(DQ$NC))
  
  CATCH_LAST = round(sum(NCS[YEAR == yM]$CATCH), 0)
  CATCH_AVG  = round(sum(NCS$CATCH / 5), 0)
  
  EST = sum(DQ[YEAR == yM & NC > 0]$CATCH)
  
  PERC_EST = round(EST / CATCH_LAST * 100 * 100, 0) / 100
  
  NEI_CATCH_LAST = round(sum(NEI[YEAR == yM]$CATCH), 0)
  NEI_CATCH_AVG  = round(sum(NEI$CATCH / 5), 0)
  
  return(
    data.table(
      LAST_YEAR_MIN = ym,
      LAST_YEAR_MAX = yM,
      SPECIES_CODE  = species,
      CATCH_LAST    = CATCH_LAST,
      CATCH_AVG     = CATCH_AVG,
      PERC_EST      = PERC_EST,
      NEI_CATCH_LAST= NEI_CATCH_LAST,
      NEI_CATCH_AVG = NEI_CATCH_AVG
    )
  )
}

SP_IOTC = unique(NCE$SPECIES_CODE)

IOTC = data.table(LAST_YEAR_MIN = integer(),
                  LAST_YEAR_MAX = integer(),
                  SPECIES_CODE  = character(),
                  CATCH_LAST    = numeric(),
                  CATCH_AVG     = numeric(),
                  PERC_EST      = numeric())

for(species in SP_IOTC)
  IOTC = rbind(IOTC, data_IOTC(NCE, species))

write.xlsx(file = "IOTC.xlsx", overwrite = TRUE, x = IOTC)

BYCT = data.table(LAST_YEAR_MIN = integer(),
                  LAST_YEAR_MAX = integer(),
                  SPECIES_CODE  = character(),
                  CATCH_LAST    = numeric(),
                  CATCH_AVG     = numeric(),
                  PERC_EST      = numeric(),
                  NEI_CATCH_LAST= numeric(),
                  NEI_CATCH_AVG = numeric())

BYCT = rbind(BYCT, data_BYCT(NCR, "BSH", c("SKH", "AG38", "RSK")))
BYCT = rbind(BYCT, data_BYCT(NCR, "OCS", c("SKH", "AG38", "RSK")))
BYCT = rbind(BYCT, data_BYCT(NCR, "SPL", c("SKH", "RSK", "AG21", "SPN")))
BYCT = rbind(BYCT, data_BYCT(NCR, "SMA", c("MAK", "MSK", "SKH", "AG38", "SKM", "AG21")))
BYCT = rbind(BYCT, data_BYCT(NCR, "FAL", c("SKH", "RSK", "AG21")))
BYCT = rbind(BYCT, data_BYCT(NCR, "BTH", c("MSK", "SKH", "SHM", "AG21", "THR")))
BYCT = rbind(BYCT, data_BYCT(NCR, "PTH", c("MSK", "SKH", "SHM", "AG21", "THR")))

write.xlsx(file = "BYCT.xlsx", overwrite = TRUE, x = BYCT)