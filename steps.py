class Solution:
    def climbStairs(self, n: int) -> int:
        if(n==1):
            return 1
        len = n+1
        count = [0] * (len) #to go to end
        count[1] = 1
        count[2] = 2

        for i in range(3,len):
            count[i] = count[i-1] + count[i-2]

#fills up the count array with the amount of ways to get to each step until the nth value.
        return count[n]

v=Solution()
print(v.climbStairs(7))

#Essentially another method of implementing Fibonacci
