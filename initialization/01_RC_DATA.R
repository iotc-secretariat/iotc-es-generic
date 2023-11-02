print("Initializing RC data...")

# DATA EXTRACTION ####

## IOTC species ####
if (ES_SPECIES_CODE %in% c("BET", "SKJ", "SWO", "YFT"))
  NC = NC_raised(species_codes = ES_SPECIES_CODE, years = FIRST_YEAR:LAST_YEAR)

if (ES_SPECIES_CODE %in% c("ALB", "BLM", "BUM", "MLS", "SFA", "BLT", "FRI", "KAW", "LOT", "COM", "GUT")) 
  NC = NC_est(species_codes = ES_SPECIES_CODE, years = FIRST_YEAR:LAST_YEAR)

## Elasmobranch species ####
# Extracts catches for the species and its aggregates
SPECIES_AGGREGATES = data.table(read.xlsx("../inputs/data/SPECIES_CODES_AGGREGATES.xlsx"))

if (ES_SPECIES_CODE %in% unique(SPECIES_AGGREGATES$SPECIES_CODE)) {
  NC                = NC_raw(species_codes = ES_SPECIES_CODE, years = FIRST_YEAR:LAST_YEAR, factorize_results = FALSE)
  SPECIES_CODES_NEI = SPECIES_AGGREGATES[SPECIES_CODE == ES_SPECIES_CODE, SPECIES_CODE_NEI]
  LIST_SPECIES_NEI  = paste0(unique(SPECIES_AGGREGATES[SPECIES_CODE == ES_SPECIES_CODE, paste(SPECIES_CODE_NEI, SPECIES_NEI, sep = ": ")]), collapse = "; ")
  NC_NEI            = NC_raw(species_codes = SPECIES_CODES_NEI, years = FIRST_YEAR:LAST_YEAR, factorize_results = FALSE)
  } 

# SPECIES INFORMATION ####
ES_SPECIES_INFORMATION = unique(NC[, .(SPECIES_CODE, SPECIES, SPECIES_SCIENTIFIC)])

NC_LAST_YEAR    = round(NC[YEAR == LAST_YEAR, sum(CATCH)])
NC_LAST_5_YEARS = round(NC[YEAR %in% LAST_5_YEARS, sum(CATCH/5)])

# AGGREGATE SPECIES
if (!ES_SPECIES_CODE %in% c("ALB", "BET", "SKJ", "YFT", "SWO", "BLM", "BUM", "MLS", "SFA", "BLT", "FRI", "KAW", "LOT", "COM", "GUT")){
  NC_NEI_LAST_YEAR    = round(NC_NEI[YEAR == LAST_YEAR, sum(CATCH)])
  NC_NEI_LAST_5_YEARS = round(NC_NEI[YEAR %in% LAST_5_YEARS, sum(CATCH/5)]) 
  
}

# NC REPORTED vs. ESTIMATED IN LAST YEAR
NC_LY                = NC[YEAR == LAST_YEAR, sum(CATCH)]
NC_LY_REPORTED       = data_quality(species_code = ES_SPECIES_CODE, year_from = LAST_YEAR, year_to = LAST_YEAR)[NC == 0, sum(CATCH)]
NC_LY_ESTIMATED      = NC_LY - NC_LY_REPORTED
PERCENT_LY_ESTIMATED = round(NC_LY_ESTIMATED / NC_LY * 100, 1)

# CHART DATA SETS ####

## Full period ####
NC_YEARS_FISHERY_GROUP = catches_by_year_and_fishery_group(NC)
NC_YEARS_FISHERY       = catches_by_year_and_fishery(NC)

## Recent years ####
NC_FISHERY_GROUP_RECENT_MEAN = NC[YEAR %in% LAST_5_YEARS, .(CATCH = round(sum(CATCH)/5)), keyby = .(FISHERY_GROUP_CODE, FISHERY_GROUP)][order(CATCH, decreasing = TRUE)]
NC_FISHERY_GROUP_RECENT_MEAN[, TOTAL := sum(CATCH)]
NC_FISHERY_GROUP_RECENT_MEAN[, PERCENT_CATCH := round(CATCH/TOTAL*100, 1)]

NC_FISHERY_RECENT_MEAN      = NC[YEAR %in% LAST_5_YEARS, .(CATCH = round(sum(CATCH)/5)), keyby = .(FISHERY_CODE, FISHERY)][order(CATCH, decreasing = TRUE)]
NC_FISHERY_RECENT_MEAN[, TOTAL := sum(CATCH)]
NC_FISHERY_RECENT_MEAN[, PERCENT_CATCH := round(CATCH/TOTAL*100, 1)]

NC_FLEET_RECENT_MEAN      = NC[YEAR %in% LAST_5_YEARS, .(CATCH = round(sum(CATCH)/5)), keyby = .(FLEET_CODE, FLEET)][order(CATCH, decreasing = TRUE)]
NC_FLEET_RECENT_MEAN[, TOTAL := sum(CATCH)]
NC_FLEET_RECENT_MEAN[, PERCENT_CATCH := round(CATCH/TOTAL*100, 1)]

# Summary table

if (ES_SPECIES_CODE %in% c("ALB", "BET", "SKJ", "SWO", "YFT", "BLM", "BUM", "MLS", "SFA", "BLT", "FRI", "KAW", "LOT", "COM", "GUT")) 
  CATCH_DATA_TABLE = data.table(NC_LAST_YEAR                = NC_LY, 
                              NC_LAST_YEAR_REPORTED         = NC_LY_REPORTED, 
                              NC_LAST_YEAR_ESTIMATED        = NC_LY_ESTIMATED, 
                              PERCENT_LAST_YEAR_ESTIMATED   = PERCENT_LY_ESTIMATED, 
                              NC_LAST_5_YEARS               = NC_LAST_5_YEARS
                                ) 

if (!ES_SPECIES_CODE %in% c("ALB", "BET", "SKJ", "SWO", "YFT", "BLM", "BUM", "MLS", "SFA", "BLT", "FRI", "KAW", "LOT", "COM", "GUT"))

  CATCH_DATA_TABLE = data.table(NC_LAST_YEAR                  = round(NC_LY), 
                                NC_LAST_YEAR_REPORTED         = round(NC_LY_REPORTED), 
                                NC_LAST_YEAR_ESTIMATED        = round(NC_LY_ESTIMATED), 
                                PERCENT_LAST_YEAR_ESTIMATED   = round(PERCENT_LY_ESTIMATED, 1), 
                                NC_LAST_5_YEARS               = round(NC_LAST_5_YEARS), 
                                NC_NEI_LAST_YEAR              = round(NC_NEI_LAST_YEAR), 
                                NC_NEI_LAST_5_YEARS           = round(NC_NEI_LAST_5_YEARS)
                             ) 

write.xlsx(CATCH_DATA_TABLE, paste0("../outputs/", ES_SPECIES_CODE, "/CATCH_DATA_TABLE_", ES_SPECIES_CODE, ".xlsx"), colWidths = "auto")

print("RC data initialized!")