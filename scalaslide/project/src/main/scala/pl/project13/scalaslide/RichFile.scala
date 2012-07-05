package pl.project13.scalaslide

import java.io._
import scala.io._

class RichFile(file: File) {

  def text = Source.fromFile(file).mkString

  def text_=(s: String) {
    val out = new PrintWriter(file)
    try {
      out.print(s)
    } finally {
      out.flush()
      out.close()
    }
  }
}

object RichFile {
  implicit def enrichFile(file: File) = new RichFile(file)
}
