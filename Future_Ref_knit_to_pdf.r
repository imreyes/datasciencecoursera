# Set working directory
setwd("C:/Users/GY/datasciencecoursera/StatisticalInference/")

# Load packages
require(knitr)
require(markdown)

# Create .md, .html, and .pdf files
knit("Week4_ProgrammingAssignment2.Rmd")
markdownToHTML('Week4_ProgrammingAssignment2.md', 'Week4_ProgrammingAssignment2.html', options=c("use_xhml"))
system("pandoc -V geometry:margin=1in -s Week4_ProgrammingAssignment2.html -o Week4_ProgrammingAssignment2.pdf")
