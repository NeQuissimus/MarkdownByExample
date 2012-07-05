ScalaSlide
==========

<h2>ScalaSlide - automated slides testing framework</h2>
On a side note, the presentation itself is compiled. And not in the sense of "plain markdown to html"!

<strong>The presentation is actually an sbt build which extracts all Scala source code from the slides and runs tests with them!</strong>

This way I am 100% sure that the presented material both compiles and passes tests :-) Like the idea? Check out the sources on: <a href="https://github.com/ktoso/scalaslide">https://github.com/ktoso/scalaslide</a>.

Here's an example of a run of the sbt build. You just type: `scalaslide:gen [options for landslide]` and here's what you get:

<a href="http://www.blog.project13.pl/wp-content/uploads/2012/06/scalaslide.png"><img class="aligncenter size-full wp-image-1620" title="scalaslide" src="http://www.blog.project13.pl/wp-content/uploads/2012/06/scalaslide.png" alt="" width="597" height="241" /></a>

Here's a quick feature list of what scalaslide can do for you:
<ul>
  <li><strong>generated test</strong> code for each of <strong>!scala</strong> code blocks in your slides.md file. I'm using ScalaTest, but you can use any framework you want.</li>
  <li>the tests are then run and the presentation will not be generated until all tests pass. <strong>Test Driven Presentation Development!</strong></li>
  <li>it works with sbt's awesome <strong>~</strong> feature, also known as "watch resources". So it will <strong>automatically recompile</strong> and run tests (and generate the presentation if they pass) <strong>each time the slides.md file changes</strong>! This allows to have a great flow while building the presentation on one display, and watching it "generated" on another.</li>
  <li>it uses google's <strong>landslide</strong> to generate the presentation, so it's nicely browsable from your browser.</li>
  <li>landslide can also generate a <strong>pdf version</strong> of the slides if needed - for handouts for example</li>
</ul>

Dependencies of ScalaSlide
--------------------------
You will need: 

* [sbt](https://github.com/harrah/xsbt) - scala's simple build tool
* [landslide](https://github.com/adamzap/landslide) - for generating the presentation

The Presentation
----------------
Was prepared and given by me at AGH - University of Science and Technology Kraków in May 2012.
It's under Creative Commons BY, and there's a video online of the talk (although in polish): http://www.blog.project13.pl/index.php/coding/1606/scala-presentation-at-agh-university-of-science-and-technology/

License
-------
Just make sure you notice me (konrad.malawski@project13.pl) or my blog; blog.project13.pl somewhere if you use this ;-)
I'll copy paste a detailed license later...
