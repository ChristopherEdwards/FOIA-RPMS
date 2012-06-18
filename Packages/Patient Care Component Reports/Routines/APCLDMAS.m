APCLDMAS ; IHS/CMI/LAB - print hs for dm patients with appts ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
 ;this routine will go through the Diabetes Register
 ;and then see if the patient has an appt, if so print health sum
 ;
 ;cmi/anch/maw 3/14/2006 modified BDMG to queue report into GUI holding file
 ;
EP ;EP - called from option interactive
 D EOJ
 W:$D(IOF) @IOF
 W !!,"This option will print a health summary for all patients who are on the ",!,"Diabetes Register that have an appointment on the date you specify.",!!
DATE ;get appt date
 S APCLDATE=""
 S DIR(0)="D^::EF",DIR("A")="Enter the Appointment Date" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !,"Goodbye" D EOJ Q
 S APCLDATE=Y
REGISTER ;get register name
 S APCLREG=""
 S DIC="^ACM(41.1,",DIC(0)="AEMQ",DIC("A")="Enter the Official Diabetes Register: " D ^DIC
 I Y=-1 S APCLREG="" W !,"No Register Selected." G DATE
 S APCLREG=+Y
HSTYPE ;get hs type
 K DIC S DIC=9001015,DIC("A")="Select health summary type: ",DIC(0)="AEQM"
 S X="" I DUZ(2),$D(^APCCCTRL(DUZ(2),0))#2 S X=$P(^(0),U,3)
 I $D(^DISV(DUZ,"^APCHSCTL(")) S Y=^("^APCHSCTL(") I $D(^APCHSCTL(Y,0)) S X=$P(^(0),U,1)
 S:X="" X="ADULT REGULAR"
 S DIC("B")=X
 D ^DIC I Y>0 S APCLTYPE=+Y
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G HSTYPE
 S XBRP="PRINT^APCLDMAS",XBRC="",XBRX="EOJ^APCLDMAS",XBNS="APCH;APCL"
 D ^XBDBQUE
 Q
EOJ ;
 D ^XBFMK
 K DIC,DIR
 K APCHSTYP,APCLREG,APCLDATE,APCLTYPE
 D EN^XBVK("APCH")
 Q
 ;
PRINT ;EP - called from xbdbque
 K ^TMP($J,"APCLDMAS")
 S APCLSDAT=$$FMADD^XLFDT(APCLDATE,-1),APCLSDAT=APCLSDAT_".9999"
 ;go through register, if patient has appt then print hs
 S APCLDMX=0 F  S APCLDMX=$O(^ACM(41,"B",APCLREG,APCLDMX)) Q:APCLDMX'=+APCLDMX  D
 .;check to see if patient has an appt
 .S DFN=$P(^ACM(41,APCLDMX,0),U,2)
 .Q:$$DEMO^APCLUTL(DFN,$G(APCLDEMO))
 .Q:$D(^TMP($J,"APCLDMAS",DFN))  ;already printed one for this pat
 .S ^TMP($J,"APCLDMAS",DFN)=""
 .S APCLDMY=APCLSDAT F  S APCLDMY=$O(^DPT(DFN,"S",APCLDMY)) Q:APCLDMY=""!($P(APCLDMY,".")>APCLDATE)  D
 ..I $P(^DPT(DFN,"S",APCLDMY,0),U,2)["C" Q  ;cancelled
 ..S APCHSPAT=DFN,APCHSTYP=APCLTYPE D EN^APCHS
 ..Q
 .Q
 Q
QUEUE ;EP - called from queued option
 S APCLREG=$O(^ACM(41.1,"B","IHS DIABETES",0))
 I APCLREG="" K APCLREG Q
 S APCLTYPE=$O(^APCHSTYP("B","ADULT REGULAR",0))
 I APCLTYPE="" K APCLREG,APCLTYPE Q
 S APCLDATE=DT
 D PRINT
 D EOJ
 Q
 ;
BDMG(APCLREG,APCLDATE,APCLTYPE,BDMGIEN) ;EP - GUI DMS Entry Point
 ;cmi/anch/maw added 10/19/2004
 S APCLTYPE=$O(^APCHSCTL("B",APCLTYPE,0))
 ;create entry in fileman file to hold output
 N APCLOPT  ;maw
 S APCLOPT="Print Health Summary for DM Patients w/Appt"
 D NOW^%DTC
 S APCLNOW=$G(%)
 K DD,D0,DIC
 S APCLJOB=$J,APCLBTH=$P($H,",")
 S X=APCLJOB_"."_APCLBTH
 S DIC("DR")=".02////"_DUZ_";.03////"_APCLNOW_";.05////"_$G(APCLPREP)_";.06///"_$G(APCLOPT)_";.07///R"
 S DIC="^APCLGUIR(",DIC(0)="L",DIADD=1,DLAYGO=9001004.4
 D FILE^DICN
 K DIADD,DLAYGO,DIC,DA
 I Y=-1 S APCLIEN=-1 Q
 S APCLIEN=+Y
 S BDMGIEN=APCLIEN  ;cmi/maw added
 D ^XBFMK
 K ZTSAVE S ZTSAVE("*")=""
 ;D GUIEP for interactive testing
 S ZTIO="",ZTDTH=$$NOW^XLFDT,ZTRTN="GUIEP^APCLDMAS",ZTDESC="GUI PRINT HS FOR DM" D ^%ZTLOAD
 D EOJ
 Q
GUIEP ;EP - called from taskman
 K ^TMP($J,"APCLDMAS")
 S IOM=80  ;cmi/maw added
 D GUIR^XBLM("PRINT^APCLDMAS","^TMP($J,""APCLDMAS"",")
 S X=0,C=0 F  S X=$O(^TMP($J,"APCLDMAS",X)) Q:X'=+X  S ^APCLGUIR(APCLIEN,11,X,0)=^TMP($J,"APCLDMAS",X),C=C+1
 S ^APCLGUIR(APCLIEN,11,0)="^^"_C_"^"_C_"^"_DT_"^"
 S DA=APCLIEN,DIK="^APCLGUIR(" D IX1^DIK
 D ENDLOG
 S ZTREQ="@"
 Q
 ;
ENDLOG ;-- write the end of the log
 D NOW^%DTC
 S APCLNOW=$G(%)
 S DIE="^APCLGUIR(",DA=APCLIEN,DR=".04////"_APCLNOW_";.07///C"
 D ^DIE
 K DIE,DR,DA
 Q
 ;
