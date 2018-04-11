# Cobbler

Purpose: Cobbler will scrape Data.com Connect and LinkedIn for company employees and output usernames in the format of your choice for use in password spray attacks.

Author:  Steve Campbell, @lpha3ch0

### Prerequisites

Obviously you'll need LinkedIn and/or Data.com Connect (https://connect.data.com) accounts. If you don't have one or the other, you can choose to disable either one during runtime.

This script was designed to use the Chrome browser and webdriver.
If you want to use a different browser, you'll need to modify lines 5 and 30.

Download and install browser drivers from http://watir.com/guides/drivers/

To change from Chrome driver to another, modify lines 5 and 30.
Example to change from Chrome to Firefox:

From:
```
browser = Watir::Browser.new :chrome
```
To:
```
browser = Watir::Browser.new :firefox
```

Install Ruby gems:
```
gem install nokogiri, watir
```

If you experience errors while installing the nokogiri gem on Ubuntu or Kali, this sometimes helps:

```
sudo apt-get install build-essential patch ruby-dev zlib1g-dev liblzma-dev
```

### Usage

No need to worry about figuring out cli options, you'll be prompted for choices.
```
ruby Cobbler.rb
```
Easy-Peasy!

![Example Usage](https://github.com/MooseDojo/Cobbler/blob/master/Monosnap%202018-04-11%2017-54-28(1).jpg)

After answering the prompts, you'll see the browser open and navigate the sites. When it's finished you can find the list of usernames in the output file.

### ToDo:

This project was done in a day while learning how to scrape websites using Ruby and Watir. The code is crude and not object-oriented. Future revisions will make use of objects and will clean up the code.

Switch from functions to objects with methods.

Bundle gems

Your testing and feedback is appreciated!

