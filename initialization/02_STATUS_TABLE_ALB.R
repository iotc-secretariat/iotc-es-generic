print("Initializing NC status table...")

# Nominal catches for the status table

STATUS_TABLE_CATCH = 
  data.frame(
    Area = "Indian Ocean",
    Indicator = c(paste0("Catch (", LAST_YEAR, ") (t)"),
                  paste0("Mean annual catch (", paste(min(LAST_5_YEARS), max(LAST_5_YEARS), sep = "-"), ") (t)"), 
                  "MSY (x1,000 t) (95% CI)", 
                  "FMSY (95% CI)", 
                  "SBMSY (t) (95% CI)", 
                  "FFinal/FMSY (95% CI)", 
                  "SBFinal/SBMSY (95% CI)", 
                  "SBFinal/SB1950 (95% CI)"
                  ),
    Value = c(pn(NC_LAST_YEAR),
              pn(NC_LAST_5_YEARS), 
              "45 (35-55)", 
              "0.18 (0.15-0.21)", 
              "27 (21-33)", 
              "0.68 (0.42-0.94)", 
              "1.56 (0.89-2.24)", 
              "0.36 (0.26-0.45)"),
    Status = NA
  )

# Format the table
STATUS_TABLE_CATCH_FT = 
  STATUS_TABLE_CATCH %>%
  flextable() %>%
  flextable::font(part = "all", fontname = "Calibri") %>%
  flextable::fontsize(part = "header", size = 11) %>%
  flextable::fontsize(part = "body", size = 11) %>%
  flextable::fontsize(part = "footer", size = 4) %>%
  bg(j = "Status", part = "body", bg = "green") %>%
  compose(part = "body", i = 4, j = "Indicator",  value = as_paragraph("F", as_sub("MSY"),' (80% CI)')) %>%
  compose(part = "body", i = 5, j = "Indicator",  value = as_paragraph("SB", as_sub("MSY"),' (x1,000 t) (80% CI)')) %>%
  compose(part = "body", i = 6, j = "Indicator",  value = as_paragraph("F", as_sub("2020"),' / F',as_sub('MSY'),' (80% CI)')) %>%
  compose(part = "body", i = 7, j = "Indicator",  value = as_paragraph("SB", as_sub("2020"),' / SB',as_sub('MSY'),' (80% CI)')) %>%
  compose(part = "body", i = 8, j = "Indicator",  value = as_paragraph("SB", as_sub("2020"),' / SB',as_sub('0'),' (80% CI)')) %>%
    #  add_footer_lines(values = "") %>% 
  #  compose(i = 1, j = 1, value = as_paragraph(as_i("Note: ")), part = "footer") %>%
  bg(part = "header", bg = "lightgrey") %>%
  merge_at(j = "Area") %>%
  merge_at(j = "Status") %>%
  border_inner() %>%
  border_outer(part = "all", border = fp_border(width = 2)) %>%
  align(part = "header", align = "center") %>%
  align(j = 3, align = "right", part = "body") %>%
  footnote(part = 'body', i = 1, j = "Area", value = as_paragraph("Stock boundaries defined as the IOTC area of competence"), ref_symbols = "1", inline = TRUE) %>%
  footnote(part = 'body', i = 1, j = "Indicator", value = as_paragraph(paste0("Proportion of catch fully or partially estimated for ",  LAST_YEAR, ": ", PERCENTAGE_ESTIMATED_LAST_YEAR, "%")), ref_symbols = "2", inline = TRUE) %>%
  footnote(part = 'header', j = "Status", value = as_paragraph("Status relates to the final year data are available for assessment"), ref_symbols = "3", inline = TRUE) %>%
  autofit() %>%
  width(j = "Status", width = 1) %>%
  fix_border_issues()

print("NC status table initialized!")
