BMCPXCHK ; IHS/PHXAO/TMJ - CHECK CPT CAT/PX AT CLOSE TIME ;
 ;;4.0;REFERRED CARE INFO SYSTEM;**3**;JAN 09, 2006
 ;4.0*3 10.30.2007 IHS/OIT/FCJ ADDED CSV CHANGES
 ;
 ; This routine checks to insure the cpt category and the cpt
 ; procedures are logically consistent.
 ;
 ; BMCRIEN=referral ien
 ;
START ;
 NEW BMCCAT,BMCCIEN,BMCOK,BMCPX,BMCSIG,BMCTBL,BMCTIEN,BMCX,BMCY,X
 D CHECK ;                         check consistency
 Q:BMCOK  ;                        quit if ok
 D EN3^BMCBULL ;                   send bulletin
 Q
 ;
CHECK ; CHECK CATEGORY/CODES
 S BMCOK=1
 S BMCCAT=$P(^BMCREF(BMCRIEN,0),U,13)
 Q:'BMCCAT  ;                      no category to check
 S BMCTIEN=$P(^BMCTSVC(BMCCAT,0),U,2)
 Q:'BMCTIEN  ;                     no taxonomy to check
 Q:'$O(^BMCPX("AD",BMCRIEN))  ;    no pxs to check
 ; table all pxs for this referral
 S BMCY=0
 ;4.0*3 10.30.2007 IHS/OIT/FCJ ADDED CSV CHANGES
 ;F  S BMCY=$O(^BMCPX("AD",BMCRIEN,BMCY)) Q:'BMCY  S BMCCIEN=$P(^BMCPX(BMCY,0),U),BMCPX=$P(^ICPT(BMCCIEN,0),U),BMCTBL(BMCPX)=BMCCIEN
 F  S BMCY=$O(^BMCPX("AD",BMCRIEN,BMCY)) Q:'BMCY  S BMCCIEN=$P(^BMCPX(BMCY,0),U),BMCPX=$P($$CPT^ICPTCOD(BMCCIEN,0),U,2),BMCTBL(BMCPX)=BMCCIEN
 D CHECK2 ;                        see if significant px in category
 Q:BMCSIG  ;                       ok if significant px in category
 ; see if significant px in any other category
 S BMCY=0
 F  S BMCY=$O(^BMCTSVC(BMCY)) Q:'BMCY  D  Q:BMCSIG
 . Q:BMCY=BMCCAT  ;                quit if original category
 . S BMCTIEN=$P(^BMCTSVC(BMCY,0),U,2)
 . Q:'BMCTIEN  ;                   quit if no taxonomy
 . D CHECK2
 . Q
 Q:'BMCSIG  ;                      ok if no significant px at all
 S BMCOK=0
 Q
 ;
CHECK2 ; SEE IF SIGNIFICANT PX IN CATEGORY
 S BMCSIG=0,BMCPX=""
 F  S BMCPX=$O(BMCTBL(BMCPX)) Q:BMCPX=""  D  Q:BMCSIG
 . S BMCCIEN=BMCTBL(BMCPX)
 . S BMCSIG=$$TXC^ATXTXCHK(BMCCIEN,BMCTIEN)
 . Q
 Q
 ;
 ;
LOGIC ;
 ; ok if no category
 ; ok if no taxonomy
 ; ok if no procedures at all
 ; ok if significant procedure in specified category
 ; ok if no significant procedure in any category
 ; if significant procedure in some other category send bulletin
 ;
 ; cpt category present              |NYYYYY
 ; significant taxonomy present      | NYYYY
 ; procedures present                |  NYYY
 ; significant procedure in category |   YNN
 ; any significant procedures        |    NY
 ;
 ; send bulletin                     |     X
 ; exit                              |XXXXXX
