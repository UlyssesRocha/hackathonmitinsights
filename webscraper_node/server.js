var express = require('express');
var fs      = require('fs');
var request = require('request');
var https = require('https');
var cheerio = require('cheerio');
var app     = express();


var index;
var result = [];


var make = function(urls){


    
    for (index = 0; index < urls.length; ++index) {
    
    

          request('https://www.vivareal.com.br'+urls[index], function(error1, response1, html1){
                  
                  
            if(!error1){

             var $ = cheerio.load(html1);
                    




            var title, address, bairro_estado,area,room,bathroom,price,status;
            //var json = { title : "", address : "", bairro_estado : "",area : "",room : "",bathroom : "",price : "",status : ""};



            /*
            const urls = [];

            $('.js-cardLink').each(function(i, elem) {
              urls[i] = $(this).attr('href');
            });

            console.log(urls);
            */


            $('h1.pD').filter(function(){
              var data = $(this);

              title = data.children().first().text().trim();
              //release = data.children().last().children().last().text().trim();

            })



             $('h3.gJ').filter(function(){
              var data = $(this);

              address = data.children().first().text().trim();
              //release = data.children().last().children().last().text().trim();

            })

             $('h3.gJ').filter(function(){
              var data = $(this);

              bairro_estado = data.children().last().text().trim();
              //release = data.children().last().children().last().text().trim();

            })

             //console.log(address);
             //console.log(bairro_estado);



            $('.icon-area').filter(function(){
              var data = $(this);

              area = data.children().last().text().trim();
              //release = data.children().last().children().last().text().trim();

            })

            $('.icon-room').filter(function(){
              var data = $(this);

              room = data.children().last().text().trim();
              //release = data.children().last().children().last().text().trim();

            })


            $('.icon-bathroom').filter(function(){
              var data = $(this);

              bathroom = data.children().last().text().trim();
              //release = data.children().last().children().last().text().trim();

            })


            $('.summary-information--price').filter(function(){
              var data = $(this);

              price = data.text().trim();
              //release = data.children().last().children().last().text().trim();

            })



            $('.hbs-step-by-step__item--current').filter(function(){
              var data = $(this);

              status = data.text().trim();
              //release = data.children().last().children().last().text().trim();

            })


            
            $('.js-showMap').filter(function(){
              var data = $(this);

              lat = data.data("latitude");
              lon = data.data("longitude");
              //release = data.children().last().children().last().text().trim();
            })



            sql = { title: title, address:address, bairro_estado: bairro_estado, area: area,room:room,bathroom:bathroom, price:price, status:status};



            result.push(sql);


            fs.writeFile('insert.json', JSON.stringify(result, null, 4), function(err){
                                //console.log('output5.json criado');
            });

            /*
            $('.js-openGallery').filter(function(){
              var data = $(this);
              console.log(data);

              img = data.data("src");
            })
            */
                    
                  }
                  
                });
                
    }



}










app.get('/scrape', function(req, res){



      var paginas = 3; 


 

      url1  = 'https://www.vivareal.com.br/imoveis-lancamento/?pagina=2';

      request(url1, function(error, response, html){

          if(!error){
            var $ = cheerio.load(html);



            const links = [];

            $('.js-cardLink').each(function(i, elem) {
              links[i] = $(this).attr('href');
            });

            //console.log(links);

            make(links);

          }


          res.send('Check your console!')
        })

  






   const urls = [];

for (i = 1; i < paginas; i++) { 

    //text += cars[i] + "<br>";

        // Let's scrape Anchorman 2
        urls[i]  = 'https://www.vivareal.com.br/imoveis-lancamento/?pagina='+i ;



  }

  //console.log(urls);



})

app.listen('8081')
console.log('Magic happens on port 8081');
exports = module.exports = app;
