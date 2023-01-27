function changePage(btn_pressed) {
    document.getElementsByClassName('nav-btn active')[0].classList.remove('active')
    document.getElementsByClassName('right-container active')[0].classList.remove('active')
    
    document.getElementById(btn_pressed).classList.add('active')
    document.getElementById(btn_pressed.split("-")[0] + "-page").classList.add('active')
}

var navBtns = document.getElementsByClassName("nav-btn");

for (let item of navBtns) {
    item.addEventListener("click", () => {changePage(item.id)})
};

var transferModal = document.getElementById("transfer-modal")
var transferBtns = document.getElementsByClassName("new-transfer");

// for (let btn of transferBtns) {
//     btn.addEventListener("click", function() {
//         console.log("transfer btn pressed")
//         transferModal.showModal();
//     })
// }

document.getElementsByClassName("manage-account")[0].addEventListener("click", function() {
    console.log("button pressed")
    document.getElementById("manage-account-modal").showModal();
})