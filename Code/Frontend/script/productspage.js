let socket;

let allProducts;

//#region FUNCTIONS

const prodById = function(id){
    for (let prod of allProducts){
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

const getAllProducts = function () {
    handleData("http://192.168.1.225:5500/api/v1/products", showAllProducts);
}


//#endregion

//#region show

const showAllProducts = function (products) {
    console.log(products)
    allProducts = products; 
    prodHTML = "";

    for (prod of products) {
        prodHTML += `<div class="c-list-entry" id="${prod.ProductId}-prod">
        <div class="c-list-entry__name">${prod.Name}</div>
        <div class="c-list-entry__price">€${prod.Price}</div>
        <div class="c-list-entry__number">${prod.NumberInVendingMachine}</div>
        <div class="c-list-entry__actions">
            <button class="c-list-entry__actions-edit" id="${prod.ProductId}-edit">
                <svg class="c-list-entry__actions-edit-icon" xmlns="http://www.w3.org/2000/svg" width="12.002" height="12.002"
                    viewBox="0 0 12.002 12.002">
                    <path id="ic_edit_24px"
                        d="M3,12.5V15H5.5l7.374-7.374-2.5-2.5ZM14.807,5.693a.664.664,0,0,0,0-.94l-1.56-1.56a.664.664,0,0,0-.94,0l-1.22,1.22,2.5,2.5,1.22-1.22Z"
                        transform="translate(-3 -2.997)" fill="#116466" />
                </svg>
            </button>
            <button class="c-list-entry__actions-delete js-delete" id="${prod.ProductId}-del">
                <svg class="c-list-entry__actions-delete-icon" xmlns="http://www.w3.org/2000/svg" width="10.111" height="13" viewBox="0 0 10.111 13">
                    <path id="ic_delete_24px"
                        d="M5.722,14.556A1.449,1.449,0,0,0,7.167,16h5.778a1.449,1.449,0,0,0,1.444-1.444V5.889H5.722ZM15.111,3.722H12.583L11.861,3H8.25l-.722.722H5V5.167H15.111Z"
                        transform="translate(-5 -3)" fill="#116466" />
                </svg>
            </button>
        </div>
        </div>
        <div class="c-list-entry-divider"></div>`
    }
    document.querySelector('.c-list-entry-container').innerHTML = prodHTML;

    listenToAllDelete();
}

const showDeleteConfirmed = async function(returned){
    console.log(returned);
    document.querySelector('.js-confirm-delete-title').innerHTML = "Product deleted"
    await sleep(2000);
    document.querySelector('.full-body').style.pointerEvents = "all";
    document.querySelector('.js-confirm-delete').style.display = "none";
    document.querySelector('.c-confirm-delete__buttons').style.display = "flex";
    getAllProducts();
}


//#endregion

//#region ListenTo

const listenToAllDelete = function(){
    let delButtons = document.querySelectorAll('.js-delete');

    for (let button of delButtons){
        button.addEventListener('click', function(){
            let prodId = button.id.substring(0, button.id.length - 4);
            let prod = prodById(prodId);

            document.querySelector('.full-body').style.pointerEvents = "none";
            document.querySelector('.js-confirm-delete').style.pointerEvents = "all";
            document.querySelector('.js-confirm-delete').style.display = "block";
            document.querySelector('.js-confirm-delete-title').innerHTML = `Are you sure you want to delete ${prod.Name}?`

            listenToConfirmDelete(prodId);
        });
    }
}

const listenToConfirmDelete = function(prodId){
    let confirmDelete = document.querySelector('.js-confirm-delete-yes');
    let denyDelete = document.querySelector('.js-confirm-delete-no');

    confirmDelete.addEventListener('click', function(){
        document.querySelector('.c-confirm-delete__buttons').style.display = "none";
        document.querySelector('.js-confirm-delete-title').innerHTML = "Deleting product..."
        handleData(`http://192.168.1.225:5500/api/v1/product/${prodId}`, showDeleteConfirmed, 'DELETE');
    });

    denyDelete.addEventListener('click', function(){
        document.querySelector('.full-body').style.pointerEvents = "all";
        document.querySelector('.js-confirm-delete').style.display = "none";
        document.querySelector('.c-confirm-delete__buttons').style.display = "flex";
    });
}

//#endregion

//#region init

const init = function () {
    socket = io("http://192.168.1.225:5500");
    socket.emit("connected", "ProductPage Connected");

    socket.on("return_on_connect", function (msg) {
        console.log(msg);
    })

    getAllProducts();

};

document.addEventListener("DOMContentLoaded", function () {
    console.info("Productpage loaded");
    init();
});
//#endregion