from flask import Flask,jsonify,request
import requests
from bs4 import BeautifulSoup
from concurrent.futures import ThreadPoolExecutor, as_completed
import json
import random
import time
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service as ChromeService
import yfinance as yf
import requests_cache

session = requests_cache.CachedSession('yfinance.cache')
session.headers['User-agent'] = 'my-program/1.0'

conversion={
    'SENSEX':"SENSEX:INDEXBOM",
    'BSECG':"BSE-CG:INDEXBOM",
    'N50':"NIFTY_50:INDEXNSE",
    'N50B':"NIFTY_BANK:INDEXNSE",
    'S&PBSE':"BSE-500:INDEXBOM",
    'S&PBSEM':"BSE-MIDCAP:INDEXBOM",
    'NASDAQ':".IXIC:INDEXNASDAQ"

}
options = Options()
options.add_argument('--headless')  # Run Chrome in headless mode
options.add_argument('--disable-gpu')
options.add_argument('--no-sandbox')
options.add_argument('--disable-dev-shm-usage')

Cache=dict()

def get_Price(ticker):
    url=f'https://www.google.com/finance/quote/{ticker}:NSE'
    class1="YMlKec fxKbKc"
    response=requests.get(url)
    soup=BeautifulSoup(response.text,'html.parser')
    price=float(soup.find(class_=class1).text[1:].replace(',',""))
    return price

def get_Market_Price(ticker):
    
    url=f'https://www.google.com/finance/quote/{conversion[ticker]}'
    if ticker not in Cache.keys():
        driver = webdriver.Chrome(service=ChromeService(ChromeDriverManager().install()), options=options)
        driver.get(url)
        percentage=float(driver.find_element(By.CLASS_NAME, "tnNmPe").text[:-1])
        price=float(''.join(driver.find_element(By.CLASS_NAME,"fxKbKc").text.split(",")))
        delta=float(driver.find_element(By.CLASS_NAME,"ZYVHBb").text.split(' ')[0])
        Cache[ticker]=driver
        
    else:
        driver=Cache[ticker]
        percentage=float(driver.find_element(By.CLASS_NAME, "tnNmPe").text[:-1])
        price=float(''.join(driver.find_element(By.CLASS_NAME,"fxKbKc").text.split(",")))
        delta=float(driver.find_element(By.CLASS_NAME,"ZYVHBb").text.split(' ')[0])
        Cache[ticker]=driver
    return price,percentage,delta
StockCache=dict()
def fetch_Stock_Price(ticker):
    
    url=f'https://www.google.com/finance/quote/{ticker}:NSE'
    if ticker not in Cache.keys():
        driver = webdriver.Chrome(service=ChromeService(ChromeDriverManager().install()), options=options)
        driver.get(url)
        percentage=float(driver.find_element(By.CLASS_NAME, "tnNmPe").text[:-1])
        price=float(''.join(driver.find_element(By.CLASS_NAME,"fxKbKc").text.split(","))[1:])
        delta=float(driver.find_element(By.CLASS_NAME,"ZYVHBb").text.split(' ')[0])
        StockCache[ticker]=driver
        
    else:
        driver=Cache[ticker]
        percentage=float(driver.find_element(By.CLASS_NAME, "tnNmPe").text[:-1])
        price=float(''.join(driver.find_element(By.CLASS_NAME,"fxKbKc").text.split(",")))
        delta=float(driver.find_element(By.CLASS_NAME,"ZYVHBb").text.split(' ')[0])
        StockCache[ticker]=driver
    return price,percentage,delta


app=Flask(__name__)
@app.route('/')
def hello():
    print("Welcome to Stock Trading")
    return "<h1>Welcome To Stock Trading</h1>"

@app.route('/fetchall')
def GetAllStocks():
    Prices=[]
    with open('DATA/Symbols.json','r',encoding='utf-8') as jsonfile:
        data=json.load(jsonfile)
    
    Symbols=data["Symbols"][0:3 ]
    start=time.time()
    with ThreadPoolExecutor(max_workers=100) as executor:
        futures = {executor.submit(get_Price, symbol): symbol for symbol in Symbols}
        for future in as_completed(futures):
            symbol = futures[future]
            try:
                result = future.result()
                Prices.append({"Symbol":symbol,"Value":result})
                print(f"Fetched {symbol}: {result}")
            except Exception as exc:
                print(f"{symbol} generated an exception: {exc}")
    end=time.time()

    print(end-start)
    return Prices

@app.route("/GetStock",methods=['GET'])
def GetStock():

    if request.is_json:
        data = request.get_json()
        Symbol=data['Symbol']
        

        return jsonify({"Symbol":Symbol,"value":get_Price(Symbol)})

    else:
        # print("OK")
        try:
            Symbol=request.args.get('Symbol')
            print(Symbol)
            return jsonify({"Symbol":Symbol,"value":get_Price(Symbol)})
        except Exception as err:
            return jsonify({'error': f'Invalid JSON data. Error: {err}'}), 400
    
    

@app.route("/GetNews",methods=["GET"])
def GetNews():
    news_titles = [
    "Sensex Surges 500 Points as Foreign Investments Flow In",
    "Reliance Industries' Shares Jump 7% After Announcing New Green Energy Initiative",
    "RBI Holds Interest Rates Steady Amid Inflation Concerns",
    "Tata Motors Reports Record Quarterly Profit, Shares Climb 8%",
    r"Infosys Gains 5% Following Strong Q1 Earnings Report",
    "Indian Rupee Strengthens Against Dollar, Boosting Importers' Stocks"
    ]
    imageURLS=[
        "https://images.moneycontrol.com/static-mcnews/2023/12/Stock-Market-1-4.jpg?impolicy=website&width=1600&height=900",
        "https://m.economictimes.com/thumb/msid-60890473,width-1200,height-900,resizemode-4,imgsize-52095/how-global-investors-view-the-indian-stock-market.jpg",
        "https://www.livemint.com/lm-img/img/2023/08/27/600x338/2-0-92302946-India-Markets1-4C-0_1681818756364_1693102727927.jpg",
    ]
    return jsonify({"Headline":random.choice(news_titles),"Link":"https://www.google.com","image":random.choice(imageURLS)})

@app.route("/GetMarketVal",methods=['GET'])
def Market():
    if request.is_json:
        data = request.get_json()
        Symbol=data['Ticker']
        

    else:
        print("OK")
        try:
            Symbol=request.args.get('Ticker')
            print(Symbol)
            data=get_Market_Price(Symbol)
            return jsonify({
                "Symbol":Symbol,
                "value":data[0],
                "percentage":data[1],
                "increase":data[2],
                })

        except Exception as err:
            return jsonify({'error': f'Invalid JSON data. Error: {err}'}), 400  

@app.route("/GetStockPrice")
def GetStockPrice():
    if request.is_json:
        data = request.get_json()
        Symbol=data['Ticker']
        

    else:
        print("OK")
        try:
            Symbol=request.args.get('Ticker')
            print(Symbol)
            data=fetch_Stock_Price(Symbol)
            return jsonify({
                "Symbol":Symbol,
                "value":data[0],
                "percentage":data[1],
                "increase":data[2],
                })

        except Exception as err:
            return jsonify({'error': f'Invalid JSON data. Error: {err}'}), 400  
  
    
@app.route("/DrawChart",methods=['GET'])
def DrawChart():
    def Get_Stock_History(Ticker,period,session):
        msft = yf.Ticker(Ticker,session=session)
        hist = msft.history(period=period)
        return hist['Close'].tolist(),hist.index.astype('str').to_list()
    if request.is_json:
        data = request.get_json()
        Symbol=data['Ticker']
    else:
        print("OK")
        try:
            Symbol=request.args.get('Symbol')
            Period=request.args.get('period')
            print(Symbol)
            data=Get_Stock_History(Symbol,Period,session)
            print(data[0])
            return jsonify({
                "Symbol":Symbol,
                "values":data[0],
                "dates":data[1]
                })

        except Exception as err:
            return jsonify({'error': f'Invalid JSON data. Error: {err}'}), 400  



@app.route("/Kill",methods=['GET'])
def Kill():
    for i in Cache.keys():
        Cache[i].quit()
    for i in StockCache.keys():
        StockCache[i].quit()
    return "Killed Drivers"



app.run(host='0.0.0.0',debug=True)