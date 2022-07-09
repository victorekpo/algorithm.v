//Frequency checker, pushes result to an array 
const v = (n) => {
  let cache = {}
  return b = (n) => {
    if (cache[n]) { console.log("cached"); let t = cache[n][0]; cache[n].push(t); console.log(cache[n].length, " times ran"); return cache[n] }
    else { cache[n] = []; let t=n+5; cache[n].push(t); return cache[n] }
  }
}

var vic = v() // can be reset if initialized again using var, but let or const will not allow you to do so. This method is preferred over a global declaration since you can reset the cache without restarting the entire program.
vic(1)
vic(2)
vic(2)
vic(3)
