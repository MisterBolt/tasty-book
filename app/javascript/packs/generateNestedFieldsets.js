document.querySelectorAll("a[data-form-prepend]").forEach(i => {
    i.addEventListener("click", e=>{
        e.preventDefault()
        let obj = document.createElement("fieldset")
        obj.innerHTML = i.getAttribute("data-form-prepend").replaceAll("FIELDSET_INDEX", e.target.parentNode.childElementCount);
        obj.querySelector(".delete").addEventListener("click", e=>{
            e.preventDefault()
            e.target.parentNode.parentNode.remove()
        })
        i.parentNode.insertBefore(obj, i);
    })
})