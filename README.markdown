# Podcast extension

This is a simple thing that adds a few radius tags and makes it very simple to serve podcast feeds.

It offers two ways to create a podcast: from the assets attached to a page, or from whatever audio it can find in a collection of pages (ie your blog, probably). The resulting feeds are itunes-compatible.

I might add a 'podcast' page type at some point to simplify away what little setup remains.

## Requirements

* [Paperclipped](https://github.com/kbingman/paperclipped/tree), to attach audio files and images to the page.
* [Ruby RSS library](http://www.cozmixng.org/~rwiki/?cmd=view;name=RSS+Parser) 0.1.8 or later to get the itunes tags. For most people this will probably mean updating the core library. See [this blog entry](http://www.subelsky.com/2007/08/roll-your-own-podcast-feed-with-rails.html) for details (and a comment lower down from the author of the Parser that was very useful).

If anyone knows a better way to get the latest RSS library I'd love to hear it.

## Installation

Should be straightforward:

	git submodule add git://github.com/spanner/radiant-podcast-extension.git vendor/extensions/podcast
	rake radiant:extensions:podcast:migrate

The migration will add a 'podcast' layout and an 'itunes' thumbnail size, unless you already have them. There are no database changes.

## Assets podcast

To create a standalone podcast, all you need is a page with a bunch of audio files attached to it. You can order them, give them captions and upload new ones in the usual way: the podcast will be updated.

## Pages podcast

Here we scan all the child pages of a given root page looking for images and audio files. The sequence is determined by page-publication order (unless you specify otherwise) and we draw on the pages for captioning and metadata.

## Images

Upload an image to the podcast page and it will appear as the cover artwork. I'm looking for the right way to do the same for individual tracks within the podcast. The migrations for this extension will add an `itunes` thumbnail size to your paperclipped configuration. It's supposed to be square and larger than 600x600 so I've been using 1024x1024#.

## Metadata

Itunes indexes the title, author, summary and keywords of the feed. It doesn't index episode text so if you care about itunes searches you need to get the metadata right. Unless you specify otherwise:

* the 'title' of the feed will be the title of the page
* the 'author' of the feed will be the full name of the author of the page
* the 'description' and 'itunes_summary' of the feed will be taken from the enclosed text if any, or from a 'description' page part.
* the 'keywords' of the feed will be the keywords of the page it's on

You can override any of these with parameters to the `r:podcast` tag. Other options you can also pass in:

* category	(as category/subcategory/mycategory. default is none)
* language	(default is en-US)
* copyright	(default is blank)
* subtitle (default is same as description)
* image (default is none)
* explicit (default is "No")

## Examples

A 'podcast' layout is created for you when you run `rake radiant:extensions:podcast:migrate`. All it does is set the right content_type (application/rss+xml) and render the page. Create a page with that layout, and in the body:

	<r:podcast />

And then attach some audio files. or 

	<r:podcast from="children" />
	
and then give it some children and give those some audio files. That's it, really. You can also:
	
* Give each page a description part, and that text will go into the description of your feed (and the itunes summary) and tracks. 
* Attach an image asset to the podcast page, and that will become the cover artwork.

If you want to turn an existing blog or other set of pages into a podcast, this should be all you need:

	<r:find url="/blog">
		<r:podcast from="children" />
	</r:find>
	
Or maybe:

	<r:find url="/blog">
		<r:podcast from="children" by="published_at" title="alert the authorities: my podcast is ready" link="site url/blog" subtitle="Don't panic" />
	</r:find>
	
Any audio files that you've attached to any child of your blog page will be drawn into the feed and ordered by the publication date of the blog entries.
	
## Author & Copyright

William Ross, for spanner. will at spanner.org
Copyright 2009 spanner ltd
Released under the same terms as Rails and/or Radiant
