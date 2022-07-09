// This is the Breadth First Traversal Algorithm
// To achieve this form of traversal we can use a queue (FIFO) data structure. 
// 1. Initiate a queue with root in it.
// 2. Remove the first item out of queue
// 3. Push the left and right chidren of popped item into the queue
// 4. Repeat steps 2 and 3 until the queue is empty

function Node(value){
  this.value = value
  this.left = null
  this.right = null
}

//usage
const root = new Node(2)
root.left = new Node(1)
root.right = new Node(3)
root.left.left = new Node(8)
root.left.right = new Node(10)
root.right.left = new Node(11)
root.right.right = new Node(15)

function walkBFS(root) {
  if(root === null) return

  const queue = [root], ans = []
  while(queue.length){
    const len = queue.length, level = []
    for(let i = 0; i < len; i++){
     const item = queue.shift()
     level.push(item)
     if(item.left) queue.push(item.left)
     if(item.right) queue.push(item.right)
    }
    ans.push(level)
   }
   return ans
}
console.log(walkBFS(root))
