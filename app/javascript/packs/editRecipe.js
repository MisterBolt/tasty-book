let btns = document.querySelectorAll(".delete");
if(btns.length > 0){
    btns.forEach(i => {
        i.addEventListener("click", e=>{
            e.preventDefault()
            e.target.parentNode.style.display = "none";
            e.target.parentNode.querySelector(".destroy").value = 1;
        })
    })
}