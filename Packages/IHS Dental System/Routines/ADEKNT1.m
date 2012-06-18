ADEKNT1 ; IHS/HQT/MJL - COMPILE DENTAL REPORTS ;   [ 04/03/2001  6:56 PM ]
 ;;6.0;ADE;**7**;APR 03, 2001
 ;
ARRAY(ADESELOB) ;EP -Initialize counter arrays for each objective in ADESELOB
 ;^TMP($J,"CTR",Objective,age)="QTR^YR^3YR^BeginDOB^EndDOB"
 ;^TMP($J,"CTR",Objective,age,Facility)="QTR^YR^3YR^BeginDOB^EndDOB"
 ;^TMP($J,"CTR",Objective,"LOGIC")="Set logic in ^ADEKOB(D0,1)"
 ;
 N ADEOBJ,ADENOD,ADEOBN,ADEGRP,ADEDOB1,ADEDOB2,I,J,K
 S ADEOBJ=0
 I ADESELOB["ALL" F  S ADEOBJ=$O(^ADEKOB(ADEOBJ)) Q:'+ADEOBJ  D ARRAY1
 I ADESELOB'["ALL" F J=1:1:$L(ADESELOB,";") S ADEOBJ=+$P(ADESELOB,";",J) D:+ADEOBJ ARRAY1
 I ADESELOB["USER" F J=1:1:6 S ADEOBJ=J D ARRAY1
 I ADESELOB["DATE" D
 . F  S ADEOBJ=$O(^ADEKOB("AD","v",ADEOBJ)) Q:'+ADEOBJ  D ARRAY1
 . F  S ADEOBJ=$O(^ADEKOB("AD","d",ADEOBJ)) Q:'+ADEOBJ  D ARRAY1
 Q
ARRAY1 S ADENOD=^ADEKOB(ADEOBJ,0)
 S ADEOBN=ADEOBJ
 S ^TMP($J,"CTR",ADEOBN,"LOGIC")="LOGIC CODED"
 I $D(^ADEKOB(ADEOBJ,1)) S ^TMP($J,"CTR",ADEOBJ,"LOGIC")=$P(^ADEKOB(ADEOBJ,1),U)
 S ^TMP($J,"CTR",ADEOBJ,"LOGIC")=$TR(^TMP($J,"CTR",ADEOBJ,"LOGIC"),";","^")
 S ADEGRP=$P(ADENOD,U,3)
 S:ADEGRP="ALL" ADEGRP="0:125"
 I ADEGRP="EACH" D
 . N J
 . S ADEGRP=""
 . F J=0:1:74 S $P(ADEGRP,";",J+1)=J_":"_J
 . S $P(ADEGRP,";",76)="75:125"
 F I=1:1:$L(ADEGRP,";") D
 . S ADEDOB1=$P($P(ADEGRP,";",I),":")
 . S ADEDOB2=$P($P(ADEGRP,";",I),":",2)
 . S ADEDOB1=ADEED-(ADEDOB1*10000)
 . S ADEDOB2=ADEED+1-(10000*(ADEDOB2+1))
 . S ^TMP($J,"CTR",ADEOBN,$P(ADEGRP,";",I))="0^0^0^"_ADEDOB2_U_ADEDOB1
 . F K=1:1:$L(ADEFAC,"^") D
 . . S ^TMP($J,"CTR",ADEOBN,$P(ADEGRP,";",I),$P(ADEFAC,U,K))="0^0^0^"_ADEDOB2_U_ADEDOB1
 Q
 ;
DATE ;EP
 ;Calculate Daily and Visit level objectives
 ;
 N ADEB,ADEDATE,ADECNT,ADE,ADE0130,ADE9170
 N ADEL,ADENOD,ADEDDS,ADEVDATA,ADELOE
 S ADEB=$P(ADE3BD,".")-1
 S ADEDATE=ADEB
 S ADECNT=0
 S ADE0130=$O(^AUTTADA("B","0140",0))
 S:'+ADE0130 ADE0130=0
 S ADE9170=$O(^AUTTADA("B","9170",0))
 S:'+ADE9170 ADE9170=0
 ;
 ;Starting with ADE3BD, $O thru ^ADEPCD("DATE"
 F  S ADEB=$O(^ADEPCD("AC",ADEB)) Q:'+ADEB  Q:$P(ADEB,".")>ADEED  D
 . ;If the Day has changed, do the daily objectives:
 . ; and reset the date variable ADEDATE
 . I $P(ADEB,".")>ADEDATE D
 . . D DSTUFF(ADEDATE,ADECNT,"")
 . . S ADEL="" F  S ADEL=$O(ADECNT(ADEL)) Q:'+ADEL  D
 . . . Q:'+ADECNT(ADEL)
 . . . D DSTUFF(ADEDATE,ADECNT(ADEL),ADEL)
 . . ;Reset Date
 . . S ADEDATE=$P(ADEB,".")
 . . ;Reset Counter
 . . K ADECNT S ADECNT=0
 . . ;Kill Dentist Marker ADE( array
 . . K ADE,ADELOE
 . ;
 . ;For each visit on that day:
 . ;1) Increment both general and facility dentist-day counter:
 . ;   get the dentist dfn ADEDDS
 . ;   If dentist hasn't already been counted for that day
 . ;   i.e., $D(ADE(ADEDDS))'=1 
 . ;   then increment counter ADECNT and
 . ;   set dentist marker array ADE(ADEDDS)=""
 . ;   Do same for facility level counter ADELOE(ADEDDS)
 . ;2) Call visit-level objectives:
 . ;    Load visit data in ADEVDATA
 . ;    Call VSTUFF(VisitData)
 . ;
 . S ADEC=0
 . ; For each visit ADEC
 . F  S ADEC=$O(^ADEPCD("AC",ADEB,ADEC)) Q:'+ADEC  D
 . . ;
 . . ;First, increment the dentist counter ADECNT if the dentist
 . . ;hasn't already been counted i.e. '$D(ADE(ADEDDS))
 . . Q:'$D(^ADEPCD(ADEC,0))
 . . S ADENOD=^ADEPCD(ADEC,0)
 . . S ADELOE=$P(ADENOD,U,3)
 . . S ADEDDS=$P(ADENOD,U,4)
 . . Q:'+ADEDDS
 . . D  ;Increment dentist counter
 . . . ;If dentist has not already been counted
 . . . ; increment counter ADECNT
 . . . ; and mark dentist as having been counted
 . . . I '$D(ADE(ADEDDS)) D
 . . . . S ADECNT=ADECNT+1
 . . . . S ADE(ADEDDS)=""
 . . . I '$D(ADELOE(ADEDDS)) D
 . . . . I '$D(ADECNT(ADELOE)) S ADECNT(ADELOE)=0
 . . . . S ADECNT(ADELOE)=ADECNT(ADELOE)+1
 . . . . S ADELOE(ADEDDS)=""
 . . . Q
 . . ;Now get visit level data into ADEVDATA and call VSTUFF
 . . ; In this version, the only visit level data is
 . . ; a count of emergency visits
 . . ; so $P(ADEVDATA,U,2) = 1 if the visit contains 9170 or 0140
 . . ;
 . . ;$P(ADEVDATA,U,1) = Native/Non-Native:
 . . S $P(ADEVDATA,U)=$$INDIAN^ADEKNT($P(ADENOD,U))
 . . ;Get DOB and set up ADEOBJ( array
 . . S ADEDOB=$P($G(^DPT($P(ADENOD,U),0)),U,3)
 . . Q:'+ADEDOB
 . . D ADEOBJ^ADEKNT(ADEDOB)
 . . S $P(ADEVDATA,U,2)=0
 . . I $D(^ADEPCD(ADEC,"ADA","B",ADE0130)) S $P(ADEVDATA,U,2)=1
 . . I $D(^ADEPCD(ADEC,"ADA","B",ADE9170)) S $P(ADEVDATA,U,2)=1
 . . ; Future versions may store more in ADEVDATA, so will
 . . ;  have to remove the IF in next line
 . . Q:'+$P(ADEVDATA,U,2)
 . . S $P(ADEVDATA,U,3)=ADELOE
 . . D VSTUFF(ADEDATE,ADEVDATA)
 . Q
 ;
 ;B  ;***Remove after testing
 ;Pick up any data left over from last visit day:
 D DSTUFF(ADEDATE,ADECNT,"")
 S ADEL="" F  S ADEL=$O(ADECNT(ADEL)) Q:'+ADEL  D
 . Q:'+ADECNT(ADEL)
 . D DSTUFF(ADEDATE,ADECNT(ADEL),ADEL)
 Q
 ;
DSTUFF(ADEDATE,ADEDDATA,ADELOE) ;EP - do DAILY objectives
 ;Do DAILY objectives using the data in ADEDDATA
 ;Call INCREM using date in ADEDATE, location ADELOE
 ;
 N ADEIEN,ADEOBJ
 S ADEIEN=0
 F  S ADEIEN=$O(^ADEKOB("AD","d",ADEIEN)) Q:'+ADEIEN  D
 . ;Daily counters are not age-related, thus all are "0:125"
 . S ADEOBJ(ADEIEN)="0:125"
 . X ^TMP($J,"CTR",ADEIEN,"LOGIC")
 Q
VSTUFF(ADEDATE,ADEVDATA) ;EP - do VISIT objectives
 ;Do VISIT objectives using the data in ADEDDATA
 ;Call INCREM using date in ADEDATE
 ;
 N ADEIEN
 S ADEIEN=0
 F  S ADEIEN=$O(^ADEKOB("AD","v",ADEIEN)) Q:'+ADEIEN  D
 . Q:'$D(ADEOBJ(ADEIEN))
 . X ^TMP($J,"CTR",ADEIEN,"LOGIC") ;D EMVIS;ADEKNT1(ADEDATE,ADEVDATA,1)
 Q
 ;
DENDAY(ADEVD,ADEDDATA,ADELOE) ;EP
 ;
 ;The first ^-piece of ADEDDATA is the number of dentists who
 ; provided care on day ADEVD at location ADELOE
 ; If ADELOE="" then the count is for all facilities
 D INCREM^ADEKNT2(ADEIEN,ADEOBJ(ADEIEN),ADELOE,ADEVD,+ADEDDATA)
 Q
 ;
EMVIS(ADEVD,ADEVDATA,ADELIM)        ;EP
 ;
 ;ADEVDATA is ^-piece 1 "1-ind 2-nonind 0-all"
 ; ^-piece2 "1:Emergency visit, 0:not an emergency visit"
 ; based on whether the visit had an 0130 or 9170 code
 ; ^-piece3 is location
 I ADELIM Q:'(ADELIM=+ADEVDATA)
 Q:'+$P(ADEVDATA,U,2)
 D INCREM^ADEKNT2(ADEIEN,ADEOBJ(ADEIEN),"",ADEVD,1)
 D INCREM^ADEKNT2(ADEIEN,ADEOBJ(ADEIEN),$P(ADEVDATA,U,3),ADEVD,1)
 Q
