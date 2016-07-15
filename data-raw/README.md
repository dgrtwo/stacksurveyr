

## Setup of Stack Overflow 2016 Developer Survey Answers

This document sets up the data in the `stacksurveyr` package, based on the following two files:

* [2016 Stack Overflow Survey Responses.csv](2016 Stack Overflow Survey Responses.csv): raw CSV available from [stackoverflow.com/research](http://stackoverflow.com/research)
* [schema.csv](schema.csv) This is adapted and formatted from the schema given in the README present with the survey responses

You can run this code yourself with the knitr package: `knitr::knit("README.Rmd")`.

### stack_schema

The schema is read in fairly straightforwardly from [schema.csv](schema.csv):


```r
library(readr)

stack_schema <- read_csv("schema.csv")
devtools::use_data(stack_schema, overwrite = TRUE)
```

### stack_survey

We read in the survey from the [raw CSV file](2016 Stack Overflow Survey Responses.csv):


```r
library(dplyr)
library(tidyr)
library(stringr)

survey_raw <- read_csv("2016 Stack Overflow Survey Responses.csv")
```

There are two column types that need to be converted to ordered factors: scales ("On a scale of 1-5, how much do you agree...") and ranges ("How much experience do you have...").


```r
convert_range_factor <- function(x) {
  d <- data_frame(name = unique(x)) %>%
    filter(!is.na(name)) %>%
    mutate(num = extract_numeric(str_extract(name, "[\\d\\,]+"))) %>%
    arrange(num, desc(name))
  
  factor(x, levels = d$name, ordered = TRUE)
}

agree_levels <- c("Disagree completely", "Disagree somewhat", "Neutral",
                  "Agree somewhat",  "Agree completely")
important_levels <- c("I don't care about this", "This is somewhat important",
                      "This is very important" )

stack_survey <- stack_survey %>%
  mutate_each(funs(convert_range_factor), contains("_range"))
  mutate_each(funs(factor(., levels = important_levels, ordered = TRUE)),
              starts_with("important_")) %>%
  mutate_each(funs(factor(., levels = agree_levels, ordered = TRUE)),
              starts_with("agree_"))
```

```
## Error in lazyeval::as.lazy_dots(dots): could not find function "starts_with"
```

```r
colnames(stack_survey)[1] <- "respondent_id"

devtools::use_data(stack_survey)
```

```
## Error: stack_survey.rda already exists in /Users/drobinson/Dropbox/stacksurveyr/data. Use overwrite = TRUE to overwrite
```

### stack_multi 

We also compute a tidied table of all multiple responses:


```r
multi_response_qs <- stack_schema$column[stack_schema$type == "multi"]

stack_multi <- stack_survey %>%
  select(respondent_id, one_of(multi_response_qs)) %>%
  gather(column, answer, -respondent_id) %>%
  filter(!is.na(answer)) %>%
  unnest(answer = str_split(answer, "; "))

devtools::use_data(stack_multi)
```
