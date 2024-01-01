const moment = require('moment');

let dateInterval = 30;
let multiplyInterval = 1;

const generateRandomDate = () => {
    // console.log("Multiply", multiplyInterval, dateInterval * multiplyInterval);
    const date = moment().add((dateInterval * multiplyInterval), "minutes"); //.format('hh:mm');
    // multiplyInterval = Math.min(multiplyInterval + 1, 300);
    multiplyInterval = multiplyInterval < 300 ? (multiplyInterval + 1) : 1;
    return date;
};

const resetDateIntervals = () => multiplyInterval = 1;

const randomString = (len, charSet) => {
    charSet = charSet || 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    let randomString = '';
    for (let i = 0; i < len; i++) {
        const randomPoz = Math.floor(Math.random() * charSet.length);
        randomString += charSet.substring(randomPoz, randomPoz + 1);
    }
    return randomString;
}

const generateRandomNumber = (end = 100, begin = 0) => Math.floor(Math.random() * (end - begin) + begin);

const keys = ["Rating", "UserId", "Username", "Email", "Utterance", "Intent", "BotReply", "Timestamp"]

const randomData = () => keys.reduce((rand, key) => {
    const mapKey = {
        Timestamp: () => generateRandomDate(),
        Rating: () => generateRandomNumber(100)
    }

    return {
        ...rand,
        [key]: mapKey?.[key]?.() || randomString(10)
    }
}, {});

const generateRandomData = (length) => [...Array(length)].map(() => randomData());

const getDayOfWeek = (number) => {
    const daysInWeek = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    return daysInWeek[number];
};

const getMonthInYear = (number) => {
    const monthsInYear = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return monthsInYear[number];
};

const generateRandomDataWithTime = (length) => generateRandomData(length).map(obj => ({
    ...obj,
    DayInWeek: getDayOfWeek(moment(obj.Timestamp).day()),
    Month: getMonthInYear(moment(obj.Timestamp).month()),
    Day: moment(obj.Timestamp).date(),
    Year: moment(obj.Timestamp).year(),
    Hour: moment(obj.Timestamp).hour(),
    Minute: moment(obj.Timestamp).minute(),
    Second: moment(obj.Timestamp).second()
}));

module.exports = {
    generateRandomData,
    generateRandomDataWithTime,
    generateRandomDate,
    randomString
};
