# Cloudee Couch mode
This project is an example for building a 10-foot TV UI for an OAuth application. This application is built on top of [Spine.js](http://spinejs.com/) MVC coffeescript framework and can be served from a completely static hosting such as S3.
Here are some of the features which you might find helpful to re-use:

* [Keyboard abstraction class](https://github.com/Boxee/cloudee-couch/blob/master/app/controllers/controller.coffee) maintains focus on one panel only
* [OAuth authentication](https://github.com/Boxee/cloudee-couch/blob/master/app/authorization.coffee) (see note below) and error handling
* Skinned HTML5 [video player](https://github.com/Boxee/cloudee-couch/blob/master/app/controllers/player.coffee) which handles seeking, pause/play, [playing next](https://github.com/Boxee/cloudee-couch/blob/master/app/controllers/files.coffee#L22) video in a list and browser timing events

Other elements which you might be interested in are:

* [Pagination](https://github.com/Boxee/cloudee-couch/blob/master/app/controllers/main.coffee#L27) or [here](https://github.com/Boxee/cloudee-couch/blob/master/app/controllers/files.coffee#L52)
* Multi-environment: easily switch working against developement, staging, production environments using easy [configuration](https://github.com/Boxee/cloudee-couch/blob/master/app/controllers/config.coffee) file

## Dependencies
* NodeJS 
* NPM
* Spine
   
## Installation
    git clone git://github.com:Boxee/cloudee-couch.git
    cd cloudee-couch
    npm install

## Running
    hem server
This will start the NodeJS Hem server, by default running on port 9294.
Open the browser on [http://localhost:9294](http://localhost:9294)

## Deployment
Spine make it easy to compact CSS and Javascript into one compiled and minified file and serve it from a static server. To compile the assets run ```hem build``` which will output application.js and application.css into the public/ directory. Upload the entire public directory into the static server.

A good option for static serving is S3:

* Go to Amazon S3 [console](https://console.aws.amazon.com/s3/)
* Create a new bucket which will be mapped to your new couch domain application
* Set bucket properties: under the "Website" tab, checkmark the "Enabled" property, and in the "Index document" field, enter "index.html". You might also want to direct the error document as well to index.html
* On a different browser tab, open your domain registrar DNS management panel, and create a new CNAME pointing to the endpoint shown on the former step where you enabled the "Website" tab.
* Back on the Amazon S3 console, upload all the files in the /public directory into the bucket, and make sure to set permissions to "Make everything public"

## OAuth AJAX request note
This example is using a fork of Spine.js which transforms some request parameters such as OAuth authorization headers into GET query-string parameters. This is mainly due to some incompatabilities of some devices with Cross-Origin ([COR](http://en.wikipedia.org/wiki/Cross-origin_resource_sharing)) requests and specific headers.
