// Cartesian Explained
defaultResponses = {
  victor: 'hello',
  nancy: 'hi',
  test: 'hey'
};

const filterUniqueValue = (arr, filterVal, inclusive = true) => {
  return arr.filter(obj => {
    let count = 0;
    const keys = Object.keys(obj);
    keys.forEach(key => {
      if(JSON.stringify(obj[key]) === JSON.stringify(filterVal)) count++
    });
    return inclusive ? count <= 1 : count === 1;
  });
};

makeTestCases = (unhappyPath) => {
  const getCartesian = (obj) => Object.entries(obj).reduce((r, [k, v]) => {
    const temp = [];
    r.forEach((s) =>
        v.forEach((x) =>
          temp.push({ ...s, [k]: x })
        )
    );
    return temp;
    }, [{}]
  );


  const buildObject = {}
  for (let key in defaultResponses) {
    // Set Happy, Unhappy Path
    const allPossibleResponses = [unhappyPath, defaultResponses[key]]
    for (let possibility of allPossibleResponses) {
      //  console.log(key, possibility)
      buildObject[key] =  [...(buildObject[key] || []), possibility]
    }
  }
  return getCartesian(buildObject);
};

a = makeTestCases(null);
b = filterUniqueValue(a, null, false)
