package pl.project13.scalaslide.gen

import org.scalatest.FlatSpec
import org.scalatest.matchers.ShouldMatchers

/** Generated from [slides.md, from line: 7] */
class Generated_0_Spec extends FlatSpec with ShouldMatchers {

  "Code embedded on slide" should "compile and pass" in {
    // This is what the GoodTool API could report
object GoodToolStats {
    var stats: Map[String, Int] = Map("latency" -> 3, "load" -> 12)
}

// This is how to use the API
object Stats {
    val stats = GoodToolStats.stats
}

Stats.stats should equal (Map("latency" -> 3, "load" -> 12))
  }
}
      