console.log("An attempt to redo the rescue boats algorithm with a different approach but it has lots of flaws! Learned in a lot in the meantime though.")
var arr = [3,2,2,1,2,1,2,3,4] 
var set = new Set()
var boats = 0
var shareb = 0
var left = []
var maxDigit=Math.max(...arr)

var calcSet = (limit) => {
  msg="not fit"
  let leftOver=[]
  set.forEach((val) => {
    if(val == limit) {console.log(val, "equal to limit, adding");boats++};
    if(val>limit) {console.log(val, "greater than", limit, msg, "shareboats: ", shareb); leftOver.push(val)};
    if(val<limit) {console.log(val, "less than", limit, "shareboats: ", shareb); if (shareb+val > limit) {boats++} else {shareb=shareb+val;}};
    if(shareb == limit) {boats++; shareb=0};
  })
console.log("Leftover People: ", leftOver, shareb)
for (i in leftOver) {left.push(leftOver[i])}
return boats
}

var calcBoats = (arr,limit) => {

  let newarr = []
  let l = arr.length-1
  if (!arr[0]) { if (!newarr[0])  { if(shareb != 0) {if (maxDigit > limit) {boats++};}console.log("boats end", boats, newarr);; return} }
  while (l >=0){

    console.log(l, arr[l],arr,set)
    if(!set.has(arr[l])){
      set.add(arr[l]);}
    else{newarr.push(arr[l]);}
    arr.pop()
//boats++
console.log(arr, "arr", newarr, "newarr")

    l--
  }
console.log(arr)
calcSet(limit)
set.clear()

console.log("current boats", boats)
calcBoats(newarr,limit)
return boats
}
calcBoats(arr,4)
console.log(left)
