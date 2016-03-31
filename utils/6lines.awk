$1 == prev {
   ++cnt
   block = block $0 RS
   if (cnt == 6) {
      printf block
      cnt = 0
      block = ""
   }
   next
}

{
   block = $0 RS
   prev = $1
   cnt = 1
}