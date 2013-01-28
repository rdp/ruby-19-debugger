--- common.mk.orig	2011-05-17 21:19:20.689620679 -0400
+++ common.mk	2011-05-17 21:19:28.688621223 -0400
@@ -256,7 +256,7 @@
 install-capi: capi pre-install-capi do-install-capi post-install-capi
 pre-install-capi:: install-prereq
 do-install-capi: $(PREP)
-	$(INSTRUBY) --make="$(MAKE)" $(INSTRUBY_ARGS) --install=capi
+	@$(NULLCMD)
 post-install-capi::
 	@$(NULLCMD)
 
