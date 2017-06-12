BLRRLMV ; cmi/anch/maw - BLR View/Refile Raw Reference Lab Messages ; 27-Jul-2015 06:30 ; MAW
 ;;5.2;LR;**1021,1030,1033,1035**;NOV 1, 1997;Build 5
 ;;1.0;BLR REFERENCE LAB;;MAR 14, 2005
 ;
 ;
 ;
 ;this routine will allow the user to verify reference lab results
 ;before passing them on to PCC
 ;
MAIN ;EP - this is the main routine driver
 S BLRMF=$$ASK
 I $G(BLRMF)="F" D  Q
 . S BLRRF=$$ASKF
 . I $G(BLRRF)]"" D LOOP
 . D EOJ
 I $G(BLRMF)="M" D
 . S BLRMSG=$$ASKM
 . I $G(BLRMSG) D SM(BLRMSG)
 D EOJ
 Q
 ;
ASK() ;-- ask to look by message number or file
 S DIR(0)="S^M:Message Number;F:File",DIR("A")="Select by Message Number or File Name "
 D ^DIR
 K DIR
 Q $G(Y)
 ;
ASKF() ;-- ask file
 S DIR(0)="P^9009026.1",DIR("A")="Which Reference Lab Import File Do You Want To View "
 D ^DIR
 K DIR
 Q +$G(Y)
 ;
ASKM() ;-- ask message number
 S DIR(0)="N",DIR("A")="Which Message Would You Like to View/Refile "
 D ^DIR
 K DIR
 Q +$G(Y)
 ;
LEDI  ;EP - main LEDI driver
 ;I '$$EDITRFL D EDHL Q
 N BLRAN,BLRIN,BLRYN
 S BLRAN=$$ASKA
 I $G(BLRAN) S BLRIN=$$ACCLOOK(.BLRD,BLRAN)
 I '$G(BLRIN) D EOJ Q
 S BLRYN=$$RFL(BLRIN)
 I $G(BLRYN) D
 . N BLRMA
 . S BLRMA=$O(^HLMA("B",$G(BLRD(BLRYN)),0))
 . Q:'BLRMA
 . D REPROC^HLUTIL(BLRMA,"D ORU^LA7VHL")
 D EOJ
 Q
 ;
EDITRFL() ;-- edit or just refile
 K DIR
 S DIR(0)="S^E:Edit and Refile Message;R:Refile Message"
 D ^DIR
 Q:$D(DIRUT) 0
 I $G(Y)="E" Q 0
 Q 1
 ;
ACCLOOK(BLRD,ACC)  ;lets look up the accession number in HL(772
 N BLRDA,BLRIEN,BLRMT,BLRI,BLRM,BLRCN
 S BLRMT=0
 S BLRCN=0
 S BLRDA=0 F  S BLRDA=$O(^HL(772,BLRDA)) Q:'BLRDA!($G(BLRMT))  D
 . S BLRIEN=0 F  S BLRIEN=$O(^HL(772,BLRDA,"IN",BLRIEN)) Q:'BLRIEN!($G(BLRMT))  D
 .. I $G(^HL(772,BLRDA,"IN",BLRIEN,0))[ACC,$$CHKMSG(BLRDA) D
 ... S BLRCN=BLRCN+1
 ... S BLRD(BLRCN)=BLRDA
 ... S BLRD=BLRDA,BLRI=BLRIEN  ;,BLRMT=1
 I '$D(BLRD) W !,"Could not find an entry to refile" Q ""
 N BLRIDA,BLRDD
 S BLRIDA=0 F  S BLRIDA=$O(BLRD(BLRIDA)) Q:'BLRIDA  D
 . S BLRDD=$G(BLRD(BLRIDA))
 . W !!,"Entry #"_BLRIDA,!
 . D WRT(BLRDD)
 ;S BLRM=$O(^HLMA("B",BLRD,0))
 ;Q $G(BLRM),!
 Q $G(BLRCN)
 ;
RFL(IN) ;-- ask if they want to refile
 ;S DIR(0)="Y",DIR("A")="Is this the entry you want to refile",DIR("B")="Y"
 ;D ^DIR
 ;Q +$G(Y)
 ;
 K DIR
 S DIR(0)="N^1:"_IN,DIR("A")="Refile which entry"
 D ^DIR
 Q +$G(Y)
 ;
ASKA() ;-- ask the accession number
 K DIR
 S DIR(0)="N",DIR("A")="Which Accession/Order # Would You Like to View/Refile "
 D ^DIR
 K DIR
 Q +$G(Y)
 ;
CHKMSG(M) ;-- check to see if this is an ORU R01 message
 N MI
 S MI=$O(^HLMA("B",M,0))
 I 'MI Q 0
 I $$GET1^DIQ(779.001,$P($G(^HLMA(MI,0)),U,14),.01)="R01" Q 1
 Q 0
WRT(RD) ;-- lets call DIQ to display the entry
 N BLRI
 S BLRI=0 F  S BLRI=$O(^HL(772,RD,"IN",BLRI)) Q:'BLRI  D
 . W !,$G(^HL(772,RD,"IN",BLRI,0))
 Q
 ;
LOOP ;-- loop the xref and call VER
 I $O(^BLRRLG("B",0))="" D  Q
 . W !,"No Files to View"
 S DIC="^INTHU("
 S BLRVDA=0 F  S BLRVDA=$O(^BLRRLG(BLRRF,1,BLRVDA)) Q:'BLRVDA!$G(BLRVQ)  D
 . Q:$G(BLRVQ)
 . W @IOF
 . S (DA,BLRUIF)=$G(^BLRRLG(BLRRF,1,BLRVDA,0))
 . I '$G(^INTHU(BLRUIF,0)) D  Q
 .. W !!,"GIS HL7 Message "_BLRUIF_" has already been purged, cannot display"
 . D DIQ^BLRLMR(DIC,DA)
 W !!,"No More Messages in Batch, Exiting"
 H 2
 Q
 ;
SM(BLRUIF) ;-- view the message
 I '$D(^INTHU(BLRUIF)) D  Q
 . W !!,"GIS HL7 Message "_BLRUIF_" has already been purged, cannot display"
 S DIC="^INTHU("
 Q:$G(BLRVQ)
 W @IOF
 S (DA,BLRUIF)=BLRUIF
 D DIQ^BLRLMR(DIC,DA)
 Q
 ;
REF(UIF) ;-- mark entry as verified
 S ^INLHSCH(0,$H,UIF)=""
 Q
 ;cmi/flag/maw 4/8/2004 the following is not used anymore
 S BLRRL=$P($G(^BLRSITE(DUZ(2),"RL")),U)
 Q:'$G(BLRRL)
 S BLRRLE=$P($G(^BLRRL(BLRRL,0)),U)
 S BLRSCR=$O(^INRHS("B","Generated: HL IHS LAB R01 "_BLRRLE_" IN-I",0))
 Q:'$G(BLRSCR)
 S BLRRUN="S BLRRFL=$$^IS"_$$ZERO(BLRSCR)_BLRSCR_"("_UIF_")"
 X BLRRUN
 Q
 ;
EOJ ;-- kill variables
 D JOB^BLRPARAM
 D EN^XBVK("BLR")
 Q
 ;
ZERO(SCR)          ;-- find out how many zeros need to be installed
 I $L(BLRSCR)=1 Q "0000"
 I $L(BLRSCR)=2 Q "000"
 I $L(BLRSCR)=3 Q "00"
 I $L(BLRSCR)=4 Q "0"
 Q "0"
 ;
EDHL ;-- lets insert the accession number if not there by finding the patient and order code
 N BLRP,BLRON,BLRCDTBLRAC,BLRIN,BLRYN,BLRY,BLRM
 S BLRP=$$ASKP
 Q:'$G(BLRP)
 S BLRON=$$ASKO
 Q:'$G(BLRON)
 S BLRCDT=$$ASKCDT
 Q:'$G(BLRCDT)
 S BLRCDT=$$FMTHL7^XLFDT(BLRCDT)
 I $G(BLRP),$G(BLRON),$G(BLRCDT) S BLRIN=$$MSGLOOK(.BLRD,BLRP,BLRON,BLRCDT)
 I '$G(BLRIN) D EOJ Q
 ;need to change this below so BLRY is the actual message number at this point
 S BLRY=$$CMSG(BLRIN)
 Q:'$G(BLRY)
 S BLRM=$G(BLRD(BLRY))
 Q:'$G(BLRM)
 D SETOBR(BLRM)
 Q:'$D(BLROBR)
 D ADDACC(.BLROBR,BLRM)
 D UPACC(.BLROBR,BLRM)
 S BLRYN=$$ERFL(BLRM)
 I $G(BLRYN) D
 . N BLRMA
 . S BLRMA=$O(^HLMA("B",BLRM,0))
 . Q:'BLRMA
 . D REPROC^HLUTIL(BLRMA,"D ORU^LA7VHL")
 D EOJ
 Q
 ;
ASKP() ;-- ask the patient chart
 K DIR
 S DIR(0)="N",DIR("A")="What is the patient chart number to find "
 D ^DIR
 K DIR
 Q +$G(Y)
 ;
ASKO() ;-- ask the order code
 K DIR
 S DIR(0)="F",DIR("A")="What is the order code to find "
 D ^DIR
 K DIR
 Q +$G(Y)
 ;
ASKCDT() ;-- ask the collection date
 K %DT
 S %DT="AE",%DT("A")="What is the collection date: "
 D ^%DT
 I Y=-1 Q 0
 Q +Y
 Q
 ;
ASKAC() ;-- ask the accession number
 K DIR
 S DIR(0)="N",DIR("A")="What is the accession number to insert "
 D ^DIR
 K DIR
 Q +$G(Y)
 ;
MSGLOOK(BLRD,PT,ON,CDT)  ;lets look up the accession number in HL(772
 N BLRDA,BLRIEN,BLRMT,BLRI,BLRM,BLRCN,BLRMT
 S BLRCN=0
 S BLRDA=0 F  S BLRDA=$O(^HL(772,BLRDA)) Q:'BLRDA  D
 . S BLRMT=0
 . S BLRIEN=0 F  S BLRIEN=$O(^HL(772,BLRDA,"IN",BLRIEN)) Q:'BLRIEN  D
 .. I $P($G(^HL(772,BLRDA,"IN",BLRIEN,0)),"|")="PID",$P($G(^HL(772,BLRDA,"IN",BLRIEN,0)),"|",4)=PT,$$CHKMSG(BLRDA) S BLRMT=1
 .. Q:'$G(BLRMT)
 .. I $P($G(^HL(772,BLRDA,"IN",BLRIEN,0)),"|")="OBR",$P($P($G(^HL(772,BLRDA,"IN",BLRIEN,0)),"|",5),"^",4)=ON,$E($P($G(^HL(772,BLRDA,"IN",BLRIEN,0)),"|",8),1,8)=CDT,$$CHKMSG(BLRDA) S BLRMT=2
 .. Q:$G(BLRMT)'=2
 .. S BLRCN=BLRCN+1
 .. S BLRD(BLRCN)=BLRDA
 .. S BLRD=BLRDA,BLRI=BLRIEN  ;,BLRMT=1
 .. K BLRMT
 I '$D(BLRD) W !,"Could not find a matching entry" Q ""
 N BLRIDA,BLRDD
 S BLRIDA=0 F  S BLRIDA=$O(BLRD(BLRIDA)) Q:'BLRIDA  D
 . S BLRDD=$G(BLRD(BLRIDA))
 . W !!,"Entry #"_BLRIDA,!
 . D WRT(BLRDD)
 ;S BLRM=$O(^HLMA("B",BLRD,0))
 ;Q $G(BLRM),!
 Q $G(BLRCN)
 ;
SETOBR(MSG) ;-- loop through the message and get the OBR and test for editing
 N MDA,CODE,DESC
 S MDA=0 F  S MDA=$O(^HL(772,MSG,"IN",MDA)) Q:'MDA  D
 . I $P($G(^HL(772,MSG,"IN",MDA,0)),"|")="OBR" D
 .. S CODE=$P($P($G(^HL(772,MSG,"IN",MDA,0)),"|",5),"^",4)
 .. S DESC=$P($P($G(^HL(772,MSG,"IN",MDA,0)),"|",5),"^",5)
 .. S BLROBR(MSG,MDA)=CODE_U_DESC
 Q
 ;
ERFL(RY) ;-- ask if they want to refile
 W !
 D WRT(RY)
 K DIR
 S DIR(0)="Y",DIR("A")="Ready to Refile"
 D ^DIR
 Q +$G(Y)
 ;
CMSG(IN) ;-- ask if they want to refile
 K DIR
 S DIR(0)="N^1:"_IN,DIR("A")="Which message is the correct one to edit"
 D ^DIR
 Q +$G(Y)
 ;
ADDACC(OBR,RY) ;-- lets add the accession to the obr
 N RDA,CD,DS,SAME
 S SAME=$$SAMEACC
 Q:SAME=-1
 I SAME D  Q
 . S ACC=$$ACC("","",1)
 . S RDA=0 F  S RDA=$O(OBR(RY,RDA)) Q:'RDA  D
 .. S $P(OBR(RY,RDA),U,3)=ACC
 S RDA=0 F  S RDA=$O(OBR(RY,RDA)) Q:'RDA  D
 . S CD=$P(OBR(RY,RDA),U)
 . S DS=$P(OBR(RY,RDA),U,2)
 . S ACC=$$ACC(CD,DS,0)
 . Q:'$G(ACC)
 . S $P(OBR(RY,RDA),U,3)=ACC
 Q
 ;
SAMEACC() ;-- same accession number for all tests
 K DIR
 S DIR(0)="Y",DIR("A")="Same accession number for all tests"
 D ^DIR
 Q:$D(DIRUT) -1
 Q +$G(Y)
 ;
ACC(C,D,T) ;-- lets get the accession number to file
 K DIR,PRM
 S DIR(0)="N"
 S PRM=$S(T:"Accession number for all tests",1:"Accession number for test ("_C_") "_D)
 S DIR("A")=PRM
 D ^DIR
 Q +$G(Y)
 ;
UPACC(OBR,RY) ;-- update the message with accessions
 N UDA,AC
 S UDA=0 F  S UDA=$O(OBR(RY,UDA)) Q:'UDA  D
 . S AC=$P($G(OBR(RY,UDA)),U,3)
 . S $P(^HL(772,RY,"IN",UDA,0),"|",3)=AC
 Q
 ;
