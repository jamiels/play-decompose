name := """foobar"""

version := "1.0-SNAPSHOT"

lazy val submodule1 = (project in file("modules/submodule1")).enablePlugins(PlayJava, PlayEbean)
lazy val submodule2 = (project in file("modules/submodule2")).enablePlugins(PlayJava, PlayEbean).dependsOn(submodule1).aggregate(submodule1)
lazy val root = (project in file(".")).enablePlugins(PlayJava, PlayEbean).dependsOn(submodule1,submodule2).aggregate(submodule1,submodule2)

scalaVersion := "2.11.7"

libraryDependencies ++= Seq(
  javaJdbc,
  cache,
  javaWs
)

libraryDependencies += evolutions
