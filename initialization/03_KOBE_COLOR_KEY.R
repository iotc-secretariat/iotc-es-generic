
PROP_TABLE = data.frame(`Colour key` = c("Stock subject to overfishing (FYear / FMSY > 1)", "Stock not subject to overfishing (FYear / FMSY < 1)", "Not assessed / Uncertain"),
                        `Stock overfished (SBYear / SBMSY < 1)` = c('X%', 'Y%', ''),
                        `Stock not overfished (SBYear / SBMSY > 1)` = c('W%', 'Z%', ''), check.names = FALSE)

PROP_TABLE_FT =
  PROP_TABLE %>%
  flextable() %>%
  compose(part = "header", j = 1,  value = as_paragraph("")) %>%
  compose(part = "header", j = 2,  value = as_paragraph("Stock overfished (SB", as_sub("2020")," / SB",as_sub("MSY"),"<1)")) %>%
  compose(part = "header", j = 3,  value = as_paragraph("Stock not overfished (SB", as_sub("2020")," / SB",as_sub("MSY"),'\u2265 1)')) %>%
  compose(part = "body", i = 1, j = 1, value = as_paragraph("Stock subject to overfishing (F", as_sub("2020")," / F",as_sub("MSY"),'\u2265 1)')) %>%
  compose(part = "body", i = 2, j=1, value = as_paragraph("Stock not subject to overfishing (F", as_sub("2020")," / F",as_sub("MSY"),'\u2264 1)')) %>%
  #  footnote(part = 'header', i = 1, j = 1, value = as_paragraph('The percentages are calculated as the proportion of model terminal values that fall within each quadrant with model weights taken into account'), ref_symbols=' ') %>%
  bg(i = 1, j = 2, bg = 'red') %>%
  bg(i = 1, j = 2, bg = 'red') %>%
  bg(i = 1, j = 3, bg = 'orange') %>%
  bg(i = 2, j = 2, bg = 'yellow') %>%
  bg(i = 2, j = 3, bg = 'green') %>%
  bg(i = 3, j = 2, bg = 'grey') %>%
  bg(i = 3, j = 3, bg = 'grey') %>%
  fontsize(part = 'header', size = 9) %>%
  fontsize(part = 'body', size = 9) %>%
  flextable::font(part = 'all', fontname = 'Calibri') %>%
  flextable::color(part = 'body', i = 1, j = 2, color = 'white') %>%
  align(part = 'body',j = 2:3, align='center') %>%
  border_inner() %>%
  border_outer(border = fp_border(width = 2)) %>%
  merge_at(i = 3, j = 2:3) %>%
  autofit()


