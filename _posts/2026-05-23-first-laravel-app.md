---
layout: post
title: My First Laravel App
date: 2026-04-28 19:00:00 +0200
categories: web
---
For the past 5 years, I have been a React developer. On projects at work, I have built React libraries, micro-frontends with Webpack module federation and web apps with NextJS. 

I have spent a lot of time in the JS/NodeJS world. However, when I started my career back in 2018 with freelancing, my go-to language was PHP. Because I could deploy it onto a shared Linux server on [Xneelo](https://xneelo.co.za).

Now since then, I moved onto building backends with .NET or Java Spring Boot at work.

All this to say, I haven't worked with PHP in 5 years.

So when I discovered [Laravel](https://laravel.com/) recently, I was really excited.

I know Laravel has been around for quite some time, but for me, it is new. So I dived into a quick [getting started guide](https://laravel.com/learn/getting-started-with-laravel), and I enjoyed it.

Here is what I've learned.

### Fulfilling my dream as a composer

With a NodeJS project, you have a `package.json` file and you run `npm install x` to install a new dependency.

PHP offers something similar. PHP offers you `composer`.

So to install Laravel project, I ran the below command:

```
composer global require laravel/installer
```

Then after installing Laravel, I can spin up a new project with the below command:

```
laravel new example-app
```

### Main folders

With Laravel, there are many folders and files from the start which was a bit overwhelming. Spending some time in that guide has made it a bit easier to navigate.

### MVC

Starting from the top, there is the `app` folder. Within this folder, there are `controllers`, `models`,  `policies` and `providers`.

> I am not sure what `providers` are. I haven't gotten that far yet.

This Laravel project works with MVC pattern which is:

- **Models** - Handle business and data logic
- **View** - The actual HTML the user sees
- **Controller** - Handles requests and acts as the bridge between the view and the model

### Databases

This is really cool. Laravel comes with a built-in ORM ([Eloquent ORM](https://laravel.com/docs/5.0/eloquent)) and with this ORM, I could generate migrations for the database.

To generate a new migration, I ran the below command:

```bash
php artisan make:migration create_chirps_table
```

Laravel then creates a file that looks like this:

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('chirps', function (Blueprint $table) {
            $table->id();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('chirps');
    }
};
```

Two functions in this file:

- `up()` - This will create tables, indexes, and other db related things.
- `down()` - This will revert whatever the `up` function did.

To then apply a migration, I ran this command:

```
php artisan migrate
```

### Blade Templates

This was the most refreshing part for me. No weird state management, no hooks, no new massive syntax change and learning curve. Just basic HTML and PHP with some handlebar syntax.

```php
<!-- Feed -->
<div class="space-y-4 mt-8">
	@forelse ($chirps as $chirp)
		<x-chirp :chirp="$chirp" />
	@empty
		<div class="hero py-12">
			<div class="hero-content text-center">
				<div>
					<p class="mt-4 text-base-content/60">No chirps yet. Be the first to chirp!</p>
				</div>
			</div>
		</div>
	@endforelse
</div>
```

### Easy Auth

Laravel offers many cool features out of the box and one of them is built in authentication and authorization.

Explaining it is kind of an article on its own but these two commits showcase what it looks like:

1. [Sign up](https://github.com/hercobezuidenhout/chirper/commit/98654741b23a514fd7327cae3763444addaaa304)
2. [Login](https://github.com/hercobezuidenhout/chirper/commit/e7e2b0d04e287e70e9acbca1771fda9e3779deca)

## Quick rant on AI

What attracted me to Laravel in the first place was its slogan:

***The web framework for artisans***

And I was like yeah... that sounds awesome. I want to be an artisan.

Well, AI is forcing itself into every corner of my laptop screen and it seems the investors behind Laravel have finally gotten their way as well because Laravels new slogan is:

The clean stack for Artisans and agents

***Disgusting.***

## Last sip of tea

There is a lot more that I can do with Laravel and I look forward to building my first project in Laravel. I plan to build something inspired by [GoodBudget](https://goodbudget.com/).

The only question I have left is, how feasible is a shared-linux server on [Xneelo](https://xneelo.co.za/) for a Laravel project?

I will probably host it locally and expose it through Cloudflare Tunnels.

Anyway, cheers!