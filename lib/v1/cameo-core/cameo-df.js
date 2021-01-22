import { load_js, load_css } from "/lib/v1/cameo-core/cameo-load.js";
async function load_all_js() {
  await load_js("https://d3js.org/d3.v6.min.js");
}
export async function load_csv(str_url) {
  await load_all_js();
  Promise.all([d3.csv(str_url)]).then(function (d3_obj) {
    console.log("d3_obj 001");
    console.log(d3_obj);
    // files[0] will contain file1.csv
    // files[1] will contain file2.csv
  });
  // d3.csv(str_url, function (ary_row) {
  //   console.log("8:d3_csv");
  //   console.log(ary_row);
  // });
}
// function load_dic_meta() {
//   return { A: 65, B: 66 };
// }
function load_ary_data(d3_csv) {
  return [
    [1, 3, 5, 7],
    [2, 4, 6, 8]
  ];
}
async function test() {
  console.log("df running 1102");
  let d3_csv = await load_csv(
    "/app-cameo-divergent-stacked-bars/data/data.csv"
  );
  console.log("d3_csv");
  console.log(d3_csv);
  let ary = load_ary_data(d3_csv);
  console.log("ary");
  console.log(ary);
  // let dic = load_dic_meta();
  // console.log(ary);
  // console.log(dic);
}
test();
