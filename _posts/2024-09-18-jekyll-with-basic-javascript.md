---
layout: post
title: Jekyll with basic JavaScript
date: 2024-09-18
tags:
  - explore
---
## Introduction

Jekyll is a ruby powered tool that lets you build static websites. However, you can still add JavaScript to these websites, which let’s me think it can be more powerful than we imagine.

The following article contains a bunch of ramble from me where I explore the boundaries of JavaScript with Jekyll. There is a 10% chance that it helps you, and a 90% chance that you get to the end and think to yourself “Wow, I could have been scrolling through TikTok now”.

Either way, enjoy the read.

## Getting started

> This article will assume you already have a Jekyll site ready to work with if you plan on following along.

I have created a new Jekyll site that is running locally on my computer by following the [Quickstart guide](https://jekyllrb.com/docs/) on their website. The default app they provide automatically installs and uses the ***minima*** theme, however, you can override the theme by adding your own theme files to the project.

In our case, I want to pop in a `<script/>` tag into the footer to see if the JavaScript gets triggered.

## Overriding theme files

> This [article](https://jekyllrb.com/docs/themes/#overriding-theme-defaults) from Jekyll covers it in detail.

We will start by creating a new `_includes` folder and popping in a `footer.html` file in there. When doing this, Jekyll should use the footer from our source code instead of the footer from the theme.

```bash
mkdir _includes
cd _includes
nano footer.html
```

By popping in a basic HTML component in there, we should see the site updating to viewing our footer.

```html
<div>
	<h1>Some random footer</h1>
</div>
```

Upon refreshing the page, we see ***Some random footer*** rendering. Next up, is adding a `<script/>` tag to the footer.

```html
<script>
	console.log('hello world')
</script>
```

Now when we refresh the page. We see *Hello World* printed in the console.

## Understanding the Jekyll lifecycle

Calling it a lifecycle is a bit optimistic, since Jekyll is a static website generator so it does not have cool tech like state management and app lifecycle. However, what I do want to find out is whether our `console.log('hello world')` will be triggered each time you navigate to a new page or each time a new page loads.

Simply navigating to pages does not verify whether it does or not. I want to say that it does, however, the page reloads each time. So I am going to implement some `localStorage` magic just to make sure.

```html
<script>
	console.log('hello world')
	var count = localStorage.getItem('count')
	console.info('count', count)
	count++
	localStorage.setItem('count', count)
</script>
```

Now when navigating between pages, you will notice that the count increases. This confirms two things:

1. We can use `localStorage` (and possibly `sessionStorage`) which is powerful.
2. The footer renders each time you navigate, so it will also trigger the code each time you navigate.

This only means that if you want code to only execute once, you will need to make use of some `sessionStorage` magic or place that code in the file you want it to execute in. Placing code in one of the files that lives within the `_includes` or `_layouts` folders will possibly cause the piece of code to execute, not only more than once, but in some cases uncontrolled.

> Just something to think about.

Let’s update the code now to make use of `sessionStorage` to increment count once per session. But logging it each time you navigate.

```html
<script>
console.log('hello world')
var count = localStorage.getItem('count')
console.info('count', count)

var hasIncrementedThisSession = sessionStorage.getItem('incrementedCount')
if (!hasIncrementedThisSession) {
	count++
	localStorage.setItem('count', count)
	sessionStorage.setItem('incrementedCount', true)
}
```

## Manipulating the DOM

JavaScript can do so much more than just log things to the console. One the things it is most famous for is manipulating the DOM. Changing HTML elements! So let’s see if we can do that. Right now, the footer is pretty boring.

```html
<div>
	<h1>Some random footer</h1>
</div>
```

Let’s update it to be a bit more *footery*.

```html
<div id="footer" class="outerContainer">
	<div class="innerContainer">
		<h4>Powerful Jekyll</h4>
		<ul>
			<li>Home</li>
			<li>About</li>
			<li>FAQ</li>
		</ul>
	</div>
</div>
```

It is not much, but it is honest work. This just gives us some toys to play with using JavaScript. First things first, layout. This renders underneath each other. Ideally, we would like the `innerContainer` class to have a `display: flex` to it.

> While I fully understand that this can be achieved using `CSS`, the whole purpose of this article is to see how powerful Jekyll can be with JavaScript and we are specifically trying to manipulate the DOM here.

Let’s write some JavaScript to update its display.

```js
var innerContainer = document.getElementById('innerContainer')
innerContainer.style.display = 'flex'
innerContainer.style.gap = '1rem'
innerContainer.style.alignItems = 'start'

var footerTitle = document.getElementById('footerTitle')
footerTitle.style.fontSize = '24px'
```

This works well. Note that while this is in the footer, any HTML element that is on the page with that `id` attribute would have worked, therefore, you must be careful when working with the DOM and follow proper naming conventions and standards.

## Handling Events

After manipulating the DOM, the natural next step is listening for events, more specifically, button clicks. Let’s add a button to our footer.

```jsx
<div id="footer" class="outerContainer">
	<div id="innerContainer" class="innerContainer">
		<h4 id="footerTitle">Powerful Jekyll</h4>
		<ul>
			<li>Home</li>
			<li>About</li>
			<li>FAQ</li>
		</ul>
		<button id="footerButton">Click Me!</button>
	</div>
</div>
```

Now, we can listen in on the click event using JavaScript and show an alert when the button is clicked.

```js
var button = document.getElementById('footerButton')
button.addEventListener('click', function (event) {
	alert('You clicked me!')
})
```

## API Calls

This is where we start to push the limits. Manipulating the DOM, and handling click events is one thing, but using JavaScript to make API calls to a backend server, that would be awesome! First, let’s find some mock API we can call.

We will be using this [Sample API](https://api.sampleapis.com), more specifically, their [Beers](https://api.sampleapis.com/beers/ale) endpoint.

```js
fetch("https://api.sampleapis.com/beers/ale")
	.then(resp => resp.json())
	.then(data => console.log(data))
```

Let’s update the code to just that when you click on a button.

```js
var button = document.getElementById('footerButton')
button.addEventListener('click', function (event) {
	fetch("https://api.sampleapis.com/beers/ale")
		.then(resp => resp.json())
		.then(data => console.log(data))
})
```

You should be seeing some data being logged onto the console. To wrap up this piece, let’s see if we can update the button’s text to *Loading…* when making the request and back to normal when done.

```js
var button = document.getElementById('footerButton')
button.addEventListener('click', function (event) {
	button.innerText = 'Loading...'
	fetch("https://api.sampleapis.com/beers/ale")
		.then(resp => resp.json())
		.then(data => {
			console.log(data)
			button.innerText = 'Click me!'
		})
})

```

Nice! It feels like we have gone full circle. Now before I jump into the last piece I want to explore, which is the Notification & Location APIs, I want to find out whether we can pass in a Jekyll value into the JavaScript, much like how you can in the HTML.

Let’s store the URL for the Beers API in our `_config.yml` file and see if we can pull it into the code.

```yaml
beers:
	api: https://api.sampleapis.com/beers/ale
```

```js
// footer.html
fetch({ site.beers.api })
	.then(resp => resp.json())
	.then(data => {
	console.log(data)
	button.innerText = 'Click me!'
	})
```

Hopeful, but the above does not work. After some hardcore Googling, which did in fact not include a message to ChatGPT, I found out that the templating from Jekyll is `{{ site.variable.name }}`. However, it gets injected during the build step. Therefore, updating the code to the below example and rerunning the server works as expected.

```js
var button = document.getElementById('footerButton')
button.addEventListener('click', function (event) {
	button.innerText = 'Loading...'
	fetch("{{ site.beers.api }}")
		.then(resp => resp.json())
		.then(data => {
			console.log(data)
			button.innerText = 'Click me!'
		})
})
```

## Browser APIs

The first API I want to try is the Notification API. First, let’s add another button for this.

```html
<button id="notifyButton">Notify Me!</button>
```

Next, let’s request permissions when clicking on the button.

```js
var notifyButton = document.getElementById('notifyButton')
notifyButton.addEventListener('click', function (event) {
	if (!("Notification" in window)) {
		alert("This browser does not support desktop notification");
	} else if (Notification.permission === "granted") {
		const notification = new Notification("Hi there!");
	} else if (Notification.permission !== "denied") {
		Notification.requestPermission()
			.then((permission) => {
				if (permission === "granted") {
					const notification = new Notification("Hi there!");
				}
			});
	}
})
```

Lastly, let’s pop through a notification when the beers have finished loading from the server.

```js
fetch("{{ site.beers.api }}")
	.then(resp => resp.json())
	.then(data => {
		console.log(data)
		button.innerText = 'Click me!'
		if (Notification.permission === "granted") {
			const notification = new Notification("Done fetching!");
		}
	});
```

Now to check out the `geolocation` API as well. Lets add our last button for a user to get their geolocation.

```html
<button id="locationButton">Find Me!</button>
```

Lastly, let’s add some geolocation code.

```js
var locationButton = document.getElementById('locationButton')

locationButton.addEventListener('click', function () {
	function success(position) {
		console.log(position)
	}

	function error() {
		console.error('No geolocation')
	}

	navigator.geolocation.getCurrentPosition(success, error);
})
```

At first it didn’t work, but then I realised that I was on Safari. When testing it on Chrome, it worked perfectly.

## Considerations & Limitations

- Since Jekyll reloads with each page, having something like notifications is a bit tricky since open a socket to a web server or even using Server Sent Events won’t work as good. It will reconnect each time you navigate to a page. Now service-workers can be a fix here.
- Since you can add a script tag to any Jekyll website, and the JavaScript is executed in the browser, the possibilities are near endless. The only limitation would be when the JavaScript is executed and how frequently it is executed. In my opinion, this can be somewhat controlled by decided where you put the script tag and by making use of some `localStorage` vs `sessionStorage`.
- I have been trying to think where you would actually use JavaScript within a Jekyll site, and in my opinion, you might be able to implement features like newsletters, memberships and perhaps a simple e-commerce solution.

## Conclusion

This was a very basic JavaScript article with Jekyll. To be honest, I was just exploring a bit and playing around. But, it is nice to think that there is potential. However, I would not recommend building a really complex JavaScript frontend using Jekyll since there are better frameworks out there. If you really want to though, it seems like you 100% can :). It will not be a single-page app though and that is okay.

Through JavaScript, you can bring some dynamic features to the static website created by Jekyll.

Which is cool, I think.

Okay, cheers 💪.

## Resources

- [https://jekyllrb.com/](https://jekyllrb.com/)
- [https://jekyllrb.com/docs/](https://jekyllrb.com/docs/)
- [https://developer.mozilla.org/en-US/docs/Web/API/Geolocation_API/Using_the_Geolocation_API#examples](https://developer.mozilla.org/en-US/docs/Web/API/Geolocation_API/Using_the_Geolocation_API#examples)
- [https://developer.mozilla.org/en-US/docs/Web/API/Notification](https://developer.mozilla.org/en-US/docs/Web/API/Notification)