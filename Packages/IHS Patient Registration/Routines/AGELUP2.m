AGELUP2 ;IHS/ASDS/EFG - PROCESS MCR ELIGIBILITY FROM CMS FILE ;  
 ;;7.1;PATIENT REGISTRATION;**2**;JAN 31, 2007
 ;
M(AG) ;EP - process Medicare
 KILL AG1,AG2,AGSAME
 I $D(^AUPNMCR(AG("DFN"))) D MCRY I AGSAME S AGACT="S" Q
 I AGAUTO'="A" D  Q
 . D HEAD^AGELUPUT("MEDICARE")
 . I '$D(^AUPNMCR(AG("DFN"))) D MCRN
 . D MDISP(5),PEND^AGELUPUT
 .Q
 U IO(0)
 W "."
 W:'(AGRCNT#100) $J(AGRCNT,8)
 Q
MCRY ;if medicare coverage
 S AGSAME=0
 ;MediCare name.
 S (AGMNM,AG1(1))=$P($G(^AUPNMCR(AG("DFN"),21)),U)
 ;MediCare DOB.
 S AGMDOB=$P($G(^AUPNMCR(AG("DFN"),21)),U,2)
 S AG1(2)=AGMDOB
 ;MediCare #.
 S (AGMNBR,AG1(3))=$P(^AUPNMCR(AG("DFN"),0),U,3)
 ;MediCare Suffix.
 S AGMSFX=$P(^AUPNMCR(AG("DFN"),0),U,4)
 S (AGMSFX,AG1(4))=$P($G(^AUTTMCS(+AGMSFX,0)),U)
 ;AG1("DT",EligDt,CovType)=EligDt^ELigEndDt^CovType
 S DA=0
 ;F  S DA=$O(^AUPNMCR(AG("DFN"),11,DA)) Q:'DA  S %=^(DA,0) S:$P(%,U,3)="" $P(%,U,3)=" " S AG1("DT",$P(%,U,1),$P(%,U,3))=%
 F  S DA=$O(^AUPNMCR(AG("DFN"),11,DA)) Q:'DA  D
 .;S %=^(DA,0)
 .S %=$P(^(DA,0),U,1,3)  ;PART D COVERAGES THREW THIS OFF AG*7.1*2 IM????? NO IM FOUND DURING TESTING ON NEW HRN LENGTH
 .Q:$P(%,U,3)="D"        ;AG*7.1*2 IM22061 IGNORE PART D FOR DIFFERENCE COMPARISON
 .S:$P(%,U,3)="" $P(%,U,3)=" "
 .S AG1("DT",$P(%,U,1),$P(%,U,3))=%
 KILL AGFL
 D DFL
 S:'$D(AGFL) AGSAME=1
 Q
MCRN ;EP - No MCR/RRE coverage in rpms.
 S AG1(1)="NO ELIGIBILITY ON FILE"
 F I=2:1:4 S AG1(I)=""
 D DFL
 Q
DFL ;EP - Set descrepency flags.
 KILL AGFL
 S AG2(1)=$G(AG("FNM"))
 S:AG2(1)'=$G(AGMNM) AGFL(1)=1  ;Name.
 S AG2(2)=$G(AG("FDOB"))
 S:AG2(2)'=$G(AGMDOB) AGFL(2)=1 ;DOB.
 S AG2(3)=$G(AG("FNBR"))
 S:AG2(3)'=$G(AGMNBR) AGFL(3)=1 ;#.
 S AG2(4)=$G(AG("FSFX"))
 S:AG2(4)'=$G(AGMSFX) AGFL(4)=1 ;Suffix.
 ;Compare file eligibilities with existing eligibilities.
 ;AG1("DT",EligDt,CovType)=EligDt^ELigEndDt^CovType
 NEW I,J
 S I=0
 F  S I=$O(AG("DT",I)) Q:'I  D
 . S J=0
 . F  S J=$O(AG("DT",I,J)) Q:J=""  D
 .. I $G(AG1("DT",I,J))'=AG("DT",I,J) S AGFL(5)=1
 ..Q
 .Q
 S I=0
 F  S I=$O(AG1("DT",I)) Q:'I  D
 . S J=0
 . F  S J=$O(AG1("DT",I,J)) Q:J=""  D
 .. I $G(AG("DT",I,J))'=AG1("DT",I,J) S AGFL(5)=1
 ..Q
 .Q
 Q
MDISP(AGDISP) ;EP - display medicare info
 I AGDISP=5 S AG1(5)="DATES",AG2(5)=""
 F I=1:1:AGDISP D
 . W !,$P($T(@I),";;",$S(AGTYPE="D":3,1:2)),":",?13
 . W:$G(AGFL(I)) $$S^AGVDF("RVN")
 . W $S('$L(AG1(I)):"     ",I=2:$$FMTE^XLFDT(AG1(I),5),1:AG1(I))
 . W:$G(AGFL(I)) $$S^AGVDF("RVF")
 . I AGTYPE="D",I=5 W " ( Matching Medicaid eligibility dates are not displayed )"
 . W ?45,$S(I=2:$$FMTE^XLFDT(AG2(I),5),1:AG2(I))
 .Q
 I AGDISP=4 W !
 ;Dates from RPMS file.
 S (AG1,AGCNT)=0
 KILL AGLINE
 F  S AG1=$O(AG1("DT",AG1)) Q:'AG1  D
 . S AGCVT=0
 . F  S AGCVT=$O(AG1("DT",AG1,AGCVT)) Q:AGCVT=""  D
 .. S AGCNT=AGCNT+1,AGLINE(AGCNT)=AG1("DT",AG1,AGCVT)
 .. I $G(AG("DT",AG1,AGCVT)) S $P(AGLINE(AGCNT),"*",2)=AG("DT",AG1,AGCVT)
 ..Q
 .Q
 ;Dates from incoming file.
 S AG2=0
 F  S AG2=$O(AG("DT",AG2)) Q:'AG2  D
 . S AGCVT=0
 . F  S AGCVT=$O(AG("DT",AG2,AGCVT)) Q:AGCVT=""  D
 .. Q:$G(AG1("DT",AG2,AGCVT))  S AGCNT=AGCNT+1,$P(AGLINE(AGCNT),"*",2)=AG("DT",AG2,AGCVT)
 .. S:$P(AGLINE(AGCNT),"*",1)="" $P(AGLINE(AGCNT),"*",1)="^^"
 ..Q
 .Q
 S (I,AGCNT)=0
 F  S I=$O(AGLINE(I)) Q:'I  D
 . I AGTYPE="D" Q:$P(AGLINE(I),"*",2)=""  Q:$P(AGLINE(I),"*",1)=$P(AGLINE(I),"*",2)
 . S AGLINE(I)=$TR(AGLINE(I),"*","^")
 . W !,"START DATE: "
 . W ?13,$$FMTE^XLFDT($P(AGLINE(I),U,1),5)
 . W ?45,$S('($P(AGLINE(I),U,1)):IORVON,1:""),$$FMTE^XLFDT($P(AGLINE(I),U,4),5),IORVOFF
 . W !,"  END DATE: "
 . W ?13,$$FMTE^XLFDT($P(AGLINE(I),U,2),5)
 . W ?45,$S('$P(AGLINE(I),U,1):IORVON,($P(AGLINE(I),U,5))&($P(AGLINE(I),U,2)'=$P(AGLINE(I),U,5)):IORVON,1:""),$S($P(AGLINE(I),U,5):$$FMTE^XLFDT($P(AGLINE(I),U,5),5),1:$J("",10)),IORVOFF
 . W !,"  COV TYPE: ",?13,$P(AGLINE(I),U,3),?45,$S('$L($P(AGLINE(I),U,3)):IORVON,1:""),$P(AGLINE(I),U,6),IORVOFF
 .Q
 Q
1 ;;MCR NAME;;MCD NAME;;
2 ;;MCR DOB;;MCD DOB;;
3 ;;MCR NUMBER;;MCD NUMBER;;
4 ;;SFX;;;;
5 ;;ELIGIBILITY;;ELIGIBILITY;;
 ;
FILE(AG) ;EP - file MEDICARE FIELDS
 I '$D(^AUTTMCS("B",AG("FSFX"))) S DIC=9999999.32,DIC(0)="L",X=AG("FSFX") D ^DIC I +Y<1 W !,"Add to MEDICARE SUFFIX file failed for '",AG("FSFX"),"'.",$$DIR^XBDIR("E") Q
 NEW AGADD
 I '$D(^AUPNMCR(AG("DFN"),0)) D  Q:+Y<0  S AGADD=1 I 1
 . NEW DIC,DLAYGO,DD,DO
 . S DIC="^AUPNMCR(",DIC(0)="F",DLAYGO=9000003,(DINUM,X)=AG("DFN")
 . S DIC("DR")=".02////"_AGINSPT_";.03///"_AG("FNBR")_";.04///"_AG("FSFX")_";2101///"_AG("FNM")_";2102///"_AG("FDOB")
 . K DD,DO
 . D FILE^DICN,PTACT(1,AG("DFN")):+Y>0
 .Q
 E  D  S AGADD=0
 . NEW DA,DIE,DR
 . S DIE="^AUPNMCR(",DA=AG("DFN"),DR=""
 . I $P(^AUPNMCR(DA,0),U,2)'=AGINSPT S DR=".02////"_AGINSPT
 . I AG("FNBR")'="",AG("FNBR")'=$P(^AUPNMCR(DA,0),U,3) S DR=DR_$S($L(DR):";",1:"")_".03///"_AG("FNBR")
 . I AG("FSFX")'="" D
 .. I $P(^AUPNMCR(DA,0),U,4),AG("FSFX")=$P(^AUTTMCS($P(^AUPNMCR(DA,0),U,4),0),U) Q
 .. S DR=DR_$S($L(DR):";",1:"")_".04///"_AG("FSFX")
 ..Q
 . I AG("FNM")'="",AG("FNM")'=$P($G(^AUPNMCR(DA,21)),U) S DR=DR_$S($L(DR):";",1:"")_"2101///"_AG("FNM")
 . I AG("FDOB")'="",AG("FDOB")'=$P($G(^AUPNMCR(DA,21)),U,2) S DR=DR_$S($L(DR):";",1:"")_"2102////"_AG("FDOB")
 . I $L(DR) NEW DITC S DITC="" D ^DIE,PTACT(2,AG("DFN")):'$D(Y) KILL DITC
 .Q
 ;
 S DA(1)=AG("DFN"),DIK="^AUPNMCR("_DA(1)_",11,",DA=0
 ;F  S DA=$O(^AUPNMCR(DA(1),11,DA)) Q:'DA  D ^DIK
 F  S DA=$O(^AUPNMCR(DA(1),11,DA)) Q:'DA  I $P($G(^AUPNMCR(DA(1),11,DA,0)),U,3)'="D" D ^DIK  ;IHS/SD/TPF 4/25/2006 AG*7.1*2 IM20585
 S DIC="^AUPNMCR("_DA(1)_",11,",DIC(0)="F",DIC("P")=$P(^DD(9000003,1101,0),U,2)
 KILL DD,DO
 S AGI=0
 F  S AGI=$O(AG("DT",AGI)) Q:'AGI  D
 . S AGJ=0
 . F  S AGJ=$O(AG("DT",AGI,AGJ)) Q:AGJ=""  D
 .. S X=$P(AG("DT",AGI,AGJ),U,1)
 .. Q:'X
 .. S DIC("DR")=".02////^S X=$P(AG(""DT"",AGI,AGJ),U,2)"
 .. S DIC("DR")=DIC("DR")_";.03////^S X=$P(AG(""DT"",AGI,AGJ),U,3)"
 .. K DD,DO
 .. D FILE^DICN
 .. Q:AGADD
 .. D:+Y>0 PTACT(2,AG("DFN"))
 ..Q
 .Q
 KILL AGI,AGJ
 ;
 D
 . NEW DFN
 . S DFN=AG("DFN")
 . D ^AGDATCK
 . I $D(AG("ER")) KILL AG("DATE"),AG("DTOT"),AG("ER") Q
 . D UPDATE1^AGED(DUZ(2),AG("DFN"),4,"")
 .Q
 Q
 ;
PTACT(AG,X) ;EP - Record action AG on patient X (DFN). 1=add, 2=edit.
 NEW DA,DIC,DIE,DINUM,DR,Y
 S DA(1)=AGRUN,DIC("P")=$P(^DD(9009062.02,AG,0),U,2),DIC="^AGELUPLG("_DA(1)_","_AG_",",DIC(0)="F",DINUM=X
 K DD,DO
 D FILE^DICN
 Q
