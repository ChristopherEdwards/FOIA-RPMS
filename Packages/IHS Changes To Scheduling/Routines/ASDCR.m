ASDCR ; IHS/ADC/PDW/ENM - CHART REQUEST (FUTURE) ; [ 03/25/1999  11:48 AM ]
 ;;5.0;IHS SCHEDULING;;MAR 25, 1999
 ; -- uses non-namespaced variables for calls to VA rtns
 ;
 D DT^DICRW
A1 ;
 K SDMADE S ASDCR=""
 S DIC=44,DIC(0)="AEMQ" W !!
 S DIC("A")="REQUEST CHARTS FOR REVIEW FOR WHICH CLINIC: "
 S DIC("S")="I $P(^(0),U,3)=""C"",$D(^(""SL""))"
 D ^DIC K DIC G END:X[U!(Y<0)
 S SC=+Y,YY=Y,SDSL=$S($D(^SC(SC,"SL")):+^("SL"),1:"") K SDRE,SDIN,SDRE1
 ;
 I $D(^SC(SC,"I")) D
 . S SDIN=+^SC(SC,"I"),SDRE=+$P(^("I"),U,2),Y=SDRE D DTS^SDUTL S SDRE1=Y
 ;
 I $S('$D(SDIN):0,'SDIN:0,SDIN>DT:0,SDRE'>DT&(SDRE):0,1:1) D  G A1
 . W !,*7,"Clinic is inactive ",$S(SDRE:"from ",1:"as of ")
 . S Y=SDIN D DTS^SDUTL W Y,$S(SDRE:" to "_SDRE1,1:"")
 ;
 ;
OTHER S DIR(0)="F^2:200"
 S DIR("A")="DELIVER CHARTS TO (PROVIDER/LOCATION/EXT.)"
 S DIR("?")=" "
 S DIR("?",1)="Enter the clinic/provider who is requesting the charts"
 S DIR("?",2)="with physical location and extension (Westley/2W5/x1669)"
 D ^DIR K DIR G A1:$D(DIRUT) S SDZPL=Y
 ;
TIME ; -- ask user for date/time to be ready
 K DIR S DIR(0)="DA^"_$$DAYS_"::EFT",DIR("B")=$$DAYSP,DIR("?")=" "
 S DIR("?",1)="Enter the date@time you would like the charts to be ready."
 S DIR("?",2)="Please allow at least "_$$DAYSN_" days for charts to be pulled."
 S DIR("A")="DATE/TIME NEEDED:  " D ^DIR K DIR G A1:$D(DIRUT),A1:Y<1
 ;
 S SDZY=$S(Y[".":Y,1:Y_".08"),SDZYY=$P(SDZY,".")
 ;
PT ; -- get patient
 W !! S DIC="^DPT(",DIC(0)="AEQMZ" D ^DIC K DIC,I,J S DFN=+Y
 I Y<0 G PRT:$D(SDMADE),A1:'$D(SDMADE)
 ;
 I $S('$D(^DPT(DFN,.35)):0,$P(^(.35),U,1)]"":1,1:0) D
 . W *7,!,"** PATIENT HAS DIED! **"
 ;
 F SDPR=DT:0 S SDPR=$O(^DPT(+Y,"S",SDPR)) Q:SDPR=""!(SDPR>(DT+.2400))  D
 . I $P(^DPT(+Y,"S",SDPR,0),U,2)'["C",$P(^(0),U,2)'["N" S I(SDPR)=+^(0)
 ;
 S J=0 F  S J=$O(^DPT(DFN,"DE",J)) Q:'$D(^(+J,0))  S:$P(^(0),U,2)'["I" J(+^(0))=""
 F SDPR=0:0 S SDPR=$O(I(SDPR)) Q:SDPR=""  D
 . F I=0:0 S I=$O(^SC(I(SDPR),"S",SDPR,1,I)) Q:'$D(^(+I,0))  D
 .. I ^SC(I(SDPR),"S",SDPR,1,I,0)-DFN=0 D
 ... D GOT S D=$P(^DPT(DFN,0),U,2)="F"
 ;
 I ('$D(J(SC)))&('$D(J(+$P(^SC(SC,"SL"),U,5)))) D ENR
 ;
 S Y=SDZY D OKTD^SDI G PT
 ;
 ;
ENR ; -- enroll patient in clinic
 S Y=$P(^SC(SC,"SL"),U,5) I '$D(^SC(+Y,0)) S Y=+SC
 S Y=$P(^SC(Y,0),U,1)
 S SDY=Y,X="NOW",%DT="XT" D ^%DT S HEY=Y
 S DA=DFN,DR="3///"_SDY,(DIE,DIC)="^DPT(",DP=2
 S DR(2,2.001)=".01///"_SDY_";1///"_HEY
 S DR(3,2.011)=".01///"_HEY_";1///O" D ^DIE K DR
 Q
 ;
GOT ;W !,"REQUESTED FOR "_$E(SDPR_"000",9,12)_" ON "
 S SDMADE="" S:'$D(^SC(I(SDPR),"S",0)) ^(0)="^44.001DA^^" Q
 ;
PRT ; -- prints out routing slips for patients selected
 I $$VAL^XBDIQ1(40.8,$$DIV^ASDUT,9999999.14)="NO" G END
 K ASDCR,SDZPL
 S SDX="ADD",SDSP="N"
 S (SDIQ,DIV,SDHS,SDPP,APCHSTYP,SDAIU,SDREP)="",SDNFF=0
 W !!,"TO BYPASS PRINTING OF ROUTING SLIPS NOW - TYPE IN ^"
 D DIV^SDUTL I $T D ROUT^SDDIV G:Y<0 END
 S VAUTC=0,VAUTC($P(^SC(SC,0),U))=SC,ORDER=2,SDSTART=""
 S SDATE=SDZYY
 S APDATE=$E(SDATE,4,5)_"/"_$E(SDATE,6,7)_"/"_$E(SDATE,2,3)
 S PRDATE=$E(DT,4,5)_"/"_$E(DT,6,7)_"/"_$E(DT,2,3)
 S %ZIS="Q",%ZIS("B")=$$CRPTR D ^%ZIS
 G END:POP,QUE:$D(IO("Q")) D START^SDROUT,END Q
 ;
QUE ;
 K IO("Q"),ZTSAVE
 F %="DIV","SDREP","SDSP","SDX","SDZPL","DUZ(2)","DT","SDSTART","SDATE","APDATE","PRDATE","SDIQ","YY","SDHS","SDPP","APCHSTYP","SDNFF","SDAIU","VAUTC(","VAUTC","ORDER" S ZTSAVE(%)=""
 S ZTRTN="START^SDROUT",ZTDESC="ROUTING SLIPS"
 D ^%ZTLOAD K ZTSK D HOME^%ZIS G END
 ;
END K %,%DT,APCHSTYP,D,DA,DFN,DIC,DIE,DP,DR,GDATE,I,SDZY,J,PRDATE,SDATE
 K SDHS,SDAIU,SDNFF,SDPP,SC,SD,SDAPTYP,SDD,SDINP,SDIQ,SDPL,SDPR,SDRT
 K SDSC,SDSL,SDTTM,SDY,SDX,SDZPL,X,Y,Y1,SDMADE,ASDCR,YY,SDZYY
 D END^SDROUT1
 Q
 ;
DAYS() ; -- returns default first date for charts to be ready
 NEW X1,X2,X
 S X1=DT,X2=$$VAL^XBDIQ1(40.8,$$DIV^ASDUT,9999999.07)
 S:X2="" X2=3 D C^%DTC
 Q X_".0800"
 ;
DAYSP() ; -- return default day in readable format
 Q $$FMTE^XLFDT($$DAYS,2)
 ;
 ;
DAYSN() ; -- returns default # of days
 Q $$VAL^XBDIQ1(40.8,$$DIV^ASDUT,9999999.07)
 ;
CRPTR() ; -- returns default chart request printer
 Q $$VAL^XBDIQ1(40.8,$$DIV^ASDUT,9999999.05)
