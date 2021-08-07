function add_ingredient(){
    const submit = document.getElementById("add_ingredient");
    submit.addEventListener('click', e=>{
        e.preventDefault();
        console.log(e)
    })
}

window.onload = add_ingredient;