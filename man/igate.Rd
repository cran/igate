% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/igate.R
\name{igate}
\alias{igate}
\title{igate function for continuous target variables}
\usage{
igate(df, versus = 8, target, test = "w", ssv = NULL,
  outlier_removal_target = TRUE, outlier_removal_ssv = TRUE,
  good_end = "low", savePlots = FALSE, image_directory = tempdir())
}
\arguments{
\item{df}{Data frame to be analysed.}

\item{versus}{How many Best of the Best and Worst of the Worst do we collect? By default, we will collect 8 of each.}

\item{target}{Target varaible to be analysed. Must be continuous. Use \code{\link{categorical.igate}} for categorical target.}

\item{test}{Statistical hypothesis test to be used to determine influential
process parameters. Choose between Wilcoxon Rank test (\code{"w"}, default) and Student's t-test (\code{"t"}).}

\item{ssv}{A vector of suspected sources of variation. These are the variables
in \code{df} which we believe might have an influence on the target variable and
will be tested. If no list of ssv is provided, the test will be performed
on all numeric variables.}

\item{outlier_removal_target}{Logical. Should outliers (with respect to the target variable)
be removed from df (default: \code{TRUE})? Important: This only makes sense if no
prior outlier removal has been performed on df, i.e. \code{df} still contains all
the data. Otherwise calculation for outlier threshold will be falsified.}

\item{outlier_removal_ssv}{Logical. Should outlier removal be performed for each ssv (default: \code{TRUE})?}

\item{good_end}{Are low (default) or high values of target variable good? This is needed
to determine the control bands.}

\item{savePlots}{Logical, only relevant if \code{outlier_removal_target} is TRUE. If  \code{savePlots == FALSE}
(the default) the boxplot of the target variable will be output to the standard output device for plots, usually
the console. If \code{TRUE}, the boxplot will additionally be saved to \code{image_directory} as a png file.}

\item{image_directory}{Directory to which plots should be saved. This is only used if \code{savePlots = TRUE} and
defaults to the temporary directory of the current R session, i.e. \code{tempdir()}. To save plots to the current
working directory set \code{savePlots = TRUE} and \code{image_directory = getwd()}.}
}
\value{
A data frame with the following columns
\tabular{ll}{
\code{Causes} \tab Those ssv that have been found to be influential to the target variable.\cr
\code{Count} \tab The value returned by the counting method. \cr
\code{p.value} \tab The p-value of the hypothesis test performed, i.e. either of the
Wilcoxon rank test (in case \code{test = "w"}) or the t-test (if \code{test = "t"}).\cr
\code{good_lower_bound} \tab The lower bound for this \code{Cause} for good quality.\cr
\code{good_upper_bound} \tab The upper bound for this \code{Cause} for good quality.\cr
\code{bad_lower_bound} \tab The lower bound for this \code{Cause} for bad quality.\cr
\code{bad_upper_bound} \tab The upper bound for this \code{Cause} for bad quality.\cr
\code{na_removed} \tab How many missing values were in the data set for this \code{Cause}?\cr
\code{ties_lower_end} \tab Number of tied observations at lower end of \code{target} when selecting the
\code{versus} BOB/ WOW.\cr
\code{competition_lower_end} \tab For how many positions are the \code{tied_obs_lower} competing?\cr
\code{ties_upper_end} \tab Number of tied observations at upper end of \code{target} when selecting the
\code{versus} BOB/ WOW.\cr
\code{competition_upper_end} \tab For how many positions are the \code{tied_obs_upper} competing?\cr
\code{adjusted.p.values} \tab The \code{p.values} adjusted via Bonferroni correction.
}
}
\description{
This function performs an initial Guided Analysis for parameter testing and controlband extraction (iGATE)
on a dataset and returns those parameters found to be influential.
}
\details{
We collect the Best of the Best and the Worst of the Worst
dynamically dependent on the current ssv. That means, for each ssv we first
remove all the observations with missing values for that ssv from df.
Then, based on the remaining observations, we select versus observations with
the best values for the target variable (“Best of the Best”, short BOB)  and
versus observations with the worst values for the target variable
(“Worst of the Worst”, short WOW). By default, we select 8 of each.
Next, we compare BOB and WOW using the the counting method and the specified
hypothesis test. If the distributions of the ssv in BOB and WOW are
significantly different, the current ssv has been identified as influential
to the target variable. An ssv is considered influential, if the test returns
a count larger/ equal to 6 and/ or a p-value of less than 0.05.
For the next ssv we again start with the entire dataset df, remove all
the observations with missing values for that new ssv and then select our
new BOB and WOW. In particular, for each ssv we might select different observations.
This dynamic selection is necessary, because in case of an incomplete data set,
if we select the same BOB and WOW for all the ssv, we might end up with many
missing values for particular ssv. In that case the hypothesis test loses
statistical power, because it is used on a smaller sample or worse, might
fail altogether if the sample size gets too small.

For those ssv determined to be significant, control bands are extracted. The rationale is:
If the value for an ssv is in the interval [\code{good_lower_bound},\code{good_upper_bound}]
the target is likely to be good. If it is in the interval
[\code{bad_lower_bound},\code{bad_upper_bound}], the target is likely to be bad.

Furthermore some summary statistics are provided: When selecting the \code{versus} BOB/ WOW, tied values for target
can mean that the \code{versus} BOB/ WOW are not uniquely determined. In that case we randomly select
from the tied observations to give us exactly \code{versus} observations per group.
\code{ties_lower_end, cometition_lower_end, ties_upper_end, competition_upper_end}
quantify this randomness. How to interpret these values: \emph{lower end} refers to
the group whose \code{target} values are \emph{low} and \emph{upper end} to the one whose
\code{target} values are high. For example if a low value for \code{target} is good,
\emph{lower end} refers to the BOB and \emph{upper end} to the WOW. We determine the \code{versus}
BOB/ WOW via

\code{lower_end <- df[min_rank(df$target)<=versus,]}

If there are tied observations, \code{nrow(lower_end)} can be larger than \code{versus}. In \code{ties_lower_end} we
record how many observations in \code{lower_end$target} have the \emph{highest} value and in \code{competition_lower_end}
we record for how many places they are competing, i.e.
\code{competing_for_lower <- versus - (nrow(lower_end) - ties_lower_end)}.
The values for \code{ties_upper_end} and \code{competition_upper_end} are determined analogously.
}
\examples{
igate(iris, target = "Sepal.Length")

}
