const sitemap = require("@quasibit/eleventy-plugin-sitemap");

// Prism highlighter
// npm install --save-dev @11ty/eleventy-plugin-syntaxhighlight
const syntaxHighlight = require("@11ty/eleventy-plugin-syntaxhighlight");

// TODO: switch to shiki highlighter, supports heta
// eleventy-plugin-shiki-twoslash not working
// https://samwarnick.com/blog/adding-shiki-to-eleventy-3/
// https://stefanzweifel.dev/posts/2024/06/03/how-i-use-shiki-in-eleventy/

module.exports = async function(eleventyConfig) {
  // create sitemap
  eleventyConfig.addPlugin(sitemap, {
    sitemap: {
      hostname: "https://metelkin.me"
    }
  });

  // copy files to the output directory
  eleventyConfig.addPassthroughCopy("content/robots.txt");
  eleventyConfig.addPassthroughCopy("content/assets");
  eleventyConfig.addPassthroughCopy("content/**/img");

  // add syntax highlighting plugin
  eleventyConfig.addPlugin(syntaxHighlight);

  // identifier for Google Analytics
  eleventyConfig.addGlobalData("googleAnalytics", "G-6DBZB44BXE");

  // default license for content
  eleventyConfig.addGlobalData("license", "CC-BY-4.0");
  eleventyConfig.addGlobalData("licenseUrl", "https://creativecommons.org/licenses/by/4.0/");
  
  return {
    dir: {
      input: ".",        // default
      output: "_site"
    }
  };
};