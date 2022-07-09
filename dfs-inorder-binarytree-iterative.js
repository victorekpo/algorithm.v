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

	const stack = []
	let current = root

	while(stack.length || current){ // when in too deep current goes to null, the stack length keeps the loop
		while(current){ // while there is a current branch, keep stacking left most values
			stack.push(current) // keep recording the trail, to backtrack
			current = current.left // get to leftmost child
		}
		const last = stack.pop() // finally pop the last item in the stack, pops parent if no more children
		console.log(last.value) // print its value
		current = last.right // now move to right child if parent node, if not go back to parent, beginning of loop, and pop the last parent
	}
}
walkInOrder(root)
