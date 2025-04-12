---
title: "Browse All Posts by Category"
permalink: /categories/
layout: single
author_profile: true
classes:
  - header-image-readability
header:
  overlay_image: /assets/images/posts/category-banner.webp
  overlay_color: "#333"
  overlay_filter: "0.7"  
excerpt: >
  Browse all categorized posts on Artificial Intelligence, LLMs, and Formula Discovery, grouped for easy access.
---

<div class="container">
  <div class="main-content">
    <p class="category-intro">Welcome to your categorized archive of insights behind <strong>AI</strong>, <strong>LLMs</strong>, and <strong>Formula Discovery</strong>. Each section below represents a category, listing all related posts.</p>
    
    {% for category in site.categories %}
      <section class="category-block" id="{{ category[0] | slugify }}">
        <h2>{{ category[0] | capitalize }} ({{ category[1].size }})</h2>
        <ul>
          {% assign posts = category[1] %}
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
</div>

<style>
  .category-intro {
    margin-bottom: 2em;
    font-size: 1.1em;
    line-height: 1.6;
  }
  .category-block {
    margin-bottom: 2em;
    border-bottom: 1px solid #ddd;
    padding-bottom: 1em;
  }
</style>
