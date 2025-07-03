const sitemap = require("@quasibit/eleventy-plugin-sitemap");

module.exports = function(eleventyConfig) {
  // create sitemap
  eleventyConfig.addPlugin(sitemap, {
    sitemap: {
      hostname: "https://metelkin.me"
    }
  });

  // copy files to the output directory
  eleventyConfig.addPassthroughCopy("content/robots.txt");
  eleventyConfig.addPassthroughCopy("content/assets");

  return {
    dir: {
      input: ".",        // default
      output: "_site"
    }
  };
};