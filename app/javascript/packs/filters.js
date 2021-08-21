let ingredients_list = document.getElementById("ingredients");
let categories_list = document.getElementById("categories");

document.querySelectorAll("a[data-prepend]").forEach(i=>{
    i.addEventListener("click", e=>{
        let fieldset = document.createElement("fieldset");
        fieldset.innerHTML = e.target.getAttribute("data-prepend");
        let type = e.target.getAttribute("data-type");
        fieldset.querySelector(".delete").addEventListener("click", e=>{deleteFromList(fieldset, type)})
        if(type == "ingredient"){
            ingredients_list.appendChild(fieldset);
        }else{
            categories_list.appendChild(fieldset);
        }
    })
})

function deleteFromList(fieldset, type){
    if(type == "ingredient"){
        ingredients_list.removeChild(fieldset);
    }else{
        categories_list.removeChild(fieldset);
    }
}