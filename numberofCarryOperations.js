const numberOfCarryOperations = (num1,num2) => {
    // split the number into an array
    const num1Array = Array.from(String(num1));
    const num2Array = Array.from(String(num2));
    
    let carry = 0;
    let carryAmount = 0;

    // // check the length of the array
    let num1ArrayLength = num1Array.length;
    let num2ArrayLength = num2Array.length;
    
    // loop through digits then return carry
    for(let digit1 = num1ArrayLength-1; digit1 >=0; digit1--) {
        
         for(let digit2 = num2ArrayLength-1; digit2 >=0; digit2--) {
            // do an operation that checks if num1 digit + num2 digit is greater than 9
             
             let calc = parseInt(num1Array[digit1],10) + parseInt(num2Array[digit2],10)  + parseInt(carryAmount,10);
            
             // if greater than 9 then +1 to carry
             if(calc > 9) {
                carryAmount = Array.from(String(calc))[0];
                carry++;
             }

             break;
         }

         num2ArrayLength--;
     }

     return carry;



}
console.log(numberOfCarryOperations(12,29));
console.log(numberOfCarryOperations(55,65));
console.log(numberOfCarryOperations(155,965));
console.log(numberOfCarryOperations(21,12));
console.log(numberOfCarryOperations(1,999))
console.log(numberOfCarryOperations(999,1))
