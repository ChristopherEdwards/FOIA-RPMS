ABMDBACK ; IHS/ASDST/DMJ - APC-PCC Back Visit Check ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;08/05/96 4:25 PM
 ;
 S U="^" K ABM
PCC S (ABM("BD"),ABM("D"))=$P(^ABMDPARM(DUZ(2),1,0),U,19)-.01 F  S ABM("D")=$O(^AUPNVSIT("B",ABM("D"))) Q:'ABM("D")  D
 .S ABM("VDFN")="" F  S ABM("VDFN")=$O(^AUPNVSIT("B",ABM("D"),ABM("VDFN"))) Q:'ABM("VDFN")  D
 ..I ABM("D")>ABM("BD"),'$D(^ABMDCLM(DUZ(2),"AV",ABM("VDFN"))) S ^AUPNVSIT("ABILL",$P(ABM("D"),"."),ABM("VDFN"))=""
 ;
APC S ABM("D")=$P(^ABMDPARM(DUZ(2),1,0),U,19) S ABM="^AAPCRCDS(""APC"","_ABM("D")_")" F  S ABM=$Q(@ABM),ABM("DT")=$P($P(ABM,"(",2),",",2) Q:ABM("DT")<ABM("D")  I ABM("DT")>ABM("BD") D
 .S ABM("VDFN")=+$P($P(ABM,"(",2),",",5)
 .Q:$D(^ABMDCLM(DUZ(2),"APC",ABM("VDFN")))
 .S ^AAPCRCDS("ABILL",ABM("DT"),ABM("VDFN"))=""
 ;
DEL S DIE="^ABMDPARM(DUZ(2),",DA=1,DR=".19///@" D ^ABMDDIE
 ;
XIT K ABM
 Q
 ;
SEL ;EP - Entry Point for intiating a back-billing check
 W !!?5,"This program will cause the nightly claim generator to initiate "
 W !?5,"a one time job of checking all visits back to the date specified."
 W !! S DIR(0)="YO",DIR("A")="Do you wish to run this program (Y/N)" D ^DIR K DIR G XIT:$D(DIRUT)!'$G(Y)
 I +$P($G(^ABMDPARM(DUZ(2),1,0)),U,16) S X1=DT,X2=0-($P(^(0),U,16)*30.417) D C^%DTC S ABM("D")=X I 1
 E  S ABM("D")=DT-10000
 D DT
 W ! S DIE="^ABMDPARM(DUZ(2),",DA=1,DR=".19Check all Visits back to (Date): //"_ABM("D") D ^ABMDDIE G XIT:$D(Y)!$D(ABM("DIE-FAIL"))
 S ABM("D")=$P(^ABMDPARM(DUZ(2),1,0),U,19) D DT
 W !!,"OK, all visits will be checked back to ",ABM("D")," during the nightly",!,"claim generation process.",!
 K DIR S DIR(0)="E" D ^DIR
 G XIT
 ;
DT ;date external
 S ABM("D")=$$HDT^ABMDUTL(ABM("D"))
 Q
