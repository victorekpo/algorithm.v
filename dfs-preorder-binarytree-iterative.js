function Node(value){
  this.value = value
  this.left = null
  this.right = null
}

//usage
const root = new Node(2)
root.left = new Node(1)
root.right = new Node(3)
root.left.left = new Node(4)
root.left.right = new Node(5)
root.right.left = new Node(6)
root.right.right = new Node(7)
console.log(root)

function walkPreOrder(root){
  if(root === null) return

  const stack = [root]
  while(stack.length){
    const item = stack.pop()

    //do something
 
     console.log(item.value)
   //left child is pushed after right one, since we want to print left child first hence it must be above right child in the stack, remember stacks are LIFO (last in first out) because you are popping the items, you are getting the inner most items starting on the left side (depth first, preorder). 
  if(item.right) stack.push(item.right)
  if(item.left) stack.push(item.left)
  }
}
walkPreOrder(root)
