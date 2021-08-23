let ingredients_list = document.getElementById("ingredients");
let categories_list = document.getElementById("categories");
let closeBtn = document.getElementById("cancel");
let myBooks = document.getElementById("btn_filter_selector1");
let all = document.getElementById("btn_filter_selector2");
let scopes = document.querySelectorAll("input[name='query[my_books]']");
let current_scope = 'all';

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

closeBtn.addEventListener('click', e => {
    toggleDisplay('filters','block'); 
    toggleColor('btn_filter');
})

function deleteFromList(fieldset, type){
    if(type == "ingredient"){
        ingredients_list.removeChild(fieldset);
    }else{
        categories_list.removeChild(fieldset);
    }
}

myBooks.addEventListener("click", e => {
    if(current_scope == "my_books"){
        return
    }
    toggleColor('btn_filter_selector1'); 
    toggleColor('btn_filter_selector2',from = 'bg-yellow-200', to = 'bg-white');
    scopes.forEach(i=>{
        i.value = 1;
    })
    current_scope = "my_books";
})

all.addEventListener("click", e => {
    if(current_scope == "all"){
        return
    }
    toggleColor('btn_filter_selector2',from = 'bg-yellow-200', to = 'bg-white');
    toggleColor('btn_filter_selector1');
    scopes.forEach(i=>{
        i.value = 0;
    })
    current_scope = 'all';
})