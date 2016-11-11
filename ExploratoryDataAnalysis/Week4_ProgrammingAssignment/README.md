# README.md

## __Data Science Specialization - Course 4: Exploratory Data Analysis__

### Week 4 Programming Assignment

### Course Info and Materials are from [Peer-graded Assignment: Course Project 2] (https://www.coursera.org/learn/exploratory-data-analysis/peer/b5Ecl/course-project-2)

The raw data files are found from above course link, and the corresponding descriptions are stored in the `CodeBook.md`.

__6 questions are broached for data analysis and plotting:__

_Q1: Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?_

A1: Yes. According to `Plot1.png`, the total pm2.5 level dropped from over 7e6 ton to below 4e6 ton.

_Q2: Have total emissions from PM2.5 decreased in the Baltimore City, Maryland from 1999 to 2008?_

A2: Yes. According to `Plot2.png`, the total pm2.5 level in Baltimore is dropped - although an increment in 2005 was seen.

_Q3: Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City?_

A3: See `Plot3.png`. From the sum we see only 'point' type has increased, all others have decreased. Scatter plot shows the increment of 'point' type pm2.5 is likely due to increased 'high pm2.5 levels' perhaps due to industry pollutions, while there's still decreasing trend at lower pm2.5 levels.

_Q4: Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?_

A4: From `Plot4.png` we can learn that, before 2005, the pm2.5 related to coal combustion has a decreasing trend, but not great; however the level dropped dramatically in 2008, perhaps as a result of prevalence of 'cleaner power'.

_Q5: How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?_

A5: See `Plot5.png`. The sum trend is an 'n' shape - increasing in 2002 and 2005, and then decreasing again in 2008 to about a same level as in 1999.

__However, it should be addressed from the scatter plot - there are only 2 points extremely high (>10) while others are all between 0~0.15. The source of these 2 'outliers' are both `Other Combustion Motor Vehicle Fires`, which could imply the result of accidents which have created way more pm2.5 pollutions. Hence I recommend to exclude them in plotting.__

After precluding the 2 outliers, the data looks cleaner - for each year the pm2.5 levels are between 0 ~ 0.15, and the V-shaped trend mostly reflect random variance, as the levels are very low.

_Q6: ompare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California. Which city has seen greater changes over time in motor vehicle emissions?_

A6: In `Plot6.png` we again see the data from `Plot5.png`, where pollutions in Baltimore were trivial; in contrast, that of LA were way worse - there are way way higher outliers (which are also from `Other Combustion Motor Vehicle Fires`) and way higher values. What's worse, the total pm2.5 level in LA was increaseing, showing there might had more and more cars in the city, but with insufficient preventing acts.