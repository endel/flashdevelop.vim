FlashDevelop features for VIM
===

This plugin aims to provide productive features for editing ActionScript 3.0 files inside your VIM.

It's actually on early development stage, but you can try it and improve it if you feel adventurous.

Requirements
---

* VIM with ruby bindings. (+ruby)
* sprout gem (<code>gem install sprout</code>)
* [vim-rooter](https://github.com/airblade/vim-rooter) plugin
* Custom ctags configuration, as described above.

ctags
---

flashdevelop.vim requires a custom ctags configuration for ActionScript files. 

Copy the contents of <code>support/ctags</code> into your ~/.ctags


Features currently avaible
---

  * Compilation through project-sprouts. (:make)

Keyboard bindings

  * __Leader + N__ - Create a new class
  * __Leader + R__ - Swap between implementation and test classes.
  * __Leader + m__ - Autocomplete
    * If cursor inside a class name:
      * Create a class if it's name isn't defined, otherwise, try to import it.


TODO
---

The first goal of flashdevelop.vim is to implement the [FlashDevelop generation features](http://www.flashdevelop.org/wikidocs/index.php?title=Features:Generation). And provide easy to compile


License
---

This plugin is distributed under the MIT license. Please see the LICENSE file.
