AGELUP5 ;IHS/ASDS/EFG - UPDATE ELIGIBILITY FROM FILE  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
R(AG) ;process railroad retirement
 I '$G(AG("DFN")) D FP
 Q:'AG("DFN")
 Q:$G(^TMP($J,"AGELUP",AG("DFN")))
 S ^TMP($J,"AGELUP",AG("DFN"))=1
 Q:AG("FNBR")'?9N
 K AG1,AG2,AGSAME
 I $D(^AUPNRRE(AG("DFN"))) D MCRY
 Q:$G(AGSAME)
 I $G(AGAUTO)'="A" D
 .D HEAD^AGELUP6
 .I '$D(^AUPNRRE(AG("DFN"))) D MCRN
 .D MDISP
 .D PEND^AGELUP6
 I $G(AGAUTO)="A" D
 .S AGACT="F"
 .U IO(0) W ","
 Q
FP ;find patient in rpms
 S AG("DFN")=$O(^DPT("SSN",AG("FSSN"),0))
 Q
MCRY ;if railroad coverage
 S (AGMNM,AG1(1))=$P($G(^AUPNRRE(AG("DFN"),21)),"^",1)
 S AGMDOB=$P($G(^AUPNRRE(AG("DFN"),21)),"^",2)
 S AG1(2)=AGMDOB
 S (AGMNBR,AG1(3))=$P(^AUPNRRE(AG("DFN"),0),"^",4)
 S AGMSFX=$P(^AUPNRRE(AG("DFN"),0),"^",3)
 S (AGMSFX,AG1(4))=$P($G(^AUTTRRP(+AGMSFX,0)),"^",1)
 S (AGMESD,AGMEED,AGMCVT)=""
 S DA=0 F  S DA=$O(^AUPNRRE(AG("DFN"),11,DA)) Q:'DA  D
 .S AGDT=$P(^AUPNRRE(AG("DFN"),11,DA,0),"^",1),AGCOV=$P(^(0),"^",3)
 .S AG1("DT",AGDT,AGCOV)=^AUPNRRE(AG("DFN"),11,DA,0)
 K AGFL
 D DFL
 S:'$D(AGFL) AGSAME=1
 Q
MCRN ;no railroad coverage in rpms
 S AG1(1)="NO ELIGIBILITY ON FILE"
 F I=2:1:4 S AG1(I)=""
 D DFL
 Q
DFL ;set descrepency flags
 K AGFL
 S AG2(1)=$G(AG("FNM"))
 S:AG2(1)'=$G(AGMNM) AGFL(1)=1
 S AG2(2)=$G(AG("FDOB"))
 S:AG2(2)'=$G(AGMDOB) AGFL(2)=1
 S AG2(3)=$G(AG("FNBR"))
 S:AG2(3)'=$G(AGMNBR) AGFL(3)=1
 S AG2(4)=$G(AG("FSFX"))
 S:AG2(4)'=$G(AGMSFX) AGFL(4)=1
 N I,J
 S I=0 F  S I=$O(AG("DT",I)) Q:'I  D
 .S J=0 F  S J=$O(AG("DT",I,J)) Q:J=""  D
 ..I $G(AG1("DT",I,J))'=AG("DT",I,J) S AGFL(5)=1
 S I=0 F  S I=$O(AG1("DT",I)) Q:'I  D
 .S J=0 F  S J=$O(AG1("DT",I,J)) Q:J=""  D
 ..I $G(AG("DT",I,J))'=AG1("DT",I,J) S AGFL(5)=1
 Q
MDISP ;display medicare info
 F I=1:1:4 D
 .W !,$P($T(@I),";;",2)
 .W ":"
 .W ?12
 .W:$G(AGFL(I)) $$S^AGVDF("RVN")
 .W:I'=2 AG1(I)
 .W:I=2 $$FMTE^XLFDT(AG1(I),5)
 .W:$G(AGFL(I)) $$S^AGVDF("RVF")
 .W ?45
 .W:I'=2 AG2(I)
 .W:I=2 $$FMTE^XLFDT(AG2(I),5)
 W !
 S AG1=0,AGCNT=0
 K AGLINE
 F  S AG1=$O(AG1("DT",AG1)) Q:'AG1  D
 .S AGCVT=0
 .F  S AGCVT=$O(AG1("DT",AG1,AGCVT)) Q:AGCVT=""  D
 ..S AGCNT=AGCNT+1
 ..S AGLINE(AGCNT)=AG1("DT",AG1,AGCVT)
 S AG2=0,AGCNT=0
 F  S AG2=$O(AG("DT",AG2)) Q:'AG2  D
 .S AGCVT=0 F  S AGCVT=$O(AG("DT",AG2,AGCVT)) Q:AGCVT=""  D
 ..S AGCNT=AGCNT+1
 ..S $P(AGLINE(AGCNT),"*",2)=AG("DT",AG2,AGCVT)
 ..S:$P(AGLINE(AGCNT),"*",1)="" $P(AGLINE(AGCNT),"*",1)="^^"
 S I=0,AGCNT=0
 F  S I=$O(AGLINE(I)) Q:'I  D
 .S AGLINE(I)=$TR(AGLINE(I),"*","^")
 .W !,"START DATE: "
 .W ?12,$$FMTE^XLFDT($P(AGLINE(I),"^",1),5)
 .W ?45,$$FMTE^XLFDT($P(AGLINE(I),"^",4),5)
 .W !,"END DATE: "
 .W ?12,$$FMTE^XLFDT($P(AGLINE(I),"^",2),5)
 .W ?45,$$FMTE^XLFDT($P(AGLINE(I),"^",5),5)
 .W !,"COV TYPE: "
 .W ?12,$P(AGLINE(I),"^",3)
 .W ?45,$P(AGLINE(I),"^",6)
 Q
1 ;;MCR NAME
2 ;;MCR DOB
3 ;;MCR NUMBER
4 ;;SFX
