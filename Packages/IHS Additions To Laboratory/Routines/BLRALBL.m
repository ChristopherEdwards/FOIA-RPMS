BLRALBL ;DAOU/ALA-Build list data for ListMan 
 ;;5.2T9;LR;**1013,1015,1018**;Nov 17, 2004
 ;;5.2;LR;**1013,1015**;Nov 18, 2002
 ;
 ;**Program Description**
 ;  Go through the cross-reference and build an
 ;  array for ListMan
 ;
 ;  Input Parameter
 ;    DUZ =  User IEN
 ;
SELF ;  Get result for self
 K ^TMP("BLRA",$J) S BLRAHDR="*** MAIN SCREEN ***"
 S BLRADUZ=DUZ D FND
 ;
TSUR ;  Check for temporary surrogates
 ;  A temporary surrogate had a date range limit
 ;
 ;  Parameters
 ;    BSTDT = Start Date
 ;    BENDT = End Date
 ;
 S BLRADUZ=""
 F  S BLRADUZ=$O(^BLRALAB(9009027.1,"AB",DUZ,BLRADUZ)) Q:BLRADUZ=""  D
 . S BSTDT=$P($G(^BLRALAB(9009027.1,BLRADUZ,1,DUZ,0)),U,2)
 . S BENDT=$P($G(^BLRALAB(9009027.1,BLRADUZ,1,DUZ,0)),U,3)
 . I BENDT=""!(BSTDT="") Q
 . I DT'<BSTDT&(DT'>BENDT) D FND
 ;
PSUR ;EP - Left in for Chinle site which may still have perm surrogates
 ;  Change for issue #12 ejn - 3/22/02
 ;  Check for permanent surrogates
 ;K ^TMP("BLRA",$J) S BLRAHDR="***OTHER PROVIDERS***"
 S BLRADUZ=""
 F  S BLRADUZ=$O(^BLRALAB(9009027.1,"AB",DUZ,BLRADUZ)) Q:BLRADUZ=""  D
 . S BSTDT=$P($G(^BLRALAB(9009027.1,BLRADUZ,1,DUZ,0)),U,2)
 . S BENDT=$P($G(^BLRALAB(9009027.1,BLRADUZ,1,DUZ,0)),U,3)
 . I BSTDT=""&(BENDT="") D FND
 Q
 ;
FND ;  Find results
 ;
 ;  Parameters
 ;    BLRADUZ = Provider IEN
 ;    BLRAS = Result Status
 ;    BLRVD = Negative Reverse Date
 ;    BLRAP = Lab Patient IEN
 ;    BLRIDT = Reverse Date
 ;    BLRSS = Lab Accession Subscript
 ;    BLRADATA = Lab ES Data
 ;    BLRAAB = Number of abnormal results
 ;    BLRAPD = Number of pending results
 ;    BLRADTT = Lab Accession Collection Date/time
 ;    BLRAOPH = Ordering Provider
 ;    BLRARPHY = Responsible Provider
 ;    BLRACCN = Accession Number
 ;    BLRAPFL = Lab Patient File Number
 ;    BLRAPIEN = Patient IEN
 ;    BLRAPNM = Patient Name
 ;
 S BLRAS=""
 F  S BLRAS=$O(^LR("BLRA",BLRADUZ,BLRAS)) Q:BLRAS=2!(BLRAS="")  D
 . S BLRVD=""
 . F  S BLRVD=$O(^LR("BLRA",BLRADUZ,BLRAS,BLRVD)) Q:BLRVD=""  D
 .. S BLRIDT=$P(BLRVD,"-",2)
 .. S BLRAP=""
 .. F  S BLRAP=$O(^LR("BLRA",BLRADUZ,BLRAS,BLRVD,BLRAP)) Q:BLRAP=""  D
 ... ;S BLRIDT=$P(BLRVD,"-",2),BLRSS=$G(^LR("BLRA",BLRADUZ,BLRAS,BLRVD,BLRAP))
 ...;----- BEGIN IHS MODIFICATIONS LR*5.2
 ...S BLRSS=""
 ...F  S BLRSS=$O(^LR("BLRA",BLRADUZ,BLRAS,BLRVD,BLRAP,BLRSS)) Q:BLRSS=""  D
 ....;W !,BLRVD,"  ",BLRAP,"  ",BLRSS
 ....;S BLRIDT=$P(BLRVD,"-",2)
 ....;----- END IHS MODIFICATIONS
 .... S BLRA0=$G(^LR(BLRAP,BLRSS,BLRIDT,0))
 .... ;
 .... S BLRADATA=$G(^LR(BLRAP,BLRSS,BLRIDT,9009027))
 .... Q:BLRADATA=""  ;IHS/ITSC/TPF IF NO DATA DON'T PROCESS 07/23/2002
 .... ;W !,BLRVD,"  ",BLRAP,"  ",BLRSS
 .... S BLRAAB=+$P(BLRADATA,U,6),BLRAPD=+$P(BLRADATA,U,7)
 .... S BLRCRTL=+$P(BLRADATA,U,8),BLRARPHY=$P(BLRADATA,U,2)
 .... S BLRRCT=+$P(BLRADATA,U,9)
 .... ;
 .... S BLRADTT=$P(BLRA0,U,1),BLRAOPH=$P(BLRA0,U,$S(BLRSS="MI":7,1:10))
 .... S BLRACCN=$P(BLRA0,U,6)
 .... S BLRAPFL=$P($G(^LR(BLRAP,0)),U,2),BLRAPIEN=$P(^(0),U,3)
 .... S BLRAPNM=$$GET1^DIQ(BLRAPFL,BLRAPIEN,.01,"E")
 .... ;
 .... S BLRASTAT=$S(BLRCRTL'=0:"CRIT",BLRAAB'=0:"ABN",BLRRCT'=0:"N/A",1:"NOR"),BLRASTA=BLRASTAT
 .... I BLRASTAT="CRIT" S BLRASTAT="AA"
 .... ;
 .... I $G(BLRASRT)="" D
 ..... ;S ^TMP("BLRA",$J,BLRASTAT,BLRVD,BLRAP)=BLRACCN_U_BLRAPNM_U_BLRADTT_U_BLRARPHY_U_BLRASTA_U_$S(BLRAPD=0:"YES",1:"PEND")
 ..... ;----- BEGIN IHS MODIFICATIONS LR*5.2
 ..... S ^TMP("BLRA",$J,BLRASTAT,BLRVD,BLRAP,BLRSS)=BLRACCN_U_BLRAPNM_U_BLRADTT_U_BLRARPHY_U_BLRASTA_U_$S(BLRAPD=0:"YES",1:"PEND")
 ..... ;----- END IHS MODIFICATIONS
 ..... Q:$G(BLRACCN)=""  ;IHS/ITSC/TPF 03/26/02 TEMPORARY FIX PER CNR (CARL RANDALL MITRTEK)
 ..... S ^TMP("BLRA",$J,"ZNODE",BLRACCN)=BLRAP_U_BLRSS_U_BLRIDT
 ....;
 .... I $G(BLRASRT)="P" D
 ..... S ^TMP("BLRA",$J,BLRAPNM,BLRASTAT,BLRVD,BLRSS)=BLRACCN_U_BLRAPNM_U_BLRADTT_U_BLRARPHY_U_BLRASTA_U_$S(BLRAPD=0:"YES",1:"PEND")
 ..... S ^TMP("BLRA",$J,"ZNODE",BLRACCN)=BLRAP_U_BLRSS_U_BLRIDT
 Q
 ;
CSUP ;EP
 ;  Check for all subordinates of a Clinician Supervisor
 K ^TMP("BLRA",$J) S BLRAHDR="***SUBORDINATE PROVIDERS***"
 S BLRADUZ=""
 F  S BLRADUZ=$O(^BLRALAB(9009027.1,"C",DUZ,BLRADUZ)) Q:BLRADUZ=""  D FND
 Q
 ;
PATS ;EP
 ; Patient sort
 S BLRASRT="P"
 D SELF
 Q
