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

  // do something here

  console.log(root.value)

  //recurse through child nodes
  if(root.left) walkPreOrder(root.left); console.log(root);
  if(root.right) walkPreOrder(root.right)
}
walkPreOrder(root)
