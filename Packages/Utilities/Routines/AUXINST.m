AUXINST ; [ 04/11/86  3:34 PM ]
 W !,"AUXINST alters the ^DIC AND ^AUTTLOC globals.",!,"Therefore,..It must NOT be interrupted!!"
 R !!,"Are you sure you want to continue <Y>? ",ANS I '(ANS="Y"!(ANS="")) W !,"OKIE DOKE - I QUIT!!",!,"AUXINST NOT EXECUTED!" K ANS Q
 B 0 D CHGINST,ADDLOC,XCHGLOC,CHGPKG
 W !,"AUXINST has completed its tasks.",!,"You may delete the ^DICBKUP and ^AUTTBKUP global at your pleasure!" B 1
 Q
CHGINST ; CHANGE ENTRY NUMBERS BY 10000 IN ^DIC(4,
 D BKUPINST
 W !,"Beginning to change ^DIC(4,EN, to ^TEMPINST(4,EN+10000,",!,"..PLEASE WAIT!"
 S ^TEMPINST(4,0)=^DIC(4,0)
 S EN="" F L=0:0 S EN=$O(^DIC(4,EN)) Q:EN'=+EN  S FROM="^DIC(4,"_EN_",",TO="^TEMPINST(4,"_(EN+10000)_"," D AUXGLOB
 W " <DONE>",!,"Removing the ^DIC(4) global nodes!!" K ^DIC(4)
 W " <DONE>",!,"Beginning to change ^TEMPINST(4, back to ^DIC(4,",!,"..PLEASE WAIT!"
 S ^DIC(4,0)=^TEMPINST(4,0)
 S EN=9999 F L=0:0 S EN=$O(^TEMPINST(4,EN)) Q:EN'=+EN  S FROM="^TEMPINST(4,"_EN_"," S:EN=10000 EN=0 S TO="^DIC(4,"_EN_"," D AUXGLOB S:EN=0 EN=10000
 W " <DONE>" K EN,L,^TEMPINST
 Q
ADDLOC ; ADD IHS LOCATION NAMES TO VA INSTITUTION FILE
 W !,"The ^DIC(4, global node has been altered!!",!,"Copying IHS Location names (^AUTTLOC) to VA Institution global (^DIC(4,",!,"..PLEASE WAIT!"
 S EN=0 F L=0:0 S EN=$O(^AUTTLOC(EN)) Q:EN'=+EN  S ^DIC(4,EN,0)=$P(^AUTTLOC(EN,0),"^",1)
 W " <DONE>"
 Q
XCHGLOC ; EXCHANGE LOCATION NAMES WITH ENTRY NUMBERS IN ^AUTTLOC
 D BKUPLOC
 W !,"Beginning to exchange the Location names with their entry numbers in ^AUTTLOC global.",!,"..PLEASE WAIT"
 S X=0
 F L=0:0 S X=$O(^AUTTLOC(X)) Q:'+X  S $P(^(X,0),"^",1)=X
 W " <DONE>" K X,L
 Q
CHGPKG ; CHANGE INSTITUTION DATA IN ^DIC(9.4) PACKAGE FILE
 D BKUPPKG
 W !,"Beginning to change ^DIC(9.4 Alpha, Beta and Delta data values by 10000",!,"..PLEASE WAIT!"
 S EN=0 F L=0:0 S EN=$O(^DIC(9.4,EN)) Q:'+EN  D:$D(^(EN,9)) AB D:$D(^(10,0)) D
 D D1 W " <DONE>" K EN,MV,X,FROM,TO,L,F,T,C,P,NF,NT,LX,F1,TF,TT,^DMV
 Q
AB ; CHANGE ALPHA/BETA VALUES
 S:$P(^DIC(9.4,EN,9),"^",1)>0 $P(^DIC(9.4,EN,9),"^",1)=$P(^DIC(9.4,EN,9),"^",1)+10000 S:$P(^DIC(9.4,EN,9),"^",2)>0 $P(^DIC(9.4,EN,9),"^",2)=$P(^DIC(9.4,EN,9),"^",2)+10000
 Q
D ; CHANGE ANY VALUES IN THE DELTA FIELDS
 S:$P(^DIC(9.4,EN,10,0),"^",3)>0 $P(^DIC(9.4,EN,10,0),"^",3)=$P(^DIC(9.4,EN,10,0),"^",3)+10000
 S MV=0 F L=0:0 S MV=$O(^DIC(9.4,EN,10,MV)) Q:'+MV  D:$D(^DIC(9.4,EN,10,MV,0)) DMV
 Q
DMV ; CHANGE DELTA MULTI-VALUE FIELDS
 S:^DIC(9.4,EN,10,MV,0)>0 ^DMV(9.4,EN,10,MV+10000,0)=^DIC(9.4,EN,10,MV,0)+10000 K ^DIC(9.4,EN,10,MV,0)
 Q
D1 ; RESTORE ^DMV(9.4) AS ^DIC(9.4,EN,10,MV+10000,0) ENTRY
 S X=0 F L=0:0 S X=$O(^DMV(X)) Q:X'=+X!(X>9.4)  S FROM="^DMV(9.4,",TO="^DIC(9.4," D AUXGLOB
 Q
AUXGLOB ; 
 S F="F",T="T",C=",",P=")",NF=$L(FROM,C)-1,NT=$L(TO,C)-1,LX=1,F1=""
 S TF=FROM F L1=1:1:30 S TF=TF_F_L1_C
 S TT=TO F L1=1:1:30 S TT=TT_F_L1_C
EXTR S X=F_LX,Y=$P(TF,C,1,LX+NF)_P,@X=$O(@Y)
 I @X'="" D:$D(@(Y))#2 SUB S LX=LX+1,@(F_LX)="" G EXTR
 S LX=LX-1 Q:LX=0  G EXTR
SUB S Z=$P(TT,C,1,LX+NT)_P,@Z=@Y
 Q
BKUPINST ; SAVE ^DIC(4) FOR BACKUP
 W !,"Saving ^DIC(4) as ^DICBKUP(4) for backup.",!,"..PLEASE WAIT!"
 S X=3.9999 F L=0:0 S X=$O(^DIC(X)) Q:X'=+X!(X>4)  S FROM="^DIC(4,",TO="^DICBKUP(4," D AUXGLOB
 W " <DONE>" K X,L,FROM,TO,F,T,C,P,NF,NT,LX,F1,TF,TT
 Q
BKUPPKG ; SAVE ^DIC(9.4) FOR BACKUP
 W !,"Saving ^DIC(9.4) as ^DICBKUP(9.4) for backup.",!,"..PLEASE WAIT!"
 S X=9.3999 F L=0:0 S X=$O(^DIC(X)) Q:X'=+X!(X>9.4)  S FROM="^DIC(9.4,",TO="^DICBKUP(9.4," D AUXGLOB
 W " <DONE>" K X,L,FROM,TO,F,T,C,P,NF,NT,LX,F1,TF,TT
 Q
BKUPLOC ; SAVE ^AUTTLOC FOR BACKUP
 W !,"Saving ^AUTTLOC, as ^AUTTBKUP for backup.",!,"..PLEASE WAIT!"
 S X="" F L=0:0 S X=$O(^AUTTLOC(X)) Q:X'?1N.N  S FROM="^AUTTLOC(",TO="^AUTTBKUP(" D AUXGLOB
 W " <DONE>" K X,L,FROM,TO,F,T,C,P,NF,NT,LX,F1,TF,TT
 Q
