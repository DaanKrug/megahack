var origin = 'https://www.megahack2020.skallerten.com.br';
var siteUrl = origin + '/megahack2020';
var cdn0 = 'https://skallerten-cdn.s3.amazonaws.com';
var cdn = 'https://megahack2020-cdn.s3-us-west-2.amazonaws.com';
var cacheName = 'megahack2020-v1.0.0_' + new Date().getTime();
var urlsToPrefetch = [
	cdn + '/custom.min.css',
	cdn0 + '/fontawesome-5.11/css/all.min.css',
	cdn0 + '/bootstrap/bootstrap-reduced.min.css',
	cdn + '/angular/runtime-es2015.js',
	cdn + '/angular/polyfills-es2015.js',
	cdn + '/angular/main-es2015.js',
	cdn + '/angular/scripts.js',
	cdn0 + '/tinymce-5.3.0/jquery.tinymce.min.js',
	cdn0 + '/tinymce-5.3.0/tinymce.min.js',
	cdn0 + '/webfonts/ubuntu/ubuntu.css',
	cdn + '/angular/styles.css',
	cdn0 + '/themes/blue01.min.css'
];
var requestProps = {method: 'GET',
		            mode: 'no-cors',
		            headers: {'Accept-Encoding':'gzip,deflate,br', 
		            	      'Origin': origin,
		            	      'Access-Control-Allow-Origin': origin}};
function canBeCached(url){
	url = url.split('?')[0];
	if(urlsToPrefetch.includes(url) || url == siteUrl){
		return true;
	}
	if(url.indexOf('.jpg') != -1 || url.indexOf('.jpeg') != -1 
	   || url.indexOf('.gif') != -1 || url.indexOf('.bmp') != -1
	   || url.indexOf('.png') != -1 || url.indexOf('.ico') != -1
	   || url.indexOf('.webmanifest') != -1 || url.indexOf('.css') != -1
	   || url.indexOf('.js') != -1){
		return true;
	}
	return false;
}
function responseAppendHeaders(response){
	response.headers = new Headers({'Access-Control-Allow-Origin': origin});
	return response;
}
function addToCache(url){
	fetch(url,requestProps).then(function(response) {
		return addToCacheResponse(url,response);
	}).catch(function(error) {
        return Promise.resolve(null);
    });
}
function addToCacheResponse(url,response){
	if(!response || !response.ok) {
    	return Promise.resolve(null);
    }
	var responseToCache = responseAppendHeaders(response);
    var requestToCache = new Request(url,requestProps);
    caches.open(cacheName).then(function(cache) {
        return cache.put(requestToCache,responseToCache);
    }).catch(function(error) {
    	return Promise.resolve(null);
    });
}
this.oninstall = function(event){
	var cacheWhitelist = [cacheName];
	event.waitUntil(
	    caches.keys().then(function(keyList) {
		    return Promise.all(keyList.map(function(key) {
		        if (cacheWhitelist.indexOf(key) === -1) {
		            return caches.delete(key);
		        }
		    }));
		}).catch(function(error) {
            console.log('Service worker caches.keys() error: ', error);
	    })
	);
	event.waitUntil(
		caches.open(cacheWhitelist[0]).then(
			function(cache){
				var size = urlsToPrefetch.length;
				for(var i = 0; i < size; i++){
					var request = new Request(urlsToPrefetch[i],requestProps);
					cache.add(request).then(function(){}).catch(function(error){});
				}
			}
		).catch(function(error) {
            console.log('Service worker caches.open error: ', error);
	    })
	);
};
this.onactivate = function(event){};
this.onfetch = function(event){
	if(!navigator.onLine 
			&& origin.indexOf('//localhost') == -1 
			&& !canBeCached(event.request.url)){
		event.respondWith(
			caches.match(event.request).then(function(response) {
				resp = new Response(null,{status: 200});
				return responseAppendHeaders(resp);
			})
		);
	}
};