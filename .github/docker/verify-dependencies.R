## Fail the build unless every DESCRIPTION dependency is loadable.

source("dependencies.R")

for (package_name in names(package_dependencies())) {
    if (!requireNamespace(package_name, quietly = TRUE)) {
        cat(paste("Error: Package", package_name, "failed to install successfully.\n"))
        quit(status = 1)
    }
}

cat("All DESCRIPTION dependencies are installed.\n")
