def add_numbers(*args:int):
  while len(args) > 2:
    for i in range(0,len(args)): 
      if isinstance(args[i], int):
        continue
      else: return("Wrong type of input")
    print("1",args)
    result = args[0] + args[1]
    l = list(args)
    l.append(result)
    l = l[2:]
    args = tuple(l)
    print("2",args)
  if len(args) == 2: 
    for i in range(0,2): 
      if isinstance(args[i], int):
        continue
      else: return("Wrong type of input")
    print("done")
    final = args[0] + args[1]
    return(final)
  if len(args) == 1: 
    print("Not enough numbers to add")
    final = args[0]
    return(final)
  else:
    return("You haven't given me anything")
# else: 
#   print("Wrong type of input")
#   return

print(a) if 'a' in locals() else print("Nothing to show here")
a=add_numbers(1,2,3)
print(a) if a !=None else print("Nothing to show here")
a=add_numbers(1,2,[])
print(a) if a !=None else print("Nothing to show here")
a=add_numbers(1,[])
print(a) if a !=None else print("Nothing to show here")
a=add_numbers([],[])
print(a) if a !=None else print("Nothing to show here")
a=add_numbers()
print(a) if a !=None else print("Nothing to show here")
a=add_numbers(1)
print(a) if a !=None else print("Nothing to show here")
#a = add_numbers(1,2,3,4,5,6,7,8,9,10,11,12,13,14)
#print(a) if a !=None else print("Nothing to show here")
