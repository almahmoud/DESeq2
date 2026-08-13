## Install every package the DESeq2 DESCRIPTION depends on, Suggests included.

source("dependencies.R")

cores <- parallel::detectCores()
options(
    warn = 1,
    Ncpus = if (is.na(cores)) 1L else max(1L, cores),
    timeout = max(600, getOption("timeout"))
)

if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager", repos = "https://cloud.r-project.org")
if (!requireNamespace("remotes", quietly = TRUE))
    BiocManager::install("remotes", quiet = TRUE)
if (!requireNamespace("BiocJobs", quietly = TRUE))
    BiocManager::install("almahmoud/BiocJobs", quiet = TRUE)

## A dependency the base image already carries at a new enough version does not
## need reinstalling.
outstanding <- function(dependencies) {
    installed <- installed.packages()[, "Version"]
    satisfied <- vapply(seq_along(dependencies), function(i) {
        package <- names(dependencies)[i]
        minimum <- dependencies[[i]]
        package %in% names(installed) &&
            (is.na(minimum) ||
                 package_version(installed[[package]]) >= package_version(minimum))
    }, logical(1L))
    dependencies[!satisfied]
}

dependencies <- package_dependencies()
cat(length(dependencies), "DESCRIPTION dependencies:", paste(names(dependencies), collapse = ", "), "\n")

## Package repositories can be flaky, so give a failed install a few tries
## before moving on. Anything still missing afterwards is reported by the
## verification step, which is what fails the build.
attempts <- 3L
for (attempt in seq_len(attempts)) {
    todo <- outstanding(dependencies)
    if (!length(todo)) break
    cat(sprintf("\nAttempt %d of %d, %d package(s) to install: %s\n",
                attempt, attempts, length(todo), paste(names(todo), collapse = ", ")))
    tryCatch(
        BiocManager::install(names(todo), ask = FALSE, update = FALSE,
                             Ncpus = getOption("Ncpus")),
        error = function(e) cat("Installation error:", conditionMessage(e), "\n")
    )
}
