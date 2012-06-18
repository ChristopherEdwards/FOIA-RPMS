BKMILK ;PRXM/HC/CLT - LOOKUP ROUTINE FOR ICARE REGISTRY ; 14 Jul 2005  8:06 PM ;
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 Q
ID ;DETERMINE AND/OR CREATE A PATIENT ID
 Q  ;Subroutine disabled due to client request of ID removal
 N BKMLOC,BKMH3,BKMH1,BKMH2,BKMID,DR,DIE
 I $P(^BKM(90451,DA,0),U,2)'="" Q
 S BKMLOC=$E($$GET1^DIQ(4,$G(DUZ(2))_",",.01,"E"),1,3)
 ;
ID1 ;BUILD OF NUMBER PORTION OF ID
 Q
 S BKMH3="" F BKMH1=1:1:5 S BKMH2=$R(9) S BKMH3=BKMH3_BKMH2
 S BKMID=BKMLOC_BKMH3
 I $D(^BKM(90451,"C",BKMID)) S (BKMID,BKMH3)="" D ID1
 ; Update REGISTER ID
 S DR=".05////"_BKMID_";"
 S DIE="^BKM(90451,"
 D ^DIE
 Q
 ;
AIDSDT ;CHECK TO BE SURE AIDS DATE IS NOT BEFORE THE HIV DATE
 ; CALLED from File 90451, Input Transform
 ; Y, DA and DA(1) set by calling process and must be preserved
 ; QUIT must be set on exit
 N AIDSDT,DFN,DOB
 I $G(Y)<1 S Y=$$GET1^DIQ(90451.01,DA_","_DA(1)_",",5.5,"I")
 S QUIT=0
 ;S A=B
 S AIDSDT=Y
 I AIDSDT<$$GET1^DIQ(90451.01,DA_","_DA(1)_",",5,"I") S QUIT=1 Q
 S DFN=$$GET1^DIQ(90451,DA(1)_",",.01,"I")
 S DOB=$$GET1^DIQ(2,DFN,.03,"I")
 I DOB>Y S QUIT=1
 Q
HIVDT ;CHECK TO BE SURE HIV DATE IS BEFORE THE AIDS DATE, IF IT EXISTS
 ; CALLED from File 90451, Input Transform
 ; Y, DA and DA(1) set by calling process and must be preserved
 ; QUIT must be set on exit
 N HIVDT,DFN,DOB,AIDSDT
 I $G(Y)<1 S Y=$$GET1^DIQ(90451.01,DA_","_DA(1)_",",5,"I")
 S QUIT=0
 S HIVDT=Y
 S AIDSDT=$$GET1^DIQ(90451.01,DA_","_DA(1)_",",5.5,"I")
 I AIDSDT'="",HIVDT>AIDSDT S QUIT=1 Q
 S DFN=$$GET1^DIQ(90451,DA(1)_",",.01,"I")
 S DOB=$$GET1^DIQ(2,DFN,.03,"I")
 I DOB>Y S QUIT=1
 Q
STATBUL ;EP
 ;PRXM/HC/BHS - Remove bulletins per IHS 9/9/2005
 Q
 S BKMPT=$$GET1^DIQ(90451,DA(1),.01,"E")
 S BKMOSTAT=$$GET1^DIQ(90451.01,DA_","_DA(1)_",",.55,"E")
 S BKMNSTAT=$$GET1^DIQ(90451.01,DA_","_DA(1)_",",.5,"E")
 S XMY("G.BKMI ALERT")=""
 S XMSUB="Register Patient status change"
 S ^TMP($J,"BKMIALERT",1)="Status change for Register Patient "_BKMPT_" from "_$S(BKMOSTAT="":"EMPTY",1:BKMOSTAT)_" to "_BKMNSTAT
 S XMTEXT="^TMP($J,""BKMIALERT"","
 D ^XMD
 K XMTEXT,BKMBUL,XMSUB,XMY,^TMP($J,"BKMIALERT"),BKMPT,BKMOSTAT,BKMNSTAT
 Q
DXBUL ;EP
 ;PRXM/HC/BHS - Remove bulletins per IHS 9/9/2005
 Q
 S BKMPT=$$GET1^DIQ(90451,DA(1),.01,"E")
 S BKMODX=$$GET1^DIQ(90451.01,DA_","_DA(1)_",",35,"E")
 S BKMNDX=$$GET1^DIQ(90451.01,DA_","_DA(1)_",",2.3,"E")
 S XMY("G.BKMI ALERT")=""
 S XMSUB="Register Patient Diagnosis change"
 S ^TMP($J,"BKMIALERT",1)="Diagnosis change for Register Patient "_BKMPT_" from "_$S(BKMODX="":"EMPTY",1:BKMODX)_" to "_BKMNDX
 S XMTEXT="^TMP($J,""BKMIALERT"","
 D ^XMD
 K XMTEXT,BKMBUL,XMSUB,XMY,^TMP($J,"BKMIALERT"),BKMPT,BKMODX,BKMNDX
 Q
MAIL ;
 ;XMDF=FLAG that programmer interface is in use.  Set & killed here only.
 ;     Therefore do not check for Security Keys on domains.
 ;XMSUB=HEADER
 ;XMTEXT=@LOCATION OF MESSAGE
 ;XMSTRIP=CHARACTERS THAT USER WANTS STRIPPED FROM TEXT OF MESSAGE
 ;XMDTEST=Testing Flag / in test mode if $G(XMDTEST)=1
 ;XMDUZ=SENDER #
 ;I $D(XMMG),'$D(XMY) XMMG WILL BE THE DEFAULT FOR THE FIRST SEND TO:
 ;XMY I '$D(XMY) RECIPIENTS WILL BE PROMPTED FOR
 D ^XMD
 Q
 ;
ETIXHLP ; EP - Executable help for Etiology field
 N BKMMN,BKMIEN,BKMDATA,BKMCNT,DUOUT,BKMRD
    D EN^DDIOL("Choose from:","","!,?3")
    S BKMMN="",BKMCNT=0
    F  S BKMMN=$O(^BKM(90451.5,"D",BKMMN)) Q:BKMMN=""  D  I $G(DUOUT) Q
    . S BKMIEN=0
    . F  S BKMIEN=$O(^BKM(90451.5,"D",BKMMN,BKMIEN)) Q:BKMIEN=""  D  I $G(DUOUT) Q
    . . S BKMDATA=$G(^BKM(90451.5,BKMIEN,0)) Q:BKMDATA=""
    . . S BKMCNT=BKMCNT+1
    . . D EN^DDIOL($$PAD^BKMIXX4($P(BKMDATA,U,2),">"," ",10)_$E($P(BKMDATA,U,1),1,70),"","!,?3")
    . . I BKMCNT=10 D  I $G(DUOUT) Q
    . . . I $$PAUSE^BKMIXX3 S DUOUT=1 Q
    . . . ;R !,"'^' TO STOP: ",BKMRD:DTIME S:'$T BKMRD=U
    . . . ;I BKMRD[U S DUOUT=1 Q
    . . . S BKMCNT=0
    ; Reset DV to "" to prevent generic help from displaying
    S DV=""
    Q
 ;
XIT ;EXIT THE LOOKUP PROCEDURE
 K BKMNEW,DIC,DIE,X,Y,DA,BKMID,BKMH3,BKMH2,BKMID,BKMLOC,BKMH1
