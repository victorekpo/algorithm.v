const fib = (n) => {
 if (n < 2) {
   console.log(n)
   return n;
 }
 let x=fib(n-1) + fib(n-2)
 console.log(x)
 return x
}
console.log(fib(3))

