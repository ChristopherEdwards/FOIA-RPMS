BLRESRCD ; IHS/OIT/MKK - Laboratory E-SIG Reports: Compile Data ; [ 04/12/06  4:00 PM ]
 ;;5.2;LR;**1022**;September 20, 2007
 ;
 ; NOTE:  The LRIDT variable in the LR("BLRA") index is stored as
 ;        as a negative number.  That is why, in several places,
 ;        the code does -(LRIDT).
 ;
EP ; "Ersatz" EP
 W $C(7),$C(7),$C(7),!
 W "Use Label Only",!
 W $C(7),$C(7),$C(7),!
 Q
 ;
 ; Get E-SIG Data, Part 1
GETESIGD ; EP
 S NRESP=$P($G(^VA(200,ESPHY,0)),"^",1)    ; Resp Phy Name
 S BLRESIGR(NRESP)=ESPHY
 ;
 S STATUS=""           ; E-SIG Status
 F  S STATUS=$O(^LR("BLRA",ESPHY,STATUS))  Q:STATUS=""  D
 . D GETESIG2
 Q
 ;
 ; Get E-SIG data, Part 2
GETESIG2 ; EP
 S LRIDT=""           ; Inverse Date
 F  S LRIDT=$O(^LR("BLRA",ESPHY,STATUS,LRIDT))  Q:LRIDT=""  D
 . I LRIDT<BEGIDT!(LRIDT>ENDIDT) Q    ; Date must be in range
 . ;
 . S LRDFN=0           ; Patient Lab Reference Number
 . S LRDFN=$O(^LR("BLRA",ESPHY,STATUS,LRIDT,LRDFN))  Q:LRDFN=""  D
 .. S LRAA=""          ; Accession Area
 .. F  S LRAA=$O(^LR("BLRA",ESPHY,STATUS,LRIDT,LRDFN,LRAA))  Q:LRAA=""  D
 ... S BLRESIGR=$G(^LR(LRDFN,LRAA,-(LRIDT),9009027)) ; E-SIG String
 ... I $G(BLRESIGR)="" Q                    ; If Null, skip
 ... ;
 ... ; Patient Name
 ... S PATN=$P($G(^DPT($P($G(^LR(LRDFN,0)),"^",3),0)),"^",1)
 ... ;
 ... S BLRESIGR(NRESP,PATN,LRAA,LRDFN,-(LRIDT))=""
 Q
 ;
 ; Not Signed by Responsible Physician
NSIGNTXN ; EP
 S LRIDT=""
 F  S LRIDT=$O(^LR("BLRA",ESPHY,STATUS,LRIDT))  Q:LRIDT=""  D
 . I LRIDT<BEGIDT!(LRIDT>ENDIDT) Q    ; Date must be in range
 . ;
 . S LRDFN=0
 . S LRDFN=$O(^LR("BLRA",ESPHY,STATUS,LRIDT,LRDFN))  Q:LRDFN=""  D
 .. S LRAA=""
 .. F  S LRAA=$O(^LR("BLRA",ESPHY,STATUS,LRIDT,LRDFN,LRAA))  Q:LRAA=""  D
 ... S BLRESIGR=$G(^LR(LRDFN,LRAA,-(LRIDT),9009027)) ; E-SIG String
 ... I $G(BLRESIGR)="" Q
 ... I $P(BLRESIGR,"^",3)=ESPHY Q      ; If Responsible = Signing Phy, skip
 ... ;
 ... S PATN=$P($G(^DPT($P($G(^LR(LRDFN,0)),"^",3),0)),"^",1)
 ... ;
 ... S BLRESIGR(NRESP,PATN,LRAA,LRDFN,-(LRIDT))=""
 ... S CNT=CNT+1
 Q
