## Istruzioni per il download via SVN del progetto ##

Prerequisiti:
  * Java JDK (SE) -> **[Download](http://java.sun.com/javase/downloads/widget/jdk6.jsp)**
  * Eclipse for Java EE -> **[Download](http://www.eclipse.org/downloads/packages/eclipse-ide-java-ee-developers/galileosr2)**
  * Plugin Eclipse per Subversioning (es: **[Subclipse](http://subclipse.tigris.org/servlets/ProjectProcess?pageID=p4wYuA)**, **[Subversive](http://www.eclipse.org/subversive/downloads.php)**)
  * Oracle/PostgreSQL + Tomcat v6.0 -> **[Guida](http://code.google.com/p/lmadb/wiki/ConfigurazioneTomcatOraclePostgres)**


#### SVN checkout ####

Eclipse -> File -> New -> Project -> SVN -> Project from SVN<br>
Create a new repository location<br>
<blockquote>URL: <a href='http://lmadb.googlecode.com/svn'>http://lmadb.googlecode.com/svn</a>
<i>Next</i></blockquote>

Select resource<br>
<blockquote>URL: <a href='http://lmadb.googlecode.com/svn/trunk'>http://lmadb.googlecode.com/svn/trunk</a>
Revision: Head revision<br>
<i>Finish</i></blockquote>

Checkout as a project with tha name specified<br>
<blockquote>name: lmadb<br>
<i>Finish</i>