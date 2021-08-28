import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["modalCard"];

  close () {
    this.modalCardTarget.classList.add('hidden') 
  }
}
