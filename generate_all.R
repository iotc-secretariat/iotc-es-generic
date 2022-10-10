# General options
options(scipen = 100)

# Period to be included in ES
START_YEAR = 1950
END_YEAR = 2021

# General parameters
ES_SPECIES_CODE  = "BLM"
STATISTICAL_YEAR = 2021
REPORT_YEAR      = 2022
MEETING          = "WPB22"
LANGUAGE         = "E"
  
TITLE = paste0("IOTC-", REPORT_YEAR, "-", MEETING, "-ES06_", ES_SPECIES_CODE, "_", LANGUAGE, "_DATA")

# Create output folder if not available
if (!dir.exists(paste0("./outputs/", ES_SPECIES_CODE, "/charts/")))
dir.create(paste0("./outputs/", ES_SPECIES_CODE, "/charts/"), recursive = TRUE)

# Source the R codes
setwd("initialization")
source("00_CORE.R")
setwd("..")
 
# Produce the document with bookdown
render("rmd/00_DOCX.Rmd", 
       output_format = "word_document2", 
       output_dir    = paste0("outputs/", ES_SPECIES_CODE, "/"), 
       output_file   = paste0(TITLE, ".docx")
)

# Produce the document with OFFICER

# Explore template style
# my_template <- read_docx("./templates/doc_template.docx") 
# styles_info(my_template, type = "paragraph")
# styles_info(my_template, type = "table")
# styles_info(my_template, type = "numbering")

# render("rmd/00_DOCX_OFFICER.Rmd", 
#        output_dir    = "outputs/", 
#        output_file   = paste0(TITLE, "_OFFICER.docx")
# )
