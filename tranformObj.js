//*****V1;
const transformObj = (obj, cb) => {
    const loopObj = (obj, newObj = {}) => {
        for (const key in obj) {
            if (typeof obj[key] === "object" && !Array.isArray(obj[key])) {
                // stage object keys
                if (!newObj[key]) newObj[key] = {};
                // recurse through inner keys
                loopObj(obj[key], newObj[key]);
            }
            if (!newObj[key]) {
                cb(newObj, obj, key);
            }
        }
        return newObj;
    };
    return loopObj(obj);
};

const transformer = (newObj, oldObj, key) => {
    newObj[key] = oldObj[key];
};

// Example 1
const obj1 = {
    a: {
        ab: [{name: "vic", age: 20}],
        ac: [{name: "nancy", age: 18}],
        ad: {
            adb: [{name: "vic", age: 30}]
        },
        av: {
            adv: [{name: "vic", age: 30}],
            ade: {
                adf: [{name: "vic", age: 30}]
            }
        }
    },
    b: {
        bb: [{name: "vic", age: 20}],
        bc: [{name: "nancy", age: 18}],
        bd: {
            be: [{name: "nancy", age: 18}]
        }
    },
    c: "123"
};

v = transformObj(obj1, transformer);

// An Example of Transforming Keys Deeply Nested
const addVicToKeys = (newObj, oldObj, key) => {
    newObj[key] = oldObj[key] + " Vic";
};

const testObj = {
    a: 1,
    b: {
        c: 3,
        d: {
            e: 4,
            f: {
                g: 5,
                h: {
                    i: 6,
                    j: {k: 7}
                }
            }
        }
    }
};
const result = transformObj(testObj, addVicToKeys);
console.log(util.inspect(result, {showHidden: false, depth: null, colors: true}));


// const isSame = JSON.stringify(v) === JSON.stringify(obj);
// console.log(isSame);


//***V2 - BEST
// Transform Object V2 using modern ES6 Javascript methods
const transformObjV2 = (origObj, cb) => Object.keys(origObj)
    .reduce((newObj, key) => {
        if (typeof origObj[key] === "object" && !Array.isArray(origObj[key])) {
            return {...newObj, [key]: transformObjV2(origObj[key], cb)};
        }
        if (!newObj[key]) {
            cb(newObj, origObj, key);
        }
        return newObj;
    }, {});

const sampleTransformer = (newObj, origObj, key) => {
    const currentValue = origObj[key];
    if (Array.isArray(currentValue)) {
        newObj[key] = [3, 4, 5];
    } else if (currentValue === "vic") {
        newObj[key] = "victor";
    } else {
        newObj[key] = currentValue + "vic";
    }
};

const sampleObj = {
    a: 1,
    b: 2,
    c: {
        d: 3,
        e: [1, 2, 3]
    },
    f: "vic"
};
transformObjV2(sampleObj, sampleTransformer);