DGRP9 ;ALB/RMO/MIR - Screen 9 - Income Screening Data ;23 JAN 1992 11:00 am
 ;;5.3;Registration;**45,108,487**;Aug 13, 1993
 ;
EN ;
 ; DVBGUI : CAPRI GUI User
 I $D(DVBGUI) U IO ;If called from CAPRI menu set output device.
 K DGDEP,DGINC,DGREL N DGMT,DGEFDT,DGEFDT,DGMTED,DGNOBUCK,DGLSTYR
 S DGLSTYR=$E(DT,1,3)+1699
 S DGRPS=9 D H^DGRPU
 D:'DGRPV NEW^DGRPEIS1
 D ALL^DGMTU21(DFN,"VSD",DT,"IPR")
 S DGNOBUCK=$S(DGRPV:0,1:$$NOBUCKS^DGMTU22(DFN,DT))
 S DGMT=$$LST^DGMTU(DFN,DT),DGEFDT=$P(DGMT,U,2)
 S:'((DGEFDT+10000)>DT&("^A^C^P^E^M^"[(U_$P(DGMT,U,4)))&DGNOBUCK) DGEFDT=DT
 S DGISYR=$E($$LYR^DGMTSCU1(DGEFDT),1,3)+1700 ; IS year
 D:DT'=DGEFDT ALL^DGMTU21(DFN,"VSD",DGEFDT,"IPR")
 S DGSP=$D(DGREL("S")) ; DGSP = flag ... + if spouse, 0 if not
 D TOT(.DGINC)
 D DIS
 W:DGNOBUCK !,"   NOTE: Since there is no income data for "_DGLSTYR_" you may COPY "_(DGLSTYR-1)_" data."
 K DGTOT
 G ^DGRPP
 ;
DIS ;Display income
 D MTCHK
 N DGBL
 W !!?34,"Veteran" W:DGSP ?46,"Spouse" W:DGDEP ?56,"Dependents" W ?73,"Total"
 W !?31,"-----------------------------------------------"
 S DGGTOT=0,DGRPW=1 ;initialize grand total variable
 S Z=1 D WW^DGRPV D FLD(.DGTOT,8,"Social Security (Not SSI)")
 S Z=2 D WW^DGRPV D FLD(.DGTOT,9,"U.S. Civil Service")
 S Z=3 D WW^DGRPV D FLD(.DGTOT,10,"U.S. Railroad Retirement")
 S Z=4 D WW^DGRPV D FLD(.DGTOT,11,"Military Retirement")
 S Z=5 D WW^DGRPV D FLD(.DGTOT,12,"Unemployment Compensation")
 S Z=6 D WW^DGRPV D FLD(.DGTOT,13,"Other Retirement")
 S Z=7 D WW^DGRPV D FLD(.DGTOT,14,"Total Employment Income")
 S Z=8 D WW^DGRPV D FLD(.DGTOT,15,"Interest,Dividend,Annuity")
 S Z=9 D WW^DGRPV D FLD(.DGTOT,16,"Workers Comp or Black Lung")
 S Z=10 D WW^DGRPV D FLD(.DGTOT,17,"All Other Income")
 W !,DGBL,DGBL," Total 1-10 -->"," ",$J($$AMT^DGMTSCU1(DGGTOT),12)
 ;
 ;** Patch DG*5.3*108; estimated household income follows
 W !!,DGISYR_" Estimated ""Household"" Taxable Income: "_$S($P(DGTOT("V"),U,21)'="":$$AMT^DGMTSCU1($P(DGTOT("V"),U,21)),1:"")
 Q
 ;
FLD(DGIN,DGPCE,DGTXT) ;Display inc. fields
 ; Input:
 ;       DGIN 0 node of #408.21 for vet,spouse, and deps
 ;       DGRPCE as piece
 ;       DGTXT as income desc.
 ;       DGGTOT - If defined keeps running total 
 N DGTOT,I
 I '$D(DGBL) S $P(DGBL," ",26)=""
 W:Z'["10" " "
 W " ",DGTXT,$P(DGBL," ",$L(DGTXT),26)
 W $J($$AMT^DGMTSCU1($P(DGIN("V"),"^",DGPCE)),10)
 W " ",$S($D(DGIN("S")):$J($$AMT^DGMTSCU1($P(DGIN("S"),"^",DGPCE)),10),1:$E(DGBL,1,10))
 W " ",$S($D(DGIN("D")):$J($$AMT^DGMTSCU1($P(DGIN("D"),"^",DGPCE)),11),1:$E(DGBL,1,11))
 S DGTOT="",I="" F  S I=$O(DGIN(I)) Q:I=""  I $P(DGIN(I),"^",DGPCE)]"" S DGTOT=DGTOT+$P(DGIN(I),"^",DGPCE)
 W "  ",$J($$AMT^DGMTSCU1(DGTOT),12)
 I $D(DGGTOT) S DGGTOT=DGGTOT+DGTOT
 Q
 ;
TOT(DGINC,DGDOEXP) ; Totals income
 ; Input
 ;   DGINC(x,ct) where X is V, S, or D and CT(counter)(per ALL^DGMTU21)
 ;   DGDOEXP: IF =1 TOTAL EXPENSE
 ;
 ;Output
 ;   DGTOT(x) where x is V, S, or D and DGTOT(x) = 0 node of #408.21
 ;    (totaled if x is D...total of all deps)
 ;
 N DGCT,NODE,PIECE
 S DGDOEXP=$G(DGDOEXP)
 S DGTOT("V")=""
 F DGTYPE="V","S","D" I $D(DGREL(DGTYPE)) S DGTOT(DGTYPE)="" D
 . S:DGDOEXP&("VS"[DGTYPE) DGEXP(DGTYPE)=$$GET1ND(+$G(DGINC(DGTYPE)))
 . I "VS"[DGTYPE S DGTOT(DGTYPE)=$$GET0ND(+$G(DGINC(DGTYPE))) Q
 . F DGCT=0:0 S DGCT=$O(DGINC(DGTYPE,DGCT)) Q:'DGCT  D
 . . S:DGDOEXP DGEXP(DGTYPE)=$$GET1ND(+$G(DGINC(DGTYPE,DGCT)))
 . . S NODE=$$GET0ND(+DGINC(DGTYPE,DGCT))
 . . F PIECE=8:1:17 I $P(NODE,"^",PIECE)]"" S $P(DGTOT("D"),"^",PIECE)=$P(DGTOT("D"),"^",PIECE)+$P(NODE,"^",PIECE)
 Q
 ;
GET0ND(IEN) ; Returns the 0 node of File #408.21
 Q $G(^DGMT(408.21,IEN,0))
 ;
GET1ND(IEN) ; Returns the 1 node of file #408.21
 Q $G(^DGMT(408.21,IEN,1))
 ;
MTCHK ; Checks if MT/CP is complete for prior calendar year
 ; Input:
 ;    DFN
 ;    DGINR array of income relation for deps
 ;    DGISYR as income screening year
 ;Output:
 ;    DGMTC as MT complete flag (1= yes,2=Non-Mt'd deps exist, 0 o/w)
 ;    DGMTC("S")= Mt complete, but spouse not MTed
 ;    DGMTC("D")= Mt complete, but at least one dep not MT'D
 ;         $D(DGMTED(X,X) if can't edit MT data
 ;
 N DGFL,DGHD,DGMTYPT,DGMTCP,I,X
 S (DGFL,DGMTC)=0 ;initialize flag to 0
 S DGHD="Income data for "_DGISYR_".  "
 I $P($G(^DGMT(408.21,+$G(DGINC("V")),0)),U,18) S DGHD=DGHD_"  [Data Copied - Not Updated]"
 I '$$MTCOMP^DGRPU(DFN,DGEFDT) W !?(40-($L(DGHD)/2)),DGHD Q  ; CP/MT not complete
 S DGMTCP=$S(DGMTYPT=1:"Means",1:"Copay")
 S DGMTC=1,DGRPVV(9)="1111111111",DGMTED("V")=1 S DGHD=DGHD_DGMTCP_" Test is complete for that calendar year!"
 W !?(40-($L(DGHD)/2)),DGHD
 G:DGEFDT'=DT MTCKQT ;NO EDITING AT ALL FOR LAST YEAR
 I $D(DGREL("S")) S DGFL=1 I +$G(^DGMT(408.22,+$G(DGINR("S")),"MT")) S DGMTED("S")=1,DGFL=0
 I DGFL S DGMTC("S")=1 S DGFL=0
 F I=0:0 S I=$O(DGREL("D",I)) Q:'I  S X=+$G(^DGMT(408.22,+$G(DGINR("D",I)),"MT")) S:X DGMTED("D",I)=1 I 'X S DGFL=1
 I DGFL S DGMTC("D")=1
 I $D(DGMTC("S"))!$D(DGMTC("D")) W !,*7," You can only edit these items for dependents who are not not "_DGMTCP_" tested!" S DGMTC=2,DGRPVV(9)="0000000000" Q
 W !,*7,?12,"This data must be edited through the "_DGMTCP_" test module!"
MTCKQT Q
