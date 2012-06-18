ASDHS ; IHS/ADC/PDW/ENM - HS BY CLINIC ; [ 03/25/1999  11:48 AM ]
 ;;5.0;IHS SCHEDULING;;MAR 25, 1999
 ;
 S DIV="" D DIV^SDUTL I $T D ROUT^SDDIV G:Y<0 END
 S (SDIQ,SDX,SDREP,SDSTART)="",SDX="ALL"
 ;
SORT ; -- ask user for sort option
 S ORDER=0
 K DIR S DIR(0)="SAO^C:CLINIC;P:PRINCIPLE CLINIC",DIR("B")="P"
 S DIR("A")="PRINT IN (C)LINIC or (P)RINCIPLE CLINIC ORDER: "
 S DIR("?",1)="Answer C - To see health summaries printed by clinic"
 S DIR("?",2)="Answer P - To sort them by principle clinic"
 S DIR("?")=" "
 D ^DIR K DIR G END:$D(DIRUT) S ORDER=$S(Y="C":2,1:3)
 ;
 S VAUTD=$S(DIV="":1,1:DIV)
 S VAUTNI=1 D CLINIC^VAUTOMA G:Y<0 END
 D:'$D(DT) DT^SDUTL
 S %DT="AEXF",%DT("A")="PRINT HEALTH SUMMARIES FOR WHAT DATE: "
 D ^%DT K %DT("A") G:Y<1 END S SDATE=Y
 ;
 K DIR S DIR(0)="YO",DIR("B")="YES"
 S DIR("A")="Do you want to print other forms also"
 S DIR("?",1)="Answer YES to print not only Health Summaries but"
 S DIR("?",2)="also Address/Insurance Updates, Medication Profiles"
 S DIR("?",3)="and Encounter forms if the clinic(s) have asked for"
 S DIR("?",4)="them in their setup."
 S DIR("?",5)="Answer NO to print ONLY Health Summaries."
 S DIR("?")="  " D ^DIR G END:$D(DIRUT)
 I Y'=1 S (SDZEF,SDZMP,SDZAI)=1
 ;
A5 ;
 S VAR="VAUTD#^VAUTC#^DIV^SDX^ORDER^SDATE^SDIQ^SDREP^SDSTART^SDZEF^SDZMP^SDZAIU"
 S DGPGM="START^ASDHS"
 S ADGDEV=$$VAL^XBDIQ1(40.8,$$DIV^ASDUT,9999999.06)
 I ADGDEV="" K ADGDEV
 D ZIS^DGUTQ G:POP END^SDROUT1
 G START:'$D(IO("Q"))
 ;
END ; -- eoj
 K ALL,DIV,ORD,ORDER,RMSEL,SDIQ,SDREP,SDSP,SDSTART
 K SDX,X,Y,C,V,I,SDEF,%I Q
 ;
START ;EP; loop thru clinics and appts to get patients
 NEW ASDX,ASDY,ASDT
 K ^UTILITY("SDHS",$J) U IO
 ;
 I ORDER=2,'$G(VAUTC) D CLIN Q
 ;
 S ASDX=0
 F  S ASDX=$O(^SC(ASDX)) Q:'ASDX  D CHECK I $T D
 . I '$G(VAUTC) D CHECK2 Q:'$T
 . S ASDT=SDATE
 . F  S ASDT=$O(^SC(ASDX,"S",ASDT)) Q:ASDT=""!(ASDT>(SDATE+1))  D
 .. S ASDY=0 F  S ASDY=$O(^SC(ASDX,"S",ASDT,1,ASDY)) Q:'ASDY  D
 ... I $P($G(^SC(ASDX,"S",ASDT,1,ASDY,0)),U,9)'="C" D GOT^ASDHS1
 D GO^ASDHS1 K VAUTC,VAUTD,SDZEF,SDZMP,SDZAI Q
 ;
CLIN ; -- sorts by clinic
 S ASDZ=""
 F  S ASDZ=$O(VAUTC(ASDZ)) Q:ASDZ=""  D
 . S ASDX=+VAUTC(ASDZ) D CHECK I $T D
 .. S ASDT=SDATE
 .. F  S ASDT=$O(^SC(ASDX,"S",ASDT)) Q:ASDT=""!(ASDT>(SDATE+1))  D
 ... S ASDY=0 F  S ASDY=$O(^SC(ASDX,"S",ASDT,1,ASDY)) Q:'ASDY  D
 .... I $P($G(^SC(ASDX,"S",ASDT,1,ASDY,0)),U,9)'="C" D GOT^ASDHS1
 D GO^ASDHS1 K VAUTC,VAUTD,SDZEF,SDZMP,SDZAI Q
 ;
CHECK ; -- checks out clinic (active?, in division?, etc.)
 I $P(^SC(ASDX,0),U,3)="C",$S(DIV="":1,$P(^SC(ASDX,0),U,15)=DIV:1,1:0),$S('$D(^SC(ASDX,"I")):1,+^("I")=0:1,+^("I")>SDATE:1,+$P(^("I"),U,2)'>SDATE&(+$P(^("I"),U,2)):1,1:0)
 Q
 ;
CHECK2 ; -- checks if clinic belongs to prin clinic chosen
 NEW X
 S X=$P($G(^SC(ASDX,"SL")),U,5)
 I X]"",$D(VAUTC($P(^SC(+X,0),U)))
 Q
