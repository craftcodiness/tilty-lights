////////////////////////////
// websockets
////////////////////////////

create_socket = function() {
  var result = new WebSocket("ws://" + window.location.host);
  result.onopen = function (event) {
    console.log("Websocket connection opened");
  };


  result.onmessage = function (event) {
    console.log('recived', event.data);
  }

  result.onerror = function(event){
    console.log("error", event.data)

  }
  return result;
}

var socket = create_socket();

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

  if (socket.readyState === socket.CLOSED) {
    socket = create_socket(); 
  }
  if (socket.readyState === socket.OPEN) {
    socket.send(JSON.stringify(data_json));
  }
}

////////////////////////////
// gyro
////////////////////////////


var gn = new GyroNorm();

gn_opts = {frequency: 500}

gn.init(gn_opts).then(function(){
  gn.start(function(data){
      update_debug(data);
      update_websocket(data);
  });
}).catch(function(e){
  // Catch if the DeviceOrientation or DeviceMotion is not supported by the browser or device
});
