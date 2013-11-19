var total = 37090.0;
var width = 780,
height = 600,
radius = Math.min(width, height) / 2;

var color = d3.scale.ordinal()
.range(["#98abc5", "#8a89a6", "#7b6888", "#6b486b", "#a05d56", "#d0743c", "#ff8c00"]);

var arc = d3.svg.arc()
.outerRadius(radius - 10)
.innerRadius(0);

var pie = d3.layout.pie()
.sort(null)
.value(function(d) { return d.posts; });

var svg_pie = d3.select("#pie").append("svg")
.attr("width", width)
.attr("height", height)
.append("g")
.attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

d3.csv("piedata.csv", function(error, data) {

  data.forEach(function(d) {
    d.posts = +d.posts;
  });

  var g = svg_pie.selectAll(".arc")
  .data(pie(data))
  .enter().append("g")
  .attr("class", "arc");

  g.append("path")
  .attr("d", arc)
  .style("fill", function(d) { return color(d.data.user); });

  g.append("text")
  .attr("transform", function(d) { return "translate(" + arc.centroid(d) +  ')'; })
  .attr("dy", ".35em")
  .style("text-anchor", "middle")
  .text(function(d) { 
    if ((d.data.posts / total)> 0.039)
      return d.data.user; 
    else return '';
  });
});
