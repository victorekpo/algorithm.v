#Testing out this algorithm Ternary & Quarternary search, which is really an enhanced binary search, since the list
# is only being split into two, will continue to experiment splitting the list into 4..

#Define Variables
arr = [1,2,3,4,5,6]
target = 5
arr2 = [1,5,12,15,46,100,221,331,332,333,500,10000,50000]
#arr.sort()

#Define Functions
def quarternarySearch(arr, target):
     left=0
     right=len(arr)-1
     third=left+1
     fourth=right-1
     
     while(left<=right):
        mid = (left+right)//2
        print("Start:", left, third, mid, fourth, right)
        if(arr[third] == target):
            print("Done!", left, third, mid, fourth, right)
            return third
        if(arr[fourth] == target):
            print("Done!", left, third, mid, fourth, right)
            return fourth
        if(arr[left] == target):
            print("Done!", left, third, mid, fourth, right)
            return left
        if(arr[right] == target):
            print("Done!", left, third, mid, fourth, right)
            return right
        if(arr[mid] == target):
            print("Done!", left, third, mid, fourth, right)
            return mid
        elif(arr[mid] < target):
            print("More..", left, third, mid, fourth, right)
            left = mid + 1
        else:
            print("Less..", left, third, mid, fourth, right)
            right = mid - 1
    
     return "Not Found"
    
result = quarternarySearch(arr, target)

#Execution
#r2 = binarySearch(arr2, 15)
#result2 = arr2[r2]
#notfound=binarySearch(arr2,-15)

