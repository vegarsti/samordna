# Gathers scores for same ID on one line
{a[$1] = a[$1] ? a[$1] FS $2 : $2 ; b[$1] = b[$1] ? b[$1] FS $3 : $3} END { for(idx in a){ print idx,a[idx] ; print idx,b[idx]}}