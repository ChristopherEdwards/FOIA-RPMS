AMHEHR1 ; IHS/CMI/LAB - ADD NEW MHSS ACTIVITY RECORDS 13 Aug 2007 4:21 PM ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
EEPC ;EP - called from option
 W !!,"This option is used to loop through all MHSS PROBLEM/DSM IV table "
 W !,"entries created by EHR users to change the grouping from the "
 W !,"generic 99.9 OTHER EHR CLINICAL grouping to a more specific"
 W !,"MHSS PROBLEM CODE grouping.",!!
 S AMHEPC=$O(^AMHPROBC("B","99.9",0))
 S AMHQ=0
 I 'AMHEPC W !!,"Problem code 99.9 is not in the file.",! D EXIT Q
 I '$O(^AMHPROB("AC",AMHEPC,0)) W !!,"There are no newly created entries in the MHSS Problem/DSM IV table.",!,"No action is needed at this time.",!! D PAUSE^AMHLEA,EXIT Q
 S AMHX=0 F  S AMHX=$O(^AMHPROB("AC",AMHEPC,AMHX)) Q:AMHX'=+AMHX!(AMHQ)  D
 .W !!,"CODE: ",$$VAL^XBDIQ1(9002012.2,AMHX,.01)
 .W !,"ICD Narrative: ",$$VAL^XBDIQ1(9002012.2,AMHX,.02)
 .S AMHPCG="" K DIC S DIC="^AMHPROBC(",DIC(0)="AEMQ",DIC("S")="I '$P(^(0),U,4)",DIC("A")="Enter the Problem Code Grouping: "
 .D ^DIC
 .I X="^" S AMHQ=1 Q
 .I Y=-1 W !,"nothing changed for CODE: ",$$VAL^XBDIQ1(9002012.2,AMHX,.01) K DIC,Y Q
 .S AMHPCG=+Y
 .K DIR,DIC
 .W !,"Are you sure you want to change the MHSS Problem Code Grouping to"
 .S DIR("A")="     "_$$VAL^XBDIQ1(9002012.4,AMHPCG,.01)_"  -  "_$$VAL^XBDIQ1(9002012.4,AMHPCG,.02)
 .S DIR(0)="Y",DIR("B")="N" KILL DA D ^DIR KILL DIR
 .I 'Y W !,"nothing changed for CODE: ",$$VAL^XBDIQ1(9002012.2,AMHX,.01) K DIC,Y Q
 .S DA=AMHX,DIE="^AMHPROB(",DR=".03////"_AMHPCG D ^DIE K DA,DIE,DR,DIU,DIV,DIW
 .Q
 Q
 ;
EXIT ;
 D EN^XBVK("AMH")
 Q
 ;
EHRALERT ;EP - called from option/scheduled
 ;find all visits entered that day or day before and send alert if there is no activity time
 ;go through all BH/EHR visits added/edited in the past 2 days and send bulletin if one
 ;has never been sent before
 NEW AMHD,AMHR,AMHP,%
 S AMHD=$$FMADD^XLFDT(DT,-3)_".9999"
 F  S AMHD=$O(^AMHREC("ALM",AMHD)) Q:AMHD'=+AMHD  D
 .S AMHR=0 F  S AMHR=$O(^AMHREC("ALM",AMHD,AMHR)) Q:AMHR'=+AMHR  D
 ..Q:$P($G(^AMHREC(AMHR,11)),U,10)'=1  ;NOT CREATED BY EHR
 ..Q:$P(^AMHREC(AMHR,0),U,12)  ;HAS ANY ACTIVITY TIME
 ..S AMHP=$$PPINT^AMHUTIL(AMHR)
 ..I AMHP=""  S %=$O(^AMHREC("AD",AMHR,0)) I % S AMHP=$P($G(^AMHRPROV(%,0)),U,1)
 ..Q:AMHP=""
 ..;send alert to user only if one never sent
 ..S (G,X)=0 F  S X=$O(^AMHREC(AMHR,97,X)) Q:X'=+X!(G)  D
 ...Q:$P(^AMHREC(AMHR,97,X,0),U,2)'=AMHP
 ...S G=1
 ..Q:G  ;already got an alert for this visit
 ..;S XQA(DUZ)=""
 ..S XQA(AMHP)=""
 ..S XQAOPT=""
 ..S XQAROU=""
 ..S XQAFLG="D"
 ..S AMHTEXT(1)=" "
 ..S AMHTEXT(2)=" "
 ..S AMHTEXT(3)="This Behavioral Health visit is missing an activity time.  The activity"
 ..S AMHTEXT(4)="time can be entered through EHR or with PCC data entry using the AT"
 ..S AMHTEXT(5)="mnemonic."
 ..S XQATEXT="AMHTEXT"
 ..S XQAMSG="HRN: "_$$HRN^AUPNPAT($P(^AMHREC(AMHR,0),U,8),DUZ(2))_"  Date: "_$$VAL^XBDIQ1(9002011,AMHR,.01)_" is missing an activity time."
 ..S XQAID="OR,"_$P(^AMHREC(AMHR,0),U,8)_",46"
 ..D SETUP^XQALERT
 ..S (G,X)=0 F  S X=$O(^AMHREC(AMHR,97,X)) Q:X'=+X  S G=X
 ..S G=G+1
 ..S ^AMHREC(AMHR,97,G,0)=DT_"^"_AMHP,^AMHREC(AMHR,97,"B",DT,G)=""
 ..S ^AMHREC(AMHR,97,0)="^9002011.97DA^"_G_"^"_G
 Q
TIUDSP ;EP
 S AMHSTR="" D S(AMHSTR)
 I '+$$CANDO^TIULP(AMHDOC,"PRINT RECORD",DUZ) Q  ;S AMHSTR="You do not have security clearance to display the TIU NOTE." D S(AMHSTR) Q
 ; Extract specified note
 S AMHGBL=$NA(^TMP("AMHOENPS",$J)),AMHHLF=IOM\2
 K @AMHGBL
 D EXTRACT^TIULQ(AMHDOC,AMHGBL,.AMHERR,".01;.02;.03;.05;.07;.08;1202;1203;1205;1208;1209;1301;1307;1402;1501:1505;1507:1513;1701","",1,"E")
 M AMHTIU=^TMP("AMHOENPS",$J,AMHDOC)
 K ^TMP("AMHOENPS",$J)
 S AMHSTR="TIU DOCUMENT:  "_AMHTIU(.01,"E") D S(AMHSTR)
 S AMHSTR="AUTHOR: "_AMHTIU(1202,"E") D S(AMHSTR)
 S AMHSTR="SIGNED BY: "_AMHTIU(1502,"E")_"               STATUS: "_AMHTIU(.05,"E") D S(AMHSTR)
 S AMHSTR="LOCATION: "_AMHTIU(1205,"E") D S(AMHSTR)
 F AMHX=0:0 S AMHX=$O(AMHTIU("TEXT",AMHX)) Q:'AMHX  S AMHSTR=AMHTIU("TEXT",AMHX,0) D S(AMHSTR)
 I $L($G(AMHTIU(1501,"E"))) D
 .S AMHSTR="/es/ "_$G(AMHTIU(1503,"E")) D S(AMHSTR)
 .S AMHSTR="Signed: "_$G(AMHTIU(1501,"E")) D S(AMHSTR)
 ;NOW GET ADDENDA USING "DAD" XREF
 I $O(^TIU(8925,"DAD",AMHDOC,0)) S AMHSTR="" D S(AMHSTR)   ;S AMHSTR="This document has addenda." D S(AMHSTR)
 S AMHX1=0 F  S AMHX1=$O(^TIU(8925,"DAD",AMHDOC,AMHX1)) Q:AMHX1'=+AMHX1  D
 .I '+$$CANDO^TIULP(AMHX1,"PRINT RECORD",DUZ) Q  ;S AMHSTR="You do not have security clearance to display the addendum." D S(AMHSTR) Q
 .S AMHGBL=$NA(^TMP("AMHOENPS",$J))
 .K @AMHGBL
 .K AMHTIU
 .D EXTRACT^TIULQ(AMHX1,AMHGBL,.AMHERR,".01;.02;.03;.05;.07;.08;1202;1203;1205;1208;1209;1301;1307;1402;1501:1505;1507:1513;1701","",1,"E")
 .M AMHTIU=^TMP("AMHOENPS",$J,AMHX1)
 .K ^TMP("AMHOENPS",$J)
 .S AMHSTR="" D S(AMHSTR)
 .S AMHSTR=AMHTIU(.01,"E") D S(AMHSTR)
 .S AMHSTR="AUTHOR: "_AMHTIU(1202,"E") D S(AMHSTR)
 .S AMHSTR="SIGNED BY: "_AMHTIU(1502,"E")_"               STATUS: "_AMHTIU(.05,"E") D S(AMHSTR)
 .S AMHSTR="LOCATION: "_AMHTIU(1205,"E") D S(AMHSTR)
 .F AMHX=0:0 S AMHX=$O(AMHTIU("TEXT",AMHX)) Q:'AMHX  S AMHSTR=AMHTIU("TEXT",AMHX,0) D S(AMHSTR)
 .I $L($G(AMHTIU(1501,"E"))) D
 ..S AMHSTR="/es/ "_$G(AMHTIU(1503,"E")) D S(AMHSTR)
 ..S AMHSTR="Signed: "_$G(AMHTIU(1501,"E")) D S(AMHSTR)
 ;
 Q
 ;
S(Y,F,C,T) ;EP - set up array
 I '$G(F) S F=0
 I '$G(T) S T=0
 ;blank lines
 F F=1:1:F S X="" D S1
 S X=Y
 I $G(C) S L=$L(Y),T=(80-L)/2 D  D S1 Q
 .F %=1:1:(T-1) S X=" "_X
 F %=1:1:T S X=" "_Y
 D S1
 Q
S1 ;
 S AMHC=AMHC+1
 S AMHTIUD(AMHC,0)=X
 Q
