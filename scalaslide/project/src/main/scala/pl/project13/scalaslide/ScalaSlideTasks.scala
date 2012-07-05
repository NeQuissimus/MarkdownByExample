
package pl.project13.scalaslide

import sbt._
import sbt.complete
import sbt.Keys._
import sbt.TaskKey
import io.Source
import java.text.SimpleDateFormat
import java.util.Date
import java.io.{FileNotFoundException, PrintWriter, File => JFile}
import annotation.tailrec

object ScalaSlideTasks extends ScalaSlideKeys {

  val scalaslideSettings = Seq[Setting[_]](
    slidesDir in ScalaSlide := file("src/main/slides"),
    watchSources := Seq(file("src/main/slides")),
    landslideTheme in ScalaSlide := "light",
    extractTestsTaskDef,
    cleanTaskDef,
    genTask in ScalaSlide <<= genTaskDef
  )

  val slides_md = file("src/main/slides/slides.md")
  val genDir = file("src/test/scala/pl/project13/scalaslide/gen/")

  val presentation_html = file("presentation.html")
  val presentation_pdf = file("presentation.pdf")

  import com.tristanhunt.knockoff.DefaultDiscounter._
  import com.tristanhunt.knockoff._

  lazy val cleanTaskDef = cleanTask in ScalaSlide := {
    
    if (!genDir.exists) genDir.mkdirs

    val generatedTests = genDir.listFiles

    println("Cleaning up [%d] generated test files...".format(generatedTests.size))
    generatedTests foreach { _.delete() }
    println("Finished cleaning up")

  }

  lazy val extractTestsTaskDef = extractTestsTask in ScalaSlide := {
    val slidesText = io.Source.fromFile(slides_md).getLines().mkString("\n")

    val blocks = knockoff(slidesText)
    val scalaCodeBlocks = blocks filter { it => it.isInstanceOf[CodeBlock] && it.toString.contains("!scala")} map { _.asInstanceOf[CodeBlock] }

    println("Found [%s] scala code blocks!".format(String.valueOf(scalaCodeBlocks.size)))

    scalaCodeBlocks.zipWithIndex foreach { case (code, testIndex) =>
      writeTestToFile(testIndex, code)
    }
  }

  lazy val genTaskDef = inputTask { (argTask: TaskKey[Seq[String]]) =>
    (argTask, scalaVersion, baseDirectory, projectID, landslideTheme in ScalaSlide, cleanTask in ScalaSlide, extractTestsTask in ScalaSlide, test in Test) map {
      (args, sv, bd, pid, theme, _, _, _) =>

      import Process._
      val landslideCommand = "landslide %s --theme %s -d %s %s"
        .format(args.mkString(" "), theme, presentation_html.getAbsolutePath, slides_md.getAbsolutePath)

      val fullCommand = landslideCommand

      println("Executing: " + fullCommand)
      fullCommand.!

      ()
    }
  }

  private def writeTestToFile(generatedSpecNumber: Long, code: CodeBlock) {
    import RichFile._

    val name = "Generated_%d_Spec".format(generatedSpecNumber)

    val testFile: java.io.File = file("%s/%s.scala".format(genDir.getAbsolutePath(), name))
    testFile.createNewFile()

    val preparedCode = code.text.content.split("\n").drop(1).mkString("\n")

    println("Generating test class [%s] with following code to test:".format(testFile.getName))
    println("-------------------")
    println(preparedCode)
    println("-------------------")

    testFile.text =
      """|package pl.project13.scalaslide.gen
        |
        |import org.scalatest.FlatSpec
        |import org.scalatest.matchers.ShouldMatchers
        |
        |/** Generated from [%s] */
        |class %s extends FlatSpec with ShouldMatchers {
        |
        |  "Code embedded on slide" should "compile and pass" in {
        |    %s
        |  }
        |}
      """.stripMargin.format("slides.md, from line: "+ code.position.line, name, preparedCode)
  }
}
