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

function walkInOrder(root){
  if(root === null) return

  //recurse through left nodes first
  if(root.left) walkInOrder(root.left)

  //then get the value of the root node
  console.log(root.value)

  //then recurse through right nodes
  if(root.right) walkInOrder(root.right)
}
walkInOrder(root)
