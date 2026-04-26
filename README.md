# metelkin.github.io
Personal website of Metelkin

To serve the site locally, run:

```bash
npm run serve
```

## RSS

Full RSS feed is available at `/feed/post.xml`. All pages with tag "post" are included.

RSS feed for featured posts is available at `/feed/featured.xml`. All pages with tag "featured" are included.
Also presented at home page.

RSS feed for Julia is available at `/feed/julia.xml`. All pages with tag "julia" are included.

RSS feed for R is available at `/feed/r.xml`. All pages with tag "r" are included.


## tags

In blog posts, there are several tags used to categorize the content:

- `post`: General tag for all blog posts. Used to display posts on blog pages and in the full RSS feed.
- `featured`: Tag for posts that are highlighted on the home page and included in the featured RSS feed.
- `julia`: Tag for posts related to the Julia programming language. Used to include posts in the Julia RSS feed.
- `r`: Tag for posts related to the R programming language. Used to include posts in the R RSS feed.
- `draft`: Tag for posts that are still in draft status and not published yet. These posts will be excluded from all RSS feeds and will not be displayed on the website. But they are still accessible via direct URL ad in sitemap.xml.

Other tags may be set for specific topics or categories but currently they are not displayed anywhere.