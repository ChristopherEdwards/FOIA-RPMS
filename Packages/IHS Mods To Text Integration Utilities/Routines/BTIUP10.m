BTIUP10 ; IHS/CIA/MGH - POST INSTALL FOR PATCH 1010;04-Oct-2012 09:44;DU
 ;;1.0;TEXT INTEGRATION UTILITIES;**1010**;SEPT 04, 2005;Build 24
 ;
ENV ;EP environment check
 N PATCH,IN,STAT,INSTDA
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 S PATCH="TIU*1.0*1009"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
 S PATCH="USR*1.0*1004"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
 S PATCH="BJPC*2.0*7"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDABORT=1
 S PATCH="PIMS*5.3*1015"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDABORT=1
 S IN="EHR*1.1*10",INSTDA=""
 I '$D(^XPD(9.7,"B",IN)) D  Q
 .W !,"You must first install the EHR patch 10 before installing patch TIU 1010"
 S INSTDA=$O(^XPD(9.7,"B",IN,INSTDA),-1)
 S STAT=+$P($G(^XPD(9.7,INSTDA,0)),U,9)
 I STAT'=3 D  Q
 .W !,"EHR patch 10 must be completely installed before installing TIU patch 1010"
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 Q
PATCH(X) ;return 1 if patch X was installed, X=aaaa*nn.nn*nnnn
 ;copy of code from XPDUTL but modified to handle 4 digit IHS patch numbers
 Q:X'?1.4UN1"*"1.2N1"."1.2N.1(1"V",1"T").2N1"*"1.4N 0
 NEW NUM,I,J
 S I=$O(^DIC(9.4,"C",$P(X,"*"),0)) Q:'I 0
 S J=$O(^DIC(9.4,I,22,"B",$P(X,"*",2),0)),X=$P(X,"*",3) Q:'J 0
 ;check if patch is just a number
 Q:$O(^DIC(9.4,I,22,J,"PAH","B",X,0)) 1
 S NUM=$O(^DIC(9.4,I,22,J,"PAH","B",X_" SEQ"))
 Q (X=+NUM)
 ;
PRE ;EP; beginning of pre install code
 Q
 ;
POST ;EP; beginning of post install code
 D REGMENU^BEHUTIL("TIU UNK ADDENDA MENU",,"UNK","BTIU SPECIAL REPORTS")
 D REGMENU^BEHUTIL("TIU MISSING EXPECTED COSIGNER",,"COS","BTIU SPECIAL REPORTS")
 D REGMENU^BEHUTIL("TIU MARK SIGNED BY SURROGATE",,"SURR","BTIU SPECIAL REPORTS")
 D REGMENU^BEHUTIL("TIU MISMATCHED ID NOTES",,"ID","BTIU SPECIAL REPORTS")
 D REGMENU^BEHUTIL("TIU SIGNED/UNSIGNED PN",,"PN","BTIU SPECIAL REPORTS")
 D REGMENU^BEHUTIL("TIU REVIEW MRT ADD SGNR",,"ADD","BTIU MENU2")
 D REGMENU^BEHUTIL("TIU ACTIVE TITLE CLEANUP",,"CLN","BTIU MENU MGR")
 Q
