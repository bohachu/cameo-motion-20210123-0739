import dfjs from "https://jspm.dev/dataframe-js";
// import { load_js_async, load_css } from "../cameo-common/cameo-load.js";

class CameoRun extends HTMLElement {
  connectedCallback() {
    this.str_random_id = "id_" + Math.random().toString(36).substr(2, 9);
    this.innerHTML = `
          <div class="cameo-run" id="${this.str_random_id}" 
            style="width: 100%; height: 600px;"></div>
        `;
    this.chart_render();
  }

  //2020-12-06 todo bowen 一週之內要放入共用 common
  async load_df(str_attribute) {
    const str_path = this.getAttribute(str_attribute);
    const str_url = `${window.location.href}/../${str_path}`;
    return await dfjs.DataFrame.fromCSV(str_url);
  }
  //2020-12-06 todo bowen 一週之內要放入共用 common
  async load_ary_data() {
    let df = await this.load_df("data");
    df = df.transpose();
    const ary = df.toArray();
    return ary;
  }
  //2020-12-06 todo bowen 一週之內要放入共用 common
  async load_dic_meta() {
    const df = await this.load_df("meta");
    const ary_df = df.toArray();
    let dic_meta = {};
    for (let i = 0; i < ary_df.length; i++) {
      let str_key = ary_df[i][0];
      let str_value = ary_df[i][1];
      dic_meta[str_key] = str_value;
    }
    return dic_meta;
  }
  //2020-12-06 caro 專屬於本動圖的解析程式碼
  parse_ary_icon_file(dic_meta) {
    let ary_icon_file = [];
    for (let str_key in dic_meta) {
      if (str_key.includes("圖示_")) {
        ary_icon_file.push(dic_meta[str_key]);
      }
    }
    return ary_icon_file;
  }
  //2020-12-06 caro 專屬於本動圖的解析程式碼
  parse_ary_chart_data(ary_data, ary_icon_file) {
    let ary_chart_data = [];
    for (let i = 0; i < ary_data[0].length; i++) {
      let dic_data = {};
      dic_data["name"] = ary_data[0][i];
      dic_data["file"] = ary_icon_file[i];
      dic_data["track"] = i + 1;
      dic_data["value"] = parseFloat(ary_data[1][i]);
      ary_chart_data.push(dic_data);
    }
    return ary_chart_data;
  }

  async chart_render() {
    //2020-12-06 caro 專屬於本動圖的：總資料準備
    const ary_data = await this.load_ary_data();
    const dic_meta = await this.load_dic_meta();
    const ary_icon_file = this.parse_ary_icon_file(dic_meta);
    const ary_chart_data = this.parse_ary_chart_data(ary_data, ary_icon_file);
    document
      .getElementById(this.str_random_id)
      .setAttribute("style", `width: 100%; height: ${dic_meta["圖表高度"]}px;`);

    // Themes begin
    am4core.useTheme(am4themes_animated);
    // Themes end

    var insterfaceColors = new am4core.InterfaceColorSet();
    var lineColor = insterfaceColors.getFor("background");

    var chart = am4core.create(
      this.str_random_id,
      am4plugins_timeline.CurveChart
    );
    this.chart = chart;
    chart.curveContainer.padding(50, 50, 50, 50);

    // Export
    chart.exporting.menu = new am4core.ExportMenu();
    chart.exporting.filePrefix = dic_meta["圖表下載檔名"];
    chart.exporting.useWebFonts = false;
    chart.exporting.menu.items = [
      {
        label: "...",
        menu: [
          {
            label: "Image",
            menu: [
              { type: "png", label: "PNG" },
              { type: "jpg", label: "JPG" },
              { type: "svg", label: "SVG" },
              { type: "pdf", label: "PDF" }
            ]
          },
          {
            label: "Print",
            type: "print"
          }
        ]
      }
    ];
    // watermark
    var watermark = chart.createChild(am4core.Label);
    watermark.text = dic_meta["資料來源"];
    watermark.fontSize = 10;
    watermark.align = "right";
    watermark.valign = "bottom";
    // watermark.paddingRight = 10;
    watermark.fillOpacity = 0.5;

    chart.data = ary_chart_data;
    // [
    //   {
    //     name: "電腦電子及光學製品(含零組件)",
    //     file: "img/lcd.png",
    //     track: 1,
    //     value: 39.3
    //   },
    //   {
    //     name: "食品飲料及煙草",
    //     file: "img/lcd.png",
    //     track: 2,
    //     value: 35.1
    //   },
    //   {
    //     name: "其他製品與機器修配",
    //     file: "img/electronic.png",
    //     track: 3,
    //     value: 31.6
    //   },
    //   {
    //     name: "塑像膠與非金屬礦物製品",
    //     file: "img/machine.png",
    //     track: 4,
    //     value: 30.1
    //   },
    //   {
    //     name: "電力設備",
    //     file: "img/run-icon/cpu.png",
    //     track: 5,
    //     value: 28.1
    //   },
    //   {
    //     name: "紡織品",
    //     file: "img/petrochemical.png",
    //     track: 6,
    //     value: 27.5
    //   }
    //   // {
    //   //   name: "機械設備",
    //   //   file: "img/machine.png",
    //   //   track: 7,
    //   //   value: 25.9
    //   // },
    //   // {
    //   //   name: "交通運輸工具",
    //   //   file: "img/car.png",
    //   //   track: 8,
    //   //   value: 26.4
    //   // },
    //   // {
    //   //   name: "紙漿及紙製品",
    //   //   file: "img/car.png",
    //   //   track: 9,
    //   //   value: 22.7
    //   // },
    //   // {
    //   //   name: "基本金屬及製品",
    //   //   file: "img/electronic.png",
    //   //   track: 10,
    //   //   value: 19.3
    //   // },
    //   // {
    //   //   name: "石油及媒製品",
    //   //   file: "img/petrochemical.png",
    //   //   track: 11,
    //   //   value: 18.0
    //   // },
    //   // {
    //   //   name: "化學材料與製品",
    //   //   file: "img/cpu.png",
    //   //   track: 12,
    //   //   value: 16.1
    //   // },
    // ];
    draw_on_browser();

    function draw_on_browser() {
      var categoryAxis = chart.yAxes.push(new am4charts.CategoryAxis());
      categoryAxis.dataFields.category = "name";
      categoryAxis.renderer.minGridDistance = 10;
      categoryAxis.renderer.innerRadius = 10;
      categoryAxis.renderer.radius = 145;
      categoryAxis.renderer.line.stroke = lineColor;
      categoryAxis.renderer.line.strokeWidth = 5;
      categoryAxis.renderer.line.strokeOpacity = 1;

      var labelTemplate = categoryAxis.renderer.labels.template;
      labelTemplate.fill = lineColor;
      labelTemplate.fontWeight = 400;
      labelTemplate.fontSize = 11;

      var gridTemplate = categoryAxis.renderer.grid.template;
      gridTemplate.strokeWidth = 1;
      gridTemplate.strokeOpacity = 1;
      gridTemplate.stroke = lineColor;
      gridTemplate.location = 0;
      gridTemplate.above = true;

      var fillTemplate = categoryAxis.renderer.axisFills.template;
      fillTemplate.disabled = false;
      fillTemplate.fill = am4core.color(dic_meta["操場跑道顏色"]);
      fillTemplate.fillOpacity = 1;

      categoryAxis.fillRule = function (dataItem) {
        dataItem.axisFill.__disabled = false;
        dataItem.axisFill.opacity = 1;
      };

      var valueAxis = chart.xAxes.push(new am4charts.ValueAxis());
      valueAxis.min = parseFloat(dic_meta["操場跑道最小值"]);
      valueAxis.max = parseFloat(dic_meta["操場跑道最大值"]);
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
      flagBullet.label.text = dic_meta["旗子文字"];
      flagRange.bullet = flagBullet;
      //flagBullet.dy = -145;
      flagBullet.adapter.add("dy", function (dy, target) {
        return -categoryAxis.renderer.radius;
      });

      var valueLabelTemplate = valueAxis.renderer.labels.template;
      valueLabelTemplate.fill = lineColor;
      valueLabelTemplate.fontSize = 10;
      valueLabelTemplate.fontWeight = 400;
      valueLabelTemplate.fillOpacity = 1;
      valueLabelTemplate.horizontalCenter = "right";
      valueLabelTemplate.verticalCenter = "bottom";
      // 跑道上數字的位置
      valueLabelTemplate.padding(0, 15, 0, 0);
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
      var series = chart.series.push(
        new am4plugins_timeline.CurveColumnSeries()
      );
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
  }
}
customElements.define("cameo-run", CameoRun);

// Add amCharts 4 license
am4core.addLicense("CH251292242");
// Add Maps license
am4core.addLicense("MP251292242");
// Add TimeLine license
am4core.addLicense("TL251292242");
