---
title: "Python Setup"
layout: single
permalink: /tutorials/setup/python-setup/
classes:
  - wide
  - inner-page
author_profile: true
toc: true
toc_label: "Contents"
toc_icon: "list"
date: 2025-01-15
tags:
  - python
  - setup
  - installation
---

{% assign category = site.data.tutorial_categories | where: "id", "setup" | first %}
{% assign tutorial = category.items | where: "id", "python-setup" | first %}

<div class="breadcrumbs">
  <a href="/">Home</a> &raquo; 
  <a href="/tutorials/">Tutorials</a> &raquo; 
  <a href="/tutorials/setup/">{{ category.name }}</a> &raquo; 
  <span>{{ tutorial.name }}</span>
</div>

# Python Setup Tutorial

This tutorial will guide you through setting up Python for your AI and machine learning projects, ensuring you have the right configuration for developing LLM applications.

## Prerequisites

Before you begin, make sure you have:
- Administrative access to your computer
- At least 5GB of free disk space
- A reliable internet connection

## Step 1: Download Python

The first step is to download the appropriate Python version for your operating system.

```bash
# For Ubuntu/Debian
sudo apt update
sudo apt install python3.11 python3-pip

# For macOS with Homebrew
brew install python@3.11

# For Windows
# Download from python.org and run the installer
```

## Step 2: Create a Virtual Environment

It's recommended to use virtual environments for your projects:

```bash
# Create a virtual environment
python -m venv myenv

# Activate on Windows
myenv\Scripts\activate

# Activate on macOS/Linux
source myenv/bin/activate
```

## Step 3: Install Essential Packages

With your environment activated, install the necessary packages:

```bash
pip install numpy pandas matplotlib scikit-learn torch transformers
```

## Common Issues and Troubleshooting

If you encounter issues during installation, here are some common problems and solutions:

### Path Issues on Windows
...

<style>
.breadcrumbs {
  margin-bottom: 30px;
  padding: 8px 0;
  font-size: 0.9rem;
}

.breadcrumbs a {
  color: #5c00c7;
  text-decoration: none;
}

pre {
  background: #f1f1f1;
  padding: 15px;
  border-radius: 5px;
  overflow-x: auto;
}

code {
  font-family: 'Consolas', 'Monaco', monospace;
}

.note {
  background: #f0e7ff;
  border-left: 4px solid #5c00c7;
  padding: 15px;
  margin: 20px 0;
  border-radius: 0 5px 5px 0;
}

.warning {
  background: #fff7e0;
  border-left: 4px solid #ffc107;
  padding: 15px;
  margin: 20px 0;
  border-radius: 0 5px 5px 0;
}
</style>