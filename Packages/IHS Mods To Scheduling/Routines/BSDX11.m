BSDX11 ; IHS/OIT/HMW/MSC/SAT - WINDOWS SCHEDULING RPCS ;
 ;;3.0;IHS WINDOWS SCHEDULING;;DEC 09, 2010
 ;
ENV0100 ;EP Version 1.0 Environment check
 I '$G(IOM) D HOME^%ZIS
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 I '(DUZ(0)["@") W:'$D(ZTQUEUED) !,"DUZ(0) DOES NOT CONTAIN AN '@'." D SORRY(2) Q
 S X=$$GET1^DIQ(200,DUZ,.01)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment...",IOM)
 ;
 ;is the PIMS requirement present?
 I '$$INSTALLD("PIMS*5.3*1003") D
 .D BMES^XPDUTL("Version 1.0 of the BSDX Package")
 . D BMES^XPDUTL("Cannot Be Installed Unless")
 . D BMES^XPDUTL("Patch 1003 of version 5.3 of the PIMS Package has been installed.")
 . D SORRY(2)
 . Q
 ;is the BMX requirement present?
 I '$$INSTALLD("BMX 1.0") D
 .D BMES^XPDUTL("Version 1.0 of the BSDX Package")
 . D BMES^XPDUTL("Cannot Be Installed Unless")
 . D BMES^XPDUTL("version 1.0 of the BMX Package has been installed.")
 . D SORRY(2)
 . Q
 Q
 ;End Environment check
 ;
V0100 ;EP Version 1.0 PostInit
 ;Add Protocol items to BSDAM APPOINTMENT EVENTS protocol
 ;
 N BSDXDA,BSDXFDA,BSDXDA1,BSDXSEQ,BSDXDAT,BSDXNOD,BSDXIEN,BSDXMSG
 S BSDXDA=$O(^ORD(101,"B","BSDAM APPOINTMENT EVENTS",0))
 Q:'+BSDXDA
 S BSDXDAT="BSDX ADD APPOINTMENT;10.2^BSDX CANCEL APPOINTMENT;10.4^BSDX CHECKIN APPOINTMENT;10.6^BSDX NOSHOW APPOINTMENT;10.8"
 F J=1:1:$L(BSDXDAT,U) D
 . K BSDXIEN,BSDXMSG,BSDXFDA
 . S BSDXNOD=$P(BSDXDAT,U,J)
 . S BSDXDA1=$P(BSDXNOD,";")
 . S BSDXSEQ=$P(BSDXNOD,";",2)
 . S BSDXDA1=$O(^ORD(101,"B",BSDXDA1,0))
 . Q:'+BSDXDA1
 . Q:$D(^ORD(101,BSDXDA,10,"B",BSDXDA1))
 . S BSDXFDA(101.01,"+1,"_BSDXDA_",",".01")=BSDXDA1
 . S BSDXFDA(101.01,"+1,"_BSDXDA_",","3")=BSDXSEQ
 . D UPDATE^DIE("","BSDXFDA","BSDXIEN","BSDXMSG")
 . Q
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....Please fix it.",IOM)
 Q
 ;
INSTALLD(BMXPKG) ;
 ;Determine if BMXPKG is present.
 N BSDXFIN,BSDXSTAT
 ;S BSDXFIN=$O(^XPD(9.7,"B","PIMS*5.3*1003",""))
 S BSDXFIN=$O(^XPD(9.7,"B",BMXPKG,""))
 I $G(BSDXFIN)="" Q 0
 S BSDXSTAT=$P($G(^XPD(9.7,BSDXFIN,0)),U,9)
 ;'0' Loaded from Distribution
 ;'1' Queued for Install 
 ;'2' Start of Install 
 ;'3' Install Completed 
 ;'4' FOR De-Installed; 
 ;
 I BSDXSTAT'=3 Q 0
 Q 1
