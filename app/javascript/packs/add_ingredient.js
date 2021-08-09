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
    
    let ingredientList = document.getElementById("ingredients");
    let ingredient = document.getElementById("recipe_ingredients_recipe_ingredient");
    let li = e.target.parentNode;

    //Delete ingredient from ingredients list
    ingredientList.removeChild(li);

    //Add select option
    Array.from(ingredient.options).forEach(i=>{
        if(i.value == li.getAttribute('ingredient_id')){
            i.style.display = 'block';
            if(ingredient.disabled == true){
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
    let unitStr = ingredientObj.unitName;
    if(ingredientObj.quantity > 1){
        unitStr = unitStr + "s";
    }
    newItem.innerHTML = ingredientObj.ingredientName + " " + ingredientObj.quantity + " " + unitStr;
    newItem.setAttribute("ingredient_id", ingredientObj.ingredient);
    let deleteButton = document.createElement('button');
    deleteButton.innerText = "X";
    deleteButton.addEventListener("click", e=>{deleteIngredient(e)})
    newItem.appendChild(deleteButton);
    ingredientList.appendChild(newItem);
}

function updateSelectOptions(){
    let ingredient = document.getElementById("recipe_ingredients_recipe_ingredient");  

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
    }
}

function currentState(){ 
    //Read current state and implement it
    let state = JSON.parse(document.getElementById("recipe_ingredients").value);
    state.forEach(ingr => {
        createIngredientItem(ingr);
        ingredients.push(ingr);
    })

    updateSelectOptions();
}

currentState();
addIngredient();