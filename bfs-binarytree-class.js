class Node {
  constructor(value){
    this.left = null;
    this.right = null;
    this.value = value;
    this.level = 1;
    this.branch = "root";
  }
}
const getNode = (node,more=0) => {
  str=" ";multiStr = str.repeat(node.level)
  if (more !==0) { console.log(multiStr,node.value, "level:", node.level, "branch:", node.branch)}
  else { console.log(multiStr,node.value) }
  if(node.left) {getNode(node.left,more);}
  if(node.right) {getNode(node.right,more);}
}

class BinarySearchTree {
  constructor(){
    this.value = null;
  }
  insert(value){
    const newNode = new Node(value);
    if (this.value === null) {
      this.branch = newNode.branch;
      this.level = newNode.level;
      this.value = newNode.value;
      this.left = newNode.left;
      this.right = newNode.right;
      console.log("newNode",newNode)
      console.log("empty")
    } else {
      let currentNode = this;
      while(true){
        if(value < currentNode.value){
         //Left
          if(!currentNode.left){
            currentNode.left = newNode;
            currentNode.left.level = currentNode.level+1;
            currentNode.left.branch = "left";
            return this;
          }
          currentNode = currentNode.left;
        } else {
          //Right
          if(!currentNode.right){
            currentNode.right = newNode;
            currentNode.right.level = currentNode.level+1;
            currentNode.right.branch = "right"
            return this;
          }
          currentNode = currentNode.right;
        }
      }
    }
  }
  lookup(value){
    if (!this.value) {
      return false;
    }
    let currentNode = this;
    while(currentNode){
      if(value < currentNode.value){
        currentNode = currentNode.left;
      } else if(value > currentNode.value){
        currentNode = currentNode.right;
      } else if (currentNode.value === value) {
        return currentNode;
      }
    }
    return null
  }
}

let vTest = new BinarySearchTree()
console.log(vTest)
getNode(vTest)
vTest.insert(9)
getNode(vTest)
console.log(vTest)
vTest.insert(7)
console.log(vTest)
getNode(vTest)
vTest.insert(12)
console.log(vTest)
getNode(vTest)
vTest.insert(18)
console.log(vTest)
getNode(vTest)
vTest.insert(22)
vTest.insert(3)
vTest.insert(2)
vTest.insert(5)
vTest.insert(1)
getNode(vTest,1)
console.log(vTest.lookup(7))
