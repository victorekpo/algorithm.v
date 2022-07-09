nums=[3,2,1,2,3,4,5]
var twoSum = (nums,target) => {
  let m = {}
  let n = nums.length
  for (i in nums) {
    goal = target - nums[i]
    if(goal in m) {
      return [m[goal], i]
    } else { m[nums[i]] = i }
  }
}
console.log(twoSum(nums, 7))

