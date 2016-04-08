#Samordna Opptak

###Background
All undergraduate studies at public universities (which means almost every university) in Norway use a purely points system for admission. The online portal for this, [Samordna Opptak](http://www.samordnaopptak.no/), does not provide an easy way to view how the admission boundaries change from year to year; these are collected in one large file for each year, so you have to look through the entire file for each year.

Wanting to learn some Bash scripting and data processing, I figured I could collect the points from each year and make viewing this more accessible.

###Format
The directory `data` contains `2009.txt` through `2015.txt`, taken straight from Samordna Opptak. They look like this:
![Screenshot of the original files.](http://i.imgur.com/vW0aXQP.png)
The middle column are the scores for one quota, those straight out of high school, and  the right column are the scores for the other quota, all others.

###Usage
Running `make` will create a directory `processed` with two subdirectories; `first` and `ordinary`, containing a `.csv` file for every university with that quota, and also a file `all.csv` containing the data from all universities.
The `.csv` files look like this:
![Screenshot of the finished files.](http://i.imgur.com/SEmdAZP.png)
