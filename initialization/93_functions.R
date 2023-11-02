print("Initializing common functions...")

# Rounding function
round_bin = function(size, bin_size) { return (floor(size / bin_size) * bin_size + bin_size/2) }

#prettyNum with default ',' as big mark
pn = function(number, big.mark = ",") {
  return(prettyNum(number, big.mark = big.mark))
}

#prettyNum with no big mark
pnn = function(number) {
  return(pn(number, ""))
}

#Round to hundreds
rh = function(number) {
  return(r_to(number, 100))
}

#Round to thousands
rt = function(number) {
  return(r_to(number, 1000))
}

#Round to tens of thousands
rtt = function(number) {
  return(r_to(number, 10000))
}

#Round to hundreds of thousands
rht = function(number) {
  return(r_to(number, 100000))
}

#Rounds to a base (a multiple of 10)
r_to = function(number, base) {
  return(round(number / base) * base) 
}

max_catch = function(data) {
  return(data[which.max(CATCH)])
}

max_catch_y = function(data) {
  return(data[, .(CATCH = sum(CATCH)), keyby = .(YEAR)][which.max(CATCH)])
}

min_catch = function(data) {
  return(data[which.min(CATCH)])
}

min_catch_y = function(data) {
  return(data[, .(CATCH = sum(CATCH)), keyby = .(YEAR)][which.min(CATCH)])
}

tot_catch = function(data) {
  return(sum(data$CATCH))  
}

avg_catch_y = function(data) {
  years = min(data$YEAR):max(data$YEAR)
  
  return(tot_catch(data) / length(years))
}

mean_catch_y = function(data) {
  return(mean(data[, CATCH = sum(CATCH), keyby = .(YEAR)]$CATCH))
}

# Wrappers for catch aggregations
catches_by_year = function(data) {
  return(data[, .(CATCH = round(sum(CATCH))), keyby=.(YEAR)])
}

catches_by_year_and_fleet = function(data) {
  return(data[, .(CATCH = round(sum(CATCH))), keyby=.(YEAR, FLEET, FLEET_CODE)])
}

catches_by_year_and_fishery_type = function(data) {
  return(data[, .(CATCH = round(sum(CATCH))), keyby=.(YEAR, FISHERY_TYPE, FISHERY_TYPE_CODE)])
}

catches_by_year_and_fishery_group = function(data) {
  return(data[, .(CATCH = round(sum(CATCH))), keyby=.(YEAR, FISHERY_GROUP, FISHERY_GROUP_CODE)])
}

catches_by_year_and_fishery = function(data) {
  return(data[, .(CATCH = round(sum(CATCH))), keyby=.(YEAR, FISHERY, FISHERY_CODE)])
}

### Utility methods to handle plots etc.

no_legend = function(plot) {
  return(plot + theme(legend.position = "none"))
}

print("Common functions initialized!")
