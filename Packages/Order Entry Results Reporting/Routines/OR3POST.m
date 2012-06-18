OR3POST ;SLC/MLI - Post-install for CPRS install ; 8/2/97
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;;Dec 17, 1997
 ;
 ; This post-install is to be run after each of the individual
 ; builds is installed with CPRS version 1.0.  It will queue a
 ; task to convert the orders for all patients once the system
 ; is back on line.
 ;
 ; It will also include the compilation of the order check
 ; expert code
 ;
EN ; post-install code to call order check expert compiler
 ; kill off old/changed cross references on file #100
 ; initialize fields in ORDER PARAMETERS file
 ; queue conversion
 ; fire completion message
 ;
 N X,IDX
 D ^OCXOPOST
 S X=$G(^ORD(100.99,1,"CONV"))
 I '$P(X,"^",1),'$P(X,"^",2) D  ; if conversion hasn't started
 . F IDX="AC","AD","AE","AF","AL","AN","AR","AS","AT" K ^OR(100,IDX)
 . D SET^OR3CONV(1,0) ; initialize completion parameter to no
 . D QUEUE^OR3CONV       ; queue off conversion
 D TIME
 Q
 ;
TIME ; send bulletin of installation time
 N COUNT,DIFROM,I,START,TEXT,XMDUZ,XMSUB,XMTEXT,XMY
 S COUNT=0
 S START=+$G(^XPD(9.7,+$$IEN(),1))
 S XMSUB="Version "_$P($T(PATCH),";;",2)_" Installed"
 S XMDUZ="CPRS PACKAGE"
 F I="G.CPRS INSTALLATION@DOMAIN.NAME",DUZ S XMY(I)=""
 S XMTEXT="TEXT("
 ;
 S X=$P($T(PATCH),";;",2)
 D LINE("Version "_X_" has been installed.")
 D LINE("      Install started:   "_$$FMTE^XLFDT($$FMTE^XLFDT(START)))
 D LINE("      Install complete:  "_$$FMTE^XLFDT($$NOW^XLFDT()))
 ;
 D ^XMD
 Q
 ;
 ;
LINE(DATA) ; set text into array
 S COUNT=COUNT+1
 S TEXT(COUNT)=DATA
 Q
 ;
 ;
IEN() ; return IEN of build listed at line FIRST
 Q $O(^XPD(9.7,"B",$P($T(FIRST),";;",2),0))
 ;
 ;
FIRST ;;ORDER ENTRY/RESULTS REPORTING 3.0
PATCH ;;1.0
