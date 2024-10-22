---
layout: post
title: GulpJS - A forgotten tool
date: 2024-09-21
tags:
  - playground
---

## TL;DR

- Gulp is a task runner that automates repetitive development tasks in your workflow. 
- Gulp uses _code-over-configuration_ approach, which means that you write JavaScript code to define tasks.

## Get Started

> ☝️ Prerequisites
>
> You need to have the latest `npm` & `node` versions installed. If not, check out [this link](https://nodejs.org/en/).

The magic behind `gulp` is the fact that it let's you create workflows that can run code that is unrelated to your project. While tools like [Webpack](https://webpack.js.org) and [Vite](https://vite.dev) are great for bundling and building code, they lack the ability to execute step in a pipeline. 

> I will be honest, I have not come across a scenario where I thought to myself "wow I wish I had a tool that executed a series of steps in JavaScript before deploying", but it would seem that if I had, Gulp would be that tool.

### Installation

> If you have not yet set up your project, you can create an empty project by running `npm init -y` in a folder of your choice.

To add `gulp` to your project, install it using `npm install --save-dev gulp`.

```bash
HercoBezuidenhout@Mac gulp-demo % npm i gulp --save-dev

added 144 packages, and audited 145 packages in 9s

14 packages are looking for funding
  run `npm fund` for details

found 0 vulnerabilities
npm notice 
npm notice New minor version of npm available! 10.2.4 -> 10.9.0
npm notice Changelog: https://github.com/npm/cli/releases/tag/v10.9.0
npm notice Run npm install -g npm@10.9.0 to update!
npm notice 
```

### Gulpfile

I am not entirely sure how important this file is, but its name is `gulpfile.js`, and my spidy senses tell me it is pretty important. According to the [Get Started](https://gulpjs.com/docs/en/getting-started/quick-start#create-a-gulpfile) doc, you want to add this file to the root of your project.

```diff
/node_modules
package-lock.json
package.json
+gulpfile.js
```

Inside this `gulpfile.js` file, you want to add your `defaultTask` which is exported by default.

```js
function defaultTask(cb) {
	// place code for your default task here.
	cb()
}

exports.default = defaultTask
```

### Test it

The last piece to this weird puzzle is testing it. To test it, you can run `gulp` if you installed `gulp` globally. In our case, we installed `gulp` locally for this project only. So let's add a new script to our `package.json`. 

```diff
{
	"scripts": {
		"test": "echo \"Error: no test specified\" && exit 1",
+		"gulp": "gulp"
	},
}
```

After updating our `package.json`, we run our `gulpfile.js`.

```bash
HercoBezuidenhout@Mac gulp-demo % npm run gulp

> gulp-demo@1.0.0 gulp
> gulp

[14:36:00] Using gulpfile ~/Desktop/gulp-demo/gulpfile.js
[14:36:00] Starting 'default'...
[14:36:00] Finished 'default' after 1.27 ms
```

Now that you have `gulp` set up in your project, you might be wondering what you can do with it. That is our next chapter :). 

## What to do with it

!["GulpMeme"](/assets/posts/GulpMeme.png)

`Gulp` is designed to help automate tasks within your project. So to answer the question of "what to do with it", we first need to ask "what do we do receptively in our project?". 

> You can run multiple tasks with `gulp <task> <othertask>`.

### Tasks

Each `gulp` task is an asynchronous JavaScript function. Tasks can also be either **public** or **private** by simply choosing what and what not to export.

```js
function clean(cb) {
	// some code here
	cb()
}

function build(cb) {
	console.info("build", "🛠️ building something here")
	cb()
}

exports.default = build
```

**Public** tasks are exported from the `gulpfile`, which means they can be run by the `gulp` command.

```bash
npm run gulp build
```

```bash
HercoBezuidenhout@Mac gulp-demo % npm run gulp build

> gulp-demo@1.0.0 gulp
> gulp build

[14:57:27] Using gulpfile ~/Desktop/gulp-demo/gulpfile.js
[14:57:27] Starting 'build'...
build 🛠️ building something here
[14:57:27] Finished 'build' after 972 μs
```

**Private** tasks are not exported but can then be called by `gulp` using the `series` function.

```js
const { series } = require('gulp');

function defaultTask(cb) {
	// place code for your default task here.
	cb()
}

  

function clean(cb) {
	// clean the code before building
	console.info("clean", "🧹 clean the code")
	cb()
}

function build(cb) {
	// some code goes here
	console.info("build", "🛠️ building something here")
	cb()
}

exports.build = series(clean, build)
exports.default = defaultTask
```

```bash
HercoBezuidenhout@Mac gulp-demo % npm run gulp build

> gulp-demo@1.0.0 gulp
> gulp build

[15:05:21] Using gulpfile ~/Desktop/gulp-demo/gulpfile.js
[15:05:21] Starting 'build'...
[15:05:21] Starting 'clean'...
clean 🧹 clean the code
[15:05:21] Finished 'clean' after 401 μs
[15:05:21] Starting 'build'...
build 🛠️ building something here
[15:05:21] Finished 'build' after 448 μs
[15:05:21] Finished 'build' after 2.01 ms
```

### Series vs Parallel tasks

In the above example, we used the `series` function to execute our **private** task with our **public** task, `clean` and `build`. However, `gulp` offers another function called `parallel()`. 

Both `series` and `parallel` lets you execute multiple tasks as part of one operation. An _operation_ in this context is an `npm` call for example `npm run gulp` or `npm run gulp build`.

**Series** will execute the tasks in order while **parallel** will execute the tasks concurrently. 

They can also be nested within each other. 

```js
export.build = series(
	clean, 
	build, 
	test, 
	parallel(
		deploy, 
		uploadTestResults
	)
)
```

## It's 2024, what about TypeScript

`gulpfiles` can be written in a language that requires transpilation, such as TypeScript or Babel by changing the extension to `.ts` or `.babel.js`. You need to install the proper modules though.

1. TypeScript - `ts-node`.
2. Babel - `@babel/register`.

## What's Next?

I am not too sure what is next. GulpJS is a really cool tool, however, you barely read about it on the internet. I am sure some of the more experienced developers out there have worked with it before, but with all of the new libraries coming out it feels like Gulp here has disappeared into the crowd.

When researching, I found many articles and posts stating that it is deprecated or not being maintained anymore, however, if you visit the Github repo you will notice the last release was in March 2024, which is not that "old" compared to other "old" tools. 

I do not see myself using Gulp in one of my projects soon, since most of them have their own built in tools, but now that I know it exists, I look forward to playing around with it. 

That is it from me.

Cheers 🍻