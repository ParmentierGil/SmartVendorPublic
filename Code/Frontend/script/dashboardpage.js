let socket;

//#region FUNCTIONS

//#endregion

//#region GET


//#endregion

//#region show


//#endregion

//#region ListenTo


//#endregion

//#region init

const init = function () {
    socket = io("http://192.168.1.225:5500");
    socket.emit("connected", "Homepage connected");

    socket.on("return_on_connect", function(msg){
      console.log(msg);
    })

    socket.on("new_temp", function(temp){
        console.log(temp);
        tempInCelsius = Math.round(temp / 100) / 10;
        document.querySelector('.js-temp').innerHTML = tempInCelsius + '°C';
    })
};

document.addEventListener("DOMContentLoaded", function () {
  console.info("Homepage loaded");
  init();
});
//#endregion