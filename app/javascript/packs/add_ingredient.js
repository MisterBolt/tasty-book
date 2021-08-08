const ingredients = [];

function addIngredient(){
    const submit = document.getElementById("add_ingredient");
    const ingredientList = document.getElementById("ingredients");

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
        let newItem = document.createElement("li");
        let unitStr = ingredientSet.unitName;
        if(quantity.value > 1){
            unitStr = unitStr + "s";
        }
        newItem.innerHTML = ingredientSet.ingredientName + " " + quantity.value + " " + unitStr;
        newItem.setAttribute("ingredient_id", ingredient.value);
        let deleteButton = document.createElement('button');
        deleteButton.innerText = "X";
        deleteButton.addEventListener("click", e=>{deleteIngredient(e)})
        newItem.appendChild(deleteButton);
        ingredientList.appendChild(newItem);

        //Delete ingredient from ingredient
        let childCount = ingredient.childElementCount;
        ingredient.childNodes.forEach(item=>{
            if(ingredients.some(i => i.ingredient == item.value)){
                item.style.display = "none";
                childCount--;
            }
        })
        ingredient.value = "";
        if(childCount == 0){
            ingredient.disabled = true;
        }
        updateInputValueWithJSON();
    })

}

function deleteIngredient(e){
    e.preventDefault();
    
    const ingredientList = document.getElementById("ingredients");
    const ingredient = document.getElementById("recipe_ingredients_recipe_ingredient");
    const li = e.target.parentNode;

    //Delete ingredient from ingredients list
    ingredientList.removeChild(li);

    //Add select option
    ingredient.childNodes.forEach(i=>{
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

function currentState(){
    const state = JSON.parse(document.getElementById("recipe_ingredients").value);
    console.log(state);

}

currentState();
addIngredient();