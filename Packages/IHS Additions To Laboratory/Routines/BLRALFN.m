BLRALFN ;DAOU/ALA-Lab ES Functions [ 11/18/2002  1:36 PM ]
 ;;5.2;LR;**1013,1015**;NOV 18, 2002
 ;
 ;**Program Description**
 ;  Lab Electronic Signature functions
 ;
FPS ;  Full Patient Summary
 ;  Call the current Full Patient Summary code but bypass
 ;  the selection of the patient which is already defined
 ;
 NEW LRIDT
 S LRIN=0,LRIDT=0,LREND=0,LROUT=9999999,LRDIS=0 K ZTRTN,DIC,X2
 I $G(LRDFN)="" Q
 ;
 D PT^LRX
 W !,"** WARNING!  This report must be queued to a printer. **"
 ;HANG 1
 N DIR,X,Y
 K DIR S DIR(0)="E",DIR("T")=10,DIR("A")="Press return to continue " D ^DIR
 K DIR,X,Y
 ;
 D QUE^LRACSUM G:POP END
 I $D(ZTSK) S IOP="HOME" D ^%ZIS
 I '$D(ZTSK) D LRLLOC^LRACSUM
 ;
 S BLDATA=$G(^TMP("BLRA",$J,"ZNODE",ACN))
 S LRDFN=$P(BLDATA,U,1),LRSS=$P(BLDATA,U,2),LRIDT=$P(BLDATA,U,3)
 I $E(LRSS,1,2)="CH" D CH^BLRALBD
 I $E(LRSS,1,2)="MI" D MI^BLRALBD
 ;NEW VALMCNT
 S VALMCNT=+$G(BLRADSP)
 S VALMBCK="R"
 ;
 K LRDPF
 I $D(ZTSK) K ZTSK Q
 Q
END ;
 ;  END^LRACM is killing too many variables, we may need to
 ;  retain some to return back to ListMan
 ;D END^LRACM
 ;D ^%ZISC
 ;
 S VALMBCK="R"
 Q
 ;
FWD ;  Forward a MailMan message with the Lab Results
 K ^TMP($J,"BLRAMSG"),^BLRALAB(9009027.1,DUZ,100)
 S DIR(0)="Y"
 S DIR("A")="Do you wish to add additional comments to send with this lab result"
 D ^DIR I $G(Y)=1 D WP
 ;
 ;  Get the data from the word processing field
 S BLRANN=0
 F  S BLRANN=$O(^BLRALAB(9009027.1,DUZ,100,BLRANN)) Q:'BLRANN  D
 . S BLRALL=$G(BLRALL)+1
 . S ^TMP($J,"BLRAMSG",BLRALL,0)=$G(^BLRALAB(9009027.1,DUZ,100,BLRANN,0))
 ;
 ;  Separate lab result build from additional text with a
 ;  new line
 S BLRALL=$G(BLRALL)+1,^TMP($J,"BLRAMSG",BLRALL,0)=" "
 ;
 ;  If clinical chem, set the patient header first
 I LRSS="CH" D
 . F BLRAI=1:1:3 S BLRALL=$G(BLRALL)+1,^TMP($J,"BLRAMSG",BLRALL,0)=VALMHDR(BLRAI)
 ;
 S BLRANN=0
 F  S BLRANN=$O(^TMP($J,"BLRA",BLRANN)) Q:'BLRANN  D
 . S BLRALL=$G(BLRALL)+1
 . S ^TMP($J,"BLRAMSG",BLRALL,0)=$G(^TMP($J,"BLRA",BLRANN,0))
 ;
 S XMSUB="LAB RESULT FOR YOUR REVIEW",XMDUZ=DUZ
 S XMTEXT="^TMP($J,""BLRAMSG"","
 ;
 ;  if no XMY is defined, MailMan should ask for recipients
 D ^XMD
 ;
 K XMZ,XMTEXT,XMSUB,XMDUZ,BLRALL,BLRANN,DIR,Y,^TMP($J,"BLRAMSG")
 ;
 S VALMBCK="R"
 Q
 ;
WP ;  Using FileMan word-processing, add additional comments
 S DWLW=75,DWPK=1,DIC="^BLRALAB(9009027.1,"_DUZ_",100,"
 D EN^DIWE
 ;
 Q
 ;
REA ;  Reassign a lab result to another participating provider
 ;
 ;  Parameters
 ;    BLRAFPH = The 'From Physician'
 ;    BLRATPH = The 'To Physician'
 ;    TERMDT = Termination Date
 ;    BLRADATA = Lab ES data
 ;    BLRARPHY = Responsible Physician
 ;    BLRARFL = Result Status Flag
 ;
 S BLRAFPH=DUZ
 ;
RTO S DIC("A")="Select PARTICIPATING PHYSICIAN reassigning this lab TO: "
 S DIC="^BLRALAB(9009027.1,",DIC(0)="AEMNZ" D ^DIC
 Q:Y<1  S BLRATPH=+Y
 S TERMDT=$$GET1^DIQ(200,BLRATPH,9.2,"I")
 I TERMDT'=""&(TERMDT'>DT) D EN^DDIOL("This provider has a termination date, please select another") G RTO
 ;
 D FILR
 K BLRAFPH,BLRATPH,TERMDT,Y,BLRADATA,BLRARPHY,BLRARFL
 ;
 Q
 ;
FILR ;EP
 S BLRADATA=$G(^LR(LRDFN,LRSS,LRIDT,9009027))
 S BLRARPHY=$P(BLRADATA,U,2),BLRARFL=$P(BLRADATA,U)
 D KX^BLRALUT1
 ;
 S $P(BLRADATA,U,2)=BLRATPH
 S ^LR(LRDFN,LRSS,LRIDT,9009027)=BLRADATA
 S BLRARPHY=BLRATPH
 D SX^BLRALUT1
 Q
