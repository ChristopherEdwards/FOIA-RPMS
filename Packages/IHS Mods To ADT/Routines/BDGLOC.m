BDGLOC ; IHS/ANMC/LJF - LOCATOR CARD ;  [ 08/20/2004  11:46 AM ]
 ;;5.3;PIMS;**1001,1003**;MAY 28, 2004
 ;IHS/ITSC/LJF 4/14/2005 PATCH 1003 default question to YES, if parameter turned on
 ;
NOPAT(BDGPRT) ;EP; entry point from menu
 NEW DFN,IEN
 S DFN=+$$READ^BDGF("PO^2:EMQZ","Select Patient") Q:DFN<1
 S IEN=$$ADMIT(DFN) Q:IEN<1
 D PAT(DFN,IEN,$S($G(BDGPRT)]"":BDGPRT,1:"A"))
 Q
 ;
PAT(DFN,BDGN,BDGPRT,BDGDEV) ;EP; entry point when patient is known
 ; can also be used as silent API
 ;  DFN=patient ien, required
 ;  BDGN = ien in file 405, movement entry, required
 ;  BDGPRT = 1 for print, 0 for not print, "A" for ask, required
 ;  BDGDEV = print device, required if silent call
 ;           if sent, automatic queuing to that device
 ;
 Q:'$G(DFN)  Q:'$G(BDGN)
 I $G(BDGPRT)="" S BDGPRT="A"
 I DGPMT=3,DGPMA]"" Q   ;no need when discharged
 ;
 ;IHS/ITSC/LJF 04/14/2005 PATCH 1003 if parameter turned on, assume they want to print
 ;I BDGPRT="A" S BDGPRT=$$READ^BDGF("Y","Print Locator Card","NO")
 I BDGPRT="A" S BDGPRT=$$READ^BDGF("Y","Print Locator Card","YES")
 ;
 Q:'BDGPRT     ;don't print
 ;
 ; if device sent, queue automatically
 I $G(BDGDEV)]"" D  Q
 . S ZTIO=BDGDEV,ZTRTN="EN^BDGLOC1",ZTDESC="Locator Card",ZTDTH=$H
 . F I="DFN","BDGN" S ZTSAVE(I)=""
 . D ^%ZTLOAD
 ;
 ; else, ask user
 ;IHS/ITSC/WAR 5/12/2004 P #1001 default LocCard Prt from ADT parameters
 ;D ZIS^BDGF("PQ","EN^BDGLOC1","Locator Card","DFN;BDGN",$G(BDGDEV))
 D ZIS^BDGF("PQ","EN^BDGLOC1","Locator Card","DFN;BDGN",$$GET1^DIQ(9009020.1,1,.04))
 Q
 ;
 ;
ADMIT(DFN) ; ask user to select an admission for patient
 I '$D(^DGPM("APCA",DFN)) W !!?5,"No admissions on file." Q 0
 ;
 ; loop by inverse date to display admissions with most recent first
 NEW IEN,IVDT,COUNT,ADM,Y
 W !!,"Admission(s)" S COUNT=0
 S IVDT=0 F  S IVDT=$O(^DGPM("ATID1",DFN,IVDT)) Q:'IVDT  D
 . S IEN=0 F  S IEN=$O(^DGPM("ATID1",DFN,IVDT,IEN)) Q:'IEN  D
 .. S COUNT=COUNT+1,ADM(COUNT)=IEN             ;save ien by count
 .. W !?5,COUNT,".  ",$$GET1^DIQ(405,IEN,.01)  ;display date by count
 ;
 I COUNT=1 Q ADM(1)     ;only one, no need to choose
 S Y=$$READ^BDGF("NO^1:"_COUNT,"Select One",1,"","")
 ;IHS/ITSC/WAR 5/12/2004 P #1001, need the array from list
 ;Q Y
 Q ADM(Y)
 ;
