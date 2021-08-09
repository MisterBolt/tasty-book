const ingredients = [];

function addIngredient(){
    const submit = document.getElementById("add_ingredient");

    const ingredient = document.getElementById("recipe_ingredients_recipe_ingredient");  
    const unit = document.getElementById("recipe_ingredients_recipe_unit");
    const quantity = document.getElementById("recipe_ingredients_recipe_quantity");

    submit.addEventListener('click', e=>{
        e.preventDefault();
        
        if(ingredient.value == "" || quantity.value == ""){
            return
        }

        //Write values to main array
        let ingredientSet = {
            ingredient: parseInt(ingredient.value),
            ingredientName: ingredient[ingredient.selectedIndex].text,
            unit: parseInt(unit.value),
            unitName: unit[unit.selectedIndex].text,
            quantity: parseFloat(quantity.value)
        }
        ingredients.push(ingredientSet);

        //Add DOM element for added ingredient
        createIngredientItem(ingredientSet);

        //Delete ingredient from ingredient
        updateSelectOptions();

        updateInputValueWithJSON();
    })

}

function deleteIngredient(e){
    e.preventDefault();
    
    let submit = document.getElementById("add_ingredient");
    let ingredientList = document.getElementById("ingredients");
    let ingredient = document.getElementById("recipe_ingredients_recipe_ingredient");
    let li = e.target.parentNode;

    //Delete ingredient from ingredients list
    ingredientList.removeChild(li);

    if(ingredientList.childElementCount == 0){
        let p = document.createElement("p");
        p.innerText = "There are no ingredients";
        ingredientList.appendChild(p);
    }

    //Add select option
    Array.from(ingredient.options).forEach(i=>{
        if(i.value == li.getAttribute('ingredient_id')){
            i.style.display = 'block';
            if(ingredient.disabled == true){
                submit.classList.remove('cursor-not-allowed');
                ingredient.disabled = false
            }
        }
    })

    //Update JSON 
    let id = li.getAttribute("ingredient_id");
    for(let i=0;i<ingredients.length;i++){
        if(ingredients[i].ingredient == id){
            ingredients.splice(i,1);
        }
    }

    updateInputValueWithJSON();
}

function updateInputValueWithJSON(){
    let hiddenInput = document.getElementById("recipe_ingredients");
    let json = JSON.stringify(ingredients);
    hiddenInput.value = json;
}

function createIngredientItem(ingredientObj){
    let ingredientList = document.getElementById("ingredients");

    let newItem = document.createElement("li");
    newItem.setAttribute("class", "space-x-2 justify-center");
    let unitStr = ingredientObj.unitName;
    if(ingredientObj.quantity > 1){
        unitStr = unitStr + "s";
    }
    //Ingredient name
    let ingredientSpan = document.createElement("span")
    ingredientSpan.innerText = ingredientObj.ingredientName;
    newItem.appendChild(ingredientSpan);
    //Qunatity + unit
    let qunatitySpan = document.createElement("span");
    qunatitySpan.innerText = ingredientObj.quantity + " " + unitStr;
    newItem.appendChild(qunatitySpan);

    newItem.setAttribute("ingredient_id", ingredientObj.ingredient);
    //Delete button
    let deleteButton = document.createElement('button');
    deleteButton.innerText = "X";
    deleteButton.setAttribute('class', "bg-red-500 hover:bg-red-400 text-white font-bold px-2 border-b-4 border-red-700 hover:border-red-500 rounded")
    deleteButton.addEventListener("click", e=>{deleteIngredient(e)})
    newItem.appendChild(deleteButton);

    if(ingredientList.childElementCount == 1 && ingredientList.firstChild.nodeName == 'P'){
        ingredientList.innerHTML = "";
    }

    ingredientList.appendChild(newItem);
}

function updateSelectOptions(){
    let ingredient = document.getElementById("recipe_ingredients_recipe_ingredient");  
    let submit = document.getElementById("add_ingredient");

    let childCount = ingredient.childElementCount;
    Array.from(ingredient.options).forEach(item=>{
        if(ingredients.some(i => i.ingredient == item.value)){
            item.style.display = "none";
            childCount--;
        }
    })
    ingredient.value = "";
    if(childCount == 0){
        ingredient.disabled = true;
        submit.classList.add('cursor-not-allowed');
    }
}

function currentState(){ 
    //Read current state and implement it
    let ingredientList = document.getElementById("ingredients");
    let state = JSON.parse(document.getElementById("recipe_ingredients").value);
    if(state.length == 0){
        let p = document.createElement("p");
        p.innerText = "There are no ingredients";
        ingredientList.appendChild(p);
    }
    
    state.forEach(ingr => {
        createIngredientItem(ingr);
        ingredients.push(ingr);
    })

    updateSelectOptions();
}

currentState();
addIngredient();