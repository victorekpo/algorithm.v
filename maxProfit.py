from typing import List
class Solution:
    def maxProfit(self, prices: List[int]) -> int:
        buyPrice = float("inf")
        profit =0

        for i, price in enumerate(prices):
            if(buyPrice > price):
                buyPrice = price
            else:
                profit = max(profit, price - buyPrice)

        return profit

v=Solution()
print(v.maxProfit([9,2,11,15,3,23,9,12,25,15]))

