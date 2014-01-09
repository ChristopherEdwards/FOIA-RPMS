GMR1006P ; IHS/MSC/MGH - PRE-INSTALL ROUTINE FOR GMRA PATCH 1005 ;04-Jan-2013 08:18;DU
 ;;4.0;Adverse Reaction Tracking;**1006**;Mar 29, 1996;Build 29
 ;
ENV ;EP; environment check
 N PATCH,IN,INSTDA,STAT
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 ;Check for the installation of other patches
 S PATCH="GMRA*4.0*1005"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
 S PATCH="GMRA*4.0*33"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
 S PATCH="GMRA*4.0*42"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
 Q
 S IN="EHR*1.1*11",INSTDA=""
 I '$D(^XPD(9.7,"B",IN)) D  Q
 .W !,"You must first install the EHR patch 11 before installing patch GMRA patch 1006"
 S INSTDA=$O(^XPD(9.7,"B",IN,INSTDA),-1)
 S STAT=+$P($G(^XPD(9.7,INSTDA,0)),U,9)
 I STAT'=3 D  Q
 .W !,"EHR patch 11 must be completely installed before installing GMRA patch 1006"
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
PATCH(X) ;return 1 if patch X was installed, X=aaaa*nn.nn*nnnn
 ;copy of code from XPDUTL but modified to handle 4 digit IHS patch numb
 Q:X'?1.4UN1"*"1.2N1"."1.2N.1(1"V",1"T").2N1"*"1.4N 0
 NEW NUM,I,J
 S I=$O(^DIC(9.4,"C",$P(X,"*"),0)) Q:'I 0
 S J=$O(^DIC(9.4,I,22,"B",$P(X,"*",2),0)),X=$P(X,"*",3) Q:'J 0
 ;check if patch is just a number
 Q:$O(^DIC(9.4,I,22,J,"PAH","B",X,0)) 1
 S NUM=$O(^DIC(9.4,I,22,J,"PAH","B",X_" SEQ"))
 Q (X=+NUM)
 ;
POST ;Post-init add new allergy
 N XUMF,FDA,IEN,DIEN,DIENS,CNT
 S CNT=0
 S XUMF=1,FILE=120.82
 S IENS="+1,"
 S FDA(FILE,IENS,.01)="TOOTHPASTE"
 S FDA(FILE,IENS,1)="FO"
 S FDA(FILE,IENS,2)="1"
 D UPDATE^DIE("","FDA","IENS","ERR")
 Q:$D(ERR)
 K FDA,ERR
 S DIEN=IENS(1)
 S DIENS=DIEN_","
 S FDA(120.823,"+"_$$INC()_","_DIENS,.01)="TOOTH PASTE"
 S FDA(120.8299,"+"_$$INC()_","_DIENS,.01)=DT
 S FDA(120.8299,"+"_$$INC(0)_","_DIENS,.02)=1
 D UPDATE^DIE("","FDA","","ERR")
 Q
 ; Increment counter
INC(VAL) ;EP-
 S VAL=$G(VAL,1)
 S CNT=$G(CNT)+VAL
 Q CNT
