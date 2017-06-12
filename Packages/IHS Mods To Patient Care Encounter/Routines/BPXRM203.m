BPXRM203 ; IHS/MSC/MGH - Version 2.0 Patch 3. ;20-Nov-2014 15:19;du
 ;;2.0;CLINICAL REMINDERS;**1003**;Feb 04, 2005;Build 21
 ;
ENV ;EP environment check
 N IN,INSTDA,STAT
 ;Check for the installation of Reminders 2.0
 S IN="CLINICAL REMINDERS 2.0",INSTDA=""
 I '$D(^XPD(9.7,"B",IN)) D  Q
 .W !,"You must first install CLINICAL REMINDERS 2.0 before this patch" S XPDQUIT=2
 S INSTDA=$O(^XPD(9.7,"B",IN,INSTDA),-1)
 S STAT=+$P($G(^XPD(9.7,INSTDA,0)),U,9)
 I STAT'=3 D  Q
 .W !,"CLINICAL REMINDERS 2.0 must be completely installed before installing this patch." S XPDQUIT=2
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;Check for the installation of other patches
 S PATCH="PXRM*2.0*1002"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
 S IN="IHS STANDARD TERMINOLOGY 1.0",INSTDA=""
 I '$D(^XPD(9.7,"B",IN)) D  Q
 .W !,"You must first install IHS STANDARD TERMINOLOGY 1.0 before this patch" S XPDQUIT=2
 S INSTDA=$O(^XPD(9.7,"B",IN,INSTDA),-1)
 S STAT=+$P($G(^XPD(9.7,INSTDA,0)),U,9)
 I STAT'=3 D  Q
 .W !,"IHS STANDARD TERMINOLOGY 1.0  must be completely installed before installing this patch." S XPDQUIT=2
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 S IN="IHS CLINICAL REPORTING 14.0",INSTDA=""
 I '$D(^XPD(9.7,"B",IN)) D  Q
 .W !,"You must first install IHS CLINICAL REPORTING 14.0 before this patch" S XPDQUIT=2
 S INSTDA=$O(^XPD(9.7,"B",IN,INSTDA),-1)
 S STAT=+$P($G(^XPD(9.7,INSTDA,0)),U,9)
 I STAT'=3 D  Q
 .W !,"IHS CLINICAL REPORTING 14.0  must be completely installed before installing this patch." S XPDQUIT=2
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 Q
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
 ;===============================================================
PRE ;EP pre-init
 Q
 ;===============================================================
POST ;Post-install
 D CNAK
 D RTAXEXP
 Q
 ;================================================================
CNAK ;Make sure all "NAK" characters are converted back to "^" in
 ;the Exchange File.
 N IEN,TEXT
 D BMES^XPDUTL("Clean up Exchange File entries")
 S IEN=0
 F  S IEN=+$O(^PXD(811.8,IEN)) Q:IEN=0  D
 . D POSTKIDS^PXRMEXU5(IEN)
 Q
 ;
 ;===============================================================
DELEI ;If the Exchange File entry already exists delete it.
 N ARRAY,IC,IND,LIST,LUVALUE,NUM
 S IC=0
 F  S IC=$O(ARRAY(IC)) Q:'IC  D
 .S LUVALUE(1)=ARRAY(IC,1)
 .D FIND^DIC(811.8,"","","U",.LUVALUE,"","","","","LIST")
 .I '$D(LIST) Q
 .S NUM=$P(LIST("DILIST",0),U,1)
 .I NUM'=0 D
 ..F IND=1:1:NUM D
 ... N DA,DIK
 ... S DIK="^PXD(811.8,"
 ... S DA=LIST("DILIST",2,IND)
 ... D ^DIK
 Q
 ;
RTAXEXP ;Rebuild taxonomy expansions.
 N IEN,IND,TEXT,TNAME
 S TNAME(1)="IHS-BARIUM ENEMA"
 S TNAME(2)="IHS-COLONOSCOPY 2007"
 S TNAME(3)="IHS-DEPO PROVERA ADMIN-2013"
 S TNAME(4)="IHS DEPOPROVERA CODES"
 S TNAME(5)="IHS-FECAL OCCULT LAB TEST"
 S TNAME(6)="IHS-FUNDOSCOPIC EYE CODES 2007"
 S TNAME(7)="IHS-HIGH RISK HPV TEST"
 S TNAME(8)="IHS-HYSTERECTOMY 2009"
 S TNAME(9)="IHS-MAMMOGRAM 2009"
 S TNAME(10)="IHS-PAP CODES 2008"
 S TNAME(11)="IHS-SIGMOIDOSCOPY"
 S TNAME(12)="IHS-BILATERAL MASTECTOMY 2008"
 D BMES^XPDUTL("Rebuilding taxonomy expansions.")
 F IND=1:1:12 D
 . S IEN=$O(^PXD(811.2,"B",TNAME(IND),""))
 . I IEN="" Q
 . S TEXT=" Working on taxonomy "_IEN
 . D BMES^XPDUTL(TEXT)
 . D DELEXTL^PXRMBXTL(IEN)
 . D EXPAND^PXRMBXTL(IEN,"")
 Q
