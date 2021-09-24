#' ---
#' title: "Data Preparation"
#' ---

#' ### Download the raw data from EDI.org

#+ download_data, eval=FALSE
library(tidyverse)
library(lubridate)
library(usethis)
library(metajam)


# Chemistry of stream water from the Luquillo Mountains
# McDowell, W. 2021. Chemistry of stream water from the Luquillo Mountains ver 4923053.
# Environmental Data Initiative. https://doi.org/10.6073/pasta/c6c35d45f7b25baac164acf42a40e95e (Accessed 2021-09-24).
luq_url <- "https://portal.edirepository.org/nis/dataviewer?packageid=knb-lter-luq.20.4923053&entityid=a05bda0a0af888cc037ff5dd00dafd7e"
stream_chem_path <- download_d1_data(data_url = luq_url, path = tempdir())


#' ### Filter the Data

#' We want to analyze the effect of hurricane Hugo which made landfall in September 1989. We are going to use the period from 1985 to 1994.

#+ data sampling, eval=FALSE
# Read that data
# View(stream_chem$attribute_metadata)
# -9999 is stated a no value in the metadata
stream_chem <- read_d1_files(stream_chem_path, na = c("-9999"))
luq_stream_chem <- stream_chem$data

# Transform the date column from character to date
luq_stream_chem <- luq_stream_chem %>%
  separate(Sample_Date, c("Sample_Date", "Sample_Time"), sep=" ") %>%
  mutate(Sample_Date = dmy(Sample_Date)) %>%
  drop_na(Sample_Date) # some dates are not of the format dmy, but before our time period of interest

# Filter from 1987 to 1992
luq_streamchem <- luq_stream_chem %>%
  filter(year(Sample_Date) > 1986 & year(Sample_Date) < 1993)


#+ save data, include=FALSE, eval = FALSE
## Save sample file
use_data(luq_streamchem, overwrite = TRUE)

