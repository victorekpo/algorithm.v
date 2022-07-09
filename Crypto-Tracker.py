import time
import requests
from collections import deque
from datetime import datetime
from datetime import timedelta
import pytz
import sys
import subprocess

coin=sys.argv[1]
UTC=pytz.utc
IST=pytz.timezone('America/Mexico_City')
start_time = int(time.time())
price_history=deque()
percdiff_history=deque()
price_now=0
price_last=0
price_started = None
pda_old=0
sleep_time=10
MAX=10 #max items in the list

def percdiff(price1,price2):
    result=round(((price1/price2)*100)-100,2)
    return result

def stringify_deque(dlist):
    return ','.join(map(str,(list(deque(dlist)))))

def writeFile(msg,filename):
    subprocess.check_output("echo \""+msg+"\"> "+filename,shell=True)

def appendFile(msg,filename):
    subprocess.check_output("echo \""+msg+"\">> "+filename,shell=True)

def sendEmail(filename):
    subprocess.check_output("cat "+filename+" | mail -a 'From: newfinstech' -s '::newfinstech:: - NEW SIGNAL' newfinstech@googlegroups.com;",shell=True)

def logging():
    if len(price_history) > 2:
        if price_history[0] < price_history[1] and price_history[1] < price_history[2]:
            print("price going down")
        elif price_history[0] > price_history[1] and price_history[1] > price_history[2]:
            print("price going up")

def getPrice(coin):
    # DEFINE VARIABLES
    global price_now
    global price_last
    global log_file
    global price_started
    global pda_old

    # MESSAGES
    MESSAGE_PRICEHISTORY = coin.upper()+"\nLast Price: "+str(price_last)+"\nPrice History: "+stringify_deque(price_history)+"\nPercDiff History: "+stringify_deque(percdiff_history)+"\n"

    # LOGGING
    log_file = open(coin+".log","a")
    old_stdout = sys.stdout
    sys.stdout = log_file

    # TIME LOGIC
    timestamp = datetime.now(IST).strftime("%m/%d/%Y %H:%M:%S")
    current_time = int(time.time())
    elapsed = round((current_time - start_time)/10)*10

    # API REQUEST
    request = requests.get('https://api.coingecko.com/api/v3/coins/'+coin)
    json = request.json()
    price_now = json['market_data']['current_price']['usd']
    if price_started is None:
        price_started = price_now
        #print("Price Started!",price_started)
    if len(price_history) > 0:
        print("Price History:",stringify_deque(price_history))
    if len(price_history) > 1:
        print(stringify_deque(percdiff_history))
    if len(price_history) >= 2:
        pd1 = percdiff(price_history[0],price_history[1])
        pd2 = percdiff(price_history[0],price_history[len(price_history)-1])
        pda = percdiff(price_history[0],price_started)
        print("Percent Difference Current:",pd1,"Relative:",pd2,"AllTime:",pda)

        # SEND SIGNALS FOR PRICE ACTION MOVEMENTS
        signal_pda=pda_old - pda
        if signal_pda > 3:
            pda_old=pda
            appendFile(MESSAGE_PRICEHISTORY,coin+".price")
            sendEmail(coin+".price")
        elif signal_pda < -3:
            pda_old=pda
            appendFile(MESSAGE_PRICEHISTORY,coin+".price")
            sendEmail(coin+".price")
        # END SIGNALS

    if len(price_history) > MAX:
        price_history.pop()
        percdiff_history.pop()

    # PRINT LOGS
    print("")
    print("Tracking..",coin.upper(),"elapsed: ",elapsed)
    print(timestamp)
    if elapsed != 0:
        if elapsed % 1800 == 0:
            print("every 30 minutes")
        elif (elapsed % 600) == 0:
            print("every 10 minutes")
        elif (elapsed % 300) == 0:
            print("every 5 minutes")
        elif (elapsed % 60) == 0:
            print("every 1 minute")
        elif (elapsed % 30) == 0:
            print("every 30 seconds")
    print("Current Price:",price_now)

    # PRICE AND PERCDIFF ARRAY
    if price_now != price_last:
        if price_last != 0:
            percdiff_history.appendleft(percdiff(price_now,price_last))
            print("Last Price:",price_last)
        else:
            percdiff_history.appendleft("Start")
        price_history.appendleft(price_now)


    # WAIT
    time.sleep(sleep_time)
    price_last = price_now
    logging()
    sys.stdout = old_stdout
    log_file.close()


# RECURSION
while True:
    getPrice(coin)

