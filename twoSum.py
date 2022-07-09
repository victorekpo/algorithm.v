class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        m = {} # declare an empty map object (dictionary)
        n = len(nums) # set n to be the length of the nums list
        for i in range(0,n): #loop through every item in the nums list
            goal = target - nums[i] # the goal is equal to the difference between the target and the value of the current index
            if(goal in m): # if the goal is found in the hash map
                return [m[goal], i] # return an array with the index value of the found goal and the current index item
            m[nums[i]] = i #set the map element for the value to be the index value
