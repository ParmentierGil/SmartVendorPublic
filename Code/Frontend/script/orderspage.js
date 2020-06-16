let socket;

let allOrders;

let IP = "http://192.168.1.62:5500"

//#region FUNCTIONS

const prodById = function (id) {
    for (let prod of allProducts) {
        if (prod.ProductId == id)
            return prod;
    }
    return null;
}

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

//#endregion

//#region GET

const getAllOrders = function () {
    handleData(`${IP}/api/v1/orders`, showAllOrders);
}


//#endregion

//#region show

const showAllOrders = function (orders) {
    console.log(orders)
    allOrders = orders;
    orderHTML = "";

    for (order of orders) {

        date = order['MomentOfPurchase'].substr(5, 11);
        console.log(date);
        time = order['MomentOfPurchase'].substr(17, 5);
        console.log(time)

        orderHTML += `<div class="c-list-entry">
        <div class="c-list-entry__date">${date}</div>
        <div class="c-list-entry__time">${time}</div>
        <div class="c-list-entry__product">${order.Name}</div>
    </div>
    <div class="c-list-entry-divider"></div>`
    }
    document.querySelector('.c-list-entry-container').innerHTML = orderHTML;
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
    socket.emit("connected", "Orderpage Connected");

    socket.on("return_on_connect", function (msg) {
        console.log(msg);
    })

    getAllOrders();
    listenToOpenMenu();
    listenToCloseMenu();
};

document.addEventListener("DOMContentLoaded", function () {
    console.info("Orderpage loaded");
    init();
});
//#endregion