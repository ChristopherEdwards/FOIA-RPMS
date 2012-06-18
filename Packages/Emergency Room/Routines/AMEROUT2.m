AMEROUT2 ; IHS/ANMC/GIS - GETS SORT BY CRITERIA ;
 ;;3.0;ER VISIT SYSTEM;;FEB 23, 2009
 ;
MP ; ENTRY POINT FROM AMEROUT1
 W !!!,"This attribute can have multiple values"
 I '$D(AMERSTAT) S DIR(0)="SO^1:Sort by all values of this attribute;2:Limit output to one particular value of this attribute;3:Display entries where attribute value is 'null'"
 E  S DIR(0)="SO^1:Do statistical analysis on this attribute now;2:Analyze only those entries with one particular value;3:Analyze only those entries where attribute value is 'null'"
 S DIR("A")="Your choice",DIR("B")="1" D ^DIR K DIR I 1
 D OUT^AMEROUT I $D(AMERQUIT) Q
 I $D(AMERSTAT) S FLDS="!.01"
 I Y=1,$D(AMERSTAT) D STAT Q
 ; I $D(AMERSTAT),Y'=2,$E(BY)'="'" S BY="'"_BY
 I Y=1 S (AMERFR,AMERTO)="",AMERNXT="Within "_AMERATNM_" sort by" Q
 I Y=3 S (AMERFR,AMERTO)="@",AMERNXT="Then sort by",^TMP("AMER",$J,8,AMERATNM)="NULL" Q
 I $D(AMERMSFL) D MS1 Q
 S DIC("A")="Select "_AMERATNM_": "
 S DIC=U_AMERGBL,DIC(0)="AEQZMI" I $D(AMERSCR) S DIC("S")=AMERSCR
 D ^DIC K DIC
 D OUT^AMEROUT I $D(AMERQUIT) Q
 Q:Y=-1
 S AMERNXT="Then sort by",(AMERFR,AMERTO)=""
 I AMERBY'["," S AMERBY=$S($D(AMERSTAT):"+",1:"'")_"INTERNAL("_$S(+$P(AMERBY,":"):"#",1:"")_""_AMERBY_")="_+Y
 E  S X=$L(AMERBY,","),%=$P(AMERBY,",",X),$P(AMERBY,",",X)=$S($D(AMERSTAT):"+",1:"'")_"INTERNAL("_$S(+$P(AMERBY,":"):"#",1:"")_""_%_")="_+Y
 S ^TMP("AMER",$J,8,AMERATNM)=Y(0,0)
 Q
 ;
MA ; ENTRY POINT FROM AMEROUT1
 D MA^AMEROUT3
 Q
 ;
MS ; ENTRY POINTY FROM AMEROUT1
 S AMERMSFL="" D MP K AMERMSFL
 Q
 ;
MS1 ;
 S %=$P(^DD(+AMERSCR,$P(AMERSCR,";",2),0),U,3),DIR(0)="SO^"_%,DIR("A")="Your choice" D ^DIR K DIR
 D OUT^AMEROUT
 I $D(AMERQUIT) Q
 S AMERNXT="Then sort by",(AMERFR,AMERTO)=""
 I AMERBY'["," S AMERBY=$S($D(AMERSTAT):"+",1:"'")_"INTERNAL("_$S(+$P(AMERBY,":"):"#",1:"")_""_AMERBY_")="""_Y_""""
 E  S X=$L(AMERBY,","),%=$P(AMERBY,",",X),$P(AMERBY,",",X)=$S($D(AMERSTAT):"+",1:"'")_"INTERNAL("_$S(+$P(AMERBY,":"):"#",1:"")_""_%_")="""_Y_""""
 S ^TMP("AMER",$J,8,AMERATNM)=Y(0)
 Q
 ;
MT ; ENTRY POINT FROM AMEROUT1
 S DIR(0)="NO^0:30:0",DIR("A")="Enter the mumimum turnaround time in days",DIR("B")="0" D ^DIR K DIR
 D OUT^AMEROUT I $D(AMERQUIT) Q
 S Y=+Y
 S AMERMIN=Y S:Y=0 Y=.1 S AMERFR=Y
 S DIR(0)="NO^0:30:0",DIR("A")="Enter the maximum turnaround time in days",DIR("B")=30 D ^DIR K DIR
 D OUT^AMEROUT I $D(AMERQUIT) Q
 I Y="" S Y=30
 S ^TMP("AMER",$J,8,AMERATNM)=AMERMIN_"-"_Y_" day(s)"
 S:Y=0 Y=.9 S AMERTO=Y
 I AMERFR>AMERTO W "  ??",*7,! G MT
 I $D(AMERSTAT) S FLDS="#"_AMERBY,AMERBY="+"_AMERBY,AMERSTAT=1 Q
 S AMERNXT="Then sort by",AMERBY="'@"_AMERBY
 Q
 ;
MM ; ENTRY POINT FROM AMEROUT1
 I '$D(AMERSTAT) G MM1
 S DIR(0)="SO^1:Do statistatical analysis of this attribute now;2:Limit analysis to entries in a certain range",DIR("A")="Your choice",DIR("B")="1",DIR("?")="" D ^DIR K DIR
 D OUT^AMEROUT I $D(AMERQUIT) Q
 I Y=1 S FLDS="#"_AMERBY,AMERBY="+"_AMERBY,(AMERFR,AMERTO)="" S:$D(AMERSTAT) AMERSTAT=1 Q
MM1 S DIR(0)="NO^1:9999:0",DIR("A")="Enter minimum time in minutes" D ^DIR K DIR
 D OUT^AMEROUT I $D(AMERQUIT) Q
 I Y="" S Y=1 W "  (1)"
 S AMERFR=Y
 S DIR(0)="NO^1:9999:0",DIR("A")="Enter maximum time in minutes" D ^DIR K DIR
 D OUT^AMEROUT I $D(AMERQUIT) Q
 I Y="" S Y=9999 W "  (9999)"
 S ^TMP("AMER",$J,8,AMERATNM)=AMERFR_"-"_Y_" minutes",AMERTO=Y
 I AMERFR>AMERTO W " ??",*7,! G MM
 I $D(AMERSTAT) S FLDS="#"_AMERBY,AMERBY="+"_AMERBY,AMERSTAT=1 Q
 S AMERBY="'@"_AMERBY
 S AMERNXT="Then sort by: "
 Q
 ;
MC ; ENTRY POINT FROM AMEROUT1
 D MC^AMEROUT3
 Q
 ;
MSTAT S AMERSTAT=1,FLDS="!.01",(AMERFR,AMERTO,AMERBY)="" Q
STAT S FLDS="!.01"
 ; Print names of DX Codes in statistical reports
 I AMERBY="5,.01" S FLDS=FLDS_",5,.01:DIAGNOSIS;N;""DX DESCRIPTION"""
 S (AMERFR,AMERTO)="",AMERBY="+"_AMERBY
 Q
 ;
MU ; ENTRY POINT FROM AMEROUT1
 D MU^AMEROUT3
 Q
