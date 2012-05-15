!SLIDE

# GoodTool

!SLIDE WhatIsGoodTool

## What is GoodTool?

GoodTool makes system monitoring easier than **ever before** and is available for _Windows_ and _Linux_ operating systems.

!SLIDE bullets incremental

## Features

* Fast
* Secure
* Easy-to-work-with GUI

!SLIDE bullets incremental

## Installation

1. Download GoodTool
2. Execute .exe or .sh file
3. Follow screen instructions

!SLIDE center transition=slide

![GUI Screenshot](GoodToolGui.png "Screenshot")

!SLIDE transition=zoom

## API examples

!SLIDE code

### Access to API factory (Java)

Get the API factory: `GoodTool api = GoodTool.getAPI();`

!SLIDE code

### Usage of API factory (Java)

Set monitoring of only one CPU thread:

    @@@ java
    GoodTool api = GoodTool.getAPI();
    api.setMonitoredThreads(1);

!SLIDE commandline incremental

## Commandline interface

    $ goodtool start
    GoodTool 1.0 has been started
    $ goodtool stop
    GoodTool 1.0 has been shut down

!SLIDE

## Contact

Go to our website <http://nequissimus.com/> or email to <steinbach.tim@googlemail.com>

<script>
$(".WhatIsGoodTool").bind("showoff:show", function (event) {
  var flash = $(event.target).find("strong");
  flash.delay(500).fadeOut(1000).fadeIn(1000).fadeOut(1000).fadeIn(1000);
});
</script>
<link rel="stylesheet" type="text/css" media="screen" href="./sh.css">
