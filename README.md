# Play Decompose
Sample illustrating how to decompose a Play app

As I developed a Play application and the size of my codebase increased, I hit a point where the codebase became too large, unwieldly and difficult to maintain. In fact, in many ways, my code became a mishmosh of at least three apps that organically grew out of one. The realization that the each app was actually distinct and could be separated came some time after initially trying to save time by reusing common code. I looked at several different options to break out my single monolithic app into independent apps and components and finally settled on a strategy that used sbt's multiproject and git's submodules capabilities. Now I can have an app that depends on and reuses other Play apps and manage the lifecycle of each independently. Here's what I learned along the way and here is a redacted version of my boilerplate code that should allow you to get started on decomposing your app.

1. SBT allows you to build multiple projects. It allows you to build from the bottom up, meaning your dependencies are compiled first and then the app that relies on the dependencies. SBT's doc here do a decent job of explaining how it does that.

http://www.scala-sbt.org/0.13/docs/Multi-Project.html