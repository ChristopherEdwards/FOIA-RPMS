BLRALUT1 ;DAOU/ALA-Lab ES Utility 
 ;;5.2T9;LR;**1018**;Nov 17, 2004
 ;;5.2;LR;**1013,1015**;Nov 18, 2002
 ;
 ;**Program Description**
 ;  This contains utilities for Lab Audit
 ;
SX ;EP
 ;  Set review cross-reference
 ;  ^LR("BLRA",BLRARPHY,BLRARFL,-LRIDT,LRDFN)
 ;     BLRARPHY  = Responsible Physician
 ;     BLRARFL = Review Status
 ;             0 = Not Reviewed 
 ;             1 = Reviewed, not signed 
 ;             2 = Reviewed, signed
 ;     LRIDT = Reverse Date
 ;     LRDFN = Lab Patient
 ;
 I $G(BLRARPHY)=""!($G(BLRARFL)="")!($G(LRIDT)="")!($G(LRDFN)="") Q
 ;
 ;S ^LR("BLRA",BLRARPHY,BLRARFL,-LRIDT,LRDFN)=LRSS
 ;----- BEGIN IHS MODIFICATIONS LR*5.2*1018
 S ^LR("BLRA",BLRARPHY,BLRARFL,-LRIDT,LRDFN,LRSS)=LRSS
 ;----- END IHS MODIFICATIONS
 Q
 ;
KX ;EP
 ;  Kill review cross-reference
 ;  ^LR("BLRA",BLRARPHY,BLRARFL,-LRIDT,LRDFN)
 ;     BLRARPHY  = Responsible Physician
 ;     BLRARFL = Review Status
 ;     LRIDT = Reverse Date
 ;     LRDFN = Lab Patient
 ;
 I $G(BLRARPHY)=""!($G(BLRARFL)="")!($G(LRIDT)="")!($G(LRDFN)="") Q
 ;
 ;K ^LR("BLRA",BLRARPHY,BLRARFL,-LRIDT,LRDFN)
 ;----- BEGIN IHS MODIFICATIONS LR*5.2*1018
 K ^LR("BLRA",BLRARPHY,BLRARFL,-LRIDT,LRDFN,LRSS)
 ;----- END IHS MODIFICATIONS
 Q
 ;
ALT ;  Generate alert message
 ;
 ;  If user is not found in the participating physician file
 ;  then they are not participating in the Electronic signature
 ;  modification.
 I '$D(^BLRALAB(9009027.1,DUZ)) Q
 ;
 ;  If user is an inactive participating physician, alert not shown
 I $P($G(^BLRALAB(9009027.1,DUZ,0)),U,7)="I" Q
 ;
 ;  Variables
 ;    BLRABC = Abnormal Count
 ;    BLRANC = Normal Count
 ;    BLRCRC = Critical Count
 ;    DUZ    = User
 S BLRABC=0,BLRANC=0,BLRCRC=0,BLRADUZ=DUZ D FND
 ;
 ;  Check for surrogates
 S BLRADUZ=""
 F  S BLRADUZ=$O(^BLRALAB(9009027.1,"AB",DUZ,BLRADUZ)) Q:BLRADUZ=""  D
 . S BSTDT=$P($G(^BLRALAB(9009027.1,BLRADUZ,1,DUZ,0)),U,2)
 . S BENDT=$P($G(^BLRALAB(9009027.1,BLRADUZ,1,DUZ,0)),U,3)
 . I BENDT=""!(BSTDT="") Q
 . I DT'<BSTDT&(DT'>BENDT) D FND
 ;
 I BLRANC'=0 D
 . W !!?5,"You have "_BLRANC_" Lab Results to Review" S BX=""
 I BLRCRC'=0 D
 . W !,?10," with "_BLRCRC_" CRITICAL"_$S(BLRCRC=1:"",1:"s")
 . S BX=" and"
 I BLRABC'=0 D
 . I BLRCRC=0 W !,?10
 . W BX_" with "_BLRABC_" ABNORMAL"_$S(BLRABC=1:"",1:"s")
 Q
 ;
FND ;  Find results
 S BLRAS=""
 F  S BLRAS=$O(^LR("BLRA",BLRADUZ,BLRAS)) Q:BLRAS=2!(BLRAS="")  D
 . S BLRVD=""
 . F  S BLRVD=$O(^LR("BLRA",BLRADUZ,BLRAS,BLRVD)) Q:BLRVD=""  D
 .. S BLRAP=""
 .. F  S BLRAP=$O(^LR("BLRA",BLRADUZ,BLRAS,BLRVD,BLRAP)) Q:BLRAP=""  D
 ... ;S BLRIDT=$P(BLRVD,"-",2),BLRSS=$G(^LR("BLRA",BLRADUZ,BLRAS,BLRVD,BLRAP))
 ... ;----- BEGIN IHS MODIFICATIONS LR*5.2*1018
 ... S BLRSS=""
 ... F  S BLRSS=$O(^LR("BLRA",BLRADUZ,BLRAS,BLRVD,BLRAP,BLRSS)) Q:BLRSS=""  D
 .... S BLRIDT=$P(BLRVD,"-",2)
 .... ;----- END IHS MODIFICATIONS
 .... S BLRANC=BLRANC+1
 .... I +$P($G(^LR(BLRAP,BLRSS,BLRIDT,9009027)),U,8)'=0 S BLRCRC=BLRCRC+1 Q
 .... I $P($G(^LR(BLRAP,BLRSS,BLRIDT,9009027)),U,6)'=0 S BLRABC=BLRABC+1
 Q
HEAD ; Privacy warning message
 W @IOF
 F BLRAJ=0:1:3 D H1
 Q
 ;
H1 S BLRAX=$T(TEXT+BLRAJ),BLRAX=$P(BLRAX,";;",2)
 W !?80-$L(BLRAX)\2,BLRAX
 Q
TEXT ;;WARNING: RESTRICTED GOVERNMENT PATIENT DATA, UNAUTHORIZED
 ;;ENTRY INTO THIS SYSTEM OR USE OF THIS DATA IS A FEDERAL CRIME
 ;;****************************************************
