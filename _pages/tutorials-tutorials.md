---
title: "Tutorials"
layout: single
permalink: /tutorials/
collection: tutorials
entries_layout: grid
classes:
   -wide
   -inner-page
   -header-image-readability
author_profile: true
sort_by: date
sort_order: reverse
header:
  overlay_color: "#333"
  overlay_filter: "0.7"
  overlay_image: /assets/images/tutorials/tutorials-banner.png
# Add this line to control what appears in each grid item
entries_layout: grid
show_excerpts: true
toc: true
toc_label: "Tutorial Topics"
toc_icon: "question-circle"
---

# Tutorials

Welcome to our comprehensive collection of AI and LLM tutorials. Whether you're just starting out or looking to expand your expertise, our step-by-step guides will help you master essential concepts and techniques.

"Explore in-depth tutorials designed to make complex AI and data science topics approachable. Whether you're a beginner or an advanced user, our guides—written by researchers and practitioners—walk you through real-world applications, best practices, and the latest techniques."

{% for category_data in site.data.tutorial_categories %}
## {{ category_data.name }}

{{ category_data.description }}

{% for item in category_data.items %}
- [{{ item.name }}](/tutorials/{{ category_data.id }}/{{ item.id }}/){% if item.tags %} {% for tag in item.tags limit: 2 %}<span class="tag">{{ tag }}</span>{% endfor %}{% endif %}
{% endfor %}

{% endfor %}

## Upcoming Tutorials {#upcoming-tutorials}

> **On Our Roadmap:** The following tutorials are currently in development. Subscribe to our [newsletter](/subscribe) to be notified when new content is released.

### Working with Popular Models

Expand your knowledge with these model-specific guides:

- **Getting Started with GPT Models**
- **Exploring Claude and Anthropic Models**
- **Implementing Open Source LLMs**
- **LLaMA Model Family Deep Dive**

### Integration Guides

Learn to integrate LLMs into various applications:

- **Integrating LLMs with Web Applications**
- **Building AI-powered Mobile Apps**
- **LLMs and Database Systems**
- **Creating AI Chatbots**

### Project-Based Learning

Put your knowledge into practice with these comprehensive project tutorials:

- **Building a Sentiment Analysis Tool**
- **Creating a Document Question-Answering System**
- **Developing an AI Content Generator**
- **Building a Custom Knowledge Base with LLMs**

## Resources and References

- [AI/LLM Terminology Glossary](/resources/glossary/)
- [Recommended Learning Path](/resources/learning-path/)
- [Troubleshooting Common Issues](/resources/troubleshooting/)
- [Community Projects Gallery](/community/projects/)

## Help Shape Our Tutorial Roadmap

👉 <span style="color:#5c00c7;">Your input matters!</span> Help us prioritize our upcoming content by sharing which LLM topics interest you most. Our development schedule is directly influenced by community feedback, ensuring we deliver the tutorials you need most.

## Request a Tutorial

📌 <span style="color: #5c00c7;">Can't find what you're looking for?</span> Submit a specific tutorial request with details about your use case and learning goals. Our team reviews all submissions to identify high-demand topics for our content roadmap.

Check back regularly as we continue to expand our tutorial library with the latest techniques and best practices in AI and LLM development.

## Join to Our Community

Join our [Community Forum](/tutorials/community-forum/) to share your experiences and learn from others

## Recent Tutorials

<div class="tutorials-list">
  {% assign recent_tutorials = site.tutorials | sort: 'date' | reverse | limit: 8 %}
  {% for tutorial in recent_tutorials %}
    <div class="tutorial-card">
      <a href="{{ tutorial.url }}">{{ tutorial.title }}</a>
      <div class="meta">{{ tutorial.date | date: "%b %d, %Y" }} | {{ tutorial.category }}</div>
      {% if tutorial.tags %}
        {% for tag in tutorial.tags limit: 2 %}
          <span class="tag">{{ tag }}</span>
        {% endfor %}
      {% endif %}
    </div>
  {% endfor %}
</div>

<style>
.tag {
  display: inline-block;
  background: #f0e7ff;
  color: #5c00c7;
  padding: 2px 8px;
  font-size: 0.75rem;
  border-radius: 12px;
  margin-left: 8px;
}

.tutorial-card {
  background: #f9f9f9;
  border-left: 3px solid #5c00c7;
  padding: 12px;
  margin-bottom: 15px;
  border-radius: 4px;
}

.tutorial-card a {
  font-weight: 500;
  color: #333;
  text-decoration: none;
}

.tutorial-card .meta {
  font-size: 0.8rem;
  color: #666;
  margin-top: 5px;
}

.tutorials-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
  margin-top: 20px;
}

@media (max-width: 768px) {
  .tutorials-list {
    grid-template-columns: 1fr;
  }
}
</style>