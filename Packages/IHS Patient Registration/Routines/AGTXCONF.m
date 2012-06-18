AGTXCONF ;IHS/ASDS/EFG - CONFIGURE AGTX FOR BEFORE or AFTER P14 ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
INTRO ;
 ;;In an attempt to foresee unknown configurations, this option
 ;;allows you to toggle the before and after Patch 14 export
 ;;formats.  This is done simply by restoring 7 routines that
 ;;were saved before the KIDS install of Patch 14.
 ;;
 ;;Before the install of Patch 14, 7 routines were saved into the
 ;;"AGTXX*" namespace.  After the install of Patch 14, the same 7
 ;;patched routines were saved into the "AGTXZ*" namespace.
 ;;  
 ;;Don't worry, you won't be asked for namespaces.  You'll just be
 ;;asked for the 'BEFORE P14' or 'AFTER P14' configuration.
 ;;###
 D HELP^XBHELP("INTRO","AGTXCONF")
 NEW AGCONFIG
 S AGCONFIG=$$CONFIG
 W !!,"It appears that your current configuration is '",AGCONFIG," P14'."
 I AGCONFIG="UNKNOWN" W !,"I don't know what to do.",!,"Some of the 7 are 'BEFORE' and some are 'AFTER'.",!,"You better call for help....." Q
 W !,"Do you want to change your export formats to '",$S(AGCONFIG="AFTER":"BEFORE",1:"AFTER")," P14'?"
 Q:'$$DIR^XBDIR("YO","Proceed","N","","Do you want to change your export formats to '"_$S(AGCONFIG="AFTER":"BEFORE",1:"AFTER")_" P14'? (Y/N)")
 D @$S(AGCONFIG="AFTER":"BEFLOD",1:"AFTLOD")
 Q
BEFLOD ;Restore the before p14 routines.
 NEW AG,XCN,XCNP,DIE,DIF
 F AG=1:1:7 D KT S X=$P($T(BEF+AG),";",4),(XCN,XCNP)=0,(DIE,DIF)="^TMP(""AGTXCONF"",$J," W !,"Loading '",X,"'..." X ^%ZOSF("LOAD") S X=$P($T(BEF+AG),";",3) X ^%ZOSF("SAVE") W "Saved as '",X,"'."
 D KT
 Q
AFTLOD ;Restore the after p14 routines.
 NEW AG,XCN,XCNP,DIE,DIF
 F AG=1:1:7 D KT S X=$P($T(AFT+AG),";",4),(XCN,XCNP)=0,(DIE,DIF)="^TMP(""AGTXCONF"",$J," W !,"Loading '",X,"'..." X ^%ZOSF("LOAD") S X=$P($T(AFT+AG),";",3) X ^%ZOSF("SAVE") W "Saved as '",X,"'."
 D KT
 Q
KT KILL ^TMP("AGTXCONF",$J)
 Q
CONFIG() ;
 NEW AGP,Y
 S Y=""
 F AG=1:1:7 S X=$P($T(BEF+AG),";",3) F AGP=14:1 Q:'$$INSTALLD^AG6P16("AG*6.0*"_AGP)  S Y=Y_($P($T(+2^@X),";",5)[AGP)
 Q $S('Y:"BEFORE",1:"AFTER")
BEF ;These are the "before p14" routines.
 ;;AGTX1;AGTXX1
 ;;AGTX2;AGTXX2
 ;;AGTX3;AGTXX3
 ;;AGTX4;AGTXX4
 ;;AGTX5;AGTXX5
 ;;AGTXST;AGTXX6
 ;;AGTXTAPE;AGTXX7
AFT ; These are the "after p14" routines.
 ;;AGTX1;AGTXZ1
 ;;AGTX2;AGTXZ2
 ;;AGTX3;AGTXZ3
 ;;AGTX4;AGTXZ4
 ;;AGTX5;AGTXZ5
 ;;AGTXST;AGTXZ6
 ;;AGTXTAPE;AGTXZ7
 ;
BEFSAV ;EP - From P14 install.  Save the before p14 routines.
 NEW AG,AGM,XCN,XCNP,DIE,DIF
 F AG=1:1:7 D
 . D KT
 . S X=$P($T(BEF+AG),";",3),(XCN,XCNP)=0,(DIE,DIF)="^TMP(""AGTXCONF"",$J,"
 . S AGM="Loading '"_X_"'..."
 . X ^%ZOSF("LOAD")
 . S X=$P($T(BEF+AG),";",4)
 . X ^%ZOSF("TEST")
 . I  D MES^XPDUTL(AGM_"NOT SAVED AS '"_X_"'.  '"_X_"' ALREADY EXISTS.") Q
 . X ^%ZOSF("SAVE")
 . D MES^XPDUTL(AGM_"Saved as '"_X_"'.")
 .Q
 D KT
 Q
AFTSAV ;EP - From P14 install.  Save the after p14 routines.
 NEW AG,AGM,XCN,XCNP,DIE,DIF
 F AG=1:1:7 D
 . D KT
 . S X=$P($T(AFT+AG),";",3),(XCN,XCNP)=0,(DIE,DIF)="^TMP(""AGTXCONF"",$J,"
 . S AGM="Loading '"_X_"'..."
 . X ^%ZOSF("LOAD")
 . S X=$P($T(AFT+AG),";",4)
 . X ^%ZOSF("TEST")
 . I  D MES^XPDUTL(AGM_"NOT SAVED AS '"_X_"'.  '"_X_"' ALREADY EXISTS.") Q
 . X ^%ZOSF("SAVE")
 . D MES^XPDUTL(AGM_"Saved as '"_X_"'.")
 .Q
 D KT
 Q
DELAFT ;EP - Delete routine(s) to make room for "just installed" routines.
 NEW AG,X
 F AG=1:1:7 S X=$P($T(AFT+AG),";",4) X ^%ZOSF("DEL")  I '$D(ZTQUEUED) D BMES^XPDUTL(X_$E("...........",1,11-$L(X))_"<poof'd>")
 Q
