ACHSEP ; IHS/ITSC/PMF - utility to set certain counts equal automagically ;   [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
        ;;3.0;CONTRACT HEALTH MGMT SYSTEM;;SEP 17, 1997  
 ;utility to set certain counts equal automagically
 ;
 ;The node  ^ACHS("9",facility,"FY",year,"W","0") keeps
 ;a count of something two ways.  The counts are supposed
 ;to come out even, but they don't.
 ;
 ;It is unimportant, because instead of going back to find
 ;out why the counts differ, we just set them equal and go on.
 ;
 ;This utility allows a user to set the counts equal whenever
 ;they want.
 ;
 N COMMA,DATA,DATH,DOLH,FAC,FOUR,FY,HAT,ODAT,THREE
 ;
 D INIT
 ;
 W !!,"starting...",!
 ;
 S DOLH=$TR($H,COMMA,HAT) S DATH=+DOLH
 ;
 ;get rid of records older than 30 days
 S ODAT="" F  S ODAT=$O(^TEMP("ACHSEP",ODAT)) Q:ODAT=""  Q:+ODAT+30>DATH  K ^TEMP("ACHSEP")
 ;
 S ^TEMP("ACHSEP",DOLH)=""
 ;
 ;For each facility, get each fiscal year.
 ;   for each fiscal year, set the counts equal
 S FAC=0 F  S FAC=$O(^ACHS(9,FAC)) Q:FAC=""  D
 . S FY=0 F  S FY=$O(^ACHS(9,FAC,"FY",FY)) Q:FY=""  D
 .. S DATA=$G(^ACHS(9,FAC,"FY",FY,"W",0))
 .. I DATA="" Q
 .. S THREE=$P(DATA,HAT,3),FOUR=$P(DATA,HAT,4)
 .. I $R(3)'=2 I THREE=FOUR Q
 .. S $P(DATA,HAT,4)=THREE,^ACHS(9,FAC,"FY",FY,"W",0)=DATA
 .. S ^TEMP("ACHSEP",DOLH,FAC,FY)=THREE_HAT_FOUR
 .. Q
 . Q
 ;
 W !!,"finished. press return  ",!!! R HAT:60
 Q
INIT ;
 S COMMA=","
 S HAT="^"
 Q
