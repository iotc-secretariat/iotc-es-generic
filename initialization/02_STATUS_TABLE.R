print("Initializing NC status table...")

# Nominal catches for the status table

STATUS_TABLE_CATCH = 
  data.frame(
  Area = "Indian Ocean",
  Indicator = c(paste0("Catch (", LAST_YEAR, ") (t)"),
                paste0("Mean annual catch (", paste(min(LAST_5_YEARS), max(LAST_5_YEARS), sep = "-"), ") (t)")),
  Value = c(pn(NC_LAST_YEAR),
          pn(NC_LAST_5_YEARS)),
  Status = NA
  )
  
# Format the table
STATUS_TABLE_CATCH_FT = 
  STATUS_TABLE_CATCH %>%
  flextable() %>%
  flextable::font(part = "all", fontname = "Calibri") %>% 
  flextable::fontsize(part = "header", size = 11) %>% 
  flextable::fontsize(part = "body", size = 11) %>% 
  bg(part = "header", bg = "lightgrey") %>%
  merge_at(j = "Area") %>%
  merge_at(j = "Status") %>%
  border_inner() %>%
  border_outer(part = "all", border = fp_border(width = 2)) %>%
  align(part = "header", align = "center") %>%
  align(j = 3, align = "right", part = "body") %>%
  footnote(part = 'body', i = 1, j = "Area", value = as_paragraph("Stock boundaries defined as the IOTC area of competence"), ref_symbols = "1", inline = TRUE) %>%
  footnote(part = 'body', i = 1, j = "Indicator", value = as_paragraph(paste0("Proportion of catch fully or partially estimated for ",  LAST_YEAR, ": ", PERCENT_LY_ESTIMATED, "%")), ref_symbols = "2", inline = TRUE) %>%
  footnote(part = 'header', j = "Status", value = as_paragraph("Status relates to the final year data are available for assessment"), ref_symbols = "3", inline = TRUE) %>%
  flextable::font(part = "footer", fontname = "Calibri") %>%
  flextable::fontsize(part = "footer", size = 8) %>% 
  fix_border_issues() %>%
  autofit()

print("NC status table initialized!")
