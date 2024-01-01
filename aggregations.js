// Aggregations Count & Group By Functions
// Assuming "data" is an array of objects [{},{}]
// "keyToCount" refers to the key to count in each object
// "groupByKey" refers to the key to group by in each object
const aggregateCount = (data, keyToCount) => {
  const count = {};
  for (let obj of data) {
    let searchValue = `ag_${obj[keyToCount]}`; // appending ag_ to avoid number keys getting sorted, normalize after return
    if (searchValue in count) {
      count[searchValue]++;
    } else {
      count[searchValue] = 1;
    }
  }
  const result = {};
  for (let searchValue in count) {
    result[searchValue] = {
      count: count[searchValue]
    };
  }
  return result;
};

const aggregateGroupBy = (data, groupByKey) => {
  const groups = {};
  for (let obj of data) {
    let searchGroup = `ag_${obj[groupByKey]}`; // appending ag_ to avoid number keys getting sorted, normalize after return
    if (searchGroup in groups) {
      groups[searchGroup].push(obj);
    } else {
      groups[searchGroup] = [obj];
    }
  }
  return groups;
};

const filterData = (data, key, value) => aggregateGroupBy(data, key)[`ag_${value}`];

const filterDataByProps = (data, object) => {
  if (!Object.keys(object).length) {
    return data;
  }
  const [first, ...rest] = Object.entries(object);
  const [key, value] = first;
  const newData = filterData(data, key, value);
  const newObject = Object.fromEntries(rest);
  return filterDataByProps(newData, newObject);
};

// group by key1,then group by key 2
const getNestedAggGroupBy = (data, key1, key2) => {
  const arr = Object.entries(aggregateGroupBy(data, key1));
  return arr.reduce((acc, kv) => ({...acc, [kv[0]]: aggregateGroupBy(kv[1], key2)}), {});
};

// group by key 1, then get number of occurrences of key 2
const getNestedAggCount = (data, key1, key2) => {
  const arr = Object.entries(aggregateGroupBy(data, key1));
  return arr.reduce((acc, kv) => ({...acc, [kv[0]]: aggregateCount(kv[1], key2)}), {});
};

module.exports = {
  aggregateCount,
  aggregateGroupBy,
  getNestedAggCount,
  getNestedAggGroupBy,
  filterDataByProps,
  filterData
};
