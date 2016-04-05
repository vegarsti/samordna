$1 == prev {
   ++count
   block = block $0 RS
   if (count == 7) {
      printf block
      count = 0
      block = ""
   }
   next
}

{
   block = $0 RS
   prev = $1
   count = 1
}