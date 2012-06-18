BLRALBD ;DAOU/ALA-Build data for a selected accession [ 11/18/2002  1:32 PM ]
 ;;5.2;LR;**1013,1015**;NOV 18, 2002
 ;
 ;**Program Description**
 ;  This program will build the lab result data for a
 ;  selected accession.
 ;
 ;  Input Parameters
 ;    LRDFN = Lab Patient IEN
 ;    LRIDT = Lab Result Reverse Date
 ;    LRSS  = Lab Result Type ('CH', 'MI', etc.)
 ;
CH ;EP
 ; Clinical Chemistry
 K ^TMP("LR",$J,"TP"),LRTP,^TMP($J,"BLRA"),LRORD
 ;
 ;  Set patient data which needs LRDFN
 D PT^LRX
 ;  returns variables needed for header in HDR^BLRALBA
 ;D HDR^BLRALBA
 ;
 S:'$D(LRTSCRN) LRTSCRN=0
 S LRLAB=$S($D(LRLABKY):1,1:0),LRHF=1,LRFOOT=0,LRCW=8
 S LR0=$G(^LR(LRDFN,"CH",LRIDT,0)) Q:'$P(LR0,U,3)
 S LRCDT=+LR0,LRSS="CH",LROC=$P(LR0,U,11),LRAA=""
 S LRAAO=1,LRTC=0,LRSPEC=$P(LR0,U,5),LRDN=1
 ;
 ;  Loop through and setup lab tests
 F  S LRDN=$O(^LR(LRDFN,"CH",LRIDT,LRDN)) Q:LRDN<1  D
 . S LRTSTS=$O(^LAB(60,"C","CH;"_LRDN_";1",0)) D SETUP^LRRP
 ;
 ;  Setup comments
 D CMNT^LRRP
 ;
 ;  Builds ^TMP($J,"BLRA",#,0) for display
 D ^BLRALBA
 ;  returns the total number of lines = BLRADSP
 Q
 ;
MI ;EP
 ; Microbiology
 S BLRADSP=0,$P(BLRABLKS," ",80)=""
 K ^TMP($J,"BLRA")
 ;
 ;  Builds ^TMP($J,"BLRA",#,0) for display
 D ^BLRALBM
 ;  returns the total number of lines = BLRADSP
 Q
