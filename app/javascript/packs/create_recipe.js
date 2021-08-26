document.querySelectorAll("a[data-form-prepend]").forEach(i => {
    i.addEventListener("click", e=>{
        e.preventDefault()
        let obj = document.createElement('fieldset')
        obj.innerHTML = i.getAttribute("data-form-prepend").replaceAll("FIELDSET_INDEX", Math.floor(100000 + Math.random() * 900000));
        obj.querySelector(".delete").addEventListener('click', e=>{
            e.preventDefault()
            e.target.parentNode.parentNode.remove()
        })
        i.parentNode.insertBefore(obj, i);
    })
})

document.querySelectorAll(".ingredient").forEach(i => {
    let data = i.getAttribute("data_form");
    let unit = i.getAttribute("data_unit");
    let quantity = i.getAttribute("data_quantity");
    let ingredient = i.getAttribute("data_ingredient");

    i.removeAttribute("data_form")
    i.removeAttribute("data_unit")
    i.removeAttribute("data_ingredient")
    i.removeAttribute("data_quantity")

    //If it's edit view assign real id to ingredient object
    let id = 0;
    let editView = false;
    if(i.hasAttribute("data_id")){
        editView = true;
        id = i.getAttribute("data_id");
        i.removeAttribute("data_id")
    }else{
        id = Math.floor(100000 + Math.random() * 900000);
    }

    i.innerHTML = data.replaceAll("FIELDSET_INDEX", id);
    i.querySelector("input[list]").value = ingredient;
    i.querySelector("input[step]").value = quantity;
    i.querySelector("select").selectedIndex = unit;

    i.querySelector(".delete").addEventListener("click", e=>{
        e.preventDefault()
        if(editView){
            i.querySelector("input[name='recipe[ingredients_recipes_attributes]["+ id +"][_destroy]']").value = 1;
            i.style.display = 'none';
        }else{
            e.target.parentNode.parentNode.remove()
        }
    })
});

document.querySelectorAll(".section").forEach(i => {
    let data = i.getAttribute("data_form");
    let title = i.getAttribute("data_title");
    let body = i.getAttribute("data_body");

    i.removeAttribute("data_form")
    i.removeAttribute("data_title")
    i.removeAttribute("data_body")

    //If it's edit view assign real id to section object
    let id = 0;
    let editView = false;
    if(i.hasAttribute("data_id")){
        editView = true;
        id = i.getAttribute("data_id");
        i.removeAttribute("data_id")
    }else{
        id = Math.floor(100000 + Math.random() * 900000);
    }

    i.innerHTML = data.replaceAll("FIELDSET_INDEX", id);
    i.querySelector(".section_id").value = id;
    i.querySelector("input[type='text']").value = title;
    i.querySelector("textarea").value = body;

    i.querySelector(".delete").addEventListener("click", e=>{
        e.preventDefault()
        if(editView){
            i.querySelector("input[name='recipe[sections_attributes]["+ id +"][_destroy]']").value = 1;
            i.style.display = 'none';
        }else{
            e.target.parentNode.parentNode.remove()
        }
    })
});