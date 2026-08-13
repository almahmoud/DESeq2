## Fail the build unless the package and every one of its DESCRIPTION
## dependencies is loadable.

source("dependencies.R")

package <- read.dcf("DESCRIPTION")[1L, "Package"]

for (package_name in c(names(package_dependencies()), package)) {
    if (!requireNamespace(package_name, quietly = TRUE)) {
        cat(paste("Error: Package", package_name, "failed to install successfully.\n"))
        quit(status = 1)
    }
}

cat(package, "and all of its DESCRIPTION dependencies are installed.\n")
