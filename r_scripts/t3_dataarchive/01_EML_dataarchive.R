## ZOOL500: Directed Studies
## P Burke
## Training at ESA 2017: Workshop to Archive Data Environmetal Data Initiative
## Date Created: 2018 April 03
## Last Modification: 2018 April 09

#library(devtools)
#install_github("EDIorg/EMLassemblyline", build_vignettes = TRUE, force = TRUE)
library(EML)
library(EMLassemblyline)

##----------------------
## EML Configuration

# The configuration file was provided by EDI during the 2017 ESA Training
#
# This file contains information about the dataset that is not included in the 
# template files. It is called upon by compile_attributes.R, define_factors.R, and 
# create_eml.R. This file contains the EMLtools version number that is required 
# for successful operation.
#
# See copy_templates.R to copy metadata templates to the dataset working 
# directory.



# Define dataset parameters ---------------------------------------------------


# Enter a title for your dataset. Be descriptive (more than 5 words):

dataset_title <- "Fish and Wildlife Compensation Program: Local bat records from the Wahleach Creek Drainage using passive bioacoustic monitoring devices in British Columbia: 2016"


# Enter the name of your dataset. This name must match that used for your 
# template files:

dataset_name <- "coaf17w1211_pbm"


# List keywords that best describe your dataset. Consult this resource 
# (http://vocab.lternet.edu/vocab/vocab/index.php) as you populate the list.
# Additionally, use keywords that describe your lab, station, and project 
# (e.g. GLEON, NSF). Combine keywords into a vector.

keywords = c("bats","mammals","lakes","reservoirs","wetlands","habitat use",
             "bioacoustics","community composition","species diversity","species richness",
             "conservation","Fish and Wildlife Compensation Program")


# Enter the beginning and ending dates covered by your dataset.

begin_date <- "2016-05-10"
end_date <- "2017-01-10"


# Enter the spatial bounding coordinates of your dataset (in decimal degrees) 
# and a brief description. Longitudes west of the prime meridian and latitudes 
# south of the equator are prefixed with a minus sign (i.e. dash -). A detailed 
# list of sampling site coordinates can be supplied by using the 
# extract_geocoverage() function.

geographic_location <- "North America"

coordinate_north <- 49.33
coordinate_east <- -121.49
coordinate_south <- 49.13
coordinate_west <- -121.73
  
# Provide information on funding of this work. If several grants were involved,
# list the main grant first.

funding_title = "Conserving Riparian Habitats and Species-at-Risk in Wahleach Watershed"

funding_grants = "Fish and Wildlife Compensation Program COA-F17-W-1211"


# Specify whether data collection for this dataset is "ongoing" or "completed".

maintenance_description <- "completed"  


# Enter information about the system you are publishing this dataset under. 
# If you have not been provided a value for this field by EDI staff, enter the 
# default value "edi".

root_system <- "edi"


# Enter your user ID. If you haven't received a user ID from EDI staff, use 
# the default value "name".

user_id <- "name"


# Enter the author system your user ID is associated with. If you haven't 
# received a author system specification from EDI staff, use the default value 
# "edi".

author_system <- "edi"


# Enter the data package ID. If you have not been provided a package ID from 
# EDI staff, enter the default value "edi.1.1".

data_package_id <- "edi.1.1"


# Set data table parameters ---------------------------------------------------


# Enter the full name(s) of your data tables as a combined vector.

table_names <- c("dat_coaf17w1211_pbmobserv.csv",
                 "dat_coaf17w1211_pbmsites.csv")


# Provide a brief descriptions for your data tables. If more than one data 
# table, then combine your descriptions into a vector (order must follow that 
# listed in the table_names object).

data_table_descriptions <- c("Site characteristics for sample stations, including spatail information, biogeographic variables, and equipment settings",
                             "Species detections and time stamps from passive bioacoustic data, identified by visual analysis from a trained observer")


# Enter the URLs of the data tables if you will have them stored on a publicly 
# accessible server (i.e. does not require user ID or password) so PASTA can 
# upload them into the repository. If you will be manually uploading your data 
# tables to PASTA, then leave this object empty (i.e. ""), and enter a value 
# for storage_type below. If more than one data table, then combine your URLs 
# into a vector (order must follow that listed in the table_names object).

data_table_urls <- c("")


# If your data is not available online (i.e. doesn't have a publicly accessible 
# URL), describe the medium on which the data is stored. If more than one data 
# table, then combine your storage types into a vector (order must follow that 
# listed in the table_names object).

storage_type <- c("External Hard Drive")


# Define the number of header lines of your data table(s). This is the number of 
# lines prior to the beginning of data. If there is more than one data table, 
# then combine these values into a vector (order must follow that listed in the 
# table_names object).

num_header_lines <- c("1", 
                       "1")


# Define the end of line specifier for your data table(s). This character 
# denotes the end of a data row. If your computers operating system is 
# Windows, then enter "\\r\\n". If you are using a Mac OS then use the value 
# "\\n". If there is more than one data table, then combine these values into 
# a vector (order must follow that listed in the table_names object).

record_delimeter <- c("\\r\\n",
                       "\\r\\n")


# Define the orientation of attributes in your data table. Acceptable value 
# is "column". If there is more than one data table, then combine 
# these values into a vector (order must follow that listed in the table_names 
# object).

attribute_orientation <- c("column",
                           "column")


# Define the field delimeter of your data tables. Acceptable values are "comma" 
# and "tab". If there is more than one data table, then combine these values 
# into a vector (order must follow that listed in the table_names object).

field_delimeter <- c("comma",
                     "comma")


# Define the quote character used in your data tables. If the quote character 
# is quotation marks, then enter \" below. If the quote character is an
# apostrophe, then enter \' below. If there is no quote character used in your
# data tables then leave as is. If there is more than one data table, then 
# combine these values into a vector (order must follow that listed in the 
# table_names object).

quote_character <- c("\"",
                     "\"")


# View and search the standard units dictionary
view_unit_dictionary()

# View documentation for this function
?define_catvars

# Run this function for your dataset\
# NOTE: didn't work when both data files were in directoy
#       So moved one data file to temp directory to run the following function:

define_catvars(path = "C:/_git_burkeprw/zool500_batdatamgt/r_scripts/t3_dataarchive/eml/")
