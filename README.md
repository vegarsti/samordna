#Samordna Opptak

###Background
All undergraduate studies at public universities (which means almost every university) in Norway admit students based purely on their points (more on this later). The online portal for this, [Samordna Opptak](http://www.samordnaopptak.no/), does not provide an easy way to view how the admission boundaries change from year to year; these are collected in one large file for each year, so you have to look through the entire file for each year. What's more: These are not formatted similarly for all universities.

Wanting to learn some Bash scripting and data processing, I figured I could collect the points from each year and make viewing this more accessible.

###Quotas
There are two quotas for admission. The first one, call this the "first timer" (FT) quota, counts your average grades x 10. Max here is 60 points. In addition, one can get up to 4 extra points for taking science courses, and up to 1 point for taking language courses. So FT caps at 64 points.

The other quota, call this "ordinary", is different. All points from FT count, but you also get 2 additional points per extra year after age 19 (in essence how many years since you "ordinarily" finished high school). These points cap out at 8 points, i.e. after 4 years. You also get (no more than) 2 extra points if you either

1. pursued university studies for at least 1 year
2. served in the military
3. attended ["folk high school"](https://en.wikipedia.org/wiki/Folk_high_school)

In total, you can get 74 points on the ordinary quota.

###Format
The directory `data` contains `2009.txt` through `2015.txt`, taken straight from Samordna Opptak. They look like this, except the columns are placed differently for universities:
![Screenshot of the original files.](http://i.imgur.com/vW0aXQP.png)
The middle column are the scores for the FT quota, and the right column contains the scores for the ordinary quota.

###Usage
Running `make` will create a directory `processed` with two subdirectories, `first` and `ordinary`, containing a `.csv` file for every university with that quota, and also a file `all.csv` containing the data from all universities.
The `.csv` files look like this:
![Screenshot of the finished files.](http://i.imgur.com/3iu6Kkp.png)
