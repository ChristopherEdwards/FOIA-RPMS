PSGMMAR2 ;BIR/CML3-MD MARS - PRINT C ORDERS(UD) ;09-Dec-2008 22:54;PLS
 ;;5.0; INPATIENT MEDICATIONS ;**8,20,1008**;16 DEC 97
 ; Modified - IHS/CIA/PLS - 01/25/04 - SITE+5
 ;                          06/21/04 - ENB+5
 ;            IHS/MSC/PLS - 12/09/08 - HEADER+2
S1 ;
 I PSGMARB'=1 S:PSGRBPPN="P" X=PN,Y=RB S:PSGRBPPN="R" X=RB,Y=PN S NO=$S(PSGSS="P":$O(^TMP($J,PN,0)),1:$O(^TMP($J,TM,WDN,X,Y,0)))'["C"
 I $S(PSGMARB'=2:1,"34"[PSGMARS:NO,1:0) D:PSGMARS'=4 HEADER,BOT D:PSGMARS'=1 BLANK^PSGMMAR3 Q:PSGMARB=1
 Q:NO  D NOW^%DTC S PSGDT=%,(DAO,PST)="" D HEADER
 S PSGMPG=0,PSGMPGN="PAGE: "
 D @($S(PSGSS="P":"P",1:"W"))
 D BOT
 Q
P ; Print on Patient order
 F  S PST=$O(^TMP($J,PN,PST)) Q:PST'["C"  S DAO="" F  S DAO=$O(^TMP($J,PN,PST,DAO)) Q:DAO=""  S PSGMARTS=^(DAO) D PRT
 S:$O(^TMP($J,PN,"N"))="" PSGMPGN="LAST PAGE: "
 Q
W ; Print Ward/Ward group
 I PSGRBPPN="P" D
 . F  S PST=$O(^TMP($J,TM,WDN,PN,RB,PST)) Q:PST'["C"  F Q=0:0 S DAO=$O(^TMP($J,TM,WDN,PN,RB,PST,DAO)) Q:DAO=""  S PSGMARTS=^(DAO) D PRT
 . S:$O(^TMP($J,TM,WDN,PN,RB,"N"))="" PSGMPGN="LAST PAGE: "
 I PSGRBPPN="R" D
 . F  S PST=$O(^TMP($J,TM,WDN,RB,PN,PST)) Q:PST'["C"  F Q=0:0 S DAO=$O(^TMP($J,TM,WDN,RB,PN,PST,DAO)) Q:DAO=""  S PSGMARTS=^(DAO) D PRT
 . S:$O(^TMP($J,TM,WDN,RB,PN,"N"))="" PSGMPGN="LAST PAGE: "
 Q
HEADER ; pat info
 S:'$G(PSGXDT) PSGXDT=PSGDT ;Reason was that PSGDT kept reset somewhere
 ;S PSGMAROC=0,(MSG1,MSG2)="" W:$G(PSGPG)&($Y) @IOF S PSGPG=1 W !?1,"CONTINUOUS SHEET",?61,PSGMARDF," DAY MAR",?100,PSGMARSP,"  through  ",PSGMARFP
 S PSGMAROC=0,(MSG1,MSG2)="" W:$G(PSGPG)&($Y) @IOF S PSGPG=1 W !?1,"CONTINUOUS SHEET",?31,PSGMARDF," DAY MAR",?60,PSGMARSP,"  through  ",PSGMARFP,?110,"Page ___ of ___"
 W !?5,$P($$SITE(80),U,2),?102,"Printed on  "_$$ENDTC2^PSGMI(PSGXDT)
 W !?5,"Name:  "_PPN,?62,"Weight (kg): "_WT,?103,"Ward: "_PWDN
 W !?6,"PID:  "_PSSN,?25,"DOB: "_BD_"  ("_PAGE_")",?62,"Height (cm): "_HT,?99,"Room-Bed: "_PRB
 W !?6,"Sex:  "_PSEX,?25," Dx: "_DX,?$S(TD:94,1:99),$S(TD:"Last Transfer: "_TD,1:"Admitted: "_AD)
 I '$D(PSGALG) W !,"Allergies:  See attached list of Allergies/Adverse Reactions"
 NEW PSGX S PSGX=0 D ATS^PSGMAR3(.PSGX) D:PSGX HEADER Q:PSGX
 ;* W !,?49,"Admin" W:PSGMARDF=14 ?55,LN14 W !?1,"Order",?9,"Start",?21,"Stop",?49,"Times" W ?55,LN3," notes",!,LN1
 W !,?49,"Admin"
 W:$G(PSJDIET)]"" ?57,"Diet: ",PSJDIET
 W:PSGMARDF=14 ?55,LN14 W !?1,"Order",?9,"Start",?21,"Stop",?49,"Times" W ?55,LN3," notes",!,LN1
 Q
PRT ; order info
 S ON=$P(DAO,U,2)
 I +PSGMSORT,$S(ON["V":1,ON["P":$P($G(^PS(53.1,+ON,0)),U,4)="F",1:0) D PRT^PSGMMIVC Q
 D:PSGMAROC>5 ENB,HEADER I PST["CV"!(PST["CZV") D PRT^PSGMMIVC Q
 ;* S PSGMARGD=$P(PSGMARTS,"^",2),PSGMARTS=$P(PSGMARTS,"^"),PSGORD=+$P(DAO,U,2)_$S(PST["CZ":"P",1:"A") D ^PSGLOI
 S PSGMARGD=$P(PSGMARTS,"^",2),PSGMARTS=$P(PSGMARTS,"^"),PSGORD=$P(DAO,U,2) S:PSGORD["P" PSJPSTO=PST,PST=$S(+PSGMSORT:"CZ",1:PST) D ^PSGLOI
 D TS^PSGMAR3(PSGMARTS)
 D MARLB^PSGMUTL(47)
 I (PSGMAROC>4&(MARLB>6))!(TS/6>6)!((TS/6+PSGMAROC)>6) D BOT,HEADER
 S PSGMAROC=PSGMAROC+1
 NEW PRTLN F PRTLN=1:1:MARLB W !,MARLB(PRTLN),?48,"|",$G(TS(PRTLN)) D CELL(PRTLN,'(PRTLN#6)) D PRT2
 I $D(PSJPSTO) S PST=PSJPSTO K PSJPSTO
 Q
PRT2 ;
 I PSGMAROC>5,(TS/6>7) D
 . S MSG1="*** CONTINUE ON NEXT PAGE ***"
 . D BOT,HEADER
 I PRTLN#6=0 W:PSGMAROC<6 !?7,LN2 S:PRTLN'=MARLB PSGMAROC=PSGMAROC+1
 Q
CHKLAB ; Check to see if next label is needed.
 I '((L+1)#6) W ?48,"| ",$G(TS(L)) D CELL(L,0) W !?1,"See next label for continuation",?48,"| ",$G(TS(L+1)) D CELL(L+1,1) W:PSGMAROC<6 !?7,LN2,!?1 S L=L+2,PSGMAROC=PSGMAROC+1 D  Q
 . I PSGMAROC>5,(TS/6>7) S MSG1="*** CONTINUE ON NEXT PAGE ***" D BOT,HEADER
 E  W ?48,"| ",$G(TS(L)) D CELL(L,0) W !?1 S L=L+1
 Q
INIT ; Print the initials on the label.
 W !?1,$E("WS",1,PSGLWS*2),?4,$S(PSGLSM:$E("HSM",PSGLSM,3),1:""),?8,$E("NF",1,PSGLNF*2),?30,"RPH: ",PSGLRPH,?39," RN: ",PSGLRN,?48,"| ",?50,$G(TS(L)) D CELL(L,1)
 Q
CELL(X,X1) ; Print the **** on the not to be given cells.
 N QTS,CELL S CELL=$E($S(X1:"         ",1:"_________"),1,PSGMARDF=7*5+4)
 I PST["CZ",(X=6) NEW PSGLFFD,PSGMARGD S P(9)="",PSGLFFD="9999999",PSGMARGD="" W ?55 D ASTERS Q
 I TS=1,'PSGMARTS,(X=6) W ?55 S P(9)=1 D ASTERS K P(9) Q
 I $G(TS(X))="" W ?55,$S(X1:LN7,1:LN4) Q
 F Q=0:0 S Q=$O(PSGD(Q)) Q:'Q  S QTS=Q_"."_TS(X) W ?55,"|"_$S(QTS<PSGLSSD:EXPIRE,QTS'<PSGLFFD:EXPIRE,PSGMARGD="":ASTERS,PSGMARGD[$P(PSGD(Q),"^"):CELL,1:ASTERS)
 W "|"
 Q
ASTERS ; Print the **** on the first label.
 S PSGLFFD=$P(PSGLFFD,".") F Q=0:0 S Q=$O(PSGD(Q)) Q:'Q  W "|"_$S(Q<$P(PSGLSSD,"."):ASTERS,Q=PSGLFFD:EXPIRE,Q>PSGLFFD:ASTERS,(PSGMARGD=""&($G(P(9))="")):SPACES,PSGMARGD[$P(PSGD(Q),"^"):SPACES,1:ASTERS)
 W "|"
 Q
BOT ; bottom of MAR
 I MSG1]"" F QQ=1:1:6 W ! W:QQ=1 ?6,"|",?19,"|" W:34[QQ ?12,$S(QQ=3:MSG1,1:MSG2) W ?55,$S(QQ<6:LN4,1:LN7)
 I PSGMAROC<6 S PSGMAROC=6-PSGMAROC F Q=1:1:PSGMAROC F QQ=1:1:6 W ! W:QQ=1 ?6,"|",?19,"|" W:34[QQ ?12,$S(QQ=3:MSG1,1:MSG2) W ?55,$S(QQ<6:LN4,1:LN7) I QQ=6,Q<PSGMAROC W !?7,LN2
ENB ;
 I $D(PSGMPG) S PSGMPG=PSGMPG+1 S PSGMPGN=$S(PSGMPGN'["LAST":"PAGE: ",1:PSGMPGN)_PSGMPG
 W !,LN1
 W !,"|",?11,"SIGNATURE/TITLE",?38,"| INIT |          INJECTION SITES           |",?87,"MED/DOSE OMITTED",?107,"|     REASON     | INIT |"
 F Q=1:1:10 W !,"|"_$E(LN1,1,37)_"|------|"_BLN(Q),?82,"|"_$E(LN1,1,24)_"|"_$E(LN1,1,16)_"|------|"
 ; IHS/CIA/PLS - 06/21/04 - Removed reference to VA Form
 ;W !,LN1,!?3,PPN,?45,PSSN,?58,"Room-Bed: "_PRB,?100,$S($D(PSGMPG):PSGMPGN,1:""),?116,"VA FORM 10-2970",*13
 W !,LN1,!?3,PPN,?45,PSSN,?58,"Room-Bed: "_PRB,?100,$S($D(PSGMPG):PSGMPGN,1:""),*13
 Q
SITE(LEN) ;* Get the Institution name
 ;* Input : LEN = Report width (80 or 132 colume)
 ;* Output: space needed to center text ^ VAMC name
 NEW X
 S X=$$NAME^VASITE
 ; IHS/CIA/PLS - 01/25/04 - Replaced VAMC with SITE
 ;I X="" S X=$$SITE^VASITE S:X]"" X="VAMC:  "_$P(X,U,2)_" ("_$P(X,U,3)_")"
 I X="" S X=$$SITE^VASITE S:X]"" X="SITE:  "_$P(X,U,2)_" ("_$P(X,U,3)_")"
 I X="" Q ""
 Q (LEN-$L(X))/2_U_X
