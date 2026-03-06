(function () {
  'use strict';

  // Elements to animate on scroll
  var selectors = [
    '.service-item',
    '.preview-item',
    '.step',
    '.reason',
    '.testimonial',
    '.about-section',
    '.contact-info',
    '.contact-form',
    '.addons-section',
  ];

  var targets = document.querySelectorAll(selectors.join(', '));

  if (!targets.length || !('IntersectionObserver' in window)) return;

  // Mark all targets for animation
  targets.forEach(function (el) {
    el.classList.add('fade-in');
  });

  // Stagger children within grid/flex containers
  var staggerParents = document.querySelectorAll(
    '.services-grid, .preview-grid, .steps, .reasons'
  );

  staggerParents.forEach(function (parent) {
    var children = parent.querySelectorAll('.fade-in');
    children.forEach(function (child, idx) {
      child.style.transitionDelay = idx * 0.09 + 's';
    });
  });

  // Trigger visibility when element enters viewport
  var observer = new IntersectionObserver(
    function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add('visible');
          observer.unobserve(entry.target);
        }
      });
    },
    { threshold: 0.1 }
  );

  targets.forEach(function (el) {
    observer.observe(el);
  });
})();
