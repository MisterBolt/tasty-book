fillPercent = () => {
  let score = gon.avgScore;
  let decimal = score % 1;
  let percent = (decimal * 100)+"%";
  document.getElementById('stop1').setAttribute("offset", percent);
  document.getElementById('stop1').setAttribute("offset", percent);
}
