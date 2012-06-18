TIULMED ; SLC/JM,JH - Active/Recent Med Objects Routine ;3/17/2004 [3/16/04 10:34am]
 ;;1.0;TEXT INTEGRATION UTILITIES;**38,73,92,94,183**;Jun 20, 1997
 Q
LIST(DFN,TARGET,ACTVONLY,DETAILED,ALLMEDS,ONELIST,CLASSORT,SUPPLIES) ;
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
 ;
 ;  SUPPLIES  0 - Supplies are excluded
 ;            1 - Supplies are included (Default)
 ;
 N NEXTLINE,EMPTY,INDEX,NODE,ISINP,KEEPMED,STATUS,ASTATS,PSTATS,OK
 N STATIDX,INPTYPE,OUTPTYPE,TYPE,MEDTYPE,CNT,DATA,MED,IDATE,XSTR,LLEN
 N LASTMEDT,LASTSTS,COUNT,TOTAL,SPACE60,DASH73,TEMP,LINE,TAB,HEADER
 N DRUGCLAS,DRUGIDX,LASTCLAS,OLDTAB,OLDHEADR,UNKNOWNS
 N NVATYPE,NVAMED,NVASTR
 N %,%H,STOP,LSTFD ;Clean up after external calls...
 S (NEXTLINE,TAB,HEADER,UNKNOWNS)=0,LLEN=47
 K @TARGET,^TMP("PS",$J)
 ; Check for Pharmacy Package and required patches
 I '$L($T(OCL^PSOORRL)) D  G LISTX
 .D ADD^TIULMED1("Outpatient Pharmacy 7.0 Required for this Object.")
 .D ADD^TIULMED1(" ")
 I '$$PATCH^XPDUTL("PSO*7.0*20") D  G LISTX
 .D ADD^TIULMED1("Outpatient Pharmacy Patch PSO*7.0*20 is required for this Object.")
 .D ADD^TIULMED1(" ")
 I '$$PATCH^XPDUTL("PSJ*5.0*22") D  G LISTX
 .D ADD^TIULMED1("Inpatient Pharmacy Patch PSJ*5.0*22 is required for this Object.")
 .D ADD^TIULMED1(" ")
 I '+$G(ACTVONLY) S ACTVONLY=0
 I '+$G(DETAILED) S DETAILED=0
 I +$D(ALLMEDS) D
 .I ALLMEDS="I" S ALLMEDS=2
 .E  I ALLMEDS="O" S ALLMEDS=3
 I '+$G(ALLMEDS) S ALLMEDS=0
 I '+$G(ONELIST) S ONELIST=0
 I '+$G(CLASSORT) S CLASSORT=0
 I $G(SUPPLIES)'="0" S SUPPLIES=1
 S (EMPTY,HEADER)=1
 I ONELIST,'ALLMEDS,'DETAILED,'CLASSORT S HEADER=0
 I 'DETAILED S LLEN=60
 S ASTATS="^ACTIVE^REFILL^HOLD^PROVIDER HOLD^ON CALL^ACTIVE (S)^"
 S PSTATS="^NON-VERIFIED^DRUG INTERACTIONS^INCOMPLETE^PENDING^"
 S ISINP=($G(^DPT(DFN,.1))'="") ; Is this an inpatient?
 I ISINP S INPTYPE=1,OUTPTYPE=2
 E  S INPTYPE=2,OUTPTYPE=1
 S NVATYPE=3
 D ADDTITLE^TIULMED1
 ;
 ; *** Scan medication data and skip unwanted meds ***
 ;
 D OCL^PSOORRL(DFN,"","")
 S INDEX=0
 F  S INDEX=$O(^TMP("PS",$J,INDEX))  Q:INDEX'>0  D
 .S NODE=$G(^TMP("PS",$J,INDEX,0))
 .S KEEPMED=($L($P(NODE,U,2))>0) ;Discard Blank Meds
 .I KEEPMED D
 ..S STATUS=$P(NODE,U,9)
 ..I STATUS="SUSPENDED" S STATUS="ACTIVE (S)"
 ..I $F(ASTATS,"^"_STATUS_"^")>0 S STATIDX=1
 ..E  I ($F(PSTATS,"^"_STATUS_"^")>0) S STATIDX=2
 ..E  S STATIDX=3
 ..I ACTVONLY=1 S KEEPMED=(STATIDX<3)
 ..I ACTVONLY=2 S KEEPMED=(STATIDX=3)
 ..I +ONELIST S STATIDX=1
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
 ..I NVAMED="N" S MEDTYPE=NVATYPE
 ..I ALLMEDS=0 D  I 1
 ...I MEDTYPE=INPTYPE S KEEPMED=ISINP
 ...E  S KEEPMED='ISINP
 ..E  I ALLMEDS=2 S KEEPMED=(MEDTYPE=INPTYPE)
 ..E  I ALLMEDS=3 S KEEPMED=(MEDTYPE=OUTPTYPE!(MEDTYPE=NVATYPE))
 .S DRUGCLAS=" "
 .S MED=$P(NODE,U,2)
 .I KEEPMED,(CLASSORT!('SUPPLIES)) D
 ..S DRUGIDX=$O(^PSDRUG("B",MED,0))
 ..D GETCLASS
 ..I KEEPMED,+DRUGIDX=0 D  ;Find orderable item
 ...N IDX,ID,ORDIDX,TMPCLASS,CDONE,SDONE,TMPIDX,TMPNODE,ISSUPPLY
 ...S ID=$P(NODE,U),IDX=+ID,ID=$E(ID,$L(IDX)+1,$L(ID))
 ...S (DRUGIDX,ORDIDX)=0
 ...I ID="R;O" D
 ....S DRUGIDX=+$P($G(^PSRX(IDX,0)),U,6)
 ....S ORDIDX=+$P($G(^PSRX(IDX,"OR1")),U)
 ...I ID="P;O" D
 ....S DRUGIDX=+$P($G(^PS(52.41,IDX,0)),U,9)
 ....S ORDIDX=+$P($G(^PS(52.41,IDX,0)),U,8)
 ...I ID="P;I" D
 ....I $P($G(^PS(53.1,IDX,1,0)),U,4)=1 D
 .....S TMPIDX=$O(^PS(53.1,IDX,1,0)) I +TMPIDX D
 ......S DRUGIDX=$P($G(^PS(53.1,IDX,1,TMPIDX,0)),U)
 ....S ORDIDX=+$P($G(^PS(53.1,IDX,.2)),U)
 ...I ID="U;I" D
 ....I $P($G(^PS(55,DFN,5,IDX,1,0)),U,4)=1 D
 .....S TMPIDX=$O(^PS(55,DFN,5,IDX,1,0)) I +TMPIDX D
 ......S DRUGIDX=$P($G(^PS(55,DFN,5,IDX,1,TMPIDX,0)),U)
 ....S ORDIDX=+$P($G(^PS(55,DFN,5,IDX,.2)),U)
 ...I ID="V;I" D
 ....I $P($G(^PS(55,DFN,"IV",IDX,"AD",0)),U,4)=1 D
 .....S TMPIDX=$O(^PS(55,DFN,"IV",IDX,"AD",0)) I +TMPIDX D
 ......S TMPIDX=$P($G(^PS(55,DFN,"IV",IDX,"AD",TMPIDX,0)),U)
 ......I +TMPIDX S DRUGIDX=$P($G(^PS(52.6,TMPIDX,0)),U,2)
 ....S ORDIDX=+$P($G(^PS(55,DFN,"IV",IDX,.2)),U)
 ...S DRUGCLAS=""
 ...D GETCLASS
 ...I KEEPMED,+DRUGIDX=0,+ORDIDX,DRUGCLAS="" D
 ....S IDX=0,ISSUPPLY=2,CDONE='CLASSORT,SDONE=+SUPPLIES
 ....F  S IDX=$O(^PSDRUG("ASP",ORDIDX,IDX)) Q:'IDX  D  Q:(CDONE&SDONE)
 .....S TMPNODE=$G(^PSDRUG(IDX,0))
 .....S TMPCLASS=$P(TMPNODE,U,2)
 .....I 'CDONE,TMPCLASS="" S CDONE=1,DRUGCLAS=""
 .....I 'CDONE D
 ......I DRUGCLAS="" S DRUGCLAS=TMPCLASS
 ......E  I DRUGCLAS'=TMPCLASS S CDONE=1,DRUGCLAS=""
 .....I 'SDONE D
 ......S ISSUPPLY=(($E(TMPCLASS,1,2)="XA")&($P(TMPNODE,U,3)["S"))
 ......I 'ISSUPPLY S SDONE=1
 ....I 'SUPPLIES,(ISSUPPLY=1) S KEEPMED=0
 ..I (DRUGCLAS="")!('CLASSORT) S DRUGCLAS=" "
 .;
 .; *** Save wanted meds in "B" temp xref, removing duplicates ***
 .;
 .I KEEPMED D
 ..D ADDMED^TIULMED1(1) ; Get XSTR to check for duplicates
 ..S IDATE=$P(NODE,U,15)
 ..S OK='$D(@TARGET@("B",MED,XSTR))
 ..I 'OK,(IDATE>@TARGET@("B",MED,XSTR)) S OK=1
 ..I OK D
 ...S @TARGET@("B",MED,XSTR)=IDATE_U_INDEX_U_MEDTYPE_STATIDX_U_TYPE_U_DRUGCLAS
 ...S EMPTY=0
 ...I DRUGCLAS=" " S UNKNOWNS=1
 ;
 ; *** Check for empty condition ***
 ;
 I EMPTY D  G LISTX
 .D ADD^TIULMED1("No Medications Found")
 .D ADD^TIULMED1(" ")
 ;
 ; *** Sort Meds in "C" temp xref - sort by Med Type, Status
 ;     Med Name, and reverse issue date, followed by a counter 
 ;     to avoid erasing meds issued on the same day
 ;
 S MED="",CNT=1000000
 F  S MED=$O(@TARGET@("B",MED)) Q:MED=""  D
 .S XSTR=""
 .F  S XSTR=$O(@TARGET@("B",MED,XSTR)) Q:XSTR=""  D
 ..S NODE=@TARGET@("B",MED,XSTR)
 ..S DATA=$P(NODE,U,3)_U_$P(NODE,U,5)_U_MED,CNT=CNT+1
 ..S @TARGET@("C",DATA,(9999999-$P(NODE,U))_CNT)=$P(NODE,U,2)_U_$P(NODE,U,4)
 K @TARGET@("B")
 ;
 ; Read sorted data and save final version to TARGET
 ;
 S (DATA,LASTCLAS)="",(LASTMEDT,LASTSTS,COUNT,TOTAL)=0
 S $P(SPACE60," ",60)=" ",$P(DASH73,"=",73)="="
 D WARNING^TIULMED1
 F  S DATA=$O(@TARGET@("C",DATA)) Q:DATA=""  D
 .S MEDTYPE=$E(DATA),STATIDX=$E(DATA,2)
 .S DRUGCLAS=$P(DATA,U,2),MED=$P(DATA,U,3),CNT=""
 .F  S CNT=$O(@TARGET@("C",DATA,CNT)) Q:CNT=""  D
 ..S INDEX=@TARGET@("C",DATA,CNT)
 ..S TYPE=$P(INDEX,U,2),INDEX=+INDEX
 ..S NODE=^TMP("PS",$J,INDEX,0)
 ..I $P($P(NODE,U),";")["N" S $P(NODE,U,2)="Non-VA "_$P(NODE,U,2)
 ..I (MEDTYPE'=LASTMEDT)!(STATIDX'=LASTSTS) D  ; Create Header
 ...I CLASSORT'=2,DRUGCLAS'=" " S LASTCLAS=DRUGCLAS
 ...I 'HEADER Q
 ...S LASTMEDT=MEDTYPE,LASTSTS=STATIDX,TAB=0
 ...I COUNT>0 D ADD^TIULMED1(" ")
 ...I CLASSORT D ADD^TIULMED1(" ")
 ...S COUNT=0
 ...I DETAILED D
 ....I MEDTYPE=OUTPTYPE D  I 1
 .....D ADD^TIULMED1(SPACE60_"Issue Date")
 .....D ADD^TIULMED1($E($E(SPACE60,1,47)_"Status"_SPACE60,1,60)_"Last Fill")
 ....E  D ADD^TIULMED1(SPACE60_"Start Date")
 ...I 'ONELIST D
 ....S TEMP=$S(STATIDX=1:"Active",STATIDX=2:"Pending",1:"Inactive")_" "
 ...E  S TEMP=""
 ...S TEMP=TEMP_$S(MEDTYPE=INPTYPE:"Inpatient",MEDTYPE=NVATYPE:"Non-VA",1:"Outpatient")
 ...S TEMP="     "_TEMP_" Medications"
 ...I CLASSORT D
 ....I DETAILED S TEMP=TEMP_" (By Class)"
 ....E  S TEMP=TEMP_" (By Drug Class)"
 ...I DETAILED D  I 1
 ....S TEMP=$E(TEMP_SPACE60,1,47)
 ....I MEDTYPE=INPTYPE S TEMP=TEMP_"Status"
 ....E  S TEMP=TEMP_"Refills"
 ....S TEMP=$E(TEMP_SPACE60,1,60)
 ....I MEDTYPE=INPTYPE S TEMP=TEMP_"Stop Date"
 ....E  S TEMP=TEMP_"Expiration"
 ...E  D
 ....S TEMP=$E(TEMP_SPACE60,1,60)_"Status"
 ...D ADD^TIULMED1(TEMP),ADD^TIULMED1(DASH73)
 ..I CLASSORT,DRUGCLAS'="",DRUGCLAS'=LASTCLAS D
 ...S LASTCLAS=DRUGCLAS,OLDTAB=TAB,OLDHEADR=HEADER
 ...S (TAB,HEADER)=0
 ...I COUNT>0 D ADD^TIULMED1(" ")
 ...I (CLASSORT=2)!(DRUGCLAS=" ") D  I 1
 ....I DRUGCLAS=" " S TEMP="   ====== Drug Class Unknown "
 ....E  S TEMP="   ====== Drug Class: "_DRUGCLAS_" "
 ...E  S TEMP="   "
 ...S TEMP=$E(TEMP_DASH73,1,LLEN-2)
 ...D ADD^TIULMED1(TEMP)
 ...S HEADER=OLDHEADR,TAB=OLDTAB
 ..S COUNT=COUNT+1,TOTAL=TOTAL+1
 ..D ADDMED^TIULMED1(0)
 I COUNT'=TOTAL D
 .S TAB=0
 .D ADD^TIULMED1(" ")
 .D ADD^TIULMED1(TOTAL_" Total Medications")
 K @TARGET@("C")
LISTX K ^TMP("PS",$J)
 Q "~@"_$NA(@TARGET)
 ;
GETCLASS ; Get Drug Class, filter out supplies
 I +DRUGIDX D
 .N TEMPNODE
 .S TEMPNODE=$G(^PSDRUG(DRUGIDX,0))
 .S DRUGCLAS=$P(TEMPNODE,U,2)
 .I 'SUPPLIES,($E(DRUGCLAS,1,2)="XA") D
 ..S KEEPMED='($P(TEMPNODE,U,3)["S")
 Q
