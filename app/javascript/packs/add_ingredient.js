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
