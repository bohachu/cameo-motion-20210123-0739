export function load_css(str_url) {
  return new Promise((resolve, reject) => {
    var link = document.createElement("link");
    link.onload = (event) => {
      resolve();
    };
    link.rel = "stylesheet";
    link.href = str_url;
    link.type = "text/css";
    document.head.appendChild(link);
  });
}
export function load_js(str_url) {
  return new Promise((resolve, reject) => {
    var script = document.createElement("script");
    script.onload = (event) => {
      resolve();
    };
    script.src = str_url;
    document.head.appendChild(script);
  });
}
