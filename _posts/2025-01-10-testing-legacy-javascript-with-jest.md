---
layout: post
title: Testing Legacy JavaScript with Jest
date: 2025-09-17
tags:
  - general
---

I recently came across a project where I wanted to add some unit tests to it, but it was not using modules. At least, not in the modern way I am used to. To give you an idea of what I was working with, a JavaScript file would look something like this:

```js
var app = app || {}

app.someModule = (function() {
	var SomeModule = function () {}

	SomeModule.prototype.someFunction = function () {
		// TODO: Write some logic here.
	}

	return new SomeModule()
}())
```

So you might notice that the main issue above is that nothing is being exported and jest mainly relies on modules being exported since the average jest test file looks something like this:

```js
const sum = require('./sum');  
  
test('adds 1 + 2 to equal 3', () => {  
	expect(sum(1, 2)).toBe(3);  
});
```

You could also use `import` instead of `require`. 

The other issue I had, was mocking dependencies. Since everything in this project is essentially a JavaScript global, mocking felt a bit strange.

However, with the above said, I did find a solution and I wish to share my solution with you here. Now, I am not claiming for this to be ***the*** solution, but rather ***a*** solution. So if you have any feedback, questions or suggestions, please feel free to [pop me an email](mailto:herco.bezuidenhout@gmail.com).

## Setting the stage

The first thing I needed to do was get everything set up which includes installing jest and configuring the project structure. The final project looks something like this:

```bash
.
├── jest.config.js
├── package-lock.json
├── package.json
├── public
│   └── index.html
├── src
│   ├── app.js
│   └── database.js
└── test
    ├── app.test.js
    ├── database.test.js
    └── utils
        └── loadScript.js
```

Since I am mimicking a basic web application (HTML, CSS and JavaScript), you will notice a couple of things:

- **public** - this folder will contain the main `index.html` file which would load the `main.js` file. The JavaScript file would be bundled using `gulp` which is not shown in this article.
- **src** - this folder contains all of the JavaScript used within the application. None of these files know the other one exists and they work together using JavaScript globals as mentioned above.
- **test** - this folder contains the test files which is run by Jest.

> Note that I am not going into much detail on how I installed things like `node`, `npm` and `jest`. I recommend reading their respective documentation on that.

The `app.js` file mimics a basic `HelloWorld` app with two functions which we will get into a bit later and the `database.js` file mimics a database which is something many web applications have. In this context, it is simple to act as a dependency which would be mocked in a usual unit test.

## Writing the first test

My first test will be for the `app.js` file. I want to have a simple function called `helloWorld` which returns a string, `"Hello World"`. The reason for this test is to get the basics of Jest working. I started by creating a new test file called `app.test.js` in the `~/test` folder.

```js
describe('app', () => {
	it('returns Hello World', () => {
		// arrange
		const expectedResult = 'Hello World'
		
		// act
		const result = app.helloWorld()

		// assert
		expect(result).toBe(expectedResult)	
	})
})
```

Now running the above as is threw the following error:

```bash
FAIL  test/app.test.js
  app
    ✕ returns Hello World (1 ms)

  ● app › returns Hello World

    ReferenceError: app is not defined

      1 | describe('app', () => {
      2 |     it('returns Hello World', () => {
    > 3 |         expect(app.helloWorld()).toBe('Hello World')
        |                ^
      4 |     })
      5 | })

      at Object.app (test/app.test.js:3:16)

Test Suites: 1 failed, 1 total
Tests:       1 failed, 1 total
Snapshots:   0 total
Time:        0.405 s, estimated 1 s
```

Which makes sense, because we don't define `app` anywhere. Which leads me into my next section.

## Jest Globals

In my test case above, `app.helloWorld()` assumes that `app` is defined somewhere. Now, I could simply define it above the test case or in a `beforeEach()` function, but I had to take two things into account:

1. There might be multiple test cases that rely on `app` being defined.
2. The file I am testing also needs to work with a global `app` object.

A quick google search landed me on [Jest's official documentation for configuring globals](https://jestjs.io/docs/configuration#globals-object) which showed me that I can update my `jest.config.js` file to include some globals, which I did.

```js
/** @type {import('jest').Config} */
const config = {
	testEnvironment: 'jsdom',
	globals: {
		app: {}
	}
}

module.exports = config
```

Now, there are two things to note with the above config:

1. I am setting `app` to an empty object. This is because `app` is supposed to be assigned and appended to when loading the specific JavaScript file which is being tested and any other piece of logic should be mocked within the test.
2. I am using `testEnvironment` which I have not talked about in this article, however, it is important to use `jsdom` as the test environment so that Jest can inject scripts into our DOM which we test against.

After updating the config, I reran the tests and got the following output:

```bash
FAIL  test/app.test.js
  app
    ✕ returns Hello World (1 ms)

  ● app › returns Hello World

    TypeError: app.helloWorld is not a function

      1 | describe('app', () => {
      2 |     it('returns Hello World', () => {
    > 3 |         expect(app.helloWorld()).toBe('Hello World')
        |                    ^
      4 |     })
      5 | })

      at Object.helloWorld (test/app.test.js:3:20)

Test Suites: 1 failed, 1 total
Tests:       1 failed, 1 total
Snapshots:   0 total
Time:        0.362 s, estimated 1 s
```

Notice how it is still failing, but the reason now is `app.helloWorld` not being a function. Which shows progress!

## "Importing the module"

The entire heading of this section is in quotations because it feels wrong, but it is essentially what I am doing. There are two things we want to achieve:

1. Make jest aware of our JavaScript file which we want to test.
2. Somehow "run" the JavaScript so that the `app` global is updated with my new code which I want to test.

Some googling lead me to this [piece of documentation](https://info343.github.io/jest.html) which says

*You load an external script in Jest by using Node’s `require()` function, passing it the _relative path_to the script file you wish to load (this script must be saved locally)* 

with the following code snippet:

```js
//load the `index.js` file
require('../js/index.js');
```

So I updated my test to require the JavaScript file.

```js
require('../src/app.js')

describe('app', () => {
	it('returns Hello World', () => {
		expect(app.helloWorld()).toBe('Hello World')
	})
})
```

But when running the test, I still got the above output stating that `app.helloWorld is not a function`. Now granted, the above documentation is not on jest's official website, so it might be out of date.

I continued working on this and came across a solution where I can load the script's contents and essentially inject it into the DOM with the following JavaScript:

```js
const script = document.createElement('script')
const scriptContent = fs.readFileSync(
	path.resolve(__dirname, `../../src/app.js`), 'utf-8'
)

script.textContent = scriptContent
document.body.appendChild(script)
```

So I cleaned it up a bit, and moved it into a new file called `loadScript.js` inside the folder `~/test/utils`. Then, I imported it into my test file and placed it in the `beforeAll()`  function, so that the JavaScript file being tested is appended to the DOM before the tests run. Below is the final JavaScript files:

```js
// loadScript.js
const fs = require('fs')
const path = require('path')

const loadScript = (filename) => {
	const script = document.createElement('script')
	const scriptContent = fs.readFileSync(
		path.resolve(__dirname, `../../src/${filename}`), 'utf-8'
	)
	
	script.textContent = scriptContent
	document.body.appendChild(script)
}

module.exports = loadScript
```

```js
// app.test.js

const loadScript = require('./utils/loadScript')

describe('app', () => {
	beforeAll(() => {
		loadScript('app.js')
	})

	it('returns Hello World', () => {
		expect(app.helloWorld()).toBe('Hello World')
	})
})
```

And now, when running the test, it passes.

```bash
PASS  test/app.test.js
  app
    ✓ returns Hello World

Test Suites: 1 passed, 1 total
Tests:       1 passed, 1 total
Snapshots:   0 total
Time:        0.404 s, estimated 1 s
```

## Mocking dependencies

A very important topic with unit tests is mocking dependencies. Jest offers a really neat approach to mocking dependencies, however, it only works if your module is importing those dependencies where in my case, the module relies on globals for example `app.database` or `app.http`, etc. To tackle this, I created a `database.js` file to simulate a database dependency which I needed to mock.

```js
var app = app || {}

app.database = (function () {
	const Database = function () { }
	
	Database.prototype.save = (entity) => {
		console.log("Entity has been saved")
		entity.id = 1
		
		return entity
	}
	
	return new Database()
}())
```

Notice how the above file appends `database` to the current `app` global. Now, I will update my `app.js` file to make use of this new dependency with a new function `createUser`. 

> Note that the functions might not make sense in this project, but I merely used them to simulate the real-world project I was working on. I mean, why would you create a user for a HelloWorld application 😅?


```js
var app = global.app || {}

app = (function () {
	var App = function () { }
	
	App.prototype.helloWorld = () => "Hello World"
	
	App.prototype.createUser = (name) => app.database.save({ 
		name: name 
	})
	
	return new App()
}())
```

I also updated the test to test the new `createUser` function. 

```js
const loadScript = require('./utils/loadScript')

describe('app', () => {
	beforeAll(() => {
		loadScript('app.js')
	})
	
	it('returns Hello World', () => {
		expect(app.helloWorld()).toBe('Hello World')
	})
	
	it('creates a new user', () => {
		const newUser = app.createUser('Billy')
		expect(newUser.name).toBe('Billy')
	})
})
```

Running the above tests outputs the following:

```bash
FAIL  test/app.test.js
  app
    ✓ returns Hello World (1 ms)
    ✕ creates a new user

  ● app › creates a new user

    TypeError: Cannot read properties of undefined (reading 'save')

      at App.createUser (http:/localhost:8:55)
      at Object.createUser (test/app.test.js:17:29)

Test Suites: 1 failed, 1 total
Tests:       1 failed, 1 passed, 2 total
Snapshots:   0 total
Time:        0.42 s, estimated 1 s
```

Notice the `TypeError: Cannot read properties of undefined (reading 'save')` which points to the `app.database.save()` function used in the `createUser()` function.

> It does not complain about `app` being undefined since I defined app in the jest config.

It is complaining about `app.database` being undefined because I never loaded the script into the DOM. Now, while loading the script into the DOM will fix this, I do not want to test `app.database.save`, instead I want to mock it. 

Since I am working with globals, I can simply just set/override the global in test, therefore, "mocking" it.

```js
it('creates a new user', () => {
	// arrange
	global.app.database = {
		save: ({ name }) => ({ id: 1, name: name })
	}
	
	// act
	const newUser = app.createUser('Billy')
	
	// assert
	expect(newUser.name).toBe('Billy')
})
```

Running the tests now produces a successful output.

```bash
PASS  test/app.test.js
  app
    ✓ returns Hello World (1 ms)
    ✓ creates a new user (1 ms)

Test Suites: 1 passed, 1 total
Tests:       2 passed, 2 total
Snapshots:   0 total
Time:        0.408 s, estimated 1 s
```

## Wrapping up

The above solution *seems to* work for the time being. I haven't tested it vigorously yet, but as of now it seems like it will do the job. It was an interesting problem to solve.

While you might think that I can just simply convert this to an ES6 project with modules, it is not as simple as that I am afraid. Of course, the actual project is not what I have above but a real-world enterprise solution which was incredibly over-simplified to illustrate the core which I needed to solve.

I hope you enjoyed this read, and at the very least, I hope this inspired you to keep your projects up to date 🙌.