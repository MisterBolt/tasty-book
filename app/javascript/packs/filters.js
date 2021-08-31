let ingredients_list = document.getElementById("ingredients");
let categories_list = document.getElementById("categories");
let closeBtn = document.getElementById("cancel");
let myBooks = document.getElementById("btn_filter_selector1");
let all = document.getElementById("btn_filter_selector2");
let scopes = document.querySelectorAll("input[name='filters[my_books]'");
let current_scope = scopes[0].value;

document.querySelectorAll("a[data-prepend]").forEach(i=>{
    i.addEventListener("click", e=>{
        let fieldset = document.createElement("fieldset");
        fieldset.innerHTML = e.target.getAttribute("data-prepend");
        let type = e.target.getAttribute("data-type");
        fieldset.querySelector(".delete").addEventListener("click", e => {e.target.parentNode.remove()})
        if(type == "ingredient"){
            ingredients_list.appendChild(fieldset);
        }else{
            categories_list.appendChild(fieldset);
        }
    })
})

document.querySelectorAll(".delete").forEach(i => {
    i.addEventListener("click", e => {
        e.target.parentNode.remove()
    })
})

closeBtn.addEventListener('click', e => {
    toggleDisplay('filters','block'); 
    toggleColor('btn_filter');
})

if(myBooks){
    myBooks.addEventListener("click", e => {
        if(current_scope == 1){
            return
        }
        toggleColor('btn_filter_selector1'); 
        toggleColor('btn_filter_selector2',from = 'bg-yellow-200', to = 'bg-white');
        scopes.forEach(i=>{
            i.value = 1;
        })
        current_scope = 1;
    })
}

if(all){
    all.addEventListener("click", e => {
        if(current_scope == 0){
            return
        }
        toggleColor('btn_filter_selector2',from = 'bg-yellow-200', to = 'bg-white');
        toggleColor('btn_filter_selector1');
        scopes.forEach(i=>{
            i.value = 0;
        })
        current_scope = 0;
    })
}

//sorting recipes js:
let form = document.getElementById("filters");

document.getElementById("order").addEventListener("change", e => {
    document.getElementById("filters_order").value = e.target.value;
    form.submit();
})

document.getElementById("kind").addEventListener("change", e => {
    document.getElementById("filters_kind").value = e.target.value;
    form.submit();
})

document.getElementById("clear_filters").addEventListener("click", e => {
    ingredients_list.innerHTML = "";
    categories_list.innerHTML = "";
    document.getElementById("filters_time_all").checked = true;
    document.querySelectorAll("input[name='filters[difficulties][]']").forEach(i => {
        i.checked = false;
    })
})