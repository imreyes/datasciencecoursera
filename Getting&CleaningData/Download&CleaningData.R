# Downloading and reading files.
# Lecture & coding source are from below link at 5pm 10/26/2016.
# https://www.coursera.org/learn/data-cleaning/lecture/fDm1d/reading-local-files



#==================================================================#
# Read Excel File.
library(xlsx)
dat<-read.xlsx('getdata-data-DATA.gov_NGAP.xlsx',sheetIndex = 1,header = TRUE)


setwd('G:/R/Project1/')
if(!file.exists('Ex1_download_file')){dir.create('Ex1_download_file')}
fileUrl<-'https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD'
download.file(fileUrl,destfile='./Ex1_download_file/cameras.csv')  
dateDownloaded<-date()
cameraData<-read.table('./Ex1_download_file/cameras.csv',sep=',',header=T)    # several parameters: quote, na.string,nrows,skip.
# x<-read.csv('./data/cameras.csv')

# Download as Excel file:
# download.file(fileUrl,destfile='.Ex1_donwload_file/cameras.xlsx')
# library(xlsx)
# x<-read.xlsx('.Ex1_download_file/cameras.xlsx')
# It is very common to incorporate Excel environment into R or vice versa.

# Download XML files:
library(XML)
fileUrl<-'http://www.w3schools.com/xml/simple.xml'
doc<-xmlTreeParse(fileUrl,useInternal=T)
rootNode<-xmlRoot(doc)
xmlName(rootNode)
names(rootNode)
rootNode[[1]]
rootNode[[1]][[1]]
xmlSApply(rootNode,xmlValue)
# To learn more about XML structure and XPath, find info from:
# http://www.stat.berkeley.edu/~statcur/Workshop2/Presentations/XML.pdf
xpathSApply(rootNode,'//name',xmlValue)
xpathSApply(rootNode,'//price',xmlValue)

# Grab another source and try.
fileUrl<-'http://espn.go.com/nfl/team/_/name/bal/baltimore-ravens'
doc<-htmlTreeParse(fileUrl,useInternal=T)
scores<-xpathSApply(doc,"//li[@class='score']",xmlValue)
teams<-xpathSApply(doc,"//li[@class='team-name']",xmlValue)

#==================================================================================================#
# Another example
library(XML)
doc <- xmlTreeParse('BaltimoreRestaurant.xml',useInternalNodes = TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)

# See how the node data structure works:
rootNode[[1]][[1]][[1]][[1]]
rootNode[[1]][[1]][[1]]
rootNode[[1]][[1]]

# Take a look at the function xmlSApply() and xmlValue().
xmlSapply(rootNode,xmlValue)

# Note in node data:
# /node - top level node
# //node -Node at any level
# node[@attr-name] node with an attribute name
# node[@attr-name='bob'] node with attribute name 'bob'

# Now look at 'name' node:
xpathSApply(rootNode,'//name',xmlValue)
# Notice it returns character list under 'name' node.

zc<-xpathApply(rootNode,'//zipcode',xmlValue)

#================================================================================================================#
# Download JSON files.
library(jsonlite)
jsonData<-fromJSON('https://api.github.com/users/jtleek/repos')
names(jsonData)
names(jsonData$owner)
jsonData$owner$login
myjson<-toJSON(iris,pretty=T)
cat(myjson)
iris2<-fromJSON(myjson)
head(iris2)

# The data.table package.
library(data.table)
DF<-data.frame(x=rnorm(9),y=rep(c('a','b','c'),each=3),z=rnorm(9))
head(DF,3)
DT<-data.table(x=rnorm(9),y=rep(c('a','b','c'),each=3),z=rnorm(9))
head(DT,3)
tables()
DT[2,]
DT[DT$y=='a']
DT[c(2,3)]
DT[,c(2,3)]
DT[,list(mean(x),sum(z))]
DT[,table(y)]
DT[,w:=z^2]
DT[,m:={tmp<-(x+z);log2(tmp+5)}]
DT[,a:=x>0]
DT[,b:=mean(x+w),by=a]
DT<-data.table(x=sample(letters[1:3],1e5,TRUE))
DT[,.N,by=x]  # .N counts number of appearance of each group by x.
DT<-data.table(x=rep(letters[1:3],each=100),y=rnorm(300))
setkey(DT,x)
DT['a']



#=========================================================================================#
# Reading data from HDF5.
# Installation of the rhdf5 package.
source('http://bioconductor.org/biocLite.R')
biocLite('rhdf5')
library(rhdf5)

# Create a h5 file - looks loke a folder.
created<-h5createFile('example.h5')

# Creat groups and subgroups - subfolder or file?
created<-h5createGroup('example.h5','foo')
created<-h5createGroup('example.h5','baa')
created<-h5createGroup('example.h5','foo/foobaa')
h5ls('example.h5')

# Write data content to groups.
A<-matrix(1:10,nr=5,nc=2)
h5write(A,'example.h5','foo/A')
B<-array(seq(0.1,2.0,by=0.1),dim=c(5,2,2))
attr(B,'scale')<-'liter'
h5write(B,'example.h5','foo/foobaa/B')
h5ls('example.h5')

df<-data.frame(1L:5L,seq(0,1,length.out=5),c('ab','cde','fghi','a','s'),stringsAsFactors = FALSE)
h5write(df,'example.h5','df')
h5ls('example.h5')

# Read out the data previously stored.
readA<-h5read('example.h5','foo/A')
readB<-h5read('example.h5','foo/foobaa/B')
readdf<-h5read('example.h5','df')

# We can write in data to part of the stored data structures.
h5write(c(12,13,14),'example.h5','foo/A',index=list(1:3,1))


#==========================================================================#
# Read data from web directly.
con<-url('http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en')
htmlCode<-readLines(con)
close(con)
htmlCode

# Parse with XML package
library(XML)
url<-'http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en'
html<-htmlTreeParse(url,useInternalNodes = T)
xpathSApply(html,'//title',xmlValue)
xpathSApply(html,"//td[@id='col-citedby']",xmlValue)

# Parse with httr package.
library(httr)
html2<-GET(url)
content2<-content(html2,as='text')
parsedHtml<-htmlParse(content2,asText = TRUE)
xpathSApply(parsedHtml,'//title',xmlValue)

# Accessing websites with password
pg1<-GET('http://httpbin.org/basic-auth/user/passwd')
pg1

# Now we get username and password
pg2<-GET('http://httpbin.org/basic-auth/user/passwd',
         authenticate('user','passwd'))
pg2

# Using handles.
google<-handle('http://google.com')
pg1<-GET(handle=google,path='/')
pg2<-GET(handle=google,path='search')


# One html example:
webpage <- 'http://biostat.jhsph.edu/~jleek/contact.html'
html <- readLines(webpage)              # Read by lines
# Check contents.
summary(html)
str(html)
# Browse through, find character numbers of several lines.
sapply(c(10,20,30,100), function(i) nchar(html[i]))

# Another example:
webpage <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for'
html <- GET(webpage)            # This doesn't work.
html <- readLines(webpage)      # Makes more sense, but still not good.
# Note 4 lines should be skipped as title and headers.
# We may use basic coding to parse:
dat <- vector()
# Strip the character strings into numeric values.
sn <- cbind(c(16,20,29,33,42,46,55,59),c(19,23,32,36,45,49,58,62))
for(rows in 5:length(html)) {
        onerow <- sapply(1:8, function(i) {
                as.numeric(substr(html[rows], sn[i,1], sn[i,2]))
        })
        dat <- rbind(dat, onerow)
}
sum(dat[,3])

# Another way to do, using read.fwf():
download.file(webpage,destfile = 'somedata.txt')
# Can't use header, as parsing lengths are different; simply skip it.
dat <-read.fwf('somedata.txt', widths = c(14,5,8,5,8,5,8,5,8), skip = 4)
sum(dat[,4])    # Note this includes the 1st column - character codes.

#=======================================================================#
# Getting data from API - Application programming interface
# Example: getting data from github api.
library(httr)
library(httpuv)     # For RStudio
oauth_endpoints('github')

# Before below, I needed to create a new OAuth application on github.
myapp<-oauth_app('github',
                 key = 'e4eabf3407c1ec9fb271',
                 secret = 'd577e0cc98427dc848a99a5e5aabba958631c769')
# Get Oauth credentials.
github_token<-oauth2.0_token(oauth_endpoints('github'),myapp)

# Use API
gtoken<-config(token = github_token)
req<-GET('https://api.github.com/users/jtleek/repos',gtoken)
stop_for_status(req)
# Read in data
dat<-content(req)
createdTime<- sapply(seq_along(1:length(dat)), function(i) {
        if(dat[[i]]$name=='datasharing') return(dat[[i]]$created_at)
})


#==================================================================================================#
# Reading data from MySQL
# - Install MySQL Server 5.7 lib - done.
# - Install RTools - done.
# - Install DBI package - done.
# - Install RMySQL - done.
library(RMySQL)
library(sqldf)
# And following scripts: (not sure if every time):
options(sqldf.driver = 'SQLite')
options(gsubfn.engine = 'R')

download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv',destfile = 'ACS.csv')
acs <- read.csv('ACS.csv')
# Several MySQL commands stored in character strings
# deciphered by sqldf()
sqldf("select * from acs")
# Compare between R and MySQL syntax:
filter1 <- unique(acs$AGEP)
filter2 <- sqldf("select distinct AGEP from acs")
identical(filter1,filter2[[1]])
# Note in filter2, MySQL use distinct rather than unique.
# return values are in data.frame class.