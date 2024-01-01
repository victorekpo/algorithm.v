export const countCommentItems = (arr, total = 0) => {
  // arr.length && console.log("arr", arr)
  const getCountForIdx = (arr, count = 0) => {
    if (arr.length > 1) {
      return countCommentItems(arr, count);
    }
    // console.log("arr", JSON.stringify(arr));
    if (!arr[ 0 ]?.items?.length)
      return count + 1;
    return getCountForIdx(arr[ 0 ]?.items, count + 1);
  };

  if (!arr[ 0 ]) {
    return total;
  }
  total = total + getCountForIdx([arr[ 0 ]]);
  if (arr.length) {
    total = total + countCommentItems(arr.slice(1));
  }
  return total;
};

export const limitNestedArray = (arr, limit) => {
  let count = 0;

  const customReducer = (accumulator, currentElement) => {
    if (count === limit) {
      // Break out early
      return accumulator;
    }

    count = count + 1;

    const newItem = { ...currentElement };
    newItem.items = [];

    if (currentElement.items && currentElement.items.length > 0) {
      for (const nestedItem of currentElement.items) {
        const temp = customReducer([], nestedItem);
        const emptyArray = Array.isArray(temp) && !temp.length;
        if (!emptyArray) newItem.items = [...newItem.items, temp];
      }
    }

    return newItem;
  };

  const customReduce = (array, reducer) => {
    // Exit early if limit = 0
    if (limit === 0) {
      return [];
    }

    let result = []; // start with an empty array

    for (const element of array) {
      result = [...result, reducer(result, element)];

      // Check breaking condition
      if (count === limit) {
        break;
      }
    }

    return result;
  };

  // Reverse the original array to get the most recent items
  const reversedArray = arr.slice().reverse();
  const truncatedReversedArray = customReduce(reversedArray, customReducer);
  const truncatedArray = truncatedReversedArray.slice().reverse(); // restore the order
  // console.log(JSON.stringify(truncatedArray, null, 2));
  return truncatedArray;
};
