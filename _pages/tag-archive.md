---
title: "Posts by Tag"
permalink: /tags/
layout: single
---

# Browse Posts by Tag

Click on a tag to see all posts with that tag.

<div class="tag-cloud">
  {% assign sorted_tags = site.tags | sort %}
  {% for tag in sorted_tags %}
    <a href="/tags/{{ tag[0] | slugify }}/" class="tag-link">
      {{ tag[0] }} <span class="tag-count">({{ tag[1].size }})</span>
    </a>
  {% endfor %}
</div>

<style>
  .tag-cloud {
    margin: 2em 0;
    display: flex;
    flex-wrap: wrap;
    gap: 0.8em;
  }
  .tag-link {
    background-color: #f0f0f0;
    border-radius: 4px;
    padding: 0.4em 0.8em;
    text-decoration: none;
    color: #333;
    transition: background-color 0.2s;
  }
  .tag-link:hover {
    background-color: #e0e0e0;
    text-decoration: none;
  }
  .tag-count {
    font-size: 0.9em;
    color: #666;
  }
</style>
