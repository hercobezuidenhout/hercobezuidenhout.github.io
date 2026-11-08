---
title: Exploring Nushell
date: 2026-11-11
categories: []
tags: []
layout: post
excerpt: This week I learned about Nushell and I decided to play around with it a little bit.
---
This week I learned about nushell which I pronounce as *new shell*. I don't know if that is correct. 

Now I am going to be completely honest with you. Although I am a senior software engineer and I have been writing code professionally since 2018, I never realised that a *shell* and a *terminal* is two different things. I spent a short couple minutes scanning through this [Reddit link](https://www.reddit.com/r/commandline/comments/10r4squ/what_is_the_difference_between_terminalshell/) for research and the conclusion is that a *shell* is a program that is installed on your machine that *interprets* your commands and does things on your machine just like any other program. The *terminal* is a program on your machine that let's you interact with the *shell*.

Each operating system is shipped with its own default terminal and shell. 

- MacOS - Terminal.app and Z shell
- Windows 11 - Windows Terminal and PowerShell
- Ubuntu - GNOME Terminal and Bash

Many developers though decide to replace their boring built-in shell and terminal with some third-party ones including iTerm2 and Nushell or Fish.

Now I already knew about iTerm2 but this week I heard about Nushell for the first time and from a comment on my [Bluesky post](https://bsky.app/profile/herco.bsky.social/post/3mznue5yglc2q) I learned about Fish as well. I will write about Fish another time. 

Therefore, I thought it is a good idea to play aroud with Nushell and write about it.

So here we go.

## Nushell - A new type of shell

When I visit their [website](https://www.nushell.sh/) I am delighted by the fresh, simple UI. No fancy moving blocks in the background any AI-generated gradients. Just a simple website giving me all the information I need.

It seems like the big hook for using Nushell is that it supports *data* and *everything is data*.

To install Nushell is simple. I can use [Homebrew](https://brew.sh/).

> BTW while writing this post I learned that Homebrew can be installed on linux. It changed my life.

```
brew install nushell
```

You can also use `nix` which I am not too familiar. I have heard about it before, coincidentally the same person who told me about Nushell told me about Nix as well.

After I installed Nushell, I went through their [Quick Tour](https://www.nushell.sh/book/quick_tour.html) page to learn more about how to use Nu and what it can do. 

Of course, the first command is `ls`.

However, when I typed `ls` into my terminal, I did not get the output I expected. So I investigated. Homebrew installs nu somewhere here: 

```
/home/linuxbrew/.linuxbrew/bin/nu
```

So I could add this to my `PATH` so that its the default but since I was just trying it out and exploring, I ran that command directly in my terminal which started a new shell session. This time, a nushell session and when I typed `ls` this time, I got the response I was expecting. 

```
~ ls
╭────┬──────────────┬──────┬────────┬────────────────╮
│  # │     name     │ type │  size  │    modified    │
├────┼──────────────┼──────┼────────┼────────────────┤
│  0 │ 404.html     │ file │  416 B │ a month ago    │
│  1 │ Gemfile      │ file │ 1,2 kB │ a month ago    │
│  2 │ Gemfile.lock │ file │ 4,6 kB │ a month ago    │
│  3 │ _config.yml  │ file │ 2,0 kB │ a month ago    │
│  4 │ _drafts      │ dir  │ 4,0 kB │ 41 minutes ago │
│  5 │ _excalidraw  │ dir  │ 4,0 kB │ an hour ago    │
│  6 │ _includes    │ dir  │ 4,0 kB │ a month ago    │
│  7 │ _layouts     │ dir  │ 4,0 kB │ a month ago    │
│  8 │ _posts       │ dir  │ 4,0 kB │ 41 minutes ago │
│  9 │ _sass        │ dir  │ 4,0 kB │ a month ago    │
│ 10 │ _templates   │ dir  │ 4,0 kB │ a month ago    │
│ 11 │ about.md     │ file │ 2,0 kB │ a month ago    │
│ 12 │ assets       │ dir  │ 4,0 kB │ an hour ago    │
│ 13 │ index.md     │ file │  175 B │ a month ago    │
╰────┴──────────────┴──────┴────────┴────────────────╯
```

Now the `ls` commands outputs data in a table format by default. This can be piped into other functions (or commands to be correct) that then *act on that data*. 

```
~ ls | sort-by size | reverse
╭────┬──────────────┬──────┬────────┬────────────────╮
│  # │     name     │ type │  size  │    modified    │
├────┼──────────────┼──────┼────────┼────────────────┤
│  0 │ Gemfile.lock │ file │ 4,6 kB │ a month ago    │
│  1 │ assets       │ dir  │ 4,0 kB │ an hour ago    │
│  2 │ _templates   │ dir  │ 4,0 kB │ a month ago    │
│  3 │ _sass        │ dir  │ 4,0 kB │ a month ago    │
│  4 │ _posts       │ dir  │ 4,0 kB │ 44 minutes ago │
│  5 │ _layouts     │ dir  │ 4,0 kB │ a month ago    │
│  6 │ _includes    │ dir  │ 4,0 kB │ a month ago    │
│  7 │ _excalidraw  │ dir  │ 4,0 kB │ an hour ago    │
│  8 │ _drafts      │ dir  │ 4,0 kB │ 44 minutes ago │
│  9 │ about.md     │ file │ 2,0 kB │ a month ago    │
│ 10 │ _config.yml  │ file │ 2,0 kB │ a month ago    │
│ 11 │ Gemfile      │ file │ 1,2 kB │ a month ago    │
│ 12 │ 404.html     │ file │  416 B │ a month ago    │
│ 13 │ index.md     │ file │  175 B │ a month ago    │
╰────┴──────────────┴──────┴────────┴────────────────╯
```

Not only can you sort using nushell's built-in `sort-by` command but you can also try and find data using the `where` command. 

```
~ ls | where size > 2kb
╭────┬──────────────┬──────┬────────┬─────────────╮
│  # │     name     │ type │  size  │  modified   │
├────┼──────────────┼──────┼────────┼─────────────┤
│  0 │ Gemfile.lock │ file │ 4,6 kB │ a month ago │
│  1 │ _config.yml  │ file │ 2,0 kB │ a month ago │
│  2 │ _drafts      │ dir  │ 4,0 kB │ an hour ago │
│  3 │ _excalidraw  │ dir  │ 4,0 kB │ an hour ago │
│  4 │ _includes    │ dir  │ 4,0 kB │ a month ago │
│  5 │ _layouts     │ dir  │ 4,0 kB │ a month ago │
│  6 │ _posts       │ dir  │ 4,0 kB │ an hour ago │
│  7 │ _sass        │ dir  │ 4,0 kB │ a month ago │
│  8 │ _templates   │ dir  │ 4,0 kB │ a month ago │
│  9 │ about.md     │ file │ 2,0 kB │ a month ago │
│ 10 │ assets       │ dir  │ 4,0 kB │ an hour ago │
╰────┴──────────────┴──────┴────────┴─────────────╯
```

Now this was just me playing aroud but you can also combine the above two commands.

```
~ ls | where size > 2kb | sort-by size | reverse
╭────┬──────────────┬──────┬────────┬─────────────╮
│  # │     name     │ type │  size  │  modified   │
├────┼──────────────┼──────┼────────┼─────────────┤
│  0 │ Gemfile.lock │ file │ 4,6 kB │ a month ago │
│  1 │ assets       │ dir  │ 4,0 kB │ an hour ago │
│  2 │ _templates   │ dir  │ 4,0 kB │ a month ago │
│  3 │ _sass        │ dir  │ 4,0 kB │ a month ago │
│  4 │ _posts       │ dir  │ 4,0 kB │ an hour ago │
│  5 │ _layouts     │ dir  │ 4,0 kB │ a month ago │
│  6 │ _includes    │ dir  │ 4,0 kB │ a month ago │
│  7 │ _excalidraw  │ dir  │ 4,0 kB │ an hour ago │
│  8 │ _drafts      │ dir  │ 4,0 kB │ an hour ago │
│  9 │ about.md     │ file │ 2,0 kB │ a month ago │
│ 10 │ _config.yml  │ file │ 2,0 kB │ a month ago │
╰────┴──────────────┴──────┴────────┴─────────────╯
```

## It is not bash

Nushell's commands are very similar to bash and other shells and it is apparently easy to forget that it is not bash. According to Nushell's documentation, it is both a shell and a programming language. For example, in bash you would write `echo "hello" > output.txt` but in nu the `>` operator is used as a greater than, for example

```
4 > 10 // equals false
```

So with nu,  a pipe would make more sense.

```
"hello" | save output.txt
```

Every command in nushell returns something, even if it is implicitely. For example `echo "Hello World"` returns *Hello World* and nu renders that return value while in other shells, echo just sends a value to the standard output. 

So nushell advises users to think of it as a compiled language, rather than another shell. Each nushell code goes through two stages.

1. Parsing
2. Evaluation

This enables it to give better error messages as well at each stage.

## Conclusion

The question I am still asking myself is why would I use Nushell over Bash. It has some neat features and I haven't even scratched the surface of all of its features. I have not spent much time in the world of shell scripts so I struggle to see the benefits. That is what this exploration has taught me though, that I need to broaden my horizons a little bit more. 

I like Nushell and I will be using it for a couple weeks to try and get more familiar with it and hopefully, I will be able to answer why I would use Nushell over Bash.

