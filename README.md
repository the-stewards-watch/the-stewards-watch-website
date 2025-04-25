# The Steward Website

A small business website build with Common Lisp to promote and manager a local home sitting service.

## Overview

The Steward Website is a web application that provides an online presence for a small, trusted home sitting business. It features service descriptions, a contact form availability calendar, and basic admin tools.

Built using Common Lisp for with a focus on simplicity, speed, and maintainability.

## Features

- Responsive landing page
- Service overview with pricing
- Secure contact form
- Availability calendar (static or dynamic)
- Admin login for viewing inquiries (optional)

## Installation

### Requirements

- A Common Lisp implementation
- Quicklisp
- Git

### Setup

```bash
git clone https://github.com/matthew-bestard/the-steward-website.git
cd the-steward-website
sbcl

(ql:quickload :the-steward-website)
(the-steward-website:start-app)
