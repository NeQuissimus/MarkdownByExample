package pl.project13.scalaslide

import sbt._
import sbt.InputKey
import sbt._

trait ScalaSlideKeys {

  val ScalaSlide = config("scalaslide")

  val landslideTheme = SettingKey[String](
    "landslide-theme",
    "Theme name to use for slides. Available: default, light, tango."
  )

  val slidesDir = SettingKey[File](
    "slides-directory",
    "Root directory where slides.md should be in. Themes and other resources should also reside in there."
  )

  val extractTestsTask = TaskKey[Unit](
    "extract-tests",
    "Extracts test code from the presentation files, such extracted tests may be run with test:test"
  )

  val cleanTask = TaskKey[Unit](
    "clean",
    "Clean generated tests and presentation files"
  )

  val genTask = InputKey[Unit](
    "gen",
    "Generates the presentation html and pdf versions"
  )
}

object ScalaSlideKeys extends ScalaSlideKeys
