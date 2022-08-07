let arr =[];
const timeSeriesArr = () => {
    let count = 0;
    while(count < 100) {
        arr[0]=Math.floor(Math.random() * 100);
        console.log(arr);
        for (let i= 5; i>=0; i--) {
            arr[i] = arr[i-1];
        }
        sleep(1000);
        count++;
    }
}

const sleep = (ms) => {
    const date = Date.now();
    let currentDate = null;
    do {
        currentDate = Date.now();
    } while (currentDate - date < ms);
}

timeSeriesArr();