#Samordna Opptak

###Background
All undergraduate studies at public universities (which means almost every university) in Norway use a purely points system for admission. The online portal for this, [Samordna Opptak](http://www.samordnaopptak.no/), does not provide an easy way to view how the admission boundaries change from year to year; these are collected in one large file for each year, so you have to look through the entire file for each year.

Wanting to learn some Bash scripting and data processing, I figured I could collect the points from each year and make viewing this more accessible.

###Format
![Screenshot of the original files.](http://i.imgur.com/vW0aXQP.png)
The middle column are the scores for one quota, those straight out of high school, and  the right column are the scores for the other quota, all others.

I gathered the data for the universities NTNU  (_Norwegian University of Science and Technology_) and UiO (_University of Oslo_), 2009-2015, in two separate files, `data/NTNU.txt` and `data/UIO.txt`.

###Usage
Running `bash script.sh` will create a `.csv` file that looks like this:
![Screenshot of the finished files.](http://i.imgur.com/WGIyzH3.png)
