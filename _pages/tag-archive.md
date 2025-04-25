---
title: "Browse All Articles & Tutorials by Tag"
permalink: /tags/
layout: tag
author_profile: true
classes:
  - header-image-readability
header:
  overlay_image: /assets/images/tag-archive-banner.webp
  overlay_color: "#333"
  overlay_filter: "0.7"
excerpt: >
  Explore structured articles and tutorials on  <span style="color:#5c00c7;">Artificial Intelligence</span>,  <span style="color:#5c00c7;">LLMs</span>, and  <span style="color:#5c00c7;">Formula Discovery</span> — organized by clearly defined tags for easy browsing.
---

<div class="container">
  <div class="main-content">
    <p class="tag-intro">
      Welcome to your categorized archive of insights behind
      <span style="color:#5c00c7;">AI, LLMs</span>, and
      <span style="color:#5c00c7;">Formula Discovery</span>.
      Each section below represents a tag, listing all related posts & tutorials.
    </p>

    {% for tag in site.tags %}
      {% assign tag_name = tag[0] %}
      {% assign posts = tag[1] %}
      
      {% assign tag_page = site.pages | where: "title", tag_name | first %}
      {% unless tag_page %}
        {% assign tag_page = site.pages | where: "slug", tag_name | first %}
      {% endunless %}

      <section class="tag-block" id="{{ tag_name | slugify }}">
        <h2>{{ tag_name | capitalize }} ({{ posts.size }})</h2>

        {% if tag_page and tag_page.excerpt %}
          <!-- Display tag description/excerpt -->
          <p class="tag-description">{{ tag_page.excerpt }}</p>
        {% elsif tag_page and tag_page.description %}
          <!-- If description is available -->
          <p class="tag-description">{{ tag_page.description }}</p>
        {% endif %}

        <ul class="post-list">
          {% for post in posts %}
            <li class="post-item">
              {% if post.path contains '/_tutorials/' %}
                <!-- If the post is in the _tutorials directory -->
                  <h4>
		     <a href="{{ post.url | relative_url }}">Tutorial: {{ post.title }}</a>
		     <!-- Post Date placed after the title to avoid the gap -->
                     <span class="post-meta"><small>({{ post.date | date: "%B %d, %Y" }})</small></span>
		   </h4>
                  {% else %}
                    <!-- If it's a regular post -->
                  <h4>
		    <a href="{{ post.url | relative_url }}">Post: {{ post.title }}</a>
		    <!-- Post Date placed after the title to avoid the gap -->
                    <span class="post-meta"><small>({{ post.date | date: "%B %d, %Y" }})</small></span>
		   </h4>
                  {% endif %}
              {% if post.excerpt %}
                <div class="post-excerpt">
                  {{ post.excerpt | markdownify }}
                  <p><a href="{{ post.url | relative_url }}" class="read-more">Read More &raquo;</a></p>
                </div>
              {% endif %}
            </li>
          {% endfor %}
        </ul>
      </section>
      <hr>
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
    margin-bottom: 3em;
    padding-bottom: 2em;
    border-bottom: 1px solid #ddd;
  }

  .tag-description {
    font-style: italic;
    color: #666;
    margin: 0.5em 0 1em;
  }

  .post-list {
    list-style: none;
    padding-left: 0;
  }

  .post-item {
    margin-bottom: 1.5em;
  }

  .post-meta {
    font-size: 0.9em;
    display: inline-block;
    color: #888;
    margin-left: 10px; /* Space between the title and the date */	
  }

  .post-excerpt {
    margin-top: 0.5em;
    font-size: 1em;
  }

  .read-more {
    font-weight: bold;
    color: #5c00c7;
    text-decoration: none;
  }

  .read-more:hover {
    text-decoration: underline;
  }
</style>
