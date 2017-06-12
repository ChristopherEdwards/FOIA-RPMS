BTIULMED ; SLC/JM - Active/Recent Med Objects Routine ;28-Apr-2016 10:18;DU
 ;;1.0;TEXT INTEGRATION UTILITIES;**1006,1011,1016**;NOV 04,2004;Build 10
 ;PATCH 1011 changed to use new pharmacy APIs
 Q
LIST(DFN,TARGET,ACTVONLY,DETAILED,ALLMEDS,ONELIST,CLASSORT,SUPPLIES,CLININC) ; EP
 ;
 ; This is the TIU Medication objects API.  Optional parameters not
 ; provided defaults to 0 (with the exception of SUPPLIES).
 ;
 ;Required Parameters:
 ;
 ;  DFN       Patient identifier
 ;
 ;  TARGET    Where the medication data will be stored
 ;
 ;Optional Parameters:
 ;
 ;  ACTVONLY  0 - Active and recently expired meds
 ;            1 - Active meds only
 ;            2 - Recently expired meds only
 ;            3 - Hold meds only
 ;
 ;  DETAILED  0 - One line per med only
 ;            1 - Detailed information on each med
 ;
 ;  ALLMEDS   0 - Specifies Inpatient Meds if patient is an
 ;                Inpatient, or Outpatient Meds if patient
 ;                is an Outpatient
 ;            1 - Specifies both Inpatient and Outpatient
 ;            2 or "I" - Specifies Inpatient only
 ;            3 or "O" - Specifies Outpatient only
 ;
 ;  ONELIST   0 - Separates Active, Pending and Inactive
 ;                medications into separate lists
 ;            1 - Combines Active, Pending and Inactive
 ;                medications into the same list
 ;
 ;  CLASSORT  0 - Sort meds alphabetically
 ;            1 - Sort meds by drug class, and within the
 ;                same drug class, sort alphabetically
 ;            2 - Same as #1, but show drug class in header
 ;  SUPPLIES  0 - Supplies are excluded
 ;            1 - Supplies are included (Default)
 ;  CLININC   0-  Do not use
 ;            1-  Display in detailed format
 ;            2-  Sort by
 ;
 N NEXTLINE,EMPTY,INDEX,NODE,ISINP,KEEPMED,STATUS,ASTATS,PSTATS,OK,RXNO,CHRONIC
 N STATIDX,INPTYPE,OUTPTYPE,TYPE,MEDTYPE,CNT,DATA,DATA1,MED,IDATE,XSTR,LLEN,DAYS
 N LASTMEDT,LASTSTS,COUNT,TOTAL,SPACE60,DASH73,TEMP,LINE,TAB,HEADER,IEN,HIEN,HSTATS,REASON,REFILLS
 N DRUGCLAS,DRUGIDX,LASTCLAS,OLDTAB,OLDHEADR,UNKNOWNS,INDIC,LSTINDIC,ERX,AUTO
 N %,%H,STOP,LSTFD ;Clean up after external calls...
 N NVATYPE,NVAMED,NVASTR,TIUXSTAT
 S (NEXTLINE,TAB,HEADER,UNKNOWNS)=0,LLEN=47
 K @TARGET,^TMP("PS",$J)
 ; Check for Pharmacy Package and required patches
 I '$$PATCHSOK^TIULMED3 G LISTX ;P213
 I '+$G(ACTVONLY) S ACTVONLY=0
 I '+$G(DETAILED) S DETAILED=0
 I +$D(ALLMEDS) D
 .I ALLMEDS="I" S ALLMEDS=2
 .E  I ALLMEDS="O" S ALLMEDS=3
 I '+$G(ALLMEDS) S ALLMEDS=0
 I '+$G(ONELIST) S ONELIST=0
 I '+$G(CLASSORT) S CLASSORT=0
 I $G(SUPPLIES)'="0" S SUPPLIES=1
 I '+$G(CLININC)  S CLININC=0
 S (EMPTY,HEADER)=1
 I ONELIST,'ALLMEDS,'DETAILED,'CLASSORT,'CLININC S HEADER=0
 I 'DETAILED S LLEN=60
 S ASTATS="^ACTIVE^REFILL^HOLD^PROVIDER HOLD^ON CALL^ACTIVE (S)^"
 S PSTATS="^NON-VERIFIED^DRUG INTERACTIONS^INCOMPLETE^PENDING^"
 S HSTATS="^HOLD^"
 S ISINP=($G(^DPT(DFN,.1))'="") ; Is this an inpatient?
 I ISINP S INPTYPE=1,OUTPTYPE=2
 E  S INPTYPE=2,OUTPTYPE=1
 S DAYS=$$GET^XPAR("ALL","BTIU EXPIRED MEDS",1,"E")
 S:$G(DAYS)<1 DAYS=365
 D ADDTITLE^BTIUMED1(DAYS)
 ;
 ; *** Scan medication data and skip unwanted meds ***
 ;
 D OCL^PSOORRL(DFN,$$FMADD^XLFDT(DT,-DAYS),"")
 S INDEX=0,INDIC=""
 F  S INDEX=$O(^TMP("PS",$J,INDEX))  Q:INDEX'>0  D
 .S AUTO=0,ERX=""
 .S NODE=$G(^TMP("PS",$J,INDEX,0))
 .S RXNO=+($P(NODE,U,1))
 .S CHRONIC=$P($G(^PSRX(RXNO,9999999)),U,2)
 .S AUTO=$P($G(^PSRX(RXNO,999999921)),U,3)
 .S KEEPMED=($L($P(NODE,U,2))>0) ;Discard Blank Meds
 .I KEEPMED D
 ..S STATUS=$P(NODE,U,9)
 ..I STATUS="ACTIVE/SUSP" S STATUS="ACTIVE (S)"
 ..I STATUS="SUSPENDED" S STATUS="ACTIVE (S)"
 ..I STATUS="PENDING" D
 ...S IEN=+($P(NODE,U))
 ...I IEN>0 S REFILLS=$P($G(^PS(52.41,IEN,0)),U,11)
 ...S $P(^TMP("PS",$J,INDEX,0),U,5)=REFILLS
 ..I $F(ASTATS,"^"_STATUS_"^")>0 S STATIDX=1
 ..E  I ($F(PSTATS,"^"_STATUS_"^")>0) S STATIDX=2
 ..E  S STATIDX=3
 ..I ACTVONLY=1 S KEEPMED=(STATIDX<3)
 ..I ACTVONLY=2 S KEEPMED=(STATIDX=3)
 ..I ACTVONLY=3 D
 ...S KEEPMED=""
 ...I STATUS="HOLD" S KEEPMED=4
 ..;I +ONELIST S STATIDX=1
 ..; Changes for *238 required by PSO*7*294
 ..I $$PATCH^XPDUTL("PSO*7.0*294"),+$D(TIUDATE),STATUS["DISCONTINUED" S KEEPMED=0
 .I KEEPMED D
 ..S TYPE=$P($P(NODE,U),";",2)
 ..S TYPE=$S(TYPE="O":"OP",TYPE="I":"UD",1:"")
 ..S NVAMED=$P($P(NODE,U),";")
 ..S NVAMED=$E(NVAMED,$L(NVAMED))
 ..S KEEPMED=(TYPE'="")
 .I KEEPMED D
 ..I $O(^TMP("PS",$J,INDEX,"A",0))>0 S TYPE="IV"
 ..E  I $O(^TMP("PS",$J,INDEX,"B",0))>0 S TYPE="IV"
 ..I TYPE="OP" S MEDTYPE=OUTPTYPE
 ..E  S MEDTYPE=INPTYPE
 ..I ALLMEDS=0 D  I 1
 ...I MEDTYPE=INPTYPE S KEEPMED=ISINP
 ...E  S KEEPMED='ISINP
 ..E  I ALLMEDS=2 S KEEPMED=(MEDTYPE=INPTYPE)
 ..E  I ALLMEDS=3 S KEEPMED=(MEDTYPE=OUTPTYPE)
 .S DRUGCLAS=" "
 .S MED=$P(NODE,U,2)
 .I KEEPMED,(CLASSORT!('SUPPLIES)) D
 ..S DRUGIDX=$$IENNAME^TIULMED2(MED)
 ..D GETCLASS
 ..I KEEPMED,+DRUGIDX=0 D  ;Find orderable item
 ...N IDX,ID,ORDIDX,TMPCLASS,CDONE,SDONE,TMPIDX,TMPNODE,ISSUPPLY
 ...S ID=$P(NODE,U),IDX=+ID,ID=$E(ID,$L(IDX)+1,$L(ID))
 ...S (DRUGIDX,ORDIDX)=0
 ...K ^TMP($J,"TIULMED")
 ...; IDX is Order #; ID indicates what file.  See IA 2400
 ...; R;O MED will always be in Drug File (Unless Drug File entry was
 ...;     changed after ordering.
 ...I ID="R;O" D
 ....D RX^PSO52API(DFN,"TIULMED",IDX,"","0,O") ; IA 4820
 ....S DRUGIDX=+$G(^TMP($J,"TIULMED",DFN,IDX,6))
 ....S ORDIDX=+$G(^TMP($J,"TIULMED",DFN,IDX,"OI"))
 ...I ID="P;O" D     ;P;O = pending outpatient order (file #52.41). P213
 ....D PEN^PSO5241(DFN,"TIULMED",IDX) ; IA 4821
 ....S DRUGIDX=+$G(^TMP($J,"TIULMED",DFN,IDX,11))
 ....S ORDIDX=+$G(^TMP($J,"TIULMED",DFN,IDX,8))
 ...I ID="P;I" D            ;P;I = pending inpatient order (file #53.1)
 ....I $P($G(^PS(53.1,IDX,1,0)),U,4)=1 D
 .....S TMPIDX=$O(^PS(53.1,IDX,1,0)) I +TMPIDX D
 ......S DRUGIDX=$P($G(^PS(53.1,IDX,1,TMPIDX,0)),U)
 ....S ORDIDX=+$P($G(^PS(53.1,IDX,.2)),U)
 ...I ID="U;I" D  ;U;I = unit dose order (file #55, subfile 55.06) P213
 ....D PSS431^PSS55(DFN,IDX,"","","TIULMED") ; IA 4826
 ....I +$G(^TMP($J,"TIULMED",IDX,"DDRUG",0))=1 D
 .....S TMPIDX=$O(^TMP($J,"TIULMED",IDX,"DDRUG",0)) Q:TMPIDX'>0
 .....S DRUGIDX=+$G(^TMP($J,"TIULMED",IDX,"DDRUG",TMPIDX,.01))
 ....S ORDIDX=+$G(^TMP($J,"TIULMED",IDX,108))
 ...I ID="V;I" D     ;V;I = IV order (file #55, subfile 55.01). P213
 ....D PSS436^PSS55(DFN,IDX,"TIULMED") ; IA 4826
 ....; Get ORDIDX before DRUGIDX since global is not there after DRUGIDX
 ....S ORDIDX=+$G(^TMP($J,"TIULMED",IDX,130))
 ....I ^TMP($J,"TIULMED",IDX,"ADD",0)=1 D
 .....S TMPIDX=$O(^TMP($J,"TIULMED",IDX,"ADD",0)) I +TMPIDX D
 ......S TMPIDX=+$G(^TMP($J,"TIULMED",IDX,"ADD",TMPIDX,.01))
 ......I +TMPIDX S DRUGIDX=$$DRGIEN^TIULMED2(TMPIDX) ; IA 4662
 ...S DRUGCLAS=""
 ...D GETCLASS
 ...I KEEPMED,+DRUGIDX=0,+ORDIDX,DRUGCLAS="" D
 ....S IDX=0,ISSUPPLY=2,CDONE='CLASSORT,SDONE=+SUPPLIES
 ....N LIST S LIST="TIULMED" K ^TMP($J,LIST)
 ....D DRGIEN^PSS50P7(ORDIDX,"",LIST) ; IA 4662
 ....F  S IDX=$O(^TMP($J,LIST,IDX)) Q:'IDX  D  Q:(CDONE&SDONE)
 .....S TMPCLASS=$$DRGCLASS^TIULMED2(IDX)
 .....S TMPNODE=U_TMPCLASS_U_$$DEA^TIULMED2(IDX)
 .....I 'CDONE,TMPCLASS="" S CDONE=1,DRUGCLAS=""
 .....I 'CDONE D
 ......I DRUGCLAS="" S DRUGCLAS=TMPCLASS
 ......E  I DRUGCLAS'=TMPCLASS S CDONE=1,DRUGCLAS=""
 .....I 'SDONE D
 ......S ISSUPPLY=(($E(TMPCLASS,1,2)="XA")&($P(TMPNODE,U,3)["S"))
 ......I 'ISSUPPLY S SDONE=1
 ....I 'SUPPLIES,(ISSUPPLY=1) S KEEPMED=0
 ..I (DRUGCLAS="")!('CLASSORT) S DRUGCLAS=" "
 ..I AUTO=1 D
 ...S ERX=$P($G(^PSRX(RXNO,999999921)),U,4)
 ...I +ERX S ERX=ERX_";"_RXNO
 ...S $P(^TMP("PS",$J,INDEX,0),U,9)=STATUS_" (X)"
 .;
 .; *** Save wanted meds in "B" temp xref, removing duplicates ***
 .;
 .I KEEPMED D
 ..D ADDMED^BTIUMED1(1) ; Get XSTR to check for duplicates
 ..S IDATE=$P(NODE,U,15)
 ..I $P($P(NODE,U),";")["N" S IDATE=$$DT^XLFDT
 ..I $P(NODE,U,9)="PENDING"!($P(NODE,U,9)="HOLD") S IDATE=$$DT^XLFDT
 ..S OK='$D(@TARGET@("B",MED,IDATE,XSTR))
 ..I 'OK,(IDATE>@TARGET@("B",MED,IDATE,XSTR)) S OK=1
 ..I OK D
 ...S @TARGET@("B",MED,IDATE,XSTR)=IDATE_U_INDEX_U_MEDTYPE_U_STATIDX_U_TYPE_U_DRUGCLAS_U_CHRONIC_U_ERX
 ...S EMPTY=0
 ...I DRUGCLAS=" " S UNKNOWNS=1
 ;
 ; *** Check for empty condition ***
 ;
 I EMPTY D  G LISTX
 .D ADD^BTIUMED1("No Medications Found")
 .D ADD^BTIUMED1(" ")
 ;
 ; *** Sort Meds in "C" temp xref - sort by Med Type, Status
 ;     Med Name, and reverse issue date, followed by a counter
 ;     to avoid erasing meds issued on the same day
 ;
 S MED="",CNT=1000000
 F  S MED=$O(@TARGET@("B",MED)) Q:MED=""  D
 .S IDATE=""
 .F  S IDATE=$O(@TARGET@("B",MED,IDATE)) Q:IDATE=""  D
 ..S XSTR=""
 ..F  S XSTR=$O(@TARGET@("B",MED,IDATE,XSTR)) Q:XSTR=""  D
 ...S NODE=@TARGET@("B",MED,IDATE,XSTR)
 ...S DATA=MED_U_$P(NODE,U,3)_U_$P(NODE,U,5),CNT=CNT+1
 ...S @TARGET@("C",DATA,(9999999-$P(NODE,U))_CNT)=$P(NODE,U,2)_U_$P(NODE,U,5)_U_$P(NODE,U,7)_U_$P(NODE,U,8)
 K @TARGET@("B")
 ;
 ; Read sorted data and save final version to TARGET
 ;
 S (DATA,LASTCLAS,LSTINDIC)="",(LASTMEDT,LASTSTS,COUNT,TOTAL)=0
 S $P(SPACE60," ",60)=" ",$P(DASH73,"=",73)="="
 D WARNING^BTIUMED1
 F  S DATA=$O(@TARGET@("C",DATA)) Q:DATA=""  D
 .S DATA1=$P(DATA,U,2)
 .S MEDTYPE=$E(DATA1),STATIDX=$E(DATA1,2)
 .S DRUGCLAS=$P(DATA,U,2),MED=$P(DATA,U,3),CNT=""
 .F  S CNT=$O(@TARGET@("C",DATA,CNT)) Q:CNT=""  D
 ..S INDEX=@TARGET@("C",DATA,CNT)
 ..S TYPE=$P(INDEX,U,2),CHRONIC=$P(INDEX,U,3),ERX=$P(INDEX,U,4),INDEX=+INDEX
 ..S NODE=^TMP("PS",$J,INDEX,0)
 ..;If hold meds, find the reason and add it to the node data
 ..S STATUS=$P(NODE,U,9)
 ..I STATUS="HOLD" D
 ...S HIEN=+($P(NODE,U))
 ...S REASON=$$GET1^DIQ(52,HIEN,99,"E")
 ...S $P(NODE,U,18)=REASON
 ..I DETAILED D
 ...S HIEN=$P(NODE,U)
 ...I CLININC>0 D
 ...;Patch 1016 changes for clinical indication
 ...I HIEN["R" D
 ....S HIEN=+HIEN
 ....S INDIC=$$GET1^DIQ(52,HIEN,9999999.21,"E")
 ....S $P(NODE,U,19)=INDIC
 ...I ERX'="" S $P(NODE,U,31)=ERX
 ..I $P($P(NODE,U),";")["N" S $P(NODE,U,2)=$P(NODE,U,2)_" (O)"
 ..I CHRONIC="Y" S $P(NODE,U,2)=$P(NODE,U,2)_" (C)"
 ..;E  S $P(NODE,U,2)="    "_$P(NODE,U,2)
 ..;I (MEDTYPE'=LASTMEDT)!(STATIDX'=LASTSTS)!(INDIC'=LSTINDIC) D  ; Create Header
 ..I (MEDTYPE'=LASTMEDT)!(CLININC=2&(INDIC'=LSTINDIC)) D  ; Create Header
 ...I CLASSORT'=2,DRUGCLAS'=" " S LASTCLAS=DRUGCLAS
 ...I 'HEADER Q
 ...S LASTMEDT=MEDTYPE,LASTSTS=STATIDX,TAB=0
 ...I COUNT>0 D ADD^BTIUMED1(" ")
 ...I CLASSORT D ADD^BTIUMED1(" ")
 ...S COUNT=0
 ...I DETAILED D
 ....I MEDTYPE=OUTPTYPE D  I 1
 .....D ADD^BTIUMED1($E($E(SPACE60,1,47)_"Status"_SPACE60,1,60)_"Last Fill")
 ....E  D ADD^BTIUMED1(SPACE60_"Start Date")
 ...S TEMP=""
 ...I 'ONELIST D
 ....S TEMP=TEMP_$S(MEDTYPE=INPTYPE:"Inpatient",1:"Outpatient")
 ....I ACTVONLY=3 S TEMP="HOLD"
 ....S TEMP="     "_TEMP_" Medications"
 ...I CLASSORT D
 ....I DETAILED S TEMP=TEMP_" (By Class)"
 ....E  S TEMP=TEMP_" (By Drug Class)"
 ....I MEDTYPE=OUTPTYPE&(CLININC>0) S TEMP=TEMP_" (By Clinical Indication)"
 ...I DETAILED D  I 1
 ....S TEMP=$E(TEMP_SPACE60,1,47)
 ....I MEDTYPE=INPTYPE S TEMP=TEMP_"Status"
 ....E  S TEMP=TEMP_"Refills"
 ....S TEMP=$E(TEMP_SPACE60,1,60)
 ....I MEDTYPE=INPTYPE S TEMP=TEMP_"Stop Date"
 ....E  S TEMP=TEMP_"Expiration"
 ...E  D
 ....S TEMP=$E(TEMP_SPACE60,1,60)_"Status"
 ...D ADD^BTIUMED1(TEMP),ADD^BTIUMED1(DASH73)
 ..I CLASSORT,DRUGCLAS'="",DRUGCLAS'=LASTCLAS D
 ...S LASTCLAS=DRUGCLAS,OLDTAB=TAB,OLDHEADR=HEADER
 ..I CLININC=2,INDIC'=LSTINDIC D
 ...S LSTINDIC=INDIC,OLDTAB=TAB,OLDHEADR=HEADER
 ...S (TAB,HEADER)=0
 ...I COUNT>0 D ADD^BTIUMED1(" ")
 ...I (CLASSORT=2)!(DRUGCLAS=" ") D  I 1
 ....I DRUGCLAS=" " S TEMP="   ====== Drug Class Unknown "
 ....E  S TEMP="   ====== Drug Class: "_DRUGCLAS_" "
 ...I REASON=1 D
 ....I INDIC="" S TEMP="   ====== Unknown Indication "
 ....E  S TEMP="   ====== "_INDIC_"  "
 ...E  S TEMP="   "
 ...S TEMP=$E(TEMP_DASH73,1,LLEN-2)
 ...D ADD^BTIUMED1(TEMP)
 ...S HEADER=OLDHEADR,TAB=OLDTAB
 ..S COUNT=COUNT+1,TOTAL=TOTAL+1
 ..D ADDMED^BTIUMED1(0)
 I COUNT'=TOTAL D
 .S TAB=0
 .D ADD^BTIUMED1(" ")
 .D ADD^BTIUMED1(TOTAL_" Total Medications")
 D ADD^BTIUMED1(" ")
 D ADD^BTIUMED1("(X)behind status of medication depicts that the medication was sent to an external pharmacy")
 K @TARGET@("C")
LISTX K ^TMP("PS",$J)
 Q "~@"_$NA(@TARGET)
 ;
GETCLASS ; Get Drug Class, filter out supplies
 D GETCLASS^TIULMED3
 Q
