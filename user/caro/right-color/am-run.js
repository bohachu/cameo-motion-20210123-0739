/**
 * ---------------------------------------
 * This demo was created using amCharts 4.
 *
 * For more information visit:
 * https://www.amcharts.com/
 *
 * Documentation is available at:
 * https://www.amcharts.com/docs/v4/
 * ---------------------------------------
 */

// Themes begin
am4core.useTheme(am4themes_animated);
// Themes end

var insterfaceColors = new am4core.InterfaceColorSet();
var lineColor = insterfaceColors.getFor("background");

var chart = am4core.create("chartdiv-run", am4plugins_timeline.CurveChart);
chart.curveContainer.padding(50, 50, 50, 50);

// watermark
var watermark = chart.createChild(am4core.Label);
watermark.text = "資料來源: 工研院產科國際所[/]";
watermark.fontSize = 10;
watermark.align = "right";
watermark.valign = "bottom";
// watermark.paddingRight = 10;
watermark.fillOpacity = 0.5;

chart.data = [
  {
    name: "電腦電子及光學製品(含零組件)",
    file: "img/run-icon/lcd.png",
    track: 1,
    value: 39.3
  },
  {
    name: "食品飲料及煙草",
    file: "img/run-icon/lcd.png",
    track: 2,
    value: 35.1
  },
  {
    name: "其他製品與機器修配",
    file: "img/run-icon/electronic.png",
    track: 3,
    value: 31.6
  },
  {
    name: "塑像膠與非金屬礦物製品",
    file: "img/run-icon/machine.png",
    track: 4,
    value: 30.1
  },
  {
    name: "電力設備",
    file: "img/run-icon/cpu.png",
    track: 5,
    value: 28.1
  },
  {
    name: "紡織品",
    file: "img/run-icon/petrochemical.png",
    track: 6,
    value: 27.5
  }
  // {
  //   name: "機械設備",
  //   file: "img/run-icon/machine.png",
  //   track: 7,
  //   value: 25.9
  // },
  // {
  //   name: "交通運輸工具",
  //   file: "img/run-icon/car.png",
  //   track: 8,
  //   value: 26.4
  // },
  // {
  //   name: "紙漿及紙製品",
  //   file: "img/run-icon/car.png",
  //   track: 9,
  //   value: 22.7
  // },
  // {
  //   name: "基本金屬及製品",
  //   file: "img/run-icon/electronic.png",
  //   track: 10,
  //   value: 19.3
  // },
  // {
  //   name: "石油及媒製品",
  //   file: "img/run-icon/petrochemical.png",
  //   track: 11,
  //   value: 18.0
  // },
  // {
  //   name: "化學材料與製品",
  //   file: "img/run-icon/cpu.png",
  //   track: 12,
  //   value: 16.1
  // },
];
draw_on_browser();

function draw_on_browser() {
  var categoryAxis = chart.yAxes.push(new am4charts.CategoryAxis());
  categoryAxis.dataFields.category = "name";
  categoryAxis.renderer.minGridDistance = 10;
  categoryAxis.renderer.innerRadius = 20;
  categoryAxis.renderer.radius = 145;
  categoryAxis.renderer.line.stroke = lineColor;
  categoryAxis.renderer.line.strokeWidth = 5;
  categoryAxis.renderer.line.strokeOpacity = 1;

  var labelTemplate = categoryAxis.renderer.labels.template;
  labelTemplate.fill = lineColor;
  labelTemplate.fontWeight = 400;
  labelTemplate.fontSize = 10;

  var gridTemplate = categoryAxis.renderer.grid.template;
  gridTemplate.strokeWidth = 1;
  gridTemplate.strokeOpacity = 1;
  gridTemplate.stroke = lineColor;
  gridTemplate.location = 0;
  gridTemplate.above = true;

  var fillTemplate = categoryAxis.renderer.axisFills.template;
  fillTemplate.disabled = false;
  fillTemplate.fill = am4core.color("#31AFA0");
  fillTemplate.fillOpacity = 1;

  categoryAxis.fillRule = function (dataItem) {
    dataItem.axisFill.__disabled = false;
    dataItem.axisFill.opacity = 1;
  };

  var valueAxis = chart.xAxes.push(new am4charts.ValueAxis());
  valueAxis.min = 0;
  valueAxis.max = 100;
  valueAxis.renderer.points = [
    { x: 0, y: -100 },
    { x: 200, y: -100 },
    { x: 200, y: 100 },
    { x: 0, y: 100 },
    {
      x: -200,
      y: 100
    },
    { x: -200, y: -100 },
    { x: 0, y: -100 }
  ];
  valueAxis.renderer.polyspline.tensionX = 0.4;
  valueAxis.renderer.line.strokeOpacity = 0.1;
  valueAxis.renderer.line.strokeWidth = 10;
  valueAxis.renderer.maxLabelPosition = 0.98;
  valueAxis.renderer.minLabelPosition = 0.02;

  // Flag bullet
  var flagRange = valueAxis.axisRanges.create();
  flagRange.value = 0;
  var flagBullet = new am4plugins_bullets.FlagBullet();
  flagBullet.label.text = "START";
  flagRange.bullet = flagBullet;
  //flagBullet.dy = -145;
  flagBullet.adapter.add("dy", function (dy, target) {
    return -categoryAxis.renderer.radius;
  });

  var valueLabelTemplate = valueAxis.renderer.labels.template;
  valueLabelTemplate.fill = lineColor;
  valueLabelTemplate.fontSize = 8;
  valueLabelTemplate.fontWeight = 400;
  valueLabelTemplate.fillOpacity = 1;
  valueLabelTemplate.horizontalCenter = "right";
  valueLabelTemplate.verticalCenter = "bottom";
  valueLabelTemplate.padding(0, 10, 0, 0);
  valueLabelTemplate.adapter.add("rotation", function (rotation, target) {
    var value = target.dataItem.value;
    var position = valueAxis.valueToPosition(value);

    var angle = valueAxis.renderer.positionToAngle(position);
    return angle;
  });

  var valueGridTemplate = valueAxis.renderer.grid.template;
  valueGridTemplate.strokeOpacity = 0.3;
  valueGridTemplate.stroke = lineColor;

  // SERIES
  var series = chart.series.push(new am4plugins_timeline.CurveColumnSeries());
  series.dataFields.categoryY = "name";
  series.stroke = lineColor;
  series.fill = lineColor;
  series.dataFields.valueX = "value";
  series.defaultState.transitionDuration = 4000;

  var columnTemplate = series.columns.template;
  columnTemplate.fill = lineColor;
  columnTemplate.strokeOpacity = 0;
  columnTemplate.fillOpacity = 0.3;
  columnTemplate.height = am4core.percent(100);

  var hoverState = columnTemplate.states.create("hover");
  hoverState.properties.fillOpacity = 0.9;

  var bullet = series.bullets.push(new am4charts.CircleBullet());
  bullet.fill = lineColor;

  // LEGEND
  chart.legend = new am4charts.Legend();
  chart.legend.data = chart.data;
  chart.legend.parent = chart.curveContainer;
  chart.legend.width = 350;
  chart.legend.horizontalCenter = "middle";
  chart.legend.verticalCenter = "middle";
  chart.legend.fontSize = 10;

  var markerTemplate = chart.legend.markers.template;
  markerTemplate.width = 20;
  markerTemplate.height = 20;

  chart.legend.itemContainers.template.events.on("over", function (event) {
    series.dataItems.each(function (dataItem) {
      if (dataItem.dataContext == event.target.dataItem.dataContext) {
        dataItem.column.isHover = true;
      } else {
        dataItem.column.isHover = false;
      }
    });
  });

  chart.legend.itemContainers.template.events.on("hit", function (event) {
    series.dataItems.each(function (dataItem) {
      if (dataItem.dataContext == event.target.dataItem.dataContext) {
        if (dataItem.visible) {
          dataItem.hide(1000, 0, 0, ["valueX"]);
        } else {
          dataItem.show(1000, 0, ["valueX"]);
        }
      }
    });
  });

  var rect = markerTemplate.children.getIndex(0);
  rect.cornerRadius(20, 20, 20, 20);

  var as = markerTemplate.states.create("active");
  as.properties.opacity = 0.5;

  var image = markerTemplate.createChild(am4core.Image);
  image.propertyFields.href = "file";
  image.width = 20;
  image.height = 20;
  image.filters.push(new am4core.DesaturateFilter());

  image.events.on("inited", function (event) {
    var image = event.target;
    var parent = image.parent;
    image.mask = parent.children.getIndex(0);
  });
}
