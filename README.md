# Play Decompose
# Multiproject / submodules for Play using SBT and Git

As I developed a Play application and the size of my codebase increased, I hit a point where the codebase became too large, unwieldly and difficult to maintain. In fact, in many ways, my code became a mishmosh of at least three apps that organically grew out of one. The realization that each app was actually distinct and could be separated came some time after initially trying to save time by reusing common code. I looked at several different options to break out my single monolithic app into independent apps and components and finally settled on a strategy that used sbt's multiproject and git's submodules capabilities. Now I can have an app that depends on and reuses other Play apps and manage the lifecycle of each independently. Here's what I learned along the way and you'll find in the repository a redacted version of my boilerplate code that should allow you to get started on decomposing your app.

1. SBT allows you to build multiple projects. It allows you to build from the bottom up, meaning your dependencies are compiled first and then the app that relies on the dependencies. SBT's docs do a decent job of explaining how it does that. See here: http://www.scala-sbt.org/0.13/docs/Multi-Project.html

2. Git allows you to check out submodules. This is very useful when you wish to selectively add common code or another Play subproject to your main project. The command is something like this:

    git submodule add https://github.com/jamiels/submodule1

    The way I use this is I add a modules folder in the root of my Play app (Let's call it fooapp) and then from within the modules folder I can clone a submodule. The main fooapp is unaffected by the addition of the module accept that Git is now aware that it is a submodule within the Git fooapp project. 
    
    https://github.com/jamiels/play-decompose/tree/master/foobar
    
    https://github.com/jamiels/submodule1
    
    https://github.com/jamiels/submodule2

3. SBT allows you to combine and aggregate subprojects (or submodules, in Git speak). The benefit of this is that you can aggregate controllers, views, models etc. as if they were are all a single app. I found this extremely useful. In fact, even the routes.conf file is aggregated as if there is one routes file (more on how to do this later, there are some things you need to do)

4. The subprojects do not have a projects folder or anything in the conf folder except the routes file. The main project's (i.e fooapp) applicaton.conf covers all the subprojects. Each subjproject, however, will have its own build.sbt file. The difference between fooapp's build.sbt file and a subproject's build.sbt is that the project var is defined only in the fooapp build.sbt file. Assuming you had two subprojects, your fooapp build.sbt would look like this:

        lazy val submodule1 = (project in file("modules/submodule1")).enablePlugins(PlayJava, PlayEbean)
        lazy val submodule2 = (project in file("modules/submodule2")).enablePlugins(PlayJava, PlayEbean).dependsOn(submodule1).aggregate(submodule1)
        lazy val root = (project in file(".")).enablePlugins(PlayJava, PlayEbean).dependsOn(submodule1,submodule2).aggregate(submodule1,submodule2)

    The SBT functions dependsOn and aggregate do the trick. dependsOn establishes the dependency and aggregate pulls it together as one app. SBT will then build from the bottom of the dependency chain up to the main fooapp.

5. The routes file in each of the submodules cannot be named routes.conf and need to be renamed. I renamed mines to submodule1-routes.conf, submodule2-routes.conf, etc. In the routes file of the main app, you'll need to include the routes file of the submodules. This is easy to do and is done simply by placing this at the top of your routes file:

    ->      /submodule1              				submodule1.Routes

6. Routes to the submodule are accessed by /submodule1 in the URL. So, for example, you have a route /loadUser in your routes.conf and /viewSubmodule1User in your submodule1-routes.conf, to access the route from your browser you would use /submodule1/viewSubmodule1User. This is handled automatically for you by Play. Assets are also accessed in a similar manner i.e. /submodule1/assets points to the /public folder in the submodule1 subproject.

7. If you have any Ebean models in the subprojects, make sure to include the below in your build.sbt. I have chosen to store my subproject models in packages named according to the subproject, i.e. models.submodule1. 

    playEbeanModels in Compile := Seq("models.submodule1.*")
    
8. Remember, there will be only one application.conf at the fooapp level. The conf folder in the subprojects do not contain application.conf but only a routes file.
    
Jamiel Sheikh
hello@overridelabs.com

