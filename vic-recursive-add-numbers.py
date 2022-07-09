def add_numbers(*args):
  print("1",args)
  if len(args) <= 1:
    print("nothing to add")
    final = args[0]
  if len(args) == 2: 
    print("done")
    final = args[0] + args[1]
    return(final)
  result = args[0] + args[1]
  l = list(args)
  l.append(result)
  l = l[2:]
  args = tuple(l)
  print("2",args)
  return(add_numbers(*args))


a = add_numbers(1,2,3,4,5,6,7,8,9,10,11,12,13,14)
print(a)
