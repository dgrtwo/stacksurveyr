library(dplyr)
library(readr)
library(tidyr)
library(stringr)

stack_survey <- readr::read_csv("data-raw/2016 Stack Overflow Survey Responses.csv")

colnames(stack_survey)[1] <- "id"

tech_do <- stack_survey %>%
  select(id, tech_do) %>%
  unnest(tech = str_split(tech_do, "; "))

```{r}
stack_survey %>%
  select(id, starts_with("important_"), starts_with("value_")) %>%
  gather(short, answer, -id) %>%
  filter(!is.na(answer)) %>%
  separate(short, c("type", "short"), extra = "merge")
```
