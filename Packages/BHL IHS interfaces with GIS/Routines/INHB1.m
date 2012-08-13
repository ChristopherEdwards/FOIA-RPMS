INHB1(INBPN) ; cmi/flag/maw - JSH 11 Feb 93 12:15 Interface - routine to run a Background Process 07 Oct 91 6:44 AM ; [ 08/09/2001 9:38 AM ]
 ;;3.01;BHL IHS Interfaces with GIS;;JULY 1, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ;INBPN = entry # in Background Process Control file (#4004)
 X $G(^INTHOS(1,2))
 Q:'$G(INBPN)  Q:'$D(^INTHPC(INBPN,0))  Q:'$G(^INRHSITE(1,"ACT"))
 K INHER S X="ERROR^INHB1",@^%ZOSF("TRAP")
 L +^INRHB("RUN",INBPN):0 E  Q
 S ^INRHB("RUN",INBPN)=$H K ^INTHPC(INBPN,2)
 ;cmi/flagstaff/maw mods here for duz 8/9/2001
 ;S U="^",DUZ=.5,DUZ(0)="@",IO=""  ;cmi/maw orig 8/9/2001
 S INHLDUZ=$O(^VA(200,"B","GIS,USER",0))
 S DUZ=$S($G(INHLDUZ):INHLDUZ,1:DUZ)
 S U="^",DUZ(0)="@",IO=""
 ;cmi/flagstaff/maw end of mods
 S DIE="^INTHPC(",DA=INBPN,DR=".04///^S X=$J;.05///NOW" D ^DIE
 S X=$$PRIO X:X ^%ZOSF("PRIORITY")
 S X=$P(^INTHPC(INBPN,0),U,3) I X,$D(^%ZIS(1,X,0)) S %ZIS="0",IOP=$P(^%ZIS(1,X,0),U)_";0;99999" D ^%ZIS I POP S INHER="Could not open device: "_$P(^%ZIS(1,X,0),U) G ERROR
 S ROU=$G(^INTHPC(INBPN,"ROU")) I ROU="" S INHER="No routine specified." G ERROR
 S:ROU'["^" ROU="^"_ROU
 U:IO]"" IO D @ROU
 ;
QUIT ;Background program termination point
 L -^INRHB("RUN",INBPN) Q
 ;
ERROR ;Process errors
 S X="HALT^INHB1",@^%ZOSF("TRAP") X ^INTHOS(1,3)
 K ^INRHB("RUN",INBPN)
 S:'$D(^INTHPC(INBPN,2,0)) ^(0)="^4004.01D^^"
 S DIC="^INTHPC("_INBPN_",2,",DIC(0)="L",DA(1)=INBPN,X="""NOW""" D ^DIC Q:Y<0
 S ^INTHPC(INBPN,2,+Y,1)=$S($D(INHER):INHER,1:$$ERRMSG^INHU1)
 D ENR^INHE(INBPN,$S($D(INHER):INHER,1:$$ERRMSG^INHU1))
 Q
 ;
HALT ;Just halt
 K ^INRHB("RUN",INBPN) H
 ;
PRIO() ;Function which returns priority for this process
 I $P(^INTHPC(INBPN,0),U,6)]"" Q $P(^(0),U,6)
 Q $P($G(^INRHSITE(1,0)),U,6)
