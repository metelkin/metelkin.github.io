module.exports = function (eleventyConfig) {
  // Copy the folder and keep the same name inside _site/
  eleventyConfig.addPassthroughCopy("content/assets");

  /*  If you’d rather strip the “content/” part so the result is
      _site/assets/…, map input → output like this:
      eleventyConfig.addPassthroughCopy({ "content/assets": "assets" });
  */

  return {
    dir: {
      input: ".",        // default
      output: "_site"
    }
  };
};