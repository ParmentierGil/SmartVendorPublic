let socket;

let allProducts;

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

const getAllProducts = function () {
    handleData(`${IP}/api/v1/products`, showAllProducts);
}


//#endregion

//#region show

const showAllProducts = function (products) {
    console.log(products)
    allProducts = products;
    prodHTML = "";

    for (prod of products) {
        let number = prod.NumberInVendingMachine

        if (prod.NumberInVendingMachine == null) {
            number = " "
        }

        prodHTML += `<div class="c-list-entry" id="${prod.ProductId}-prod">
        <div class="c-list-entry__name">${prod.Name}</div>
        <div class="c-list-entry__price">€${prod.Price}</div>
        <div class="c-list-entry__number">${number}</div>
        <div class="c-list-entry__actions">
            <button class="c-list-entry__actions-edit js-edit" id="${prod.ProductId}-edit">
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
        <div class="c-list-entry-divider"></div>
        <div class="c-list-entry-edit-container" id="${prod.ProductId}-edit-cont">
                        <h2 class="c-list-entry-edit__title">Edit Product</h2>
                        <div class="c-list-entry-edit__name">
                            <label class="c-list-entry-edit-label" for="product-name">Name</label>
                            <input class="c-list-entry-edit-input" type="text" id="${prod.ProductId}-product-name" placeholder="${prod.Name}"/>
                        </div>
                        <div class="c-list-entry-edit__price">
                            <label class="c-list-entry-edit-label" for="product-price">Price</label>
                            <input class="c-list-entry-edit-input" type="number" id="${prod.ProductId}-product-price" placeholder="${prod.Price}"/>
                        </div>
                        <div class="c-list-entry-edit__stock">
                            <label class="c-list-entry-edit-label" for="product-stock">Stock Count</label>
                            <input class="c-list-entry-edit-input" type="number" id="${prod.ProductId}-product-stock" placeholder="${prod.StockCount}"/>
                        </div>
                        <div class="c-list-entry-edit__number">
                            <label class="c-list-entry-edit-label" for="product-number">Number</label>
                            <select class="c-list-entry-edit-input c-list-entry-edit-input--select" id="${prod.ProductId}-product-number">
                                <option selected>None</option>
                                <option>1 (Top Left)</option>
                                <option>2 (Top Right)</option>
                                <option>3 (Bottom Left)</option>
                                <option>4 (Bottom Right)</option>
                            </select>
                        </div>
                        <div class="c-list-entry-edit__buttons">
                            <button class="c-list-entry-edit__button--confirm" id="${prod.ProductId}-edit-save">Save Product</button>
                            <button class="c-list-entry-edit__button--cancel" id="${prod.ProductId}-edit-cancel">Cancel</button>
                        </div>                      
                    </div>`
    }
    document.querySelector('.c-list-entry-container').innerHTML = prodHTML;

    listenToAllDelete();
    listenToAllEdit();
}

const showDeleteConfirmed = async function (returned) {
    console.log(returned);
    document.querySelector('.js-confirm-delete-title').innerHTML = "Product deleted"
    await sleep(2000);
    document.querySelector('.full-body').style.pointerEvents = "all";
    document.querySelector('.js-confirm-delete').style.display = "none";
    document.querySelector('.c-confirm-delete__buttons').style.display = "flex";
    getAllProducts();
}

const showProductSaved = async function (prodId) {
    console.log(prodId)
    document.getElementById(`${prodId}-edit-cont`).style.display = "none";
    document.getElementById(`${prodId}-product-name`).value = "";
    document.getElementById(`${prodId}-product-price`).value = "";
    document.getElementById(`${prodId}-product-stock`).value = "";
    document.querySelector('.c-status-message').innerHTML = "Product Saved";
    getAllProducts();
    await sleep(3000);
    document.querySelector('.c-status-message').innerHTML = "";
}

//#endregion

//#region ListenTo

const listenToAllDelete = function () {
    let delButtons = document.querySelectorAll('.js-delete');

    for (let button of delButtons) {
        button.addEventListener('click', function () {
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

const listenToAllEdit = function () {
    let editButtons = document.querySelectorAll('.js-edit');

    for (let button of editButtons) {
        button.addEventListener('click', function () {
            let prodId = button.id.substring(0, button.id.length - 5);
            let prod = prodById(prodId);

            document.getElementById(`${prodId}-edit-cont`).style.display = "flex";

            document.getElementById(`${prodId}-edit-save`).addEventListener('click', function () {
                let product = {};
                product['ProductId'] = prodId;
                product['Name'] = document.getElementById(`${prodId}-product-name`).value;
                product['Price'] = document.getElementById(`${prodId}-product-price`).value;
                product['StockCount'] = document.getElementById(`${prodId}-product-stock`).value;
                product['NumberInVendingMachine'] = document.getElementById(`${prodId}-product-number`).value.substr(0, 1);

                if (product.Name == "") {
                    product.Name = document.getElementById(`${prodId}-product-name`).placeholder;
                }
                if (product.Price == "" || Number(product.Price) <= 0) {
                    product.Price = document.getElementById(`${prodId}-product-price`).placeholder;
                }
                if (product.StockCount == "") {
                    product.StockCount = document.getElementById(`${prodId}-product-stock`).placeholder;
                }
                if (product.NumberInVendingMachine == "N") {
                    product.NumberInVendingMachine = null;
                }
                console.log(product)
                var jsonString = JSON.stringify(product);
                handleData(`${IP}/api/v1/product/${prodId}`, showProductSaved, 'PUT', jsonString);
            })

            document.getElementById(`${prodId}-edit-cancel`).addEventListener('click', function () {
                document.getElementById(`${prodId}-edit-cont`).style.display = "none";
                document.getElementById(`${prodId}-product-name`).value = "";
                document.getElementById(`${prodId}-product-price`).value = "";
                document.getElementById(`${prodId}-product-stock`).value = "";
            })
        })
    }

}

const listenToConfirmDelete = function (prodId) {
    let confirmDelete = document.querySelector('.js-confirm-delete-yes');
    let denyDelete = document.querySelector('.js-confirm-delete-no');

    confirmDelete.addEventListener('click', function () {
        document.querySelector('.c-confirm-delete__buttons').style.display = "none";
        document.querySelector('.js-confirm-delete-title').innerHTML = "Deleting product..."
        handleData(`${IP}/api/v1/product/${prodId}`, showDeleteConfirmed, 'DELETE');
    });

    denyDelete.addEventListener('click', function () {
        document.querySelector('.full-body').style.pointerEvents = "all";
        document.querySelector('.js-confirm-delete').style.display = "none";
        document.querySelector('.c-confirm-delete__buttons').style.display = "flex";
    });
}

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
    socket.emit("connected", "ProductPage Connected");

    socket.on("return_on_connect", function (msg) {
        console.log(msg);
    })

    getAllProducts();
    listenToOpenMenu();
    listenToCloseMenu();
};

document.addEventListener("DOMContentLoaded", function () {
    console.info("Productpage loaded");
    init();
});
//#endregion