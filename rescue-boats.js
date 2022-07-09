people=[5,4,3,1,2,2,3,1,2,7,8,1,2,3,4,5,6,7]  //we have a lot of people to rescue
limit=3  // but we can only fit an accumulation of values per boat (i.e. weight)
peopleLeft=[]  // these are the people that are remaining after we dispatch all boats
people.sort()  // first thing we need to do is rate everyone accordingly, they will all report their "weight" and we sort them accordingly
left=0 // then we start at the beginning of the list
right=people.length-1  // and also at the ending of the list
boats=0  // with the current boat count starting at 0
while (left <= right) {   // we go through everyone in the list, as long as beginning and end never cross (natural law)
  if (left==right) {  // if beginning and end meet up, then we are at the end of our lookup
    if (people[right] <= limit) {    //if the person on the right has a value less than the limit (which is also equal to the person on the left's value), then we can add this value to the boat
      boats++; // increment a boat for this last person
    } else { peopleLeft.push(people[right]) }  // otherwise leave this person behind, they are beyond the limit
    break;   // end
  } 
  if (people[left]+people[right]<=limit){ // if left and right's values add and are less than or equal to the limit, add the two to a boat together and then move accordingly 1 step within the list
    right-=1; left+=1; boats+=1 // move right 1 (left), move left 1 (right), increment a boat for the two people
  } 
  else {  // if left does not right and left and right together are over the limit, check the right's value if it is over the limit
    if (people[right] <= limit) {  // if the right's value is less than the limit
      boats+=1;    // increment a boat for this person
    } else { peopleLeft.push(people[right]) }  // otherwise leave this person behind
   right-=1  // move the right one step to the left to continue on, notice the left stays where they are since they didn't get checked
  } 
}
console.log(boats)
console.log(peopleLeft)


