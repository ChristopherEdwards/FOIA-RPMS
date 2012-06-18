ASU0PURG ; IHS/ITSC/LMH -DELETE TRANS - RANGE OF DATES ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine is invoked by the yearly closeout update (at entry point
 ;EN2) to purge all history transaction record older than 3 years.
 ;Although it may also be invoked from the top, no Kernel option is
 ;provided to do this since it could easly be mis-used - for example all
 ;transactions except for the current year could be accidently
 ;deleted if a range of 'First allowed date' to 'Last allowed date' were
 ;selected.
 D DATE^ASUUDATE,TIME^ASUUDATE
 S:'$D(DTIME) DTIME=$$DTIME^XUP(DUZ)
 D CLS^ASUUHDG
 W !!,"Warning -if you continue, You will be asked for a range of 'PROCESS DATES' and",!,"Transactions of all types which were PROCESSED BETWEEN THOSE DATES will be DELETED!!"
 K DIR
 S DIR("A")="Are you SURE you wish to CONTINUE",DIR(0)=Y,DIR("B")="N"
 D ^DIR K DIR
 I 'Y Q
 W !!,"Beginning date may not be before three years ago",!
 S %DT="APE",%DT("A")="Enter Beginning Date : ",%DT(0)=ASUK("DT","FM")-30000 D ^%DT
 Q:Y<0  S ASUU("BEGIN")=$P(Y,".") D DD^%DT S ASUU("1ST")=Y K Y
 W !!,"Ending date may not be after one year ago",!
 S %DT("A")="Enter Ending Date : ",%DT(0)=(ASUK("DT","FM")-10000)*-1 D ^%DT
 Q:Y<0  S ASUU("END")=$P(Y,".") D DD^%DT S ASUU("LAST")=Y K Y,%DT
DOIT ;
 S ASUU("AC")="AC",(ASUC("DEL"),ASUC("KEPT"))=0
 S DIK="^ASUH("
 S ASUU("NXDT")=DIK_"ASUU(""AC""),ASUU(""DT"")"
 S ASUU("NXTRN")=ASUU("NXDT")_",DA)"
 S ASUU("NXDT")=ASUU("NXDT")_")"
 X "S ASUU(""E#"")=$P("_DIK_"0),U)"
 S ASUU("DT")=0,(ASUA("DELT",ASUU("E#")),ASUA("KEPT",ASUU("E#")))=0
 S ASURX="W !,""Now Processing History Transaction File""" D ^ASUUPLOG
 F ASUC("TR")=1:1 S ASUU("DT")=$O(@ASUU("NXDT")) Q:ASUU("DT")'?1N.N  D
 .I ASUU("DT")=""!(ASUU("DT")<ASUU("BEGIN"))!(ASUU("DT")>ASUU("END")) D
 ..I '$D(ASUA("PROC",ASUU("DT"))) S ASUA("PROC",ASUU("DT"))="",ASUC("KEPT")=ASUC("KEPT")+1
 ..S ASUA("KEPT",ASUU("E#"))=ASUA("KEPT",ASUU("E#"))+1
 .E  D
 ..S DA=0
 ..F ASUC("TR")=1:1 S DA=$O(@ASUU("NXTRN")) Q:DA=""  D ^DIK
 ..S ASUA("DELT",ASUU("E#"))=ASUA("DELT",ASUU("E#"))+ASUC("TR")
 S ASUC("DEL")=ASUC("DEL")+ASUA("DELT",ASUU("E#"))
 S ASUU(2)=1 K ^XTMP("ASUR","R02")
 S ^XTMP("ASUR","R02",0)=ASUK("DT","FM")+10000_U_ASUK("DT","FM")
 S ASURX="W !,""Statistics for Transaction Purge for the Date Range"",!,""Beginning "_ASUU("1ST")_" Ending "_ASUU("LAST")_""",!!" D LOG
 S ASUU(1)=""
 F ASUC("TR")=1:1 S ASUU(1)=$O(ASUA("DELT",ASUU(1))) Q:ASUU(1)=""  D
 .S ASURX="W !,"""_ASUU(1)_" Records deleted "",?55,"_ASUA("DELT",ASUU(1)) D LOG
 S ASURX="W !,""Total records Deleted "",?55,"_ASUC("DEL")_",!" D LOG
 S ASUU(1)=""
 F ASUC("TR")=1:1 S ASUU(1)=$O(ASUA("KEPT",ASUU(1))) Q:ASUU(1)=""  D
 .S ASURX="W !,"""_ASUU(1)_" Days Processed Kept "",?55,"_ASUA("KEPT",ASUU(1)) D LOG
 S ASURX="W !,""Total Processed Days Kept"",?55,"_ASUC("KEPT") D LOG
 K ASUU,ASUC("TR"),ASUC,ASULA
 I $G(ASUP("TYP"))="" D
 .S DIR(0)="E" D ^DIR
 Q
EN2 ;EP; FROM YEARLY UPDATE
 I '$D(ASUK("DT","FM")) D DATE^ASUUDATE,TIME^ASUUDATE
 S ASUU("BEGIN")=1,ASUU("1ST")="FIRST DATE",ASUU("END")=$E(ASUK("DT","FM"),1,3)-3_1001,Y=ASUU("END") D DD^%DT S ASUU("LAST")=Y
 G DOIT
LOG ;
 S ^XTMP("ASUR","R02",ASUU(2))=ASURX,ASUU(2)=ASUU(2)+1
 I $G(ASUP("TYP"))="" X ASURX
 Q
