# Send only lines with actual point scores
{
if (NF >= 3 && $2 != "Alle" && $3 != "Alle" && $2 != "TRU")
	print $0
}