# General options
options(scipen = 100)

# Period to be included in ES
FIRST_YEAR = 1950
LAST_YEAR = 2023
LAST_5_YEARS = (LAST_YEAR-4):LAST_YEAR

# ES NUMBERING
ES_NUMBERING = data.frame(SPECIES_CODE = c("ALB", "BET", "SKJ", "YFT", "SBF", "BLT", "FRI", "KAW", "LOT", "GUT", "COM", "BLM", "BUM", "MLS", "SFA", "SWO", "BSH", "OCS", "SPL", "SMA", "FAL", "BTH", "PTH"), NUMBER = 1:23)

# General parameters
ES_SPECIES_CODE  = "SKJ"
REPORT_YEAR      = 2024
MEETING          = "SC26"
ES_NUMBER        = sprintf("%02d", ES_NUMBERING[ES_NUMBERING$SPECIES_CODE == ES_SPECIES_CODE,  "NUMBER"])
LANGUAGE         = "E"

TITLE = paste0("IOTC-", REPORT_YEAR, "-", MEETING, "-ES", ES_NUMBER, "_", ES_SPECIES_CODE, "_", LANGUAGE)

# Create output folder if not available
if (!dir.exists(paste0("./outputs/", ES_SPECIES_CODE, "/charts/")))
dir.create(paste0("./outputs/", ES_SPECIES_CODE, "/charts/"), recursive = TRUE)

# Source the R codes
setwd("initialization")
source("00_CORE.R")
setwd("..")
 
# OFFICEDOWN
render("rmd/00_DOCX.Rmd", 
       output_dir    = paste0("outputs/", ES_SPECIES_CODE, "/"), 
       output_file   = paste0(TITLE, ".docx")
       )
