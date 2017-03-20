# Samordna Opptak

### Background
All undergraduate studies at public universities (which means almost every university) in Norway admit students based purely on their points (more on this later). The online portal for this, [Samordna Opptak](http://www.samordnaopptak.no/), does not provide an easy way to view how the admission boundaries change from year to year; these are collected in one large file for each year, so you have to look through the entire file for each year. What's more: These are not formatted similarly for all universities.

Wanting to learn some Bash scripting and data processing, I figured I could collect the points from each year and make viewing this more accessible.

### Quotas
There are two quotas for admission. The first one, call this the "first timer" (FT) quota, counts your average grades x 10. Max here is 60 points. In addition, one can get up to 4 extra points for taking science courses, and up to 1 point for taking a course in a third language at the highest level. So FT caps out at 65 points.

The other quota, call this "ordinary" (O), is different. All points from FT count, but you also get 2 additional points per extra year after age 19 (in essence how many years since you "ordinarily" finished high school). These points cap out at 8 points, i.e. after 4 years. You also get (no more than) 2 extra points if you either

* have obtained 60 ECTS credits (or 1 point if you have 30 credits)
* served in the military or
* attended ["folk high school"](https://en.wikipedia.org/wiki/Folk_high_school)

In total, you can get 75 points on the ordinary quota.

### Format
The directory `data` contains `2009.txt` through `2015.txt`, taken straight from Samordna Opptak. They look like this, except with many more programmes for each university than shown here:
![Screenshot of the original files.](http://i.imgur.com/5NVaupi.png)
The middle column are the scores for the FT quota, and the rightmost column contains the scores for the ordinary quota.

As we can see, the columns we want are not placed equally. What's more, the number of columns differs for some universities. Thus, we will have to specify, for each university, the location of each column.

### Usage
Running `make` will create a directory `processed` with two subdirectories, `first` and `ordinary`, containing a `.csv` file for every university with that quota, and also a file `all.csv` containing the data from all universities.
The resulting files look like this (in Google Sheets):
![Screenshot of the finished files.](http://i.imgur.com/PeJpSpH.png)
