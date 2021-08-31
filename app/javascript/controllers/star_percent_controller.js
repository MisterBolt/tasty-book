import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["stop1", "stop2"]
  connect() {
    if (typeof gon != "undefined") {
      let score = gon.avgScore;
      let decimal = score % 1;
      let percent = (decimal * 100)+"%";
      this.stop1Target.setAttribute("offset", percent);
      this.stop2Target.setAttribute("offset", percent);
    }
  }
}