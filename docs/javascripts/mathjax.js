// MathJax configuration
window.MathJax = {
  tex: {
    inlineMath: [["\\(", "\\)"], ["$", "$"]],
    displayMath: [["\\[", "\\]"], ["$$", "$$"]],
    processEscapes: true,
    processEnvironments: true
  },
  options: {
    ignoreHtmlClass: ".*|",
    processHtmlClass: "arithmatex"
  }
};

// Hook into MkDocs Material instant navigation (document$)
if (typeof document$ !== "undefined") {
  document$.subscribe(() => {
    // 1. Re-render MathJax
    if (typeof MathJax !== "undefined" && MathJax.startup) {
      MathJax.startup.output.clearCache();
      MathJax.typesetClear();
      MathJax.texReset();
      MathJax.typesetPromise();
    }

    // 2. Render Mermaid diagrams
    if (typeof mermaid !== "undefined") {
      mermaid.initialize({
        startOnLoad: false,
        theme: "default",
        securityLevel: "loose"
      });
      mermaid.run({
        querySelector: ".mermaid"
      });
    }
  });
}
