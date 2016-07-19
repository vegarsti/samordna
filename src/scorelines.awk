# Send only lines with actual point scores
{
if (NF >= 3 && $1 ~ /[0-9]/ && $2 ~ /[0-9]/ && $3 ~ /[0-9]/)
	print $1 " " $2 " " $3 # print ID field, first and second score fields
}