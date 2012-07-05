import sbt._
import sbt.Keys._
import pl.project13.scalaslide.ScalaSlideKeys._
import pl.project13.scalaslide.ScalaSlideTasks._

object Resolvers {
  val smsserResolvers = Seq(
    "Sonatype Releases" at "http://oss.sonatype.org/content/repositories/releases",
    "Typesafe Releases" at "http://repo.typesafe.com/typesafe/releases",
    "EasyTesting Releases" at "http://repo1.maven.org/maven2/org/easytesting"
  )
}

object Versions {
  val knockoff = "0.8.0-16"
  val guava = "12.0"
  val rainbow = "0.1"

  val mockito = "1.8.5"
  val scalatest = "1.7.RC1"

  val fest = "1.4"
}

object Dependencies {
  import Resolvers._
  import Versions._

  val knockoff                = "com.tristanhunt"         %% "knockoff"                  % Versions.knockoff
  val guava                   = "com.google.guava"         % "guava"                     % Versions.guava

  val scalaTest               = "org.scalatest"           %% "scalatest"                 % Versions.scalatest % "test"
  val mockito                 = "org.mockito"              % "mockito-core"              % Versions.mockito   % "test"

  val rainbow                 = "pl.project13.scala"      %% "rainbow"                   % Versions.rainbow

  // java stuff
  val festAssert              = "org.easytesting"          % "fest-assert"               % Versions.fest      % "test"

}

object BuildSettings {
  import Resolvers._
  import Dependencies._

  val dependencies  = Seq(
    knockoff,
    guava,
    rainbow,
    scalaTest,
    mockito
  )

  val buildSettings = Defaults.defaultSettings ++
    Seq(
      parallelExecution in Global := false,
      organization := "pl.project13.scalaslide",
      name         := "scalaslide",
      version      := "0.1",
      scalaVersion := "2.9.1",
      resolvers    ++= Resolver.withDefaultResolvers(smsserResolvers, mavenCentral = true, scalaTools = false),
      libraryDependencies ++= dependencies
    )
}

object AndroidBuild extends Build {
  import Dependencies._
  import BuildSettings._

  lazy val root = Project (
    "scalaslides",
    file("."),
    settings = buildSettings ++ scalaslideSettings ++
      Seq (
      )
  )
}
