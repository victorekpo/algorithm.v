const cache = new WeakMap();
function countKeys(obj){
	if(cache.has(obj)){
		return [cache.get(obj), 'cached'];
	} else {
		const count = Object.keys(obj).length;
		cache.set(obj, count);
		return [count, 'computed'];
	}
}
const obj = {vic:1, vic2: 2};
console.log(countKeys(obj))
console.log(countKeys(obj))
