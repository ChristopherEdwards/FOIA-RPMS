ACRFSPL1 ;IHS/OIRM/DSD/AEF - DHR-SPLITOUT [ 11/01/2001   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;;NOV 05, 2001
 ;
 ;This routine produces a display of batches available for export and 
 ;prompts the user for which batch to export.  The variable ACRD0 is
 ;returned set to the internal number of the batch to be exported.
 ;
 ;
EN(ACRCTR,ACRDTNM,ACRPKG)    ;EP
 ;----- MAIN ENTRY POINT
 ;
 ;      ACRCTR  = TYPE OF TRANSACTIONS
 ;                ARM = ARMS
 ;                BCS = CHS
 ;                PCC = MANUALLY ENTERED
 ;      ACRDTNM = DATA TYPE NAME
 ;                DHRP
 ;                dhc
 ;      ACRPKG  = PACKAGE
 ;                AFSH = ARMS
 ;                ACHS = CHS
 ;
 N ACR,ACRDISP,ACRNTRB,ACRNTRL,ACROUT,ACRZ
 D ^XBKVAR
 D HOME^%ZIS
 D HDR
 D GET
 D HDR1
 D HDR2
 D HDR3
 D SHOW
 D PROMPT
 I $G(ACROUT) K ACRD0 Q
 Q
GET ;----- GETS DATA TO DISPLAY
 ;
 ;      ACRD0 = BATCH COLOR
 ;              1 = PCC-BLUE
 ;              2 = PCC-RED
 ;              3 = CHS-BLUE
 ;              4 = CHS-RED
 ;              5 = ARMS-BLUE
 ;              6 = ARMS-RED
 ;
 N ACRD0
 K ACR
 I ACRCTR="PCC" F ACRD0=1,2 D LOOP(ACRD0)
 I ACRCTR="BCS" F ACRD0=3,4 D LOOP(ACRD0)
 I ACRCTR="ARM" F ACRD0=5,6 D LOOP(ACRD0)
 D DISP
 Q
LOOP(ACRD0)        ;
 ;----- LOOPS THROUGH THE BATCH COLOR ENTRIES TO GATHER DATA FOR DISPLAY
 ;
 ;      DATA = REUSABLE DATA VARIABLE
 ;      ACR  = ARRAY CONTAINING BATCH DATA:
 ;             ACR(COLORIEN,BATCHDATE)=1ST BATCHID^LAST BATCHID^NUMBER
 ;             OF BATCHES^NUMBER OF RECORDS^NUMBER OF NO TRAILERS
 ;
 N ACRD1,ACRD2,ACRD3,DATA
 S ACRD1=0
 F  S ACRD1=$O(^AFSHRCDS(ACRD0,"D",ACRD1)) Q:'ACRD1  D
 . S ACR(ACRD0,ACRD1)=""
 . S DATA=$P(^AFSHRCDS(ACRD0,0),U,2) ;color export date
 . S ACR(ACRD0,"STATUS")=$S(DATA="":"E",1:"T")_U_DATA
 . S ACRD2=0
 . F  S ACRD2=$O(^AFSHRCDS(ACRD0,"D",ACRD1,"I",ACRD2)) Q:'ACRD2  D
 . . S DATA=^AFSHRCDS(ACRD0,"D",ACRD1,"I",ACRD2,0)
 . . I $P(ACR(ACRD0,ACRD1),U)="" S $P(ACR(ACRD0,ACRD1),U)=$P(DATA,U)
 . . S $P(ACR(ACRD0,ACRD1),U,2)=$P(DATA,U)
 . . S $P(ACR(ACRD0,ACRD1),U,3)=$P(ACR(ACRD0,ACRD1),U,3)+1
 . . I $P(DATA,U,3)'="C" D
 . . . S $P(ACR(ACRD0,ACRD1),U,5)=$P(ACR(ACRD0,ACRD1),U,5)+1
 . . . S ACRNTRL(ACRD0)=1
 . . . S ACRNTRB(ACRD0,ACRD1,$P(DATA,U))=""
 . . S ACRD3=0
 . . F  S ACRD3=$O(^AFSHRCDS(ACRD0,"D",ACRD1,"I",ACRD2,"S",ACRD3)) Q:'ACRD3  D
 . . . S $P(ACR(ACRD0,ACRD1),U,4)=$P(ACR(ACRD0,ACRD1),U,4)+1
 Q
DISP ;----- BUILDS DISPLAY ARRAY
 ;
 N ACRD0,ACRD1,CNT
 S (ACRZ(1),ACRZ(2),ACRD0)=0
 F  S ACRD0=$O(ACR(ACRD0)) Q:'ACRD0  D
 . S (ACRD1,CNT)=0
 . F  S ACRD1=$O(ACR(ACRD0,ACRD1)) Q:'ACRD1  D
 . . S CNT=CNT+1
 . . S $P(ACRDISP(CNT),";",$S(ACRD0#2:1,1:2))=ACRD1_U_ACR(ACRD0,ACRD1)
 . . S ACRZ($S(ACRD0#2:1,1:2))=1
 Q
SHOW ;----- SHOW BATCHES
 ;
 N DATA,I,PC
 S I=0
 F  S I=$O(ACRDISP(I)) Q:'I  D
 . W !
 . F PC=1,2 D
 . . S DATA=$P(ACRDISP(I),";",PC)
 . . W ?$S(PC=1:5,1:41)
 . . W $$DATE($P(DATA,U))
 . . W "   "
 . . W $J($P(DATA,U,4),3)
 . . W "   "
 . . W $P(DATA,U,2)_$S($P(DATA,U,2)]"":"-",1:"")_$P(DATA,U,3)
 . . W "  "
 . . W $J($P(DATA,U,5),4)
 . . W "  "
 . . W $J($P(DATA,U,6),3)
 . . I PC=1 W "    |"
 Q
DATE(X) ;----- RETURNS DATE IN MM/DD/YY FORMAT
 ;
 I X]"" S X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3)
 Q X
 ;
PROMPT ;----- PROMPTS USER FOR WHICH BATCH TO EXPORT
 ;
 N DIR,X,Y
 S DIR(0)="SBM^B:BLUE;R:RED"
 S DIR("A")="Enter Batch COLOR to USE"
 W !
 D ^DIR
 I $D(DIRUT) S ACROUT=1 Q
 I Y="B" S ACRD0=$S(ACRCTR="PCC":1,ACRCTR="BCS":3,ACRCTR="ARM":5,1:"")
 I Y="R" S ACRD0=$S(ACRCTR="PCC":2,ACRCTR="BCS":4,ACRCTR="ARM":6,1:"")
 I '$G(ACRD0) S ACROUT=1 Q
 I '$D(ACR(ACRD0)) W !?10,*7,"Batch COLOR NOT AVAILABLE FOR EXPORT -- Select AGAIN" G PROMPT
 I $D(ACRNTRL(ACRD0)) D
 . D NTRL
 . W !!,*7,"All Batches MUST have a trailer -- JOB CANCELLED"
 . S ACROUT=1
 Q
NTRL ;----- LISTS BATCHES WITH NO TRAILERS
 ;
 N ACRD0,ACRD1,ACRI,DIR,X,Y
 S DIR(0)="Y"
 S DIR("A")="Batches exist w/o TRAILERS -- want to see a list"
 S DIR("B")="YES"
 D ^DIR
 Q:'Y
 S ACRD0=0
 F  S ACRD0=$O(ACRNTRB(ACRD0)) Q:'ACRD0  D
 . S ACRD1=0
 . F  S ACRD1=$O(ACRNTRB(ACRD0,ACRD1)) Q:'ACRD1  D
 . . S ACRI=""
 . . F  S ACRI=$O(ACRNTRB(ACRD0,ACRD1,ACRI)) Q:ACRI']""  D
 . . . W !?5,$$DATE(ACRD1)_"-"_ACRI
 Q
HDR ;----- WRITES MAIN OPTION HEADER
 ;
 D ^XBCLS
 N I
 S ACRPKG=$S(ACRCTR="PCC"!(ACRCTR="ARM"):"REGULAR FINANCE TRANSACTIONS",ACRCTR="BCS":"CHS CORRECTIONS TRANSACTIONS",1:"")
 W !?18
 F I=1:1:45 W "*"
 W !?18,"*"
 W ?22,"IHS AREA OFFICE DHR EXPORT (SPLITOUT)"
 W ?62,"*"
 W !?18,"*"
 W ?26,ACRPKG
 W ?62,"*"
 W !?18,"*"
 W ?34,"VERSION "
 W $P($T(ACRFSPL1+1),";",3)
 W ?62,"*"
 W !?18
 F I=1:1:45 W "*"
 Q
HDR1 ;----- WRITES HEADER 1
 ;
 N I
 W !?5
 F I=1:1:70 W "-"
 W !?5,"*"
 W ?15,"COLOR = BLUE"
 W ?40,"*"
 W ?56,"COLOR = RED"
 W ?74,"*"
 W !?5
 F I=1:1:70 W "-"
 Q
HDR2 ;----- WRITES HEADER 2
 ;
 W !?5,"*"
 W ?10,$S($G(ACRZ(1)):"COLOR AVAILABLE FOR EXPORT",1:"     NO DATA ON FILE")
 W ?40,"*"
 W ?45,$S($G(ACRZ(2)):"COLOR AVAILABLE FOR EXPORT",1:"     NO DATA ON FILE")
 W ?74,"*"
 W !?5
 F I=1:1:70 W "-"
 Q
HDR3 ;----- WRITES HEADER 3
 ;
 W !,?6,"B. DATE  #BCH  ID'S  RCDS  NO-TR"
 W ?40,"|"
 W ?42,"B. DATE  #BCH  ID'S  RCDS  NO-TR"
 W !?5
 F I=1:1:70 W "-"
 Q
