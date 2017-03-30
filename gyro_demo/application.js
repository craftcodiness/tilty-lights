////////////////////////////
// websockets
////////////////////////////

var aurthur_url = "ws://99d617a5.ngrok.io"
var arthur_socket = new WebSocket(aurthur_url);

arthur_socket.onopen = function (event) {
  arthur_socket.send("Here's some text that the server is urgently awaiting!"); 
};


arthur_socket.onmessage = function (event) {
  console.log('recived', event.data);
}

arthur_socket.onerror = function(event){
  console.log("error", event.data)

}

update_debug = function(data) {
  var data_div = document.getElementById('debug_data')

  data_div.innerHTML = "<p> x = " + data.dm.x + "</p>" +
                  "<p> y = " + data.dm.y + "</p>" +
                  "<p> z = " + data.dm.z + "</p>" +
                  "<p> alpha = " + data.do.alpha + "</p>" +
                  "<p> beta = " + data.do.beta + "</p>" +
                  "<p> gamma = " + data.do.gamma + "</p>";
}


update_websocket = function (data) {
  data_json = {
    x: data.dm.x,
    y: data.dm.y,
    z: data.dm.z,
    alpha: data.do.alpha,
    beta: data.do.beta,
    gamma: data.do.gamma
  }

  //console.log(JSON.stringify(data_json))
  arthur_socket.send(JSON.stringify(data_json));
  arthur_socket.send("fuck you");

}

////////////////////////////
// gyro
////////////////////////////


var gn = new GyroNorm();

gn_opts = {frequency: 2000}

gn.init(gn_opts).then(function(){
  gn.start(function(data){
      update_debug(data);
      update_websocket(data);
  });
}).catch(function(e){
  // Catch if the DeviceOrientation or DeviceMotion is not supported by the browser or device
});