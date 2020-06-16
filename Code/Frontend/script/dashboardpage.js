let socket;

let IP = "http://192.168.1.62:5500"

//#region FUNCTIONS

//#endregion

//#region GET

const getStatus = function () {
  handleData(`${IP}/api/v1/status`, showStatus);
}

const getProductsInMachine = function () {
  handleData(`${IP}/api/v1/products/inmachine`, showProductsInMachine);
}

const getTotalMoney = function () {
  handleData(`${IP}/api/v1/totalmoney`, showTotalMoney);
}

const getLastOrder = function () {
  handleData(`${IP}/api/v1/lastorder`, showLastOrder);
}

//#endregion

//#region show

const showProductsInMachine = function (products) {
  console.log(products);

  for (let prod of products) {
    if (prod['NumberInVendingMachine'] == 1) {
      document.querySelector('.js-top-left-product').innerHTML = `<h2 class="c-product-info__title">${prod['Name']}</h2>
      <p>Number in Machine: ${prod['NumberInVendingMachine']}</p>
      <p>Price: €${prod['Price']}</p>
      <p>Sold: ${prod['SoldCount']}</p>`
    } else if (prod['NumberInVendingMachine'] == 2) {
      document.querySelector('.js-top-right-product').innerHTML = `<h2 class="c-product-info__title">${prod['Name']}</h2>
      <p>Number in Machine: ${prod['NumberInVendingMachine']}</p>
      <p>Price: €${prod['Price']}</p>
      <p>Sold: ${prod['SoldCount']}</p>`
    } else if (prod['NumberInVendingMachine'] == 3) {
      document.querySelector('.js-bottom-left-product').innerHTML = `<h2 class="c-product-info__title">${prod['Name']}</h2>
      <p>Number in Machine: ${prod['NumberInVendingMachine']}</p>
      <p>Price: €${prod['Price']}</p>
      <p>Sold: ${prod['SoldCount']}</p>`
    } else if (prod['NumberInVendingMachine'] == 4) {
      document.querySelector('.js-bottom-right-product').innerHTML = `<h2 class="c-product-info__title">${prod['Name']}</h2>
      <p>Number in Machine: ${prod['NumberInVendingMachine']}</p>
      <p>Price: €${prod['Price']}</p>
      <p>Sold: ${prod['SoldCount']}</p>`
    }

  }
}

const showStatus = function (status) {
  console.log(status);
  if (status.Online)
    document.querySelector('.js-status').innerHTML = "Online"
  else
    document.querySelector('.js-status').innerHTML = "Offline"
}


const showTotalMoney = function (totalmoney) {
  document.querySelector('.js-money').innerHTML = `€${totalmoney.total}`
}

const showLastOrder = function (order) {
  let colindex = order['MomentOfPurchase'].indexOf(":");
  let time = order['MomentOfPurchase'].substr(colindex - 2, 5);
  console.log(time);
  document.querySelector('.js-last-order').innerHTML = `${time}`
}

//#endregion

//#region ListenTo

const listenToOpenMenu = function () {
  let openButton = document.querySelector('.js-open-menu');

  openButton.addEventListener('click', function () {
    document.querySelector('.c-mobile-menu').style.display = "flex";
    openButton.style.display = "none";
    let lefts = document.querySelectorAll('.c-sensor-container--left');
    let rights = document.querySelectorAll('.c-sensor-container--right');
    let conts = document.querySelectorAll('.c-sensor-container');

    for (let cont of conts) {
      cont.style.flexBasis = "75%";
    }

    for (let l of lefts) {
      l.style.marginRight = "0px";
    }

    for (let r of rights) {
      r.style.marginLeft = "0px";
    }

  })
}

const listenToCloseMenu = function () {
  let closeButton = document.querySelector('.js-close-menu');

  closeButton.addEventListener('click', function () {
    document.querySelector('.c-mobile-menu').style.display = "none";
    document.querySelector('.js-open-menu').style.display = "block";

    let lefts = document.querySelectorAll('.c-sensor-container--left');
    let rights = document.querySelectorAll('.c-sensor-container--right');
    let conts = document.querySelectorAll('.c-sensor-container');

    for (let cont of conts) {
      cont.style.flexBasis = "40%";
    }

    for (let l of lefts) {
      l.style.marginRight = "8px";
    }

    for (let r of rights) {
      r.style.marginLeft = "8px";
    }
  })
}


//#endregion

//#region init

const init = function () {
  socket = io(`${IP}`);
  socket.emit("connected", "Homepage connected");

  socket.on("return_on_connect", function (msg) {
    console.log(msg);
  })

  socket.on("new_temp", function (temp) {
    console.log(temp);
    tempInCelsius = Math.round(temp / 100) / 10;
    document.querySelector('.js-temp').innerHTML = tempInCelsius + '°C';
  })

  socket.on("status_changed", function (status) {
    if (status) {
      document.querySelector('.js-status').innerHTML = "Online"
    } else {
      document.querySelector('.js-status').innerHTML = "Offline"
    }
  })

  socket.on("new_order", function (order) {
    console.log(order);
    money = Number(document.querySelector('.js-money').innerHTML.substring(1));
    money += Number(order['price'])
    document.querySelector('.js-money').innerHTML = `€${money}`

    document.querySelector('.js-last-order').innerHTML = `${order['time'][3]}:${order['time'][4]}`
  });

  listenToOpenMenu();
  listenToCloseMenu();

  getStatus();
  getProductsInMachine();
  getTotalMoney();
  getLastOrder();
};

document.addEventListener("DOMContentLoaded", function () {
  console.info("Homepage loaded");
  init();
});
//#endregion