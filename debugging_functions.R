# Debugging functions in R
# Some of these methods are also useful to help you build complex functions.

library(dplyr)

# Our dummy dataset
dummy_data <- data.frame(age = floor(runif(1000,0,100)), 
                         area = c("A", "B", "C", "D"),
                         sex = c("F", "M"))


# A small function that renames a variable and then aggregates
test_function <- function(dataset) {
  dataset <- dataset %>% 
    rename(age_in_years = age)
  
  dataset %>% 
    group_by(sex, age) %>%
    count() %>% ungroup() %>% 
    head()
  
}

# But it fails!!
test_function(dummy_data)
# In a longer, more complex function this error could be difficult to pinpoint.

##############################################.
# The basic way
# Creating objects with the same name as the parameters of the function in the 
# global environment
dataset <- dummy_data

# Then running the code as if outside of the function
  dataset <- dataset %>% 
    rename(age_in_years = age)
  
  dataset %>% 
    count(sex, age) %>% ungroup() %>% 
    head()
  

##############################################.
# Using traceback
test_function(dummy_data) # Running function fails
traceback() # Using traceback tells you where issue is. Complex to read

##############################################.
# Using debug
# Useful to get inside of package functions, for my own functions I tend to use
# browser (see below)
debug(test_function) # Starting debugging mode next time function is run
test_function(dummy_data)
# Remember to come out of debugging mode
debuggingState(on = F) # Switching debugging mode

# There is also a similar function called trace which is more flexible, but
# I have never used it!

##############################################.
# Using print or equivalents
# This is a simple method that requires modifying the function to get an output
# that might help you figuring out what the issue is

test_function <- function(dataset) {
  dataset <- dataset %>% 
    rename(age_in_years = age)
  
  # Introducing a check to look at variable names
  print(paste0("Renaming worked. Variable names are: ", paste(names(dataset), collapse = ',')))
  
  # Other sort of checks can be done with str, head, counts of rows, etc.
  paste("This will show the structure of the dataset at a point in the function")
  str(dataset)
  
  dataset %>% 
    group_by(sex, age) %>%
    count() %>% ungroup() %>% 
    head()
  
}

test_function(dummy_data)

##############################################.
# Using breakpoints
source("function_source.R")
test_function(dummy_data)

# As you need to source to add breakpoints this can be impractical depending on
# where your function is located (e.g. if not in a different script)

##############################################.
# Using browser
test_function <- function(dataset) {
  dataset <- dataset %>% 
    rename(age_in_years = age)
  
  browser() #stopping running of function at this point
  
  dataset %>% 
    count(sex, age) %>% ungroup() %>% 
    head()
  
}

test_function(dummy_data)
# Need to remember to remove the browser afterwards

##############################################.
# Fixing the function
test_function <- function(dataset) {
  dataset <- dataset %>% 
    rename(age_in_years = age)
  
  dataset %>% 
    count(sex, age_in_years) %>% ungroup() %>% 
    head()
  
}

test_function(dummy_data)


## END