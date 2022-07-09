#Binary Search Algorithm
#Binary Search has an O complexity of O(log(n)) since it doesn't have to go through every single node. It splits the list in half
#until it finds the target value. A very fast search algorithm, much better than linear search. Implement whenever possible.
#The goal behind binary search is to use the left and the right pointer to split the list and check the mid value for the
#target value. In the below implementation, I have also made the program check the left and right pointers to make the algorithm
#a bit more efficient.

#Notes: One thing to note is that in binary search the list must already be sorted.

#Define Variables
arr = [1,2,3,4,5,6]
target = 5
arr2 = [1,5,12,15,46,100,221,331,332,333,500,10000,50000]
#arr.sort()

#Define Functions
def binarySearch(arr, target):
     left=0
     right=len(arr)-1
     
     while(left<=right):
        mid = (left+right)//2
        print("Start:", left, mid, right)
        if(arr[left] == target):
            print("Done!", left, mid, right)
            return left
        if(arr[right] == target):
            print("Done!", left, mid, right)
            return right
        if(arr[mid] == target):
            print("Done!", left, mid, right)
            return mid
        elif(arr[mid] < target):
            print("More..", left, mid, right)
            left = mid + 1
        else:
            print("Less..", left, mid, right)
            right = mid - 1
    
     return "Not Found"
    
result = binarySearch(arr, target)

#Execution
#r2 = binarySearch(arr2, 15)
#result2 = arr2[r2]
#notfound=binarySearch(arr2,-15)

