ABSPOSUA ; IHS/FCS/DRS - sort and print utilities ;    
 ;;1.0;PHARMACY POINT OF SALE;**37**;JUN 21, 2001
 Q
DEFDEST()          Q "^TMP("""_$T(+0)_""","_$J_",1)" ; default dest for sort
SAVEAREA()         Q "^TMP("""_$T(+0)_""","_$J_",2)" ; if you save old vers.
SAVEOLD K @$$SAVEAREA M @$$SAVEAREA=@$$DEFDEST Q
 ;
SORT(USER,PATDFN,TDIF,INIT,DEST,LOCK) ;EP - from ABSPOS6I
 ; USER = DUZ or 0 for all users
 ; USER = DUZ # you want;  MINS = within the last N minutes
 ;  (Because of timing, you might catch a prescription more than once)
 ; PATDFN = a particular patient or 0 for all patients
 ; TDIF = days.hhmmss = 0.0015, for instance, for last 15 minutes
 ; or TSINCE, e.g. 2991105.140305, for changes since absolute time
 ; If TDIF is given, TSINCE is computed from NOW^%DTC and TDIF 
 ; TDIF can be positive and we'll take care of treating it as minus.
 ; TDIF can theoretically be   days.hhmmss  but in practice it's
 ;  either one or the other.
 ; INIT = 1 if you want to init list (erase what's there now)
 ; DEST defaults to ^TMP("ABSPOSUA",$J)
 ;      If it's a global,it must begin with ^TMP( or ^UTILITY(
 ; LOCK defaults to 1, Lock file 9002313.59
 ;   It seems that not locking really does lead to some misleading
 ;   displays.
 ; - - - - - It builds this: - - - - -
 ; @DEST=how many patients
 ; @DEST@(patname)=how many prescriptions for this patient
 ; @DEST@(patname,"RXI",ABSBRXI)=status^datetime last update
 ; And this node, which we aren't using anymore:
 ; @DEST@(patname,100-status,9'sDate9'sTime,ABSBRXI)="" for each presc
 ;
 ; Returns the root reference of the DEST.
 ;
SORT0 N ROU S ROU=$T(+0)
 I '$D(USER) S USER=0
 I '$D(PATDFN) S PATDFN=0
 I '$D(TDIF) S TDIF=0.001500
 I '$D(INIT) S INIT=1
 I '$D(DEST) S DEST=$$DEFDEST
 I $E(DEST)="^",$P(DEST,"(")'="^TMP",$P(DEST,"(")'="^UTILITY" D  Q
 . D IMPOSS^ABSPOSUE("P","TI","we cannot use "_DEST_" for scratch storage",,,$T(+0))
 I '$D(LOCK) S LOCK=1
SORT1 N NOW,%,%H,%I,X D NOW^%DTC S NOW=%
 N TIME,STARTTIM ;S (TIME,STARTTIM)=$$TADD(NOW,TDIF)
 N ROOT S ROOT="^ABSPT"
 I TDIF>2990000 S (TIME,STARTTIM)=TDIF ; absolute time was given
 E  S (TIME,STARTTIM)=$$TADD(NOW,TDIF*$S(TDIF>0:-1,1:1)) ; delta
 I INIT K @DEST S @DEST=0
 I $G(LOCK) L +@ROOT:3600
 D SORT2
 I $G(LOCK) L -@ROOT
 Q:$Q DEST Q
 ;
SORT2 ; If doing one particular patient, then use the patient index
 I PATDFN D
 . S STARTTIM=STARTTIM\1
 . S RXI="" F  S RXI=$O(@ROOT@("AC",PATDFN,RXI)) Q:'RXI  D
 . . Q:$P($G(@ROOT@(RXI,0)),U,8)<STARTTIM
 . . D SORT3
 E  D  ; If doing the usual time search, use the time index
 . F  D  S TIME=$O(@ROOT@("AH",TIME)) Q:'TIME
 . . S RXI="" F  S RXI=$O(@ROOT@("AH",TIME,RXI)) Q:'RXI  D SORT3
 Q
SORT3 ;
 N X S X=$G(@ROOT@(RXI,0)) Q:X=""
 I USER,$P(X,U,10)'=USER Q
 I PATDFN,$P(X,U,6)'=PATDFN Q
 ;IHS/OIT/SCR 021110 patch 37 START don't add this RX if it is closed
 N ABSPCLSD
 S ABSPCLSD=$P($G(@ROOT@(RXI,9)),U,1)
 Q:ABSPCLSD
 ;IHS/OIT/SCR 021110 patch 37 END don't add this RX if it is closed
 ; Compute time diff with record - in case index is corrupted
 ; Criteria met - so include this record
 N STATUS S STATUS=$P(X,U,2)
 N STAT99 S STAT99=100-STATUS
 N TIME99 S TIME99=9999999.99999999-$P(X,U,8)
 I 'PATDFN N PATDFN S PATDFN=$P(X,U,6)
 N PATNAME I PATDFN S PATNAME=$P($G(^DPT(PATDFN,0)),U)
 S:$G(PATNAME)="" PATNAME="Patient `"_PATDFN
 I '$D(@DEST@(PATNAME)) S @DEST=@DEST+1,@DEST@(PATNAME)=0
 E  I $D(@DEST@(PATNAME,"RXI",RXI)) Q  ; timing - we got this twice
 ;W "TIME=",TIME,",RXI=",RXI,",",$ZR,"=",@$ZR," now increment..."
 S @DEST@(PATNAME)=@DEST@(PATNAME)+1
 ;W "=",@$ZR,! H 1
 S @DEST@(PATNAME,STAT99,TIME99,RXI)=""
 S @DEST@(PATNAME,"RXI",RXI)=$S(STATUS=99:100,1:STATUS)_U_TIME
 Q
DISP(USER) ; display @ROOT@(pat,status99,time99,rxi)
 N ROU S ROU=$T(+0) N X,Y,I,RXI
 I '$G(^TMP("ABSPOSUA",$J)) D  Q
 .W "None" W:$G(USER) " for ",$P(^VA(200,USER,0),U) W ! Q
 S X="" F  S X=$O(^TMP("ABSPOSUA",$J,X)) Q:X=""  D
 .S Y="" F  S Y=$O(^TMP("ABSPOSUA",$J,X,Y)) Q:Y=""  D
 ..S RXI="" F  S RXI=$O(^TMP("ABSPOSUA",$J,X,Y,RXI)) Q:RXI=""  D
 ...N X,Y D DISP1
 Q
TT() Q "S:Y[""."" Y=$P(Y,""."",2) S Y=Y_""000000"" S Y=""@""_$E(Y,1,2)_"":""_$E(Y,3,4)_"":""_$E(Y,5,6)" ; TT is kind of like ^DD("DD") but just for our times
DISP1 ; given RXI
 N REC M REC=^ABSPT(RXI)
 N X,Y
 N TT S TT=$$TT
 F I=0:1:2 I '$D(REC(I)) S REC(I)=""
 N STAT S STAT=$P(REC(0),U,2)
 W "`",RXI," "
 N PAT S PAT=$P(REC(0),U,6)
 I PAT W " ",$P($G(^DPT(PAT,0)),U)," "
 W:STAT'=99 "in Q",STAT,":" W $E($$STATI^ABSPOSU(STAT),1,30)
 S Y=$P($P(REC(0),U,8),".",2) X TT W " ",Y
 I STAT'=99 G DISP99
 D DISPRESP
DISP99 W !
 Q
DISPRESP ;EP - ABSPOS6M
 ; Given REC(2) = result, RXI = prescription
 N RES S RES=$P(REC(2),U)
 I RES=0 D  ; good, go to the claim response and see what it says
 .N RSP D RESPINFO^ABSPOSQ4(RXI,.RSP)
 .I RSP("HDR")'="Accepted" D  ; happily noninteresting if "Accepted"
 ..;ABSP*1.0T7*6 removed erroneous call to SHOULDNT
 ..;W !?10,"Response Status (Header) = ",RSP("HDR"),", " D SHOULDNT W ! ; ABSP*1.0T7*6
 ..W !?10,"Response Status (Header) = ",RSP("HDR") W ! ; ABSP*1.0T7*6
 .W " ",RSP("RSP") ; Payable, Rejected, Captured, Duplicate
 .I RSP("MSG")]"" W !?10,RSP("MSG")
 .N I F I=1:1:RSP("REJ",0) W !?10,RSP("REJ",I)
 E  D
 .W " result: ",RES
 .I $P(REC(2),U,2)]"" W !?5,$P(REC(2),U,2,$L(REC(2),U))
 Q
SHOULDNT W "this should never happen" Q
TDIF(T1,T2)        ; compute time difference T1-T2 = how many seconds
 ;T1,T2 both Fileman date.times
 S T1=$TR($J(T1,16,8)," ","0"),T2=$TR($J(T2,16,8)," ","0")
 N R S R=$P(T1,".")-$P(T2,".")*86400 ; days' difference
 S T1=$P(T1,".",2),T2=$P(T2,".",2) ; hhmmsstt
 S T1=$E(T1,1,2)*60+$E(T1,3,4)*60+$E(T1,5,6)
 S T2=$E(T2,1,2)*60+$E(T2,3,4)*60+$E(T2,5,6)
 I $E(T1,7,8) S T1=$E(T1,7,8)/100+T1
 I $E(T2,7,8) S T2=$E(T2,7,8)/100+T2
 S R=R+T1-T2
 Q R
TADDE D IMPOSS^ABSPOSUE("DB,P","TI","Bad T1="_T1,,"TADD",$T(+0)) Q
TADD(T1,T2)        ; FOR THIS ROUTINE'S USE ONLY - ALL OTHERS USE TADD^ABSPOSUD
 ; add T2 time differential to T1
 ; T2 = number of days.hhmmsstt (mixed, not pure va date)
 N X,X1,X2,%H,%T,%Y,H1,H2,SGN,%
 I T1<0 D TADDE ; but T2 can be negative
 S SGN=$S(T2<0:-1,1:1)
 S X2=$P(T2,".") ; days difference, maybe with sign
 I X2 S X1=T1 D C^%DTC S T1=X
 S $P(T2,".")="",T2=T2_"00000000" ; the days part is done
 ; T2=.hhmmsstt now, positive amount
 I 'T2 Q T1 ; days only, no seconds to compute
 S X=T1 D H^%DTC S $P(%H,",",2)=%T ; %H = T1 in $H format
 ;W "before convert to seconds, T2=",T2,!
 S %=T2,T2=$E(%,2,3)*60+$E(%,4,5)*60+$E(%,6,7)*SGN ; T2 in secs
 ;W "after convert to seconds, T2=",T2,!
 ;W "%H=",%H,", T2=",T2,!
 S $P(%H,",",2)=$P(%H,",",2)+T2 ; add the seconds
 ;W "Add the T2 seconds to %H, giving ",%H
TADDLOOP I $P(%H,",",2)<0 D  G TADDLOOP ; borrow 1 day = 86400 seconds
 . S $P(%H,",")=$P(%H,",")-1,$P(%H,",",2)=$P(%H,",",2)+86400
 E  I $P(%H,",",2)>86400 D  G TADDLOOP ; carry 86400 secs = 1 day
 . S $P(%H,",")=$P(%H,",")+1,$P(%H,",",2)=$P(%H,",",2)-86400
 ;W "any carry/borrow done, and %H=",%H,!
 D YMD^%DTC
 Q X_%
