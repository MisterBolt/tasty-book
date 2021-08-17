document.querySelectorAll("a[data-form-prepend]").forEach(i => {
    i.addEventListener("click", e=>{
        e.preventDefault()
        let obj = document.createElement('fieldset')
        let newIndex = new Date().getTime()
        obj.innerHTML = i.getAttribute("data-form-prepend").replaceAll("FIELDSET_INDEX", newIndex);
        obj.querySelector(".delete-ingredient").addEventListener('click', e=>{
            e.preventDefault()
            e.target.parentNode.style.display = 'none';
            e.target.parentNode.querySelector(".destroy_flag").value = '1';
        })
        i.parentNode.insertBefore(obj, i);
    })
})

document.querySelectorAll("fieldset[data_form]").forEach(i => {
    let data = i.getAttribute("data_form");
    let unit = i.getAttribute('data_unit');
    let quantity = i.getAttribute("data_quantity");
    let ingredient = i.getAttribute("data_ingredient");

    i.removeAttribute("data_form")
    i.removeAttribute("data_unit")
    i.removeAttribute("data_ingredient")
    i.removeAttribute("data_quantity")

    let newIndex = new Date().getTime()
    i.innerHTML = data.replaceAll("FIELDSET_INDEX", newIndex);
    i.querySelector("input[list]").value = ingredient;
    i.querySelector("input[step]").value = quantity;
    i.querySelector("select").selectedIndex = unit;

    i.querySelector(".delete-ingredient").addEventListener('click', e=>{
        e.preventDefault()
        e.target.parentNode.style.display = 'none';
        e.target.parentNode.querySelector(".destroy_flag").value = '1';
    })
});
