qlvega
----------

macOS QuickLook Plugin

Introduction
------------

qlvega is a QuickLook generator for Vega and Vega-Lite files. It renders the visualization of the selected file using the vl2svg or vg2svg binaries provided with vega-lite and vega.


Prerequisite
------------

`npm i -g vega vega-lite`

Make sure vl2svg and vg2svg are in your PATH before invoking qlvega.



Installation
------------

Copy the qlvega.qlgenerator to `~/Library/QuickLook`,


To uninstall, simply remove the qlgenerator file mentioned above.

If Homebrew Cask is preferred, then:

`$ git clone https://github.com/invokesus/qlvega.git`

`$ cd qlvega`

`$ brew cask install ./qlvega.rb`



Downloads
---------

Source code is available at <http://github.com/invokesus/qlvega>


Limitations
----------

Currently all json files are treated as vega or vega-lite files. This will be fixed very soon.


Acknowledgements
----------------
The QLColorCode project by derzzle and its fork maintained by
anthonygelibert.


