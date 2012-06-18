DGACT ;ALB/CAW - Active check for facility TS or Specialty ; [ 09/13/2001  3:02 PM ]
 ;;5.3;Registration;**64**;Aug 13, 1993
 ;IHS/ANMC/LJF  5/17/2001 added IHS check for admitting services
 ;
 ;
ACTIVE(FILE,IEN,DGDT) ; Extrinsic function to determine if TS entry is active
 ;
 ;     Input -- FILE to determine if checking facility TS or TS
 ;                  FACILITY TREATING SPECIALTY (45.7)
 ;                  SPECIALTY (42.4)
 ;          IEN is the internal IFN of whichever file passed in
 ;       DGDT as 'as of' date (uses DT if undefined)
 ;    Output -- 1 if active, 0 otherwise
 ;
 N DGID,Y,X
 S DGID=$S($G(DGDT):DGDT,1:DT)
 S DGID=$S('$P(DGID,".",2):(DGID-1)_.2359,1:(DGID-1)),DGID=-DGID
 S Y=0
 S ID=$O(^DIC(FILE,IEN,"E","ADATE",DGID)) G:'ID ACTIVEQ
 S ID=$O(^DIC(FILE,IEN,"E","ADATE",ID,0))
 S X=$G(^DIC(FILE,IEN,"E",ID,0)) I 'X G ACTIVEQ
 I $P(X,"^",2)=1 S Y=1
 ;
 ;IHS/ANMC/LJF 5/17/01 check if IHS admitting service
 I FILE=45.7,$P($G(^DIC(FILE,IEN,9999999)),U,3)'="Y" S Y=0
 ;
ACTIVEQ Q $S(Y:1,1:0)
