import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "ingredients_content", "method_content", "comments_content",
    "ingredients_button" , "method_button", "comments_button"]
  ingredients () {
    this.ingredients_buttonTarget.classList.add("selected")
    this.method_buttonTarget.classList.remove("selected")
    this.comments_buttonTarget.classList.remove("selected")
    this.ingredients_contentTarget.classList.remove("hidden")
    this.method_contentTarget.classList.add("hidden")
    this.comments_contentTarget.classList.add("hidden")
  }
  method () {
    this.ingredients_buttonTarget.classList.remove("selected")
    this.method_buttonTarget.classList.add("selected")
    this.comments_buttonTarget.classList.remove("selected")
    this.ingredients_contentTarget.classList.add("hidden")
    this.method_contentTarget.classList.remove("hidden")
    this.comments_contentTarget.classList.add("hidden")
  }
  comments () {
    this.ingredients_buttonTarget.classList.remove("selected")
    this.method_buttonTarget.classList.remove("selected")
    this.comments_buttonTarget.classList.add("selected")
    this.ingredients_contentTarget.classList.add("hidden")
    this.method_contentTarget.classList.add("hidden")
    this.comments_contentTarget.classList.remove("hidden")
  }
}