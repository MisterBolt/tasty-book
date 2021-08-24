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

    i.innerHTML = data.replaceAll("FIELDSET_INDEX", Math.floor(100000 + Math.random() * 900000));
    i.querySelector("input[list]").value = ingredient;
    i.querySelector("input[step]").value = quantity;
    i.querySelector("select").selectedIndex = unit;

    i.querySelector(".delete").addEventListener("click", e=>{
        e.preventDefault()
        e.target.parentNode.parentNode.remove()
    })
});

document.querySelectorAll(".section").forEach(i => {
    let data = i.getAttribute("data_form");
    let title = i.getAttribute("data_title");
    let body = i.getAttribute("data_body");

    i.removeAttribute("data_form")
    i.removeAttribute("data_title")
    i.removeAttribute("data_body")

    i.innerHTML = data.replaceAll("FIELDSET_INDEX", Math.floor(100000 + Math.random() * 900000));
    i.querySelector("input").value = title;
    i.querySelector("textarea").value = body;

    i.querySelector(".delete").addEventListener("click", e=>{
        e.preventDefault()
        e.target.parentNode.parentNode.remove()
    })
});