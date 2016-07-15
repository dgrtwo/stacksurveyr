#' Unnest multi-answer questions on the Stack Overflow Developer Survey
#'
#' Several questions on the Developer Survey allow multiple responses, which
#' appear in the dataset delimited by semi-colons. This function is a shortcut
#' for unnesting those columns into a tidy format: that is, one row per
#' user-answer pair. This can then be joined with the stack_survey dataset,
#' or with other stack_multi columns.
#'
#' @param columns Columns to unnest. If NULL, will unnest all multi-response
#' columns
#'
#' @return A tbl_df with three columns:
#' \describe{
#'   \item{respondent_id}{An ID to the stack_survey dataset}
#'   \item{column}{If multiple columns are given, }
#' }
#'
#' @importFrom dplyr %>%
#'
#' @examples
#'
#' library(dplyr)
#'
#' tech_multi <- stack_multi("tech_do")
#' tech_multi
#'
#' tech_counts <- tech_multi %>%
#'   count(tech = answer, sort = TRUE)
#' tech_counts
#'
#' # look at the typical development environments of data scientists
#' stack_survey %>%
#'   filter(occupation == "Data scientist") %>%
#'   inner_join(stack_multi("dev_environment")) %>%
#'   count(answer, sort = TRUE)
#'
#' # find connected technologies and environments
#' tech_env_pairings <- tech_multi %>%
#'   select(respondent_id, tech = answer) %>%
#'   inner_join(stack_multi("dev_environment")) %>%
#'   count(tech, environment = answer) %>%
#'   ungroup()
#'
#' tech_env_pairings %>%
#'   arrange(-n)
#'
#' # fractions of tech X that use environment Y
#' tech_env_pairings %>%
#'   rename(paired = n) %>%
#'   inner_join(tech_counts, by = "tech") %>%
#'   mutate(percent = paired / n) %>%
#'   arrange(desc(percent))
#'
#' @export
stack_multi <- function(columns = NULL) {
  multi_response_qs <- stack_schema$column[stack_schema$type == "multi"]

  if (is.null(columns)) {
    columns <- multi_response_qs
  } else {
    dif <- setdiff(columns, multi_response_qs)
    if (length(dif) > 0) {
      stop(dif[1], " is not a multi-response column in stack_survey")
    }
  }

  stack_survey %>%
    dplyr::select(respondent_id, one_of(columns)) %>%
    tidyr::gather(column, answer, -respondent_id) %>%
    dplyr::filter(!is.na(answer)) %>%
    tidyr::unnest(answer = stringr::str_split(answer, "; "))
}
