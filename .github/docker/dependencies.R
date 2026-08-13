## The packages the DESeq2 DESCRIPTION depends on, across every dependency
## field. Sourced by both the installation and the verification script so that
## the two always work from the same list.
##
## Returns a character vector of minimum versions ("3.4.0", or NA where the
## DESCRIPTION states no constraint) named after the packages themselves.

package_dependencies <- function(description = "DESCRIPTION",
                                 fields = c("Depends", "Imports", "LinkingTo",
                                            "Suggests", "Enhances")) {
    desc <- read.dcf(description)
    entries <- unlist(lapply(intersect(fields, colnames(desc)), function(field) {
        value <- desc[1L, field]
        if (is.na(value)) character() else strsplit(value, ",", fixed = TRUE)[[1L]]
    }), use.names = FALSE)
    entries <- trimws(entries)
    entries <- entries[nzchar(entries)]

    ## "ggplot2 (>= 3.4.0)" splits into the name and the minimum version;
    ## an entry carrying no ">=" constraint is left unconstrained.
    packages <- trimws(sub("\\(.*", "", entries))
    versions <- trimws(sub(".*\\(\\s*>=\\s*([^)]*)\\).*", "\\1", entries))
    versions[versions == entries] <- NA_character_

    keep <- !packages %in% c("R", rownames(installed.packages(priority = "base")))
    keep <- keep & !duplicated(packages)
    setNames(versions[keep], packages[keep])[order(tolower(packages[keep]))]
}
