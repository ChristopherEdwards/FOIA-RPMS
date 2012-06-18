ABSPOSU7 ; IHS/FCS/DRS - misc. utilities ;   
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
 ; delete antique, hopeless .59s [ 09/14/2000  8:36 AM ]
 ; How can they possibly get stranded?
 ; Well, this cleans them up
PURGE(HRS) ;EP - purge all the ones older than HRS hours 
 W !
 I '$D(HRS) D  Q:'$G(HRS)
 . W "Unstrand all the claims which haven't been updated",!
 . N PROMPT S PROMPT="in how many hours? "
 . N DEF S DEF=24
 . N OPT S OPT=1
 . N MIN,MAX S MIN=.05,MAX=99999999 ; .05 hours = 3 minutes
 . S HRS=$$NUMERIC^ABSPOSU2(PROMPT,DEF,OPT,MIN,MAX,2) ; 2 = dec. places
 . I HRS<MIN K HRS
 . W !
 W "Stranded claims survey and cleanup; HRS=",HRS,"   ",$$NOWEXT^ABSPOSU1,!
 N COUNT S (COUNT,COUNT("SET TO COMPLETE"))=0
 N SECS S SECS=HRS*60*60 ; ABSP*1.0T7*5 ; needed an extra *60
 N STAT S STAT=""
 F  S STAT=$O(^ABSPT("AD",STAT)) Q:STAT=""  D
 . Q:STAT=99  ; complete
 . N IEN59 S IEN59=""
 . F  S IEN59=$O(^ABSPT("AD",STAT,IEN59)) Q:IEN59=""  D
 . . S COUNT=COUNT+1
 . . I '$D(^ABSPT(IEN59,0)) D  Q  ; should never happen
 . . . W "STAT=",STAT,", IEN59=",IEN59," has no 0 node",!
 . . N LAST S LAST=$P(^ABSPT(IEN59,0),U,8)
 . . I 'LAST D  Q  ; should never happen
 . . . W "STAT=",STAT,", IEN59=",IEN59," has no LAST UPDATE time",!
 . . N AGE,AGEI
 . . S AGEI=$$TIMEAGOI^ABSPOSUD(LAST),AGE=$$TIMEAGO^ABSPOSUD(LAST)
 . . W IEN59," last update ",LAST," which was ",AGE," ago",!
 . . I AGEI>SECS D
 . . . W ?10,"setting it to complete..."
 . . . D PURGE1(IEN59)
 . . . W "done.",!
 . . . S COUNT("SET TO COMPLETE")=COUNT("SET TO COMPLETE")+1
 . . E  D
 . . . W ?10,"nothing done to this claim.",!
 D ZWRITE^ABSPOS("COUNT")
 Q
PURGE1(IEN59)      ;
 N ABSBRXI S ABSBRXI=IEN59
 D SETSTAT^ABSPOSU(99)
 D SETRESU^ABSPOSU(-1,"mark incomplete claim as stranded after "_AGE)
 Q
PURGEALL D PURGE(0) Q  ; should only be done by programmer?
