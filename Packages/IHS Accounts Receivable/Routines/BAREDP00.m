BAREDP00 ; IHS/SD/LSL - AR ERA AUTO-POSTIEG ; 01/30/2009
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**1,5,6,7,10,17,20,21,23**;OCT 26,2005
 ;P23: JAN 2013 P.OTTIS: AUTO-SELECT THE TRANSPORT TYPE ($$FORMAT)
 ;
 Q
TSEL ;EP TRANSPORT SELECT (DEFUNCT)
 W !
 K DIC,DA
 S DIC=$$DIC^XBDIQ1(90056.01)
 S DIC(0)="AEQM"
 K DD,DO
 D ^DIC
 S TRDA=+Y
 S TRNAME=$P(Y,U,2)
 Q
 ;THIS IS ENTRY POINT FOR BOTH 4010 & 5010 TRANSPORT TYPES
INSTALL ;EP -Load New Import 
 D SIG^XUSESIG
 Q:X1=""
 I $G(DUZ(2))="" D  Q
 . W !!,"Check your DUZ setup."
 . H 4
 I '$D(^BAREDI("I",DUZ(2),0)) S ^BAREDI("I",DUZ(2),0)="A/R EDI IMPORT^90056.02^^^"
 K ^TMP($J,"ERA")
 S DIR(0)="F"
 S DIR("A")="Enter the directory path for the transport file"
 S BARPATH=$P($G(^BAR(90052.06,DUZ(2),DUZ(2),0)),U,17)
 S DIR("B")=BARPATH
 S DIR("?")="For example enter '/usr/mydir/'"
 D ^DIR
 K DIR
 Q:$D(DIRUT)
 ; Path
 S XBDIR=X
 D FNAME^BAREDIUT
 S HSTFILE=$G(XBFN)
 Q:HSTFILE=""
 W !!,"CHECKING FILE FORMAT....."
 S BARCTRL=0
 S POP=0 D READ(XBDIR,HSTFILE) I POP QUIT
 S BARRET=$$FORMAT(BARREC) I +BARRET D  QUIT  ;------------------------------>
 . W !,"The file ",HSTFILE," in directory ",XBDIR
 . W !,"is not a Remittance Advice.  It cannot be loaded."
 . W !,"Reason: "
 . I BARRET=1 W " missing 'ISA' id "
 . I BARRET=2 W " missing 'HP' id "
 . I BARRET=3 W " UNKNOWN TRANSPORT FILE TYPE."
 . D EOP^BARUTL(1)
 . Q
 S TRNAME=$P(BARRET,"^",2)
 S TRDA=$O(^BAREDI("1T","B",TRNAME,""))
 W !,"File type: ",TRNAME," FILE FORMAT OKAY."
 D READ^BAR50PA1(XBDIR,HSTFILE)  ;Read file into ^TMP($J,"ERA")
 Q:+$G(POP)
 I TRNAME["5010" D 5010^BAR50P00 Q
 D 4010 Q
 Q  ;-------------------------------------------------------
4010 S ANS="Y"
 K FILE  ;bar*1.8*20
 I $D(^BAREDI("I",DUZ(2),"C",HSTFILE)) D  Q:ANS="N"
 . S IEN=$O(^BAREDI("I",DUZ(2),"C",HSTFILE,9999999),-1)
 . S LOADDT=""
 . S:(+IEN'=0) LOADDT=$$GET1^DIQ(90056.02,IEN,".02"),FILE=$$GET1^DIQ(90056.02,IEN,".01")
 . W !!,"This file was previously loaded on "_LOADDT_" as",!?2,"file "_FILE
 . W !!,?5," You can exit and review the import by entering"
 . W !,?5," the filename in the View Import Header option.",!
 . W !,"NOTE: reloading a file will create duplicate entries in the A/R EDI Check!"
 . W !,"Proceed with caution"
 . S BARFLG=1
 . S BARFLG=$$POSTCHK^BAREDP0A(IEN)
 . I BARFLG=1 W !,"Nothing has been posted from this ERA.  If you reload it, the original file",!,"will be replaced with this file.  Any edits done in REV will be lost."
 . I BARFLG=0 D  S ANS="N" Q
 . . W !!!,"Part of this file has been POSTED and is therefore not eligible for reload."
 . S DIR(0)="Y"
 . S DIR("A")="Do you wish to reload this file"
 . S DIR("B")="N"
 . S DIR("?")="Enter 'Y' to re-install transport file: "
 . D ^DIR
 . I $D(DIRUT)!Y=0 S ANS="N" Q
 . I BARFLG=1 D
 . . K DIR
 . . S DIR(0)="Y"
 . . S DIR("A")="Are you sure?"
 . . S DIR("B")="N"
 . . S DIR("?")="Enter 'Y' to re-install transport file: "
 . . D ^DIR
 . I BARFLG=1 Q:$D(DIRUT)!(ANS'="Y")
 . K DIR
 . S ANS=$S(+Y:"Y",1:"N")
 . Q:ANS'="Y"
 Q:ANS'="Y"
 K XBY,XBGUI
 W !!,"File",?25,"Directory",?50,"Transport"
 W !,HSTFILE,?25,XBDIR,?50,TRNAME,!!
 S DIR(0)="Y"
 S DIR("A")="Do you want to proceed"
 S DIR("B")="N"
 S DIR("?")="Enter 'Y' to install transport file: "
 D ^DIR
 K DIR
 Q:$D(DIRUT)
 Q:'+Y
  I +$G(BARFLG)=1 D
 . S DIK=$$DIC^XBDIQ1(90056.02)
 . S DA=IEN
 . D ^DIK
 S BARCTRL=0
 D READ^BAREDPA1(XBDIR,HSTFILE)  ;Read file into ^TMP($J,"ERA")
 Q:+$G(POP)
 D EOP^BARUTL(1)
 I '$D(^TMP($J,"ERA")) D  Q
 . W !,"The file ",HSTFILE," in directory ",XBDIR
 . W !,"Appears to be an empty file."
 . W !,"Empty files are not HIPAA compliant."
 . W !,"Inform your source and request a HIPAA compliant file"
 . W !,"Please contact your supervisor for assistance."
 . D EOP^BARUTL(1)
 D CLEAR^VALM1
 S X=$O(^TMP($J,"ERA",""),-1)
 W !,"LINE COUNT LOADED: ",X,!
 H 3
 I X'>0 G INSTALL
 K DIC
 S DIC=$$DIC^XBDIQ1(90056.02)
 S DIC(0)="EL"
 S X=HSTFILE
 S:$G(FILE) DINUM=($P(FILE,"_")-1000)  ;bar*1.8*20
 K DD,DO D FILE^DICN
 S IMPDA=+Y
 K DIC
 I +Y<1 D  Q
 . W !!,"File not created for transport"
 . D EOP^BARUTL(1)
 D NOW^%DTC
 S X=X+17000000
 S DATE=$E(X,5,6)_"/"_$E(X,7,8)_"/"_$E(X,1,4)
 D YX^%DTC
 S DATM=Y
 S SEQ=1000+IMPDA
 S TNAME=SEQ_"_ERA_"_DATE
 W TNAME,! H 3
 K DIE,DR,DA
 S DIE=$$DIC^XBDIQ1(90056.02)
 S DA=IMPDA
 S DR=".01///^S X=TNAME"
 S DR=DR_";.04////^S X=XBDIR"
 S DR=DR_";.05////^S X=HSTFILE"
 S DR=DR_";.02////^S X=DATM"
 S DR=DR_";.03////^S X=TRDA"
 D ^DIE
 ;Convert ^TMP($J,"ERA") to ^BAREDI("I",DUZ(2))
 S ^BAREDI("I",DUZ(2),IMPDA,10,0)=""
 S BARCNTL=0
 I +BARCTRL D
 . S BARESEP=$A(BARESEP)
 . S BARSSEP=$A(BARSSEP)
 . S BARCSEP=$A(BARCSEP)
 S X="" F  S X=$O(^TMP($J,"ERA",X)) Q:X=""  D
 . S BARTMP=^TMP($J,"ERA",X)
 . I +BARCTRL D  ;Separators=ctrl char
 . . F I=1:1:$L(BARTMP) D
 . . .I (($A($E(BARTMP,I))<32)!($A($E(BARTMP,I))>126)),$A(BARTMP,I)=BARSSEP S BARTMP=$E(BARTMP,1,I-1)_"~"_$E(BARTMP,I+1,999) Q
 . . .I (($A($E(BARTMP,I))<32)!($A($E(BARTMP,I))>126)),$A(BARTMP,I)=BARESEP S BARTMP=$E(BARTMP,1,I-1)_"*"_$E(BARTMP,I+1,999) Q
 . . .I (($A($E(BARTMP,I))<32)!($A($E(BARTMP,I))>126)),$A(BARTMP,I)=BARCSEP S BARTMP=$E(BARTMP,1,I-1)_":"_$E(BARTMP,I+1,999) Q
 . . .I ($A($E(BARTMP,I))<32)!($A($E(BARTMP,I))>126) S BARTMP=$E(BARTMP,1,I-1)_$E(BARTMP,I+1,999)
 . I '+BARCTRL D
 . . F I=1:1:$L(BARTMP) D
 . . . I ($A($E(BARTMP,I))<32)!($A($E(BARTMP,I))>126) S BARTMP=$E(BARTMP,1,I-1)_$E(BARTMP,I+1,999)
 . I '+$L(BARTMP) Q
 . S BARCNTL=BARCNTL+1
 . S ^BAREDI("I",DUZ(2),IMPDA,10,BARCNTL,0)=BARTMP
REDO ;EP entry for mid stream testing
 S SUCC=""
 S NRECS=$O(^TMP($J,"ERA",""),-1)
 I NRECS="" S NRECS="No",SUCC="un"
 W !,"The ",XBFN," file has been "_SUCC_"successful in updating"
 W !,"the transport global"
 W !!,NRECS," records updated"
 Q:NRECS="No"
 W !,"PROCESSING",!,"TRANSPORT FILE: ",?20,XBFN
 W !,"IMPORT NAME: ",?20,TNAME,!!
 ; Split image into segmts
 W !,"Starting stage 1 of 3 -> Extract data from transport to segments"
 D EN^BAREDP01(TRDA,IMPDA)
 W !,"Stage 1 -> Complete"
 ; Parse segmts into elemts & vals
 W !!,"Starting stage 2 of 3 -> Parse segments into elements & values"
 D EN^BAREDP02(TRDA,IMPDA)
 D CHKS^BAREDP02(IMPDA)  ;bar*1.8*20 REQ2
 W !," Stand by to print TRN - Check Number/Check Amount Report..."
 D EN1^BAREDPCS  ;bar*1.8*20 REQ2
 W !,"Stage 2 -> Complete"
 ; Build postable clms
 W !!,"Starting stage 3 of 3 -> Build postable claims"
 H 1
 D EN^BAREDP03(TRDA,IMPDA)
 W !,"Stage 3 -> Complete"
 D EOP^BARUTL(1)  ;bar*1.8*20
 Q
PLB ;Chk for PLB/Pymt Reversals ;MRS:BAR*1.8*10 D159
 ;start new bar*1.8*20 REQ4
 D SELFL
 I Y'>0 Q
 ;IHS/SD/TPF 8/22/2001 BAR*1.8*21 5010
 I TRNAME[("5010") D PLB^BAR50P00 Q
 S BARCNT=0,I=0
 F  S I=$O(^BAREDI("I",DUZ(2),IMPDA,5,I)) Q:'I  D
 . S BARCNT=BARCNT+1
 I BARCNT=1 S BARCKIEN=$O(^BAREDI("I",DUZ(2),IMPDA,5,0)),BARCHK=$P($G(^BAREDI("I",DUZ(2),IMPDA,5,BARCKIEN,0)),U)
 I BARCNT>1 D SELCK  ;if 1+ chk, pick 1
 I +$G(BARCKIEN)'>0 Q
 S BARQT=0,BARQUIT=1
 I $D(^BAREDI("I",DUZ(2),IMPDA,30,"AC","M")) D
 . S CLMDA=0
 . F  S CLMDA=$O(^BAREDI("I",DUZ(2),IMPDA,30,"AC","M",CLMDA)) Q:'CLMDA  D  Q:BARQT
 . .I $P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,2)),U)=BARCHK S BARQT=1
 . Q:'BARQT
 . W !!,"Bill matching for this check has already been done."
 . K DIR
 . S DIR(0)="Y"
 . S DIR("A")="Do you want to do matching again"
 . D ^DIR K DIR
 . S BARQUIT=+Y
 Q:'BARQUIT
 I $P($G(^BAREDI("I",DUZ(2),IMPDA,5,BARCKIEN,0)),U,7)="" W !!,"NOTE: This check has NOT been matched to a batch/item",!
 W !,"I will begin bill matching..."
 H 1
 D EN^BAREDP04(TRDA,IMPDA)
 I '+$G(QFLG) W !!,"Matching complete"
 I +$G(QFLG) W !!,"Matching NOT complete"
 S DIE=$$DIC^XBDIQ1(90056.02)
 S DA=IMPDA
 S DR=".08////M"
 D ^DIE
 K DIR
 S DIR(0)="E"
 S DIR("A")="<CR> - Continue"
 D ^DIR
 D CLEAR^VALM1
 D CLNUP
 Q
FORMAT(BARREC) ;
 ; Verify file loading is HIPAA 835 if Transport HIPAA 835
 ; Return >0^STRING if wrong format
 ; Return 0^TRANSPORT_TYPE if correct format
 K BARSSEP,BARESEP,BARCSEP
 N BARTMP,BARGS08,X,I,BARERR
 S BARCTRL=0,BARERR=0
 S BARTMP=BARREC
 I $E(BARTMP,1,3)'="ISA" S BARERR=1 Q BARERR  ;all X12 messages start w/ ISA
 S BARESEP=$E(BARTMP,4)  ;Element separator
 I $A(BARESEP)<32!($A(BARESEP)>126) S BARCTRL=1
 S BARSSEP=$E(BARTMP,106)  ;Segment separator
 I $A(BARSSEP)<32!($A(BARSSEP)>126) S BARCTRL=1
 S BARCSEP=$E(BARTMP,105)  ;Component separator
 I $A(BARCSEP)<32!($A(BARCSEP)>126) S BARCTRL=1
 I DUZ=902 W 1/0
 I $E($P(BARTMP,BARSSEP,2),4,5)'="HP" S BARERR=2 Q BARERR ;GS01 must be HP for 835
 S BARGS08=$P($P(BARTMP,BARSSEP,2),BARESEP,9)
 I BARGS08["004010X091" Q 0_"^HIPAA 835 v4010"
 I BARGS08["005010X221" Q 0_"^HIPAA 835 v5010"
 Q 3_"^"_BARGS08
 ;
REVIEW ;EP
 I $G(DUZ(2))="" D  Q
 . W !!,"Check your DUZ setup."
 . D EOP^BARUTL(1)
 D SELFL
 I Y'>0 Q
 I TRNAME[("5010") D REVIEW^BAR50P00 Q
 D ERACHECK^BAREDP09
 I $O(BARCHK(9999),-1)=1 S BARCKIEN=$O(^BAREDI("I",DUZ(2),IMPDA,5,0)),BARCHK=$P($G(^BAREDI("I",DUZ(2),IMPDA,5,BARCKIEN,0)),U)
 I $O(BARCHK(9999),-1)>1 D SELCK
 I +$G(BARCKIEN)'>0 Q
 ;Review screen
 D EN^BAREDP05
 I TRNAME["HIPAA" D  ;Mark chk as reviewed
 .D NOW^%DTC
 .S BARDTREV=%
 .K DIE,DIC,DA,DR,X,Y
 .S DIE="^BARECHK("
 .S DA=$P(BARCHK(BARCKIEN),U,5)
 .S DR=".05///^S X=BARDTREV"
 .S DR=DR_";.06////^S X=DUZ"
 .D ^DIE
 D CLNUP
 Q
POST ; EP
 I $G(DUZ(2))="" D  Q
 .W !!,"Check your DUZ setup."
 .D EOP^BARUTL(1)
 D SELFL
 I Y'>0 Q
 I TRNAME[("5010") D POST^BAR50P00 Q
 I TRNAME["HIPAA" D  Q
 .S BARCKIEN=$$CHKSEL^BAREUTL(IMPDA,"POST")
 .Q:'+BARCKIEN
 .D POST^BAREDP08(BARCKIEN)
 ;Get batch/item info
 I NOBTCH D BTCHCHK
 I 'NOBTCH D
 .D BTCHDISP
 .W !
 .S DIR(0)="Y"
 .S DIR("A")="Do you want to select a different batch"
 .S DIR("B")="N"
 .S DIR("?")="Enter 'Y' to select a different batch "
 .D ^DIR
 .K DIR
 .Q:$D(DIRUT)
 .S NOBTCH=1
 .I X="Y" D BTCHCHK
 D CLEAR^VALM1
 I 'NOBTCH D BTCHDISP
 I +$G(BARCOL),+$G(BARITM)
 E  D
 .W !,"Batch & Item not selected ",!,"Adjustments only will be made,",!!
 .H 2
 .K BARCOL,BARITM
 .K DR,DIE,DA,DIC
 .S DIE=$$DIC^XBDIQ1(90056.02)
 .S DA=IMPDA
 .S DR=".06///@;.07///@"
 .D ^DIE
POSTA ;EP  POST
 W !
 S DIR(0)="Y"
 S DIR("A")="DO YOU WANT TO POST CLAIMS NOW."
 S DIR("A",1)="The above information details the transport and batch that"
 S DIR("A",2)="has been selected to post matched claims to the A/R database"
 S DIR("B")="N"
 S DIR("?")="Enter 'Y' to load matched claims: "
 D ^DIR
 K DIR
 Q:$D(DIRUT)
 I X="Y" D
 .D EN^BAREDP06(TRDA,IMPDA)
 .S BARRAYGO=0  ;"Roll-over as you go" flag set to no
 .D EN^BARROLL  ;Loops BARROLL array & marks for rollback
 .K BARROLL
 D CLNUP
 Q
VIEW ; EP
 I $G(DUZ(2))="" D  Q
 .W !!,"Check your DUZ setup."
 .D EOP^BARUTL(1)
 N RPTLOOK S RPTLOOK=1
 D SELFL
 I Y'>0 Q
 I TRNAME[("5010") D VIEW^BAR50P00 Q
 D VIEW^BAREDIUT(TRDA,IMPDA)
 D CLNUP
 Q
REPORT ; EP
 I $G(DUZ(2))="" D  Q
 .W !!,"Check your DUZ setup."
 .D EOP^BARUTL(1)
 N RPTLOOK S RPTLOOK=1  ;Allow rpts to view ERA batches older than 3rd qtr past
 ;RPTLOOK will be used to BARPST to bypass chk HEAT10729 BAR*1.8*17 PKD 3/30/10
 D SELFL
 I Y'>0 Q
 I TRNAME[("5010") D REPORT^BAR50P00 Q
 I TRNAME["HIPAA" D  Q:'+BARCKIEN  S BARCHK=$$GET1^DIQ(90056.22,BARCKIEN,.01)
 .S BARCKIEN=$$CHKSEL^BAREUTL(IMPDA,"REPORT")
 I TRNAME["HIPAA",+BARCKIEN D EN^BAREDP10
 I TRNAME'["HIPAA" D EN^BAREDP07
 D CLNUP
 Q
 ;new code bar*1.8*20 REQ8
NFOUND ; EP
 I $G(DUZ(2))="" D  Q
 .W !!,"Check your DUZ setup."
 .D EOP^BARUTL(1)
 N RPTLOOK S RPTLOOK=1  ;Allow rpts to view ERA batches older than 3rd qtr past
 D SELFL
 I Y'>0 Q
 I TRNAME[("5010") D NFOUND^BAR50P00 Q
 I TRNAME["HIPAA" D EN^BAREDP12
 D CLNUP
 Q
SELFL ;Select file
 S NOBTCH=1
 ;D SELFL^BAR50FS
 K DIC
 S DIC="^BAREDI(""I"",DUZ(2),"
 S DIC("W")="D VIEWLIST^BAREDP00"
 W !
 S DIC(0)="AEZQM"
 S DIC("A")="Select file: "
 ;S DIC("S")="I $$NEWFILE^BAREDP00(Y)" ;show only files newer than...12/20/2013 P.OTT TEST
 K DD,DO
 D ^DIC
 I Y'>0 Q
 L +^BAREDI("I",+Y):2 E  W !,"THIS FILE IS BEING VIEWED, REVIEWED OR POSTED BY ANOTHER USER!! TRY AGAIN LATER." G SELFL  ;BAR*1.8*5 SRS-80 TPF
 S IMPDA=$P(Y,U)
 S TRDA=$P(Y(0),U,3)
 S HSTIME=$P(Y(0),U,2)
 ;RPTLOOK set in REPORT tag - allow rpts on batches > 3quarters old
 S HSTFILE=$P(Y(0),U,5)
 I '$G(RPTLOOK) D  I 'Y G SELFL
 . I '$$CKDATE^BARPST(HSTFILE,1,"SELECT ERA FILE") S Y=0 K IMPDA  ;MRS;BAR*1.8*6 DD 4.2.4  ;bar*1.8*20
 S TRNAME=$$GET1^DIQ(90056.01,TRDA,.01)
 I TRNAME'["HIPAA" D
 .S BARCOL=$P(Y(0),U,6)
 .S BARITM=$P(Y(0),U,7)
 .I +BARCOL,+BARITM S NOBTCH=0
 K DIC
 Q
 ;
NEWFILE(Y) ;
 N X,X1,X2
 S X=^BAREDI("I",DUZ(2),Y,0)
 S X=$P(X,"_ERA_",2)
 S X=$P(X,"^",1) I X="" Q 1
 S %DT="" D ^%DT
 ;W !,X," = ",Y 
 S X1=DT,X2=Y D ^%DTC I X>365 Q 0 ;W " > 365 DYAS" Q 0
 Q 1
SELCK ;
 D SELCK^BAREDP0A
 Q
 ;
BTCHCHK ; 
 D INIT^BARUTL
 K BARCOL,BARITM
 D BATCH^BARFPST
 ; Returns BARCOL
 I '$G(BARCOL) D  Q
 .W !,"NO BATCH SELECTED ",!
 .H 2
 D ITEM^BARFPST
 I +$G(BARCOL),+$G(BARITM)
 E  D  Q
 .W !,"NONE SELECTED ",!
 .H 2
 K DIE,DR,DA
 S DIE=$$DIC^XBDIQ1(90056.02)
 S DA=IMPDA
 S DR=".06////^S X=BARCOL;.07////^S X=BARITM"
 D ^DIE
 S NOBTCH=0
 H 2
 Q
BTCHDISP ;
 S SP="      "
 D CLEAR^VALM1
 I $G(BARCOL) D ENP^XBDIQ1(90051.01,"BARCOL",".01;8","BNM($J,")
 W !,"Transport: ",$P($G(^BAREDI("1T",TRDA,0)),"^")
 W !,"Created from ",$G(HSTFILE)," on ",$G(HSTIME)
 W !!,"Batch: ",$G(BNM($J,.01))_"  "_$G(BNM($J,8))
 I $G(BARCOL) D BBAL^BARPST(BARCOL)
 W !!,"Item: "_$G(BARITM)
 I $G(BARITM) D IBAL^BARPST(BARITM)
 Q
CLNUP ;
 I $G(IMPDA) L -^BAREDI("I",IMPDA)
 K XBDIR,X,Y,HSTFILE,ANS,IMPDA,TRDA,DATM,SEQ,TNAME
 K HSTIME,BARCOL,BARITM
 Q
VIEWLIST ;EP
 N I,BARCHK
 W ?35,$P($G(^BAREDI("I",DUZ(2),+Y,0)),U,5)
 I $P($G(^BAREDI("I",DUZ(2),+Y,0)),U,9)]"" W !?50,"CHK/EFT #: ",$P(^BAREDI("I",DUZ(2),+Y,0),U,9) Q
 S I=""
 F  S I=$O(^BAREDI("I",DUZ(2),"F",I)) Q:I=""  D
 . Q:'$D(^BAREDI("I",DUZ(2),"F",I,+Y))
 . S BARCHK(I)=""
 S I=""
 F  S I=$O(BARCHK(I)) Q:I=""  W ?50,"CHK/EFT #: ",I,!
 Q
READ(BARPATH,BARFILE) ; EP
 ; Read host file into ^TMP($J,"ERA")
 N BARCNT,BARTXT,BARDONE
 S (BARCNT,BARDONE)=0,BARREC=""
 D OPEN^%ZISH("835FILE"_$J,BARPATH,BARFILE,"R")
 I POP D  Q
 . W !!,"Error opening file....please verify filename and directory and try again"
 . S BARDONE=1
 . D EOP^BARUTL(1)
 S BARCNT=0,BARI=0 ;# OF DELIMITERS
 F I=1:1 Q:BARCNT=3  D
 . U IO READ *CH
 . I CH=10 Q
 . I CH=13 Q
 . S BARI=BARI+1 I BARI=106 S BARDEL=$C(CH),BARCNT=1 ;GET DELIMITER
 . S BARREC=BARREC_$C(CH)
 . I BARI>106 I BARDEL=$C(CH) S BARCNT=BARCNT+1
 D CLOSE^%ZISH("835FILE"_$J)
 Q  ;EOR
