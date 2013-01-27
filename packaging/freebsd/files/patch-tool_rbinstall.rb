--- tool/rbinstall.rb.orig	2011-07-30 07:19:11.000000000 -0700
+++ tool/rbinstall.rb	2011-11-19 00:08:56.000000000 -0800
@@ -292,6 +292,7 @@
 
 bindir = CONFIG["bindir"]
 libdir = CONFIG["libdir"]
+libdatadir = CONFIG["prefix"] + "/" + "libdata"
 archhdrdir = rubyhdrdir = CONFIG["rubyhdrdir"]
 archhdrdir += "/" + CONFIG["arch"]
 rubylibdir = CONFIG["rubylibdir"]
@@ -349,7 +350,7 @@
 install?(:local, :arch, :data) do
   pc = CONFIG["ruby_pc"]
   if pc and File.file?(pc) and File.size?(pc)
-    prepare "pkgconfig data", pkgconfigdir = File.join(libdir, "pkgconfig")
+    prepare "pkgconfig data", pkgconfigdir = File.join(libdatadir, "pkgconfig")
     install pc, pkgconfigdir, :mode => $data_mode
   end
 end
