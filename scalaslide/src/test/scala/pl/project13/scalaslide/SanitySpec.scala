package pl.project13.scalaslide

import org.scalatest.FlatSpec
import org.scalatest.matchers.ShouldMatchers

class SanitySpec extends FlatSpec with ShouldMatchers {

  behavior of "SanitySpec"

  it should "pass" in {
    true should equal (true)
  }

}
