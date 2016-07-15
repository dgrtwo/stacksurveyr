#' Schema for the Stack Overflow 2016 Developer Survey
#'
#' Description of columns in the \code{\link{stack_survey}} dataset, including
#' the specific text of those questions in the survey.
#'
#' @format A tbl_df with 66 rows, one for each column in
#' \code{\link{stack_survey}}, and four columns:
#' \describe{
#'   \item{column}{Column name in \code{\link{stack_survey}}}
#'   \item{type}{Either "single" (a simple response), "multi" (multiple
#'   responses delimited by "; "), or "inferred" (a column that doesn't
#'   correspond to a survey question, but is a processed version of another
#'   column)}
#'   \item{question}{The text of the question in the Stack Overflow
#'   Developer Survey 2016 (NA for "inferred" columns)}
#'   \item{description}{Description of how "inferred" columns were calculated,
#'   as well as the specific text of "What's important..." and "How much
#'   do you agree or disagree..." question that ask for rankings on a variety
#'   of issues}
#' }
#'
#' @source \url{http://stackoverflow.com/research}
"stack_schema"
