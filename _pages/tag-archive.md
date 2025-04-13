---
title: "Browse All Posts by Tag"
permalink: /tags/
layout: single
author_profile: true
classes:
  -wide
  -header-image-readability
header:
  overlay_image: /assets/images/posts/tag-banner_.png
  overlay_color: "#333"
  overlay_filter: "0.7"  
excerpt: >
  Browse all categorized posts on Artificial Intelligence, LLMs, and Formula Discovery, grouped for easy access.
---

<div class="container">
  <div class="main-content">
    <p class="tag-intro">Welcome to your categorized archive of insights behind <strong>AI</strong>, <strong>LLMs</strong>, and <strong>Formula Discovery</strong>. Each section below represents a tag, listing all related posts.</p>
    
    {% for tag in site.tags %}
      <section class="tag-block" id="{{ tag[0] | slugify }}">
        <h2>{{ tag[0] | capitalize }} ({{ tag[1].size }})</h2>
        <ul>
          {% assign posts = tag[1] %}
          {% for post in posts %}
            <li>
              <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
              <small>({{ post.date | date: "%B %d, %Y" }})</small>
            </li>
          {% endfor %}
        </ul>
      </section>
    {% endfor %}
  </div>
<script src="{{ '/assets/js/tag-filter.js' | relative_url }}"></script>
</div>

<style>
  .tag-intro {
    margin-bottom: 2em;
    font-size: 1.1em;
    line-height: 1.6;
  }
  .tag-block {
    margin-bottom: 2em;
    border-bottom: 1px solid #ddd;
    padding-bottom: 1em;
  }
</style>

