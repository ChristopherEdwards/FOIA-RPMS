BDMDMAS ; IHS/CMI/LAB - print hs for dm patients with appts ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**2**;JUN 14, 2007
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
 S BDMDATE=""
 S DIR(0)="D^::EF",DIR("A")="Enter the Appointment Date" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !,"Goodbye" D EOJ Q
 S BDMDATE=Y
REGISTER ;get register name
 S BDMREG=""
 S DIC="^ACM(41.1,",DIC(0)="AEMQ",DIC("A")="Enter the Official Diabetes Register: " D ^DIC
 I Y=-1 S BDMREG="" W !,"No Register Selected." G DATE
 S BDMREG=+Y
HSTYPE ;get hs type
 K DIC S DIC=9001015,DIC("A")="Select health summary type: ",DIC(0)="AEQM"
 S X="" I DUZ(2),$D(^APCCCTRL(DUZ(2),0))#2 S X=$P(^(0),U,3)
 I $D(^DISV(DUZ,"^APCHSCTL(")) S Y=^("^APCHSCTL(") I $D(^APCHSCTL(Y,0)) S X=$P(^(0),U,1)
 S:X="" X="ADULT REGULAR"
 S DIC("B")=X
 D ^DIC I Y>0 S BDMTYPE=+Y
ZIS ;
DEMO ;
 D DEMOCHK^BDMUTL(.BDMDEMO)
 I BDMDEMO=-1 G HSTYPE
 S XBRP="PRINT^BDMDMAS",XBRC="",XBRX="EOJ^BDMDMAS",XBNS="APCH;BDM"
 D ^XBDBQUE
 Q
EOJ ;
 D ^XBFMK
 K DIC,DIR
 K APCHSTYP,BDMREG,BDMDATE,BDMTYPE
 D EN^XBVK("APCH")
 Q
 ;
PRINT ;EP - called from xbdbque
 K ^TMP($J,"BDMDMAS")
 S BDMSDAT=$$FMADD^XLFDT(BDMDATE,-1),BDMSDAT=BDMSDAT_".9999"
 ;go through register, if patient has appt then print hs
 S BDMDMX=0 F  S BDMDMX=$O(^ACM(41,"B",BDMREG,BDMDMX)) Q:BDMDMX'=+BDMDMX  D
 .;check to see if patient has an appt
 .S DFN=$P(^ACM(41,BDMDMX,0),U,2)
 .Q:$$DEMO^BDMUTL(DFN,$G(BDMDEMO))
 .Q:$D(^TMP($J,"BDMDMAS",DFN))  ;already printed one for this pat
 .S ^TMP($J,"BDMDMAS",DFN)=""
 .S BDMDMY=BDMSDAT F  S BDMDMY=$O(^DPT(DFN,"S",BDMDMY)) Q:BDMDMY=""!($P(BDMDMY,".")>BDMDATE)  D
 ..I $P(^DPT(DFN,"S",BDMDMY,0),U,2)["C" Q  ;cancelled
 ..S APCHSPAT=DFN,APCHSTYP=BDMTYPE D EN^APCHS
 ..Q
 .Q
 Q
QUEUE ;EP - called from queued option
 S BDMREG=$O(^ACM(41.1,"B","IHS DIABETES",0))
 I BDMREG="" K BDMREG Q
 S BDMTYPE=$O(^APCHSTYP("B","ADULT REGULAR",0))
 I BDMTYPE="" K BDMREG,BDMTYPE Q
 S BDMDATE=DT
 D PRINT
 D EOJ
 Q
 ;
BDMG(BDMREG,BDMDATE,BDMTYPE,BDMGIEN) ;EP - GUI DMS Entry Point
 ;cmi/anch/maw added 10/19/2004
 S BDMTYPE=$O(^APCHSCTL("B",BDMTYPE,0))
 ;create entry in fileman file to hold output
 N BDMOPT  ;maw
 S BDMOPT="Print Health Summary for DM Patients w/Appt"
 D NOW^%DTC
 S BDMNOW=$G(%)
 K DD,D0,DIC
 S BDMJOB=$J,BDMBTH=$P($H,",")
 S X=BDMJOB_"."_BDMBTH
 S DIC("DR")=".02////"_DUZ_";.03////"_BDMNOW_";.05////"_$G(BDMPREP)_";.06///"_$G(BDMOPT)_";.07///R"
 S DIC="^BDMGUI(",DIC(0)="L",DIADD=1,DLAYGO=9003201.4
 D FILE^DICN
 K DIADD,DLAYGO,DIC,DA
 I Y=-1 S BDMIEN=-1 Q
 S BDMIEN=+Y
 S BDMGIEN=BDMIEN  ;cmi/maw added
 D ^XBFMK
 K ZTSAVE S ZTSAVE("*")=""
 ;D GUIEP for interactive testing
 S ZTIO="",ZTDTH=$$NOW^XLFDT,ZTRTN="GUIEP^BDMDMAS",ZTDESC="GUI PRINT HS FOR DM" D ^%ZTLOAD
 D EOJ
 Q
GUIEP ;EP - called from taskman
 K ^TMP($J,"BDMDMAS")
 S IOM=80  ;cmi/maw added
 D GUIR^XBLM("PRINT^BDMDMAS","^TMP($J,""BDMDMAS"",")
 S X=0,C=0 F  S X=$O(^TMP($J,"BDMDMAS",X)) Q:X'=+X  S ^BDMGUI(BDMIEN,11,X,0)=^TMP($J,"BDMDMAS",X),C=C+1
 S ^BDMGUI(BDMIEN,11,0)="^^"_C_"^"_C_"^"_DT_"^"
 S DA=BDMIEN,DIK="^BDMGUI(" D IX1^DIK
 D ENDLOG
 S ZTREQ="@"
 Q
 ;
ENDLOG ;-- write the end of the log
 D NOW^%DTC
 S BDMNOW=$G(%)
 S DIE="^BDMGUI(",DA=BDMIEN,DR=".04////"_BDMNOW_";.07///C"
 D ^DIE
 K DIE,DR,DA
 Q
 ;
