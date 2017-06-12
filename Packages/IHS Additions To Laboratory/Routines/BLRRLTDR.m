BLRRLTDR ; IHS/MSC/MKK - Reference Lab Test "Delete" Routine  ; 22-Oct-2013 09:22 ; MKK
 ;;5.2;IHS LABORATORY;**1033**;NOV 1, 1997
 ;
 ; Code cloned from LRTSTOUT
 ;
 ; This routine will mark all tests on an Accession as Not Performed when the incoming HL7 message
 ; from a Reference Lab has the OBX "not performed" flag set.  No output.
 ;
 ; NOTE: There will be no check on the LRLABKY variable.
 ;       It is assumed that the process running this routine MUST be able to mark test NOT PERFORMED.
 ;
EEP ; Ersatz EP
 D EEP^BLRGMENU
 Q
 ;
PEP ; EP 
EP ; EP
NOTPERF(UID,CANCLRSN) ; EP - Not Performed
 NEW (CANCLRSN,DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,TESTDESC,U,UID,XPARSYS,XQXFLG)
 ;
 D ^LRPARAM
 S BLRLOG=1
 ;
 S X=$Q(^LRO(68,"C",UID)),LRAA=+$QS(X,4),LRAD=+$QS(X,5),LRAN=+$QS(X,6)
 ;
 ; Skip if no Accession variables
 I LRAA<1!(LRAD<1)!(LRAN<1) D XTMPISET^BLRRLTDU("Could not determine Accession variables from UID:"_UID_".","BLRRLTDR")  Q
 ;
 S SAVLRAA=LRAA,SAVLRAD=LRAD,SAVLRAN=LRAN
 ;
 S LRSS=$$GET1^DIQ(68,LRAA,"LR SUBSCRIPT","I")
 S IEN=LRAN_","_LRAD_","_LRAA_","
 S LRDFN=$$GET1^DIQ(68.02,IEN,"LRDFN","I")
 S LRIDT=$$GET1^DIQ(68.02,IEN,"INVERSE DATE","I")
 ; 
 S BLROPT="DELACC"
 ;
 ; S CANCLRSN=$$GETCANCL^BLRRLMUU(UID)     ; Get Cancel reason from 62.49
 ;
 K LRXX,LRSCNXB
 F  S (LREND,LRNOP)=0 D FIX D  I $G(LREND) D END Q
 . I $G(LREND) D END S LREND=1 Q
 . K DIC D:'$G(LRNOP) CHG D END
 ;
 D COMPDATE(SAVLRAA,SAVLRAD,SAVLRAN)
 ;
 D LMIMAIL(UID,CANCLRSN)
 Q
 ;
COMPDATE(LRAA,LRAD,LRAN) ; EP - Put Completed Date on Accession
 NEW CANCELDT,ERRS,FDA,IEN
 ;
 S IEN=LRAN_","_LRAD_","_LRAA_","
 ;
 K FDA
 S CANCELDT=$$NOW^XLFDT
 S FDA(68.02,IEN,13)=CANCELDT
 D UPDATE^DIE(,"FDA","IEN","ERRS")
 Q
 ;
LMIMAIL(UID,CANCLRSN) ; EP - E-mail LMI Mail Group with Ref Lab Cancellations
 NEW LRAA,LRAD,LRAN,LRAS,MSGARRAY,REFLAB,TAB
 ;
 S REFLAB=$$GET1^DIQ(9009029,DUZ(2),3001)   ; Get Reference Lab Name
 ;
 NEW DUZ
 D DUZ^XUP(.5)  ; Set DUZ to POSTMASTER since "GIS,USER" cannot send MailMan messages
 ;
 S X=$Q(^LRO(68,"C",UID)),LRAA=+$QS(X,4),LRAD=+$QS(X,5),LRAN=+$QS(X,6)
 S LRAS=$$GET1^DIQ(68.02,LRAN_","_LRAD_","_LRAA,15)
 ;
 S TAB=$J("",5)
 S MSGARRAY(1)=TAB_"Reference Lab "_REFLAB,MSGARRAY(2)=" "
 S MSGARRAY(3)=TAB_"Accession "_LRAS_" has been rejected.",MSGARRAY(4)=" "
 S MSGARRAY(5)=TAB_"Cancellation Reason:",MSGARRAY(6)=TAB_TAB_CANCLRSN
 ;
 D MAILALMI^BLRUTIL3("Accession "_LRAS_" Rejected",.MSGARRAY,"HL7 Interface",1)
 Q
 ;
FIX ; EP
 S (LREND,LRNOP)=0,LRNOW=$$NOW^XLFDT
 S LRACC=1 D LRACC Q:$G(LRNOP)
 ;
 K LRACC,LRNATURE I $G(LRAN)<1 S LREND=1 Q
 ;
 I '$P($G(^LRO(68,+$G(LRAA),1,+$G(LRAD),1,+$G(LRAN),0)),U,2) D XTMPISET^BLRRLTDU("Accession has no Test.","BLRRLTDR") S LRNOP=1  Q
 ;
 L +^LRO(68,LRAA,1,LRAD,1,LRAN):1 I '$T D XTMPISET^BLRRLTDU("Someone else is working on this accession.","BLRRLTDR") S LRNOP=1 Q
 ;
 S LRX=^LRO(68,LRAA,1,LRAD,1,LRAN,0),LRACN=$P(^(.2),U),LRUID=$P(^(.3),U)
 S LRDFN=+LRX,LRSN=+$P(LRX,U,5),LRODT=+$P(LRX,U,4)
 S LRDPF=$P(^LR(LRDFN,0),U,2),DFN=$P(^(0),U,3)
 ;
 D PT^LRX
 ;
 S LRIDT=$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,3)),U,5) L +^LR(LRDFN,LRSS,LRIDT):1  I '$T D XTMPISET^BLRRLTDU("Someone else is working on this data.","BLRRLTDR")  L -^LRO(68,LRAA,1,LRAD,1,LRAN) S LRNOP=1 Q
 ;
 I '$G(^LR(LRDFN,LRSS,LRIDT,0)) D XTMPISET^BLRRLTDU("Can't find Lab Data for this accession.","BLRRLTDR") D UNLOCK S LRNOP=1 Q
 ;
FX1 ; EP
 S LRTSTS=0
 F  S LRTSTS=$O(^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRTSTS))  Q:LRTSTS<1  D
 . S F60IEN=$$GET1^DIQ(68.04,LRTSTS_","_LRAN_","_LRAD_","_LRAA_",",.01,"I")
 . D:F60IEN&(LRTSTS) CHG
 Q
 ;
TESTGET ; EP - IEN into 62.49 Passed in
 S F60IEN=0
 S LA7INST=$$GET1^DIQ(9009029,DUZ(2),3001)
 Q:$G(LA7INST)="" 0                                ; Quit with zero if no Reference Lab
 ;
 ; Determine what piece is the observation sub-id: QUEST uses OBX3.4; all others use OBX3.1
 S WOTPIECE=$S($$UP^XLFSTR(LA7INST)["QUEST":4,1:1)
 ;
 S SEG=0,F60SYN=""
 F  S SEG=$O(^LAHM(62.49,LA76249,150,SEG))  Q:SEG=""!($L(F60SYN))  D
 . Q:$G(^LAHM(62.49,LA76249,150,SEG,0))'["OBR"
 . S F60SYN=$P($P($G(^LAHM(62.49,LA76249,150,SEG,0)),"|",5),"^",WOTPIECE)
 ;
 Q:$L(F60SYN)<1
 ;
 ; Have to use $O(^LAB(60,"B",OBRIEN,0)) because FIND1^DIC does not work correctly if the synonym is purely numeric
 S F60IEN=+$O(^LAB(60,"B",F60SYN,0))
 ;
 NEW WHCHTEST
 S (WHCHTEST,LRTSTS)=0
 F  S WHCHTEST=$O(^LRO(68,LRAA,1,LRAD,1,LRAN,4,WHCHTEST))  Q:WHCHTEST<1!(LRTSTS)  D
 . S:$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,4,WHCHTEST,0)),"^")=F60IEN LRTSTS=WHCHTEST
 ;
 Q
 ;
CHG ; EP
 ; Have LRACN,LRUID,LRDFN,LRSS,LRIDT and CANCLRSN
 ;
 K LRCCOM,LRCTST,DIC
 N LRIFN
 ;
 S LRCCOM="",LREND=0
 I '$D(^LRO(69,LRODT,1,LRSN,0))#2 D XTMPISET^BLRRLTDU("There is no Order for this Accession","BLRRLTDR")  D UNLOCK,END Q
 ;
 D FX2 Q:$G(LREND)
 ;
 Q:'$D(^LAB(60,LRTSTS,0))#2
 S LRTNM=$P(^(0),U)
 ;
 S LRORDTST=$P(^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRTSTS,0),U,9) D SET,CLNPENDG
 ;
 ; The following line added per appendix A of RPMS Lab
 ; E-Sig Enhancement clinical manual IHS/HQW/SCR - 8/23/01 
 I $$ADDON^BLRUTIL("LR*5.2*1013","BLRALAF",DUZ(2)) D ^BLRALAF
 ;
 ; Send over changes to PCC
 D:BLRLOG ^BLREVTQ("M","D",$G(BLROPT),,LRAA_","_LRAD_","_LRAN)
 ;
 S LREND=0 K LRCTST
 Q
 ;
SHOWTST ; EP
 Q    ; Skip entirely.  No output.
 ;
 N LRI,LRN,DIR,LRY,LRIC,X
 S DIR(0)="E"
 D DEMO
 S LRN=0,LRI=0 F  S LRI=$O(^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRI)) Q:LRI<1!($G(LRY))  D
 . S LRIC=$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRI,0)),U,4,6) Q:'$D(^LAB(60,+LRI,0))#2  W !,?5,$P(^(0),U) S LRN=LRN+1 I LRIC  D
 . . W ?35,"  "_$S($L($P(LRIC,U,3)):$P(LRIC,U,3),1:"Completed")_"  "_$$FMTE^XLFDT($P(LRIC,U,2),"5FMPZ")_" by "_$P(LRIC,U)
 . I LRN>18 D ^DIR S:$E(X)=U LRY=1 Q:$G(LRY)  D DEMO S LRN=0
  S X=^LRO(68,LRAA,1,LRAD,1,LRAN,0),LRODT=$P(X,U,4),LRSN=$P(X,U,5)
 Q
 ;
DEMO ; EP
 W !,PNM,?50,HRCN
 W !,"TESTS ON ACCESSION: ",LRACN,?40,"UID: ",LRUID
 Q
 ;
SET ; EP
 S:'$G(LRNOW) LRNOW=$$NOW^XLFDT
 S LRLLOC=$P(^LRO(69,LRODT,1,LRSN,0),U,7) D
 . N II,X,LRI,LRSTATUS,OCXTRACE
 . S:$G(LRDBUG) OCXTRACE=1
 . S LRI=0 F  S LRI=$O(^LRO(69,LRODT,1,LRSN,2,LRI)) Q:LRI<1  I $D(^(LRI,0))#2,LRTSTS=+^(0) S (LRSTATUS,II(LRTSTS))="" D  K II
 . . Q:$P(^LRO(69,LRODT,1,LRSN,2,LRI,0),U,11)  S ORIFN=$P(^(0),U,7)
 . . S $P(^LRO(69,LRODT,1,LRSN,2,LRI,0),U,11)=DUZ
 . . S X=1+$O(^LRO(69,LRODT,1,LRSN,2,LRI,1.1,"A"),-1),X(1)=$P($G(^(0)),U,4)
 . . S ^LRO(69,LRODT,1,LRSN,2,LRI,1.1,X,0)=$P($G(LRNATURE),U,5)_": "_LRCCOM,X=X+1,X(1)=X(1)+1
 . . S ^LRO(69,LRODT,1,LRSN,2,LRI,1.1,X,0)="*NP Action:"_$$FMTE^XLFDT(LRNOW,"5MZ")
 . . S ^LRO(69,LRODT,1,LRSN,2,LRI,1.1,0)="^^"_X_"^"_X(1)_"^"_DT
 . . I $G(ORIFN),$D(II) D NEW^LR7OB1(LRODT,LRSN,$S($G(LRMSTATI)=""!($G(LRMSTATI)=1):"OC",1:"SC"),$G(LRNATURE),.II,LRSTATUS)
 . . I ORIFN,$$VER^LR7OU1<3 D DC^LRCENDE1
 . . S $P(^LRO(69,LRODT,1,LRSN,2,LRI,0),"^",9)="CA",$P(^(0),U,10)="L",$P(^(0),U,11)=DUZ
 . . S:$D(^LRO(69,LRODT,1,LRSN,"PCE")) ^LRO(69,"AE",DUZ,LRODT,LRSN,LRI)=""
 K ORIFN,ORSTS
 I $D(^LRO(68,+$G(LRAA),1,+$G(LRAD),1,+$G(LRAN),0))#2,$D(^(4,$G(LRTSTS),0))#2 S $P(^(0),U,4,6)=DUZ_U_LRNOW_U_"*Not Performed" D
 . D XTMPNSET^BLRRLTDU(+$G(^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRTSTS,0)),"*NP:Set Accs")
 . D STORTXNS^BLRRLTDU(LRTSTS,$G(^LRO(68,LRAA,1,LRAD,1,LRAN,.2)),"N")
 . S LROWDT=$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,0)),U,3) I LROWDT,LROWDT'=LRAD D ROL Q
 . S LROWDT=+$G(^LRO(68,LRAA,1,LRAD,1,LRAN,9)) I LROWDT D ROL
 I $G(LRIDT),$L($G(LRSS)),$L(LRCCOM),$G(^LR(LRDFN,LRSS,LRIDT,0)) D
 . D 63(LRDFN,LRSS,LRIDT,LRTNM,LRCCOM)
 . D:'$D(^LRO(68,LRAA,1,LRAD,1,"AD",DT,LRAN)) XREF^LRVER3A
 D EN^LA7ADL($P($G(^LRO(68,+$G(LRAA),1,+$G(LRAD),1,+$G(LRAN),.3)),"^")) ; Put in list to check for auto download.
 ;
 Q
 ;
ROL ; EP
 Q:+$G(^LRO(68,LRAA,1,LROWDT,1,LRAN,0))'=LRDFN  Q:'$D(^(4,LRTSTS,0))#2
 S $P(^LRO(68,LRAA,1,LROWDT,1,LRAN,4,LRTSTS,0),U,4,6)=DUZ_U_LRNOW_U_"*Not performed"
 Q
 ;
LRACC ; EP
 S LREND=0,LREXMPT=1 K LREXMPT
 ;
 Q:'$G(LRAA)!('$G(LRAN))
 Q:'$D(^LRO(68,LRAA,0))#2
 ;
 S DA(2)=LRAA,DA(1)=LRAD,LRSS=$P(^LRO(68,LRAA,0),U,2)
 I '$L(LRSS) S LRAN=0,LRNOP=1 D XTMPISET^BLRRLTDU("No Subscript for this Accession Area","BLRRLTDR")
 ;
 Q
 ;
LREND ; EP
 S LREND=1
 Q
 ;
UNLOCK ; EP
 L -(^LR($G(LRDFN),$G(LRSS),$G(LRIDT)),^LRO(68,$G(LRAA),1,$G(LRAD),1,$G(LRAN)))
 D END
 Q
 ;
EXIT ; EP
 K LRSCNX,LRNOECHO,LRACN,LRLABRV,LRNOW
 ;
END ; EP
 K LRCCOM0,LRCCOM1,LRCCOMX,LREND,LRI,LRL,LRNATURE,LRNOP,LRSCN,LRMSTATI,LRORDTST,LROWDT,LRPRAC,LRTSTS,LRUID
 K Q9,LRXX,DIR,LRCOM,LRAGE,DI,LRCTST,LRACN,LRACN0,LRDOC,LRLL,LRNOW
 K LROD0,LROD1,LROD3,LROOS,LROS,LROSD,LROT,LRROD,LRTT,X4
 D @$S($$ISPIMS^BLRUTIL:"KVAR^VADPT",1:"KVAR^BLRDPT")
 D END^LRTSTJAM
 K HRCN
 Q
 ;
FX2 ; EP
 S LREND=0
 S LRL=52
 ;
 ; Hard set the necessary variables
 S X="L",Y="L",Y(0)="LAB"
 ;
 K LRSCNXB,LRNOECHO
 S:'$D(LRSCN) LRSCN="AKL"
 ;
 S LRSCNXB=Y(0),LRSCN=LRSCN_Y
 ;
FX3 ; EP
 ; S (LRCCOM,LRCCOMX)="*NP Reason:Reference Lab Rejected Test."
 S (LRCCOM,LRCCOMX)="*NP Reason:"_$G(CANCLRSN,"Reference Lab Rejected Test.")
 Q
 ;
63(LRDFN,LRSS,LRIDT,LRTNM,LRCCOM) ; EP
 N X,Y,D0,D1,DA,DR,DIC,DIE,LRCCOM0,LRNOECHO,DLAYGO
 NEW TMPSTR,PRNTNAM
 ;
 S DLAYGO=63,DIC(0)="SL"
 S:'$G(LRNOW) LRNOW=$$NOW^XLFDT
 S LRNOECHO=1
 ;
 ; Make certain Comment string within field length; if not, use PRINT NAME from file 60
 S TMPSTR="*"_LRTNM_" Not Performed: "_$$FMTE^XLFDT(LRNOW,"5FMPZ")_" by "_DUZ
 I $L(TMPSTR)>68 D
 . S PRNTNAM=$$GET1^DIQ(60,LRTSTS,"PRINT NAME")
 . S LRCCOM0=$E("*"_PRNTNAM_" Not Performed: "_$$FMTE^XLFDT(LRNOW,"5FMPZ")_" by "_DUZ,1,68)
 ;
 ; Full name of test can be used in Comment string
 I $L(TMPSTR)<69 S LRCCOM0=$E("*"_LRTNM_" Not Performed: "_$$FMTE^XLFDT(LRNOW,"5FMPZ")_" by "_DUZ,1,68)
 ;
 S DA=LRIDT,DA(1)=LRDFN,DIE="^LR("_LRDFN_","""_LRSS_""","
 S LRCCOM0=$TR(LRCCOM0,";","-") ; Strip ";" - FileMan uses ";" to parse DR string.
 S DR=".99////^S X="_""""_LRCCOM0_"""" D ^DIE
 ;
 D ADDSPCON(UID)   ; Add the SPECIMEN CONDITION, if it exists
 ;
 Q:LRSS="MI"
 ;
631 ; EP
 K D0,D1,DA,DR,DIC,DIE
 S DIC(0)="SL"
 S DA=LRIDT,DA(1)=LRDFN,DIE="^LR("_LRDFN_","""_LRSS_""",",DIC=DIE
 S LRCCOM=$TR(LRCCOM,";","-") ; Strip ";" - FileMan uses ";" to parse DR string.
 S LRCCOM=$TR(LRCCOM,"""","'") ; Change " to ' -- " causes FileMan error.
 S DR=".99///^S X="_""""_LRCCOM_""""
 D ^DIE
 Q
CLNPENDG ;Remove pending from Lab test when set to not performed
 N LRIFN
 S LRIFN=$P($G(^LAB(60,LRTSTS,.2)),U)
 Q:LRIFN=""
 S:$P($G(^LR(LRDFN,LRSS,LRIDT,LRIFN)),U)="pending" $P(^LR(LRDFN,LRSS,LRIDT,LRIFN),U)=""
 Q
 ;
ADDCOMNT(LRDFN,LRIDT,MSG) ; EP - Add the Ref Lab comments from the NTE segments to file 63
 NEW ARRAYL,CL,COMARRAY,FDA,IENS,SEG,STR
 ;
 S ARRAYL=$$GETNTEC(MSG,.COMARRAY)
 Q:ARRAYL<1
 ;
 F CL=1:1:ARRAYL D
 . S IENS(1)=$O(^LR(LRDFN,"CH",LRIDT,1,"B"),-1)+1  ; Get next COMMENT line
 . S FDA(63.041,"+1,"_LRIDT_","_LRDFN_",",.01)=$G(COMARRAY(CL))
 . ;
 . D UPDATE^DIE(,"FDA","IENS","ERRS")
 . ;
 . ; D:$D(ERRS("DIERR"))>0 ADDERRS(WOT,.ERRS,.ERRCNT)   ; Errors
 Q
 ;
GETNTEC(MSG,ARRAY) ; EP - Stuff ARRAY with NTE comments from message
 NEW COML,COMLS,SEG,STR
 ;
 S (COML,SEG)=0
 F  S SEG=$O(^LAHM(62.49,MSG,150,SEG))  Q:SEG<1  D
 . Q:$G(^LAHM(62.49,MSG,150,SEG,0))'["NTE"
 . ;
 . S STR=$G(^LAHM(62.49,MSG,150,SEG,0))
 . Q:$TR($P(STR,"|",4)," ")=""    ; Don't bother with blank lines
 . ;
 . S COMLS=$$TRIM^XLFSTR($P(STR,"|",4),"LR"," ")
 . ;
 . Q:$D(COMLS(COMLS))>0           ; Don't store duplicate comments
 . ;
 . S COML=COML+1
 . S ARRAY(COML)=COMLS
 . S COMLS(COMLS)=""              ; Store comment so no duplicates
 ;
 Q COML                           ; Return # of lines stored
 ;
GETSPMC(MSG,ARRAY) ; EP - Stuff ARRAY with SPM comments from message
 NEW COML,COMLS,SEG,STR
 ;
 S (COML,SEG)=0
 F  S SEG=$O(^LAHM(62.49,MSG,150,SEG))  Q:SEG<1  D
 . Q:$G(^LAHM(62.49,MSG,150,SEG,0))'["SPM"
 . ;
 . S STR=$G(^LAHM(62.49,MSG,150,SEG,0))
 . Q:$TR($P(STR,"|",4)," ")=""    ; Don't bother with blank lines
 . ;
 . S COMLS=$$TRIM^XLFSTR($P(STR,"|",4),"LR"," ")
 . ;
 . Q:$D(COMLS(COMLS))>0           ; Don't store duplicate comments
 . ;
 . S COML=COML+1
 . S ARRAY(COML)=COMLS
 . S COMLS(COMLS)=""              ; Store comment so no duplicates
 ;
 Q COML                           ; Return # of lines stored
 ;
ADDSPCON(UID) ; EP - Add the SPECIMEN CONDITION from the SPM segment, if it exists
 NEW AUTOIEN,AUTOINSP,FOUNDIT,IEN,INST,INSTUID,LA7INST,LOADWORK,SEGCNT
 ;
 Q:$$USELAHG(UID)="OK"    ; Check the LAH global.  If successful, quit
 ;
 S PIEN=$$RELAHMID^BLRRLMUU(UID)
 Q:PIEN<1              ; Could not determine IEN of UID, so quit
 ;
 S (FOUNDIT,SEGCNT)=0
 F  S SEGCNT=$O(^LAHM(62.49,PIEN,150,SEGCNT))  Q:SEGCNT<1!(FOUNDIT)  D
 . S:$P($G(^LAHM(62.49,PIEN,150,SEGCNT,0)),"|")="SPM" FOUNDIT=SEGCNT
 ;
 Q:FOUNDIT<1                        ; Could not find "SPM" segment, so quit
 ;
 S STR=$G(^LAHM(62.49,PIEN,150,FOUNDIT,0))
 ;
 S CONDSPEC=$P($P(STR,"|",25),"^")            ; SPECIMEN CONDITION
 Q:$L(CONDSPEC)<1                             ; Skip if no SPECIMEN CONDITION
 ;
 S X=$Q(^LRO(68,"C",UID)),LRAA=+$QS(X,4),LRAD=+$QS(X,5),LRAN=+$QS(X,6)
 S LRSS=$$GET1^DIQ(68,LRAA,"LR SUBSCRIPT","I")
 S IEN=LRAN_","_LRAD_","_LRAA_","
 S LRDFN=$$GET1^DIQ(68.02,IEN,"LRDFN","I")
 S LRIDT=$$GET1^DIQ(68.02,IEN,"INVERSE DATE","I")
 ;
 S $P(^LR(LRDFN,LRSS,LRIDT,"IHS"),"^")=CONDSPEC
 S $P(^LR(LRDFN,LRSS,LRIDT,"HL7"),"^")=PIEN    ; Store 62.49 IEN
 Q
 ;
USELAHG(UID) ; EP - Use the LAH global.  If successful, quit with "OK"
 NEW AUTOIEN,CONDSPEC,LA7INST,LOADWORK
 ;
 S LA7INST=$$GET1^DIQ(9009029,DUZ(2),3001)
 Q:$G(LA7INST)="" 0                                ; Quit with zero if no Reference Lab
 ;
 S AUTOIEN=+$O(^LAB(62.4,"B",LA7INST,""))          ; Auto Instrument IEN
 Q:AUTOIEN<1 0                                     ; Quit with zero if No Auto Instrument
 ;
 S LOADWORK=$$GET1^DIQ(62.4,AUTOIEN,"LOAD/WORK LIST","I")
 ;
 ; First, look at the ^LAH global
 S IEN=+$O(^LAH(LOADWORK,1,"C",UID,"A"),-1)        ; Get UID's most recent IEN
 ;
 S STR=$G(^LAH(LOADWORK,1,IEN,"IHSSPM"))
 ;
 ; Q 0                                               ; As of 19-Apr-2013, not being stored in ^LAH, so just Quit
 ;
 S CONDSPEC=$P(STR,"^",4)                          ; SPECIMEN CONDITION
 Q:$L(CONDSPEC)<1 0                                ; Quit with zero if no SPECIMEN CONDITION string
 ;
 S $P(^LR(LRDFN,LRSS,LRIDT,"IHS"),"^")=CONDSPEC
 Q "OK"
