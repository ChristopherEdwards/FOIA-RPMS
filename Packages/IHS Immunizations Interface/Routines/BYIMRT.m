BYIMRT ;IHS/CIM/THL - IMMUNIZATION DATA INTERCHANGE;
 ;;2.0;BYIM IMMUNIZATION DATA EXCHANGE INTERFACE;**3**;JAN 15, 2013;Build 79
 ;;CONTINUATION OF BYIMIMM
 ;
 ;REAL-TIME PROCESSING
 ;
 ;-----
RT ;EP;FOR REAL TIME QUERIES
 F  D RT1 Q:$D(BYIMQUIT)
 K BYIMQUIT
 Q
 ;-----
RT1 ;REAL TIME
 D PATH^BYIMIMM
 K BYIMQTX,BYIMQUIT
 S BYIMQTX=$S(BYIMQT=1:"VXQ",1:"QBP")
 K ^TMP($J,"BYIM RT")
 N RT
 W @IOF
 W !!?10,"Real-Time Query Options - Version: ",BYIMVER
 K DIR
 S DIR(0)="SO^1:Get  a Patient's Immunizations FROM State IIS;2:Send a Patient's Immunizations TO   State IIS;3:Review State IIS Responses;4:Check for Additional Response Messages"
 S DIR("A")="Select the action type"
 D ^DIR
 K DIR
 I 'Y S BYIMQUIT=1 Q
 S RT=$S(Y=1:"VXQ",Y=2:"VXU",Y=3:"RESP",Y=4:"RTIN",1:"")
 I RT="RESP" D RESP K BYIMQUIT Q
 I RT="RTIN" D  Q
 .W !!,"Checking for query responses that have not yet been processed."
 .W !!,"Please stand by..."
 .H 4
 .N BYIMRTIN
 .S BYIMRTIN=1
 .D RTIN
 .W !!,"Please check 'Review State IIS Responses' for new IIS responses."
 .D PAUSE^BYIMIMM
 .K BYIMQUIT
 D PAT
 Q:'$D(^TMP($J,"BYIM RT"))
 D SEND
 Q
 ;-----
PAT ;
 I RT="VXU" D ALL
 W !!,"Select patient(s) to send to the State Immunization Registry"
 F  D P1 Q:$D(BYIMQUIT)
 K BYIMQUIT
 Q
P1 ;SELECT MULTIPE PATIENTS
 K DIE,DIC,DINUM,DR,DA,DD,DO,DIK,DLAYGO
 S DIC=9000001
 S DIC("A")="Select "_$S($D(^TMP($J,"BYIM RT")):"another ",1:"")_"patient: "
 S DIC(0)="AEQM"
 W !
 D ^DIC
 K DIE,DIC,DINUM,DR,DA,DD,DO,DIK,DLAYGO
 I Y<1 S BYIMQUIT="" Q
 S ^TMP($J,"BYIM RT",+Y)=""
 D RTPAT
 Q
 ;-----
SEND ;SEND RT QUERY
 W !!,$S(RT="VXQ":"A 'Query for Vaccination Record ("_BYIMQTX_")'",1:"An 'Unsolicited Vaccine Record Update (VXU)'")," will be sent for:"
 D RTPAT
 K DIR
 S DIR(0)="YO"
 S DIR("A")="Do you want to proceed"
 S DIR("B")="YES"
 W !
 D ^DIR
 K DIR
 Q:Y'=1
 I '$D(ZTQUEUED)&$D(^TMP($J,"BYIM RT")) D
 .W !!,"Please stand by.  This may take a couple of seconds...",!
 S DFN=0
 F  S DFN=$O(^TMP($J,"BYIM RT",DFN)) Q:'DFN  D
 .D:RT="VXQ" VXQ(DFN)
 .D:RT="VXU" VXU(DFN)
 .K ^TMP($J,"BYIM RT",DFN)
 K ^TMP($J,"BYIM RT")
 D PAUSE^BYIMIMM
 Q
 ;-----
RTPAT ;DISPLAY PATIENTS FOR RT QUERY
 N DFN
 W !
 S DFN=0
 F  S DFN=$O(^TMP($J,"BYIM RT",DFN)) Q:'DFN  D
 .W !," *** ",$P(^DPT(DFN,0),U)," *** "
 Q
 ;-----
VXQ(DFN) ;EP;TO SEND VXQ MESSAGE
 W:'$D(ZTQUEUED) !,"Query being sent for: ",$P(^DPT(DFN,0),U)
 D DELAY
 S Y=$$VXQX(DFN)
 Q
DELAY Q:$D(ZTQUEUED)
 W "  "
 F J=1:1:3 W "." H 1
 Q
 ;-----
VXU(DFN) ;EP;TO SEND VXU MESSAGE
 N VST
 S VST=$O(^AUPNVSIT("AC",DFN,9999999999),-1)
 Q:'VST
 S Y=$$V04^BYIMIMM(VST)
 W:'$D(ZTQUEUED) !,"Immunization record being sent for: ",$P(^DPT(DFN,0),U)
 D DELAY
 S INHF=+Y
 Q:'INHF
 S BYIMUIF=$O(^INTHU("AT",INHF,0))
 Q:'BYIMUIF
 D LOGD^BYIMIMM4(DFN,"E")
 D RXR(BYIMUIF)
 S BYIMSTP="VXU"
 D SFILE(BYIMUIF,DFN,BYIMSTP)
 D CLEANVXU(BYIMUIF)
 Q
 ;-----
RSP ;EP;IMMUNIZATION DATA EXCHANGE
 S BHLDEST="D DEST^INHUSEN"
 S INDEST("RSPK11")="HL IHS IZV04 RSP IN"
 X BHLDEST
 Q
 ;-----
RESP ;EP;REVIEW RT RESPONSE FILES
 K BYIMQUIT
 F  D RESP1 Q:$D(BYIMQUIT)
 Q
 ;-----
RESP1 ;REVIEW RESPONSES
 K BYIMQUIT
 K ^TMP($J,"BYIM RT")
 N DFN,RT
 W @IOF
 W !!?10,"Review Responses from the State IIS"
 K DIR
 S DIR(0)="SO^1:Review Immunizations ready to add to RPMS;2:Review Query Response Messages"
 S DIR("A")="Select the action type"
 W !
 D ^DIR
 K DIR,BYIMQUIT
 I 'Y S BYIMQUIT=1 Q
 S RT=$S(Y=1:"START",1:"NON")
 I RT="START" D START Q
 F  D NON Q:$D(BYIMQUIT)
 K BYIMQUIT
 Q
 ;-----
START ;
 W @IOF
 W !!?10,"All NEW immunizations for Query Responses from the state"
 W !!?10,"that can be added to RPMS will be listed below."
 W !!
 S DIR("A")="Press <ENTER> to review immunizations, press '^' to exit"
 D PAUSE^BYIMIMM
 Q:'Y
 D START^BYIMIMM1
 Q
 ;-----
NON ;EP;TO REVIEW NON-IMMUNIZATION IIS RESPONSES
 W @IOF
 W !!?10,"Select Responses by Patient or Date"
 K DIE,DIC,DINUM,DR,DA,DD,DO,DIK,DLAYGO
 S DIC="^BYIMRT("
 S DIC(0)="AEMQ"
 S DIC("A")="Select Query Date or Patient: "
 S DIC("S")="I $P(^(0),U,2)=""E"""
 W !
 D ^DIC
 K DIE,DIC,DINUM,DR,DA,DD,DO,DIK,DLAYGO
 I Y<0 S BYIMQUIT=1 Q
 D DISP(+Y)
 Q
 ;-----
RTIMP(FILE) ;EP;TO AUTOMATICALLY IMPORT REAL-TIME MESSAGES
 K BYIMQUIT
 N AUTOIMP,AUTOADD,DIR
 S AUTOIMP=$P($G(^BYIMPARA(DUZ(2),0)),U,4)
 S AUTOADD=$P($G(^BYIMPARA(DUZ(2),0)),U,5)
 D PATH^BYIMIMM
 Q:IPATH=""
 S Y=$$OPEN^%ZISH(IPATH,FILE,"R")
 Q:Y
 N BYIMJ,BYIMX,UIF
 S UIF=""
 S BYIMJ=0
 F  U IO R BYIMX:DTIME D:BYIMX="" CLOSE^%ZISH() Q:BYIMX=""  D
 .I BYIMX["MSH|" D  Q:'UIF
 ..D NEWUIF
 .I BYIMX["MSH|" D NEWUIF Q:'UIF
 .S BYIMJ=BYIMJ+1
 .S ^INTHU(UIF,3,BYIMJ,0)=BYIMX_"|CR|"
 D LOG(UIF,"I",FILE)
 N BYIMXX
 S BYIMXX=0
 F  S BYIMXX=$O(^BYIMTMP($J,"BYIM IMM",BYIMXX)) Q:'BYIMXX  D
 .D SET1^BYIMIMM1(BYIMXX)
 Q
 ;-----
LOG(UIF,ACT,FILE) ;LOG RT FILE
 Q:'$G(UIF)
 S ^BYIMTMP($J,"BYIM IMM",UIF)=""
 N XX,DFN
 S DFN=$P(FILE,"_",2)
 S MID=""
 S XX=0
 S:MID'["IHS-" MID=""
 D RTLOG(FILE,ACT,IPATH,DFN,UIF,MID,0)
 Q
 ;-----
VXQX(BYIMPAT) ;PEP;send query request for patient IEN - BYIMPAT
 ;BYIMPAT - PATIENT DFN/IEN
 ;RETURNS GIS HL7 MESSAGE CREATION MESSAGE
 ;
 I '$G(BYIMPAT)!'$D(^DPT(+$G(BYIMPAT),0)) Q "No Patient identified for DFN "_$G(BYIMPAT)
 D PATH^BYIMIMM
 S BYIMQTX=$S(BYIMQT=1:"VXQ",1:"QBP")
 N BYIMDEST,INH,INDA,INA
 S INDA=BYIMPAT
 S INDA(2,1)=BYIMPAT
 S INDA(9000001,1)=BYIMPAT
 S INA("QNM",INDA)=""
 S BYIMDEST=$S(BYIMQT=1:"HL IHS IZV04 V01VXQ OUT PARENT",1:"HL IHS IZV04 QBP OUT PARENT")
 D ^INHF(BYIMDEST,.INDA,.INA)
 H 2
 I $G(INHF) D
 .S BYIMUIF=$O(^INTHU("AT",INHF,0))
 .Q:'BYIMUIF
 .S BYIMSTP=BYIMQTX
 .D SFILE(BYIMUIF,BYIMPAT,BYIMSTP)
 D EOJ^BYIMIMM
 Q $$MSG^BYIMIMM(INHF)
 ;-----
SFILE(BYIMUIF,BYIMPAT,BYIMSTP) ;EP;TO SEND RT FILE VIA HL7 BRIDGE
 ;BYIMUIF - THE IEN OF THE ^INTHU( ENTRY FOR THE MESSAGE
 ;BYIMPAT - THE IEN OF PATIENT
 ;BYIMSTP - MESSAGE TYPE FOR FILE NAME
 Q:'$G(BYIMUIF)!'$G(BYIMPAT)
 S BYIMSTP=$TR(BYIMSTP,"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz")
 S MID=""
 D PATH^BYIMIMM
 D NOW^%DTC
 S QFILE="izrt"_BYIMSTP_$TR(BYIMVER,".")_"_"_$E("000000",1,6-$L(BYIMPAT))_BYIMPAT_"_"_($P(%,".")+17000000)_"_"_$P(%,".",2)_$E("000000",1,6-$L($P(%,".",2)))_".dat"
 S ACT="W"
 D FILE(OPATH,QFILE,ACT,BYIMUIF,BYIMPAT,BYIMSTP)
 Q
FILE(PATH,FILE,ACT,BYIMUIF,BYIMPAT,BYIMSTP) ;SEND FILE
 ;OPATH   - PATH FOR TRANSMISSION
 ;FILE    - FILE NAME
 ;ACT     - ACTION
 ;BYIMUIF - IEN IN ^INTHU
 ;BYIMPAT - PATIENT DFN
 ;BYIMSTP - 
 S Y=$$OPEN^%ZISH(PATH,FILE,ACT)
 I Y D  Q
 .D EXPBULL^BYIMIMM4(FILE,0,PATH)
 .D RTLOG(FILE,"E",PATH,BYIMPAT,BYIMUIF,MID,1)
 N X,XX
 S X=""
 S XX=0
 F  S XX=$O(^INTHU(BYIMUIF,3,XX)) Q:'XX  S READ=^(XX,0) D
 .S X=X_$P(READ,"|CR|")
 .Q:READ'["|CR|"
 .S:X'["MSH|" X=$TR(X,"\")
 .S:X["MSH|" MID=$P(X,"|",10)
 .U IO W X,!
 .S X=""
 D CLOSE^%ZISH()
 D RTLOG(QFILE,"E",OPATH,BYIMPAT,BYIMUIF,MID,0)
 Q:BYIMBDG<1
 N BYIMRTIN
 S BYIMRTIN=0
 D RTIN
 Q
 ;-----
RTIN ;EP;CHECK REAL-TIME INBOUND FILES
 N DIR,FILE
 D PATH^BYIMIMM
 S DIR=$$LIST^%ZISH(IPATH,"izrt*",.DIR)
 N IN
 S IN=0
 F  S IN=$O(DIR(IN)) Q:'IN  S FILE=DIR(IN) D:FILE]""
 .Q:$D(^BYIMRT("ACT",FILE,"I"))
 .D RTIMP(FILE)
 .I $G(BYIMRTIN) W !,FILE," processed..."
 Q
 ;-----
RTDEST ;EP;CHECK DESTINATION GLOBAL FOR RT MESSAGES
 S BYIMDEST=$S(BYIMVER["2.3":"HL IHS IZV04 V01VXQ OUT PARENT",1:"HL IHS IZV04 QBP OUT PARENT")
 S BYIMDDA=$O(^INRHD("B",BYIMDEST,0))
 Q:'BYIMDDA
 N PRI
 S PRI=0
 F  S PRI=$O(^INLHDEST(BYIMDDA,PRI)) Q:'PRI  D
 .N BYIMDT
 .S BYIMDT=""
 .F  S BYIMDT=$O(^INLHDEST(BYIMDDA,PRI,BYIMDT)) Q:BYIMDT=""  D
 ..N BYIMUIF
 ..S BYIMUIF=0
 ..F  S BYIMUIF=$O(^INLHDEST(BYIMDDA,PRI,BYIMDT,BYIMUIF)) Q:'BYIMUIF  D
 ...Q:'$D(^INTHU(BYIMUIF,3))
 ...D UIF(BYIMUIF)
 Q
 ;-----
UIF(BYIMUIF) ;PROCESS UIF
 Q:'$G(BYIMUIF)
 Q:'$D(^INTHU(BYIMUIF,3))
 N XX
 S XX=$G(^INTHU(BYIMUIF,3,2))
 Q:XX=""
 N DFN,HRN,LOC,HRN,LOCDA,X,Y,Z
 S HRN=""
 S:XX["PID|" HRN=$P(XX,"|",4)
 S:XX["QRD|" HRN=$P($P(XX,"|",9),U)
 S:XX["QPD|" HRN=$P(XX,"|",3)
 S LOC=$E(HRN,1,6)
 S HRN=+$E(HRN,7,12)
 S LOCDA=$O(^AUTTLOC("C",LOC,0))
 Q:'LOCDA!'HRN
 S DFN=""
 S X=0
 F  S X=$O(^AUPNPAT("D",HRN,X)) Q:'X!DFN  I $D(^AUPNPAT("D",HRN,X,LOCDA)) S DFN=X
 Q:'DFN
 S BYIMSTP="IN"
 D SFILE(BYIMUIF,DFN,BYIMSTP)
 Q
 ;-----
RTLOG(FILE,ACT,PATH,DFN,UIF,MID,STAT) ;EP;
 ;LOG EXPORT/IMPORT FILES THAT HAVE BEEN PROCESSED
 ;FILE     = NAME OF FILE IMPORTED OR EXPORTED
 ;ACT      = ACTION - 'I'MPORT OR 'E'XPORT
 ;PATH     = DRIVE/DIRECTORY FILE SENT TO
 ;DFN      = DFN OF PATIENT FOR QUERY/RESPONSE
 ;UIF      = IEN OF THE UNIVERSAL MESSAGE ENTRY
 ;MID      = MESSAGE ID ASSIGNED FOR THE UNIVERSAL MESSAGE ENTRY
 ;STAT     = TRANSMITTION STATUS
 Q:$G(FILE)=""!($G(ACT)="")
 K DIE,DIC,DINUM,DR,DA,DD,DO,DIK,DLAYGO
 S X=FILE
 S DIC="^BYIMRT("
 S DIC(0)="L"
 S DIC("DR")=".02////"_ACT_";.03////"_PATH_";.04////"_DFN_";.05////"_($P(FILE,"_",3)-17000000)_"."_$P($P(FILE,"_",4),".")_";.06////"_MID_";.07////"_UIF_";.08////"_$G(STAT)
 D FILE^DICN
 K DIE,DIC,DINUM,DR,DA,DD,DO,DIK,DLAYGO
 Q:Y<1
 S RTLDA=+Y
 S ^BYIMRT(RTLDA,1,0)="^90480.21"
 N X
 S X=0
 F  S X=$O(^INTHU(UIF,3,X)) Q:'X  S ^BYIMRT(RTLDA,1,X,0)=^(X,0),Z=X
 S $P(^BYIMRT(RTLDA,1,0),U,3)=Z
 S $P(^BYIMRT(RTLDA,1,0),U,4)=Z
 Q
 ;-----
DISP(RTLDA) ;DISPLAY RESPONSE FILE
 D HDR
 N XX,BYIMQUIT
 S MID=$P(^BYIMRT(RTLDA,0),U,6)
 S FILE=$P(^BYIMRT(RTLDA,0),U)
 S XX=0
 S MIDDA=$O(^BYIMRT("ACT",FILE,"I",0))
 I 'MIDDA D  Q
 .W !!,"No response on file yet for this query."
 .D PAUSE^BYIMIMM
 D MID
 K BYIMQUIT
 Q
 ;-----
HDR ;QUERY RESPONSE DISPLAY HEADER
 W @IOF
HDR1 W !!,"Query for Patient",?26,"Query Date",?38,"Query file"
 W !,"------------------------",?26,"----------",?38,"-------------------------------"
 N X0
 S X0=$G(^BYIMRT(RTLDA,0))
 W !,$P($G(^DPT(+$P(X0,U,4),0)),U)
 S X1=$P(X0,U,5)
 W ?26,$E(X1,4,5),"/",$E(X1,6,7),"/",$E(X1,1,3)+1700
 W ?38,$P(X0,U)
 Q
 ;-----
HDR2 ;DISPLAY RELATED MESSAGE
 W !!!,"HL7 Response Message"
 W:$P(^BYIMRT(MIDDA,0),U,6)]"" " ID: ",$P(^(0),U,6)
 W !,"*******************************************************"
 W !
 Q
 ;-----
NEWUIF ;CREATE INTHU ENTRY
 K DIE,DIC,DINUM,DR,DA,DD,DO,DIK,DLAYGO
 D NOW^%DTC
 S X=%
 S DIC="^INTHU("
 S DIC(0)="L"
 D FILE^DICN
 K DIE,DIC,DINUM,DR,DA,DD,DO,DIK,DLAYGO
 S UIF=+Y
 Q
 ;-----
MID ;DISPLAY MESSAGE RESPONSES
 S MIDDA=0
 F  S MIDDA=$O(^BYIMRT("ACT",FILE,"I",MIDDA)) Q:'MIDDA!$G(BYIMQUIT)  D MID1
 K BYIMQUIT
 Q
 ;-----
MID1 ;
 D HDR2
 N XX,BYIMQUIT
 S XX=0
 F  S XX=$O(^BYIMRT(MIDDA,1,XX)) Q:'XX!$D(BYIMQUIT)  S X=^(XX,0) D
 .I X["MSH|",X["|VXU" D DVXU(X) S BYIMQUIT=1 Q
 .W !,X
 .I IOST["C-",IOSL<($Y+4) D PAUSE^BYIMIMM S:X[U BYIMQUIT=1 W @IOF
 D PAUSE^BYIMIMM
 Q
 ;-----
VXQV01(UIF) ;EP;TO DISPLAY VXQ^V01 QUERY
 ;UIF     - IEN OF THE UNIVERSAL INTERFACE ENTRY
 Q:'$G(UIF)
 S MSH=$G(^INTHU(UIF,3,1,0))
 S QRD=$G(^INTHU(UIF,3,2,0))
 S QRF=$G(^INTHU(UIF,3,1,0))
 Q:MSH=""
 W !!,"Message ID: ",$P(MSH,"|",10)
 W !,"Patient HRN: ",+$E($P(QRD,"|",9),7,12),"  Facility: ",$P($G(^DIC(4,+$E($P(QRD,"|",9),1,6),0)),U)
 Q
 ;-----
RXR(BYIMUIF) ;EP;CLEAN OUT BLANK RXR AND '0' OBX segments
 N X,Y
 S X=0
 F  S X=$O(^INTHU(BYIMUIF,3,X)) Q:'X  S Y=^(X,0) D
 .K:$E(Y,1,5)="RXR||" ^INTHU(BYIMUIF,3,X,0)
 .K:Y["OBX|"&(Y["V00") ^INTHU(BYIMUIF,3,X,0)
 Q
 ;-----
DVXU(X) ;DISPLAY RT VXU MESSAGE
 N DISP,HDR
 S XX=XX
 F  S XX=$O(^BYIMRT(MIDDA,1,XX)) Q:'XX!$G(BYIMQUIT)  S X=^(XX,0) D
 .D:X["PID|" PID(X)
 .D:X["RXA|" RXA(X)
 Q:'$D(DISP)
 F J=1:1:6 W !,HDR(J)
 N XX,YY
 S XX=""
 F  S XX=$O(DISP(XX)) Q:XX=""!$G(BYIMQUIT)  D
 .S YY=""
 .F  S YY=$O(DISP(XX,YY)) Q:YY=""!$G(BYIMQUIT)  S Z=DISP(XX,YY) D
 ..W !,XX,?12,YY
 ..W ?39,$J($P(Z,U),4)
 ..W ?45,$P(Z,U,2)
 ..W ?54,$P(Z,U,3)
 ..W ?69,$P(Z,U,4)
 .I IOST["C-",IOSL<($Y+4) D
 ..D PAUSE^BYIMIMM
 ..S:X[U BYIMQUIT=1
 ..Q:$G(BYIMQUIT)
 ..W @IOF
 ..F J=1:1:6 W !,HDR(J)
 Q
MSH ;DISPLAY RT MSH SEGMENT
 W !,$TR($P(X,"|",3),"^"," "),"  ",$TR($P(X,"|",4),"^"," "),"  "
 S Y=$P(X,"|",7)
 W $E(Y,1,4),"-",$E(Y,5,6),"-",$E(Y,7,8),"  ",$P(X,"|",9),"  ",$P(X,"|",11)
 Q
 ;-----
PID(X) ;DISPLAY RT PID SEGMENT
 N Y,Z
 S Y="NAME"
 S $E(Y,33)="DOB"
 S $E(Y,45)="SEX"
 S HDR(1)=Y
 S HDR(2)="------------------------------  ----------  ---"
 S Y=$P(X,"|",6)
 S Y=$P(Y,U)_","_$P(Y,U,2)_" "_$P(Y,U,3)
 S Z=$P(X,"|",8)
 S $E(Y,33)=$E(Z,1,4)_"-"_$E(Z,5,6)_"-"_$E(Z,7,8)
 S $E(Y,45)=$P(X,"|",9)
 S HDR(3)=Y
 S HDR(4)=""
 S Y="ADMIN DATE"
 S $E(Y,13)="CVX  VACCINE NAME"
 S $E(Y,40)="QUAN"
 S $E(Y,46)="TYPE"
 S $E(Y,55)="LOT NO."
 S $E(Y,70)="EXP. DATE"
 S HDR(5)=Y
 S Y="----------"
 S $E(Y,13)="---  --------------------"
 S $E(Y,40)="----"
 S $E(Y,46)="-------"
 S $E(Y,55)="-------------"
 S $E(Y,70)="---------"
 S HDR(6)=Y
 Q
 ;-----
RXA(X) ;DISPLAY RT RXA SEGMENT
 N Y,Z,AD,IMM,QUAN,TYPE,LOT,EXP
 S Y=$P(X,"|",4)
 S AD=$E(Y,1,4)_"-"_$E(Y,5,6)_"-"_$E(Y,7,8)
 S Y=$P(X,"|",6)
 S CVX=$P(Y,U)
 S IMM=$J(CVX,3)_"  "_$E($P(Y,U,2),1,20)
 S QUAN=$TR($P(X,"|",7),"^")
 S TYPE=$TR($E($P($P(X,"|",10),U,2),1,7),"^")
 S LOT=$TR($P(X,"|",16),"^")
 S Y=$TR($P(X,"|",17),"^")
 S EXP=$E(Y,1,4)_"-"_$E(Y,5,6)_"-"_$E(Y,7,8)
 S DISP(AD,IMM)=QUAN_U_TYPE_U_LOT_U_EXP
 Q
 ;-----
ALL ;EP;TO SPECIFY NEW ONLY OR ALL IMMUNIZATIONS
 K BYIMALL
 W !!,"Which immunizations should be include:"
 K DIR
 S DIR(0)="SO^1:NEW Immunizations (not previously exported);2:ALL Immunizations for exported patient(s)"
 S DIR("A")="Send NEW or ALL Immunizations"
 S DIR("B")="NEW Immunizations"
 D ^DIR
 K DIR
 I 'Y S BYIMQUIT=1 Q
 S BYIMALL=+Y
 Q
 ;-----
CLEANVXU(BYIMUIF) ;REMOVE INLHDEST REMNANT FOR RT MESSAGES
 Q:'$G(BYIMUIF)
 N X,Y,Z
 S X=0
 F  S X=$O(^INLHDEST(X)) Q:'X  D
 .S Y=""
 .F  S Y=$O(^INLHDEST(X,Y)) Q:Y=""  D
 ..S Z=""
 ..F  S Z=$O(^INLHDEST(X,Y,Z)) Q:Z=""  K ^INLHDEST(X,Y,Z,BYIMUIF)
 Q
 ;
