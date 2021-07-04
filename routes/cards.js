var express = require('express')
var router = express.Router()
const fetch = require("node-fetch")
const fs = require('fs')
const readline = require('readline')
const dateFormat = require("dateformat")

//DEMARRER : nodemon .bin/www

module.exports = router;
/* GET cards pricing. */
router.get('/', async function(req, res, next) {
  console.log("######### search prices for card list #########")
  emptyFile()

  readDataFile(req, res)

});

function emptyFile() {
    //Empty the file
    fs.writeFile('prices.txt', '', function(){console.log('fichier vidé')})
}

var readDataFile = async function (req, res) {


    const rl = readline.createInterface({
      input: fs.createReadStream('./data/MCMsearchCards.txt'),
      crlfDelay: Infinity
    })


    const start = async () =>{
        for await (const line of rl) {
            await searchCardPrice(line, req, res)
        }
        res.end("fichier cree")
    }
    start()
}


async function searchCardPrice(url, req, res) {
    console.log("-----------searchCardPrice-----------")
    console.log(url)
    console.log("----------------------")
    return new Promise(function(resolve, reject) {
        try {
            const request = step => fetch(url)
            .then(function(response) {
                console.log(response.url + " => " + response.status + " " + response.statusText)
                if(response.status == "200") {
                    return response.text()
                }
            })
            

            request().then(
                result => {
                    //Find word "Tendance"
                    var fromTendance = "Tendance"
                    var myContentWithPrice = result.indexOf(fromTendance)
                    console.log(myContentWithPrice)

                    //Find next 100 words ~ and extract the price bewteen spans
                    var stringtoExtract = result.slice(myContentWithPrice, myContentWithPrice+100)
                    stringtoExtract= stringtoExtract.split("<span>").pop().split("</span>").shift();

		            var myPrice = stringtoExtract
		            console.log("myPrice: "+myPrice)
        
                    let price = writePrices(myPrice, url, req, res)
                    resolve(price)
                }
            ).catch(error => {
                console.log("error: "+error)
            })

        } catch (error) {
            console.log(error);
        }

    })

}

async function writePrices(price, url, req, res) {
    return new Promise(function(resolve, reject) {
        fs.appendFileSync('prices.txt', price + " - " + url + "\r\n" , function (err) {
          if (err) return console.log(err);
        })
        resolve(price)
    })
        
}

function sleep(ms) {
  return new Promise((resolve) => {
    setTimeout(resolve, ms);
  });
} 