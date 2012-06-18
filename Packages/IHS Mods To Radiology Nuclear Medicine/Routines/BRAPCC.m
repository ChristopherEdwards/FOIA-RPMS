BRAPCC ; IHS/ITSC/PDW,CLS - RADIOLOGY PCC LINK ;05-Feb-2002 10:56;PLS
 ;;5.0;Radiology/Nuclear Medicine;**1001**;Feb 20, 2004
 ; RA*4*2 IHS/ADC/GTH 01/21/98 If the conversion has not been done, walk back to file 6.
 ;
 ;
CREATE ;EP---> CREATE OR MODIFY A VISIT FILE ENTRY, CREATE A NEW V RAD ENTRY.
 ;S DUZ(0)="@" MWR >>No longer needed IHS/ISD/EDE 1/6/97
 K APCDALVR N I,N,X
 ;---> QUIT IF PCC IS NOT PRESENT AT THIS SITE (RPMS SITE FILE).
 Q:$P(^AUTTSITE(1,0),U,8)'="Y"
 ;---> QUIT IF NO PCC MASTER CONTROL FILE FOR THIS SITE.
 Q:'$D(^APCCCTRL(DUZ(2)))
 ;---> QUIT IF RADIOLOGY IS NOT IN THE PACKAGE FILE.
 S DIC=9.4,DIC(0)="",X="RADIOLOGY/NUCLEAR MEDICINE" D ^DIC
 Q:Y<0
 ;---> QUIT IF RADIOLOGY IS NOT IN PCC MASTER CONTROL FILE OR IF
 ;---> "PASS DATA TO PCC" IS "NO".
 Q:'$D(^APCCCTRL(DUZ(2),11,+Y,0))
 Q:'$P(^APCCCTRL(DUZ(2),11,+Y,0),U,2)
 ;---> QUIT IF VISIT TYPE ISN'T DEFINED IN PCC MASTER CONTROL FILE.
 Q:$P(^APCCCTRL(DUZ(2),0),U,4)']""
 ;---> QUIT IF NECESSARY RAD VARIABLES ARE NOT PRESENT.
 Q:'$D(RADFN)  Q:'$D(RADTI)  Q:'$D(RACNI)  Q:'$D(RADTE)
 ;---> QUIT IF PCC DATE/TIME NODE DOES NOT EXIST.
 Q:'$D(^RADPT(RADFN,"DT",RADTI,"P",RACNI,"PCC"))
 ;
 ;I interactive S variable D EN^BSDAPI3 I IEN S APCDVSIT=IEN D VRAD Q  ;IHS/ITSC/CLS 05/11/2004
 ;
VISIT ;---> CREATE OR MODIFY VISIT IN VISIT FILE.
 ;---> SET BRATEST=1 TO DISPLAY VISIT AND V RAD PTRS AFTER SET.
 S BRATEST=0
 ;
 ;---> PATIENT
 S APCDALVR("APCDPAT")=RADFN
 ;
 ;---> PCC DATE/TIME; IF NO TIME, ATTACH 12 NOON.
 S APCDALVR("APCDDATE")=$P(^RADPT(RADFN,"DT",RADTI,"P",RACNI,"PCC"),U)
 I '$P(APCDALVR("APCDDATE"),".",2) S APCDALVR("APCDDATE")=APCDALVR("APCDDATE")_".12"
 ;
 ;---> LOCATION
 S APCDALVR("APCDLOC")=DUZ(2)
 ;
 ;---> VISIT TYPE FROM PCC MASTER CONTROL FILE. (I,C,T,6,V)
 S APCDALVR("APCDTYPE")=$P(^APCCCTRL(DUZ(2),0),U,4)
 ;
 ;---> TYPE OF LINK FROM PCC MASTER CTRL FILE; IF TIME REQ SET APCDAUTO.
 ;I $P(^APCCCTRL(DUZ(2),0),U,2) S APCDALVR("APCDAUTO")=""
 ;---> RADIOLOGY SOFTWARE WILL APPEND 12 NOON TO ANY VISIT WITHOUT TIME.
 S APCDALVR("APCDAUTO")=""
 ;
 ;---> CATEGORY
 S X=$S($P(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0),U,4)="I":"I",1:"A")
 ;
 ;IHS/ANMC/LJF 11/28/2001 if observation patient use A (PIMS v5.3)
 I X="I" D
 .NEW DAT,CA S DAT=9999999.9999-RADTI  ;convert date
 .S CA=$$INPT1^BDGF1(RADFN,DAT)  ;admission ien
 .I CA,$$GET1^DIQ(405,+$$PRIORTXN^BDGF1(DAT,CA,RADFN),.09)["OBSERVATION" S X="A"
 .;IHS/ANMC/LJF 11/28/2001 end of new code
 S APCDALVR("APCDCAT")=X K X
 ;
 ;---> CLINIC
 ;modified for correct clinic identification  IHS/HQW/PMF-4/25/01**8**
 ;S X=$P(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0),U,8)
 ;S X=$P($G(^SC(+X,0)),U,7)
 ;S X=$S(X:X,APCDALVR("APCDCAT")="A":57,1:0)
 ;
 D CLINIC   ;IHS/HQW/PMF - 4/25/01 **8**
 ;
 ;---> REQUESTING PROVIDER/ORDERING PROVIDER
 ;---> I $P(^AUTTSITE(1,0),U,22)) SEND 200 PTR.
 S X=$P(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0),U,14)
 ;S:$P(^AUTTSITE(1,0),U,22) X=^DIC(16,X,"A3") ;IHS/ISD/EDE 02/16/97
 ; no longer necessary, converted to file 200  IHS/ISD/EDE 02/16/97
 ;S:$P(^AUTTSITE(1,0),U,22) X=^DIC(16,X,"A3") ; RA*4*2 IHS/ADC/GTH 01/21/98 If the conversion has not been done, walk back to file 6.
 ; check the DD of the VRAD file vs the PCC converted field is the site global $P(^AUTTSITE(1,0),U,22) due to users have errored the process by changing the flag.
 D:$P(^DD(9000010.22,1202,0),U,3)="DIC(6,"  ; RA*4*5 IHS/HQW/JDH If no PCC conversion to file 200, convert to file 6
 .N Y
 .S Y=^VA(200,X,0)
 .S X=$P($G(^DIC(16,+$P(Y,U,16),0)),U)=$P(Y,U)
 .S:X X=$P(Y,U,16)
 S:X APCDALVR("APCDTPRV")="`"_X K X
 ;
 ;---> NO INTERACTION, NO FILEMAN ECHOING
 S APCDALVR("AUPNTALK")="",APCDALVR("APCDANE")=""
 ;
 D ^APCDALV
 D:BRATEST DISPLAY1
 ;
 G:'$$STORE(197,$G(APCDALVR("APCDVSIT"))) EXIT ; store the ptr in the PCC node of ^RADPT IHS/HQW/JDH
 ;
 ;---> QUIT IF VISIT WAS NOT CREATED.
 ;G:'$D(APCDALVR("APCDVSIT")) EXIT ; IHS/HQW/JDH replaced by the call to STORE
 G:$D(APCDALVR("APCDAFLG")) EXIT
 ;
 ;RETURNS  APCDVSIT - PTR TO VISIT JUST SELECTED OR CREATED
 ;         APCDVSIT("NEW") - IF ^APCDALVR CREATED A NEW VISIT
 ;         APCDAFLG - =2 IF FAILED TO CREATE VISIT
 ;
VRAD ;---> CREATE (ADD) VISIT TO V RADIOLOGY FILE.
 ;
 I $P($G(^RADPT(RADFN,"DT",RADTI,"P",RACNI,"PCC")),"^",2) D UPDTIMP(RADFN,RADTI) Q  ;IHS/ITSC/CLS 01/09/2004
 ;
 ;V RADIOLOGY FILE#=9000010.22
 S DLAYGO=9000010.22
 ;
 ;---> RADIOLOGY PROCEDURE
 S APCDALVR("APCDTRAD")="`"_$P(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0),U,2)
 ;
 ;---> RADIOLOGY PROCEDURE EVENT DATE/TIME
 S APCDALVR("APCDTCDT")=$P(^RADPT(RADFN,"DT",RADTI,0),U)
 ;
 ;---> ABNORMAL ; V RAD ^DD SHOULD BE MODIFIED TO TAKE DIAG CODES!
 ;---> 4/6/95:
 ;---> LORI WILL BE CHANGING THE .05 FIELD OF V RADIOLOGY TO POINT
 ;---> THE THE DIAGNOSTIC CODES FILE #78.3 SOMETIME SOON.  FOR NOW
 ;---> FIELD #.05 IS STILL A SET OF CODES: NORMAL/ABNORMAL.
 ;S APCDALVR("APCDTABN")=0
 ;
 ;---> 3/17/97 WE DECIDED TO LEAVE .05 FIELD AS IS FOR DIRECT DATA
 ;---> ENTRY AND ADDED A .06 FIELD FOR DIAGNOSTIC CODE IHS/ISD/EDE
 ;S APCDALVR("APCDTDC")="`"_$P(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0),U,13)
 I $P($G(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0)),U,13)]"" D
 .S APCDALVR("APCDTDC")="`"_$P(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0),U,13)
 ;---> REMOVE THE ; FROM ABOVE LINE WHEN PCC READY TO TAKE DIAGNOSTIC
 ;---> CODES ::IHS/ISD/EDE 03/17/97
 ;---> ;IHS/ITSC/CLS 01/08/2004  don't send just an "`"
 ;
 ;---> IMPRESSION
 S APCDALVR("APCDTIMP")="NO IMPRESSION."
 I $G(RARPT),$D(^RARPT(RARPT,"I")) D  ;IHS/PLS 12/26/2001 - $G added
 .S I=$$SETIMP  ;IHS/ITSC/CLS 01/08/2004
 .I $L(I) S APCDALVR("APCDTIMP")=I
 ;
 ;---> TEMPLATE TO ADD VISIT TO V RADIOLOGY FILE.
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.22 (ADD)]"
 D ^APCDALVR
 D:BRATEST DISPLAY2
 ;
 G:'$$STORE(196,$G(APCDALVR("APCDADFN"))) EXIT ; store the pointer in PCC node of ^RADPT IHS/HQW/JDH
 ;
 ;G:'$D(APCDALVR("APCDADFN")) EXIT ; IHS/HQW/JDH replaced by the call to STORE
 G:$D(APCDALVR("APCDAFLG")) EXIT
 D:BRATEST DISPLAY3
 ; replaced by STORE
 ;S X=APCDALVR("APCDADFN")_"^"_APCDALVR("APCDVSIT")
 ;S $P(^RADPT(RADFN,"DT",RADTI,"P",RACNI,"PCC"),U,2,3)=X
 ;D:BRATEST DISPLAY3
 ;
EXIT ;
 K I,N,BRATEST,X
 Q
 ;
CLINIC ;
 ; Identify radiology clinic rather than stuff a value
 ;IHS/HQW/PMF - 05/30/01 **8**
 ;
 ;retrieve the clinic number
 N RACLINIC
 ;first get the hospital location pointer from the rad patient file
 S RACLINIC=$P(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0),U,8)
 ;if that pointer is not null, get the stop code number from the
 ;hospital location file, if it's there.
 ;if not there, clinic will be null
 I RACLINIC'="" S RACLINIC=$P($G(^SC(+RACLINIC,0)),U,7)
 ;
 ;if we got one, set the arrays and stop.
 ;
 I RACLINIC S (APCDALVR("APCDTCLN"),APCDALVR("APCDCLN"))="`"_RACLINIC Q
 ;
 ;if that didn't work, and this is NOT a category A, stop
 ;
 I APCDALVR("APCDCAT")'="A" Q
 ;if we got this far, use the ein of the Radiology clinic stop
 S RACLINIC=$O(^DIC(40.7,"B","RADIOLOGY",""))
 I RACLINIC S (APCDALVR("APCDTCLN"),APCDALVR("APCDCLN"))="`"_RACLINIC
 Q
 ;End changes to identify correct clinic -IHS/HWQ/PWF -05/30/01 **8**
 ;
STORE(RAFLD,RAVALUE) ;---> STORE VISIT AND V RAD IEN'S IN RADIOLOGY EXAMS FILE #70
 N RAFDA,RAOK
 S RAOK=1
 S:'RAVALUE RAOK=0 ; If pointer fields were defined for the PCC node, this kludge would not be needed.
 D:RAOK
 .S RAFDA($J,70.03,""_RACNI_","_RADTI_","_RADFN_",",RAFLD)=RAVALUE
 .D FILE^DIE("E","RAFDA($J)","RAFDA($J,""ERR"")")
 I $G(DIERR)!'RAOK D
 .W !!,*7,"The Radiology to PCC interface has encountered an error. Please call the HQW help desk at 248-4371"
 .W !!,$G(RAFDA($J,"ERR","DIERR",1,"TEXT",1)),!!
 .D ^%ZTER S RAOK=0 ; trap an error
 Q RAOK
 ;
 ;
DELETE ;EP---> DELETE PCC V RAD ENTRY. (REQUIRES RADFN, RADTI, & RACNI)
 ;---> CALLED FROM CIAZPRAD (DELETE OR CANCEL AN EXAM).  ;IHS/ITSC/CLS 01/08/2004
 ;---> QUIT IF NECESSARY RAD VARIABLES ARE NOT PRESENT.
 Q:'$D(RADFN)  Q:'$D(RADTI)  Q:'$D(RACNI)  Q:'$D(RADTE)  ;IHS/ITSC/CLS 12/31/2003
 I $D(^RADPT(RADFN,"DT",RADTI,"P",+RACNI,"PCC")) D
 .S DA=$P(^RADPT(RADFN,"DT",RADTI,"P",+RACNI,"PCC"),U,2)
 .;---> QUIT IF POINTER TO VRAD FILE IS NULL.
 .Q:'+DA
 .Q:'$D(^AUPNVRAD(DA,0))
 .S APCDVDLT=$P(^AUPNVRAD(DA,0),U,3)
 .S DIK="^AUPNVRAD(" D ^DIK
 .Q:APCDVDLT'=$P(^RADPT(RADFN,"DT",RADTI,"P",+RACNI,"PCC"),U,3)
 .D:'$P(^AUPNVSIT(APCDVDLT,0),U,9) ^APCDVDLT
 .;---> SET PCC VISIT POINTERS FOR THIS EXAM = NULL.
 .S $P(^RADPT(RADFN,"DT",RADTI,"P",+RACNI,"PCC"),U,2,3)=""
 Q
 ;
 ;
DISPLAY1 ;---> DISPLAY VISIT IEN.
 I $D(APCDALVR("APCDVSIT")) D
 .W !,"APCDVSIT DEFINED: ",APCDALVR("APCDVSIT")
 I $D(APCDALVR("APCDVSIT","NEW")) D
 .W !,"NEW VISIT: ",APCDALVR("APCDVSIT","NEW")
 ;---> SHOW FLAG IF VISIT WAS NOT CREATED.
 I $D(APCDALVR("APCDAFLG")) D
 .W !,"APCDAFLG DEFINED, FAILED: ",APCDALVR("APCDAFLG")
 Q
DISPLAY2 ;---> DISPLAY V RAD IEN.
 I $D(APCDALVR("APCDADFN")) D
 .W !,"APCDADFN DEFINED: ",APCDALVR("APCDADFN")
 ;> SHOW FLAG IF VISIT WAS NOT CREATED.
 I $D(APCDALVR("APCDAFLG")) D
 .W !,"APCDAFLG DEFINED, FAILED: ",APCDALVR("APCDAFLG")
 Q
DISPLAY3 ;---> DISPLAY VISIT AND V RAD GLOBAL NODES AND FILE#70 IENS.
 W !!,"VISIT FILE: "
 S N=APCDALVR("APCDVSIT")-3
 F  S N=$O(^AUPNVSIT(N)) Q:'N  D
 .W !,N,": ",^AUPNVSIT(N,0)
 ;
 W !!,"V RAD FILE: "
 S N=APCDALVR("APCDADFN")-3,M=N+10
 F  S N=$O(^AUPNVRAD(N)) Q:'N  Q:N>M  D
 .W !,N,": ",^AUPNVRAD(N,0)
 W !,"EXAM IENS: ",RADFN," ",RADTI," ",RACNI
 Q
 ;
UPDTIMP(RADFN,RADTI) ;EP ---> Called from BRAPRAD and VRAD above
 ;Updates V RAD file with impression after a visit has been sent to PCC
 ;at EXAMINED with "NO IMPRESSION." in V RAD file 
 ;IHS/HQW/SCR - 07/20/01 **8**
 ;
 S RAXM=0,RACNUM=""   ;IHS/HQW/SCR - 07/20/01 **8**
 ;
 ;If the exam has been VERIFIED locate the CaseNumber of the EXam since
 ;multiple EXams can be part of the same visit-IHS/HQW/SCR-07/20/01**8**
 ;
 F  D Q:RAXM="" S RAXM=$O(^RADPT(RADFN,"DT",RADTI,"P",RAXM)),RACNUM=$P(^(RAXM,0),U) Q:RACNUM=RACN  ;IHS/HQW/SCR - 07/20/01 **8**
 ;
 ;Use the RAXM to identify the IEN of the V RAD file for this visit
 ;IHS/HQW/SCR - 7/20/01 **8**
 S PCCVRAD=$P(^RADPT(RADFN,"DT",RADTI,"P",RAXM,"PCC"),U,2)  ;IHS/HQW/SCR - 07/20/01 **8**
 I $G(PCCVRAD)="" W !,"NO PCC data available for this exam." D CLN Q  ;IHS/HQW/SCR - 8/15/01 **8**
 ;
 ;If report is Unverified (ORDSTS="ZU"), revert back to "NO IMPRESSION."
 ;If report has been deleted, report pointer is null.
 ;
 I ORDSTS="ZU" S I="NO IMPRESSION." D CDIE Q  ;IHS/ITSC/CLS 01/08/2004 if report unverified, reset impression
 ;
 ;If the impression field of the VRAD file holds "NO IMPRESSION.", update the
 ;field with the impression that is now stored in the Radiology Reports file.
 ; -- IHS/HQW/SCR - 07/20/01 **8**
 ;
 ;If report is Re-verified (ACTION="ZE"), update impression.
 ;
 ;I $G(^AUPNVRAD(PCCVRAD,11))="NO IMPRESSION." D   ;IHS/HQW/SCR-7/20/01
 I $G(^AUPNVRAD(PCCVRAD,11))="NO IMPRESSION."!(ACTION="RE") D   ;IHS/ITSC/CLS 01/08/2004
 .N DIE,DA,DR                       ;IHS/HQW/SCR - 07/20/01 **8**
 .;S DIE="^AUPNVRAD(",DA=PCCVRAD,DR="1101///"_$G(^RARPT(RARPT,"I",1,0))  ;IHS/HQW/SCR - 07/20/01 **8**
 .;N RARPT S RARPT=$P(^RADPT(RADFN,"DT",RADTI,"P",RAXM,0),U,17) Q:'$D(^RARPT(RARPT,"I"))  ;IHS/ITSC/CLS 07/15/2004
 .I '$G(RARPT) N RARPT S RARPT=$P(^RADPT(RADFN,"DT",RADTI,"P",RAXM,0),U,17) G CLN:RARPT=""  G CLN:'$D(^RARPT(RARPT,"I"))  ;IHS/ITSC/CLS 07/15/2004 09/28/2004
 .S I=$$SETIMP  ;IHS/ITSC/CLS 01/08/2004
 .I $P($G(^RADPT(RADFN,"DT",RADTI,"P",RAXM,0)),U,13)]"" D
 ..S DC="`"_$P(^RADPT(RADFN,"DT",RADTI,"P",RAXM,0),U,13)  ;IHS/ITSC/CLS 01/09/2004 added diagnostic code
 .D CDIE
 Q
 ;
CDIE ;CALL DIE   
 ;S DIE="^AUPNVRAD(",DA=PCCVRAD,DR="1101///"_I
 S DIE="^AUPNVRAD(",DA=PCCVRAD,DR="1101///"_I_";.06///"_$G(DC)  ;IHS/ITSC/CLS 01/09/2004
 L +^AUPNVRAD(PCCVRAD):0 I '$T W !,"Can not update IMPRESSION in V RAD file. File being edit by another user." Q   ;IHS/HQW/SCR - 07/20/01 **8**
 D ^DIE                            ;IHS/HQW/SCR - 07/20/01 **8**
 L -^AUPNVRAD(PCCVRAD)             ;IHS/HQW/SCR - 07/20/01 **8**
 W !,"IMPRESSION has been updated in the V RAD file." ;IHS/HQW/SCR - 07/20/01 **8**
 ;
 ;The following two lines tell the VISIT file when this visit was
 ;last modified and is needed whenever PCC is not updated through
 ; ^APCDALVR per Lori Butcher - IHS/HQW/SCR - 07/24/01 **8**
 ; 
 S AUPNVSIT=$P(^AUPNVRAD(PCCVRAD,0),U,3)  ;IHS/HQW/SCR - 7/24/01 **8** 
 D MOD^AUPNVSIT                    ;IHS/HQW/SCR - 07/24/01 **8**
 K DIE,DA,DR,AUPNVSIT              ;IHS/HQW/SCR - 07/20/01 **8**
CLN ;
 K DC,I,RAFN,RATI,XM,CN,PCCVRAD     ;IHS/HQW/SCR - 07/20/01 **8**
 Q                                  ;IHS/HQW/SCR - 07/20/01 **8**
 ;
Q ;
 K RADA,RADFNZ,RADTIZ,RACNIZ Q
 ;
SETIMP() ;moved set impression string to function call  ;IHS/ITSC/CLS 01/08/2004
 S I="",N=0 F  S N=$O(^RARPT(RARPT,"I",N)) Q:'N  D
 .I $L(I)+$L(^RARPT(RARPT,"I",N,0))<220 S I=I_" "_^(0) Q
 .S I=I_"...*MORE* (SEE EXAM).",N=-1
 Q I
