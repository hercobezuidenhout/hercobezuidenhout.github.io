---
layout: post
title:  "Writing Unit Tests with IIFE JavaScript"
date:   2025-01-07
tags: [general]
---

I recently came across a unique situation. On the surface, it might not sound so unique, however, as I dived ever deeper into the sea of JavaScript, my perspective started to change.

When being tasked with writing unit tests for a JavaScript project, one quickly things about tools such as [Jest](https://jestjs.io) and [Playwright](https://playwright.dev) and while these tools are indeed amazing, the did not solve my problem out of the box. In fact, I am not even sure if my makeshift solution is the right one. I just know it works.

> I am aware of that there are other frontend testing libraries out there but I have not yet had the pleasure of working with them.

## The Problem

The above mentioned tools, and many other modern tools, rely on modern technology to show off their full potential which is unfortunetly, not the case with this particular project. In our case, we are working with ES5 JavaScript and gulp. Now the project is set up quite nicely and the development experience is not too bad, however, when it came to writing unit tests for this project, I was a bit challenged since the project mainly relies on globals. Below is an example of a JavaScript module.

> I am using the word ___module___ very loosely in this context.

```js
// app.js

var app = app || {}

app = (function() {
    var App = function () { }


    return new App()
}())
```

In the above code snippet, you will see two main themes:

1. We are working with a global `app`.
2. We are using the IIFE Pattern.

What you will **not** see, is anything being exported. Which makes writing jest tests a tiny bit difficult since most jest tests look something like this:

```js
const sum = require('./sum');

test('adds 1 + 2 to equal 3', () => {
  expect(sum(1, 2)).toBe(3);
});
```

In a nutshell, Jest cannot import your module.

## The Solution

The best solution I found was to inject the JavaScript into the Jest DOM where I can then write tests against the functions. I will share my solution below, but I am open to any better suggestions to doing this. 

### A possible solution
Before I settled on the below solution, I tried this one first.

```js
require('path/to/file.js')

test('helloWorld', () => {
    expect(app.helloWorld()).toBe("Hello World")
})
```

However, jest complained that `app` is `undefined` which, to me, meant that it wasn't running the JavaScript in `/path/to/file.js`.

### What I settled on

The goal was to inject my JavaScript into the Jest DOM and mimic the below implementation

```html
<html>
    <body>
        <h1>Hello World</h1>
        <script src="path/to/file.js"></script>
        <script>
            describe('tests', () => {
                ...
            })
        </script>
    </body>
</html>
```

If I could achieve this, it would mean that whatever is defined in the `path/to/file.js` will be available in my test logic.

#### Step 1: Install and configure Jest

> I recommend giving the [official documentation](https://jestjs.io/docs/getting-started) a read as well.

