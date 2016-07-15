#' Results of the Stack Overflow 2016 Developer Survey
#'
#' Developer Survey results as a data frame (specifically a tbl_df). While this is
#' almost identical to the CSV available from \url{http://stackoverflow.com/research},
#' this takes the additional step of turning each range (e.g. years of experience being
#' "1 - 5 years") and each scale (e.g. "On a scale of 1 to 5, how important...") into an
#' ordered factor, which allows easier
#' visualization and sorting.
#'
#' @format One row for each respondent (56,030), with 66 columns: one column for each
#' survey question (along with some columns added through processing). The format and
#' text for each question is described in the \code{\link{stack_schema}} dataset.
#'
#' @source \url{http://stackoverflow.com/research}
"stack_survey"
