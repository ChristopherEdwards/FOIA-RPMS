AMQQDOH ; IHS/CMI/THL - AMQQDO SUBROUTINE...PRINTS OUTPUT HEADERS;
 ;;2.0;IHS PCC SUITE;**4**;MAY 14, 2009
 ;-----
 I $D(AMQV("OPTION")),AMQV("OPTION")="COUNT" Q
HEADER S X=""
 I '$D(ZTQUEUED),'$D(AMQQDIBT),AMQQTOT>1,$E(IOST,1,2)="C-" W !,"<>" R X:DTIME E  S X=U
 I X=U S AMQQQUIT="" F %=AMQQOV,.1,1,2,3,5,10 S AMQP(%)=99999999999
 I $D(AMQQQUIT) Q
IOF W @IOF
 I $E(IOST,1,2)="P-",$G(AMQQ200(3))]"" D TOP I 1
 E  W #
 I AMQQCCLS="H" D HH Q
 I AMQQCCLS="D" D HD Q
 I AMQQCCLS="V" D HV Q
 S W=$S('$D(AMQQCNAM):"        ",AMQQCNAM="LIVING PATIENTS":"(Alive)",1:"        ")
 F AMQQHDR="HF1","HF2" D
 .W:AMQQHDR[1 "PATIENTS",?17,AMQQLABB
 .W:AMQQHDR[2 !,W,?17,"NUMBER"
 .S J=$$CHKVA(24)
 .S %=""
 .F I=9:0 S I=$O(^UTILITY("AMQQ",$J,"VAR NAME",I)) Q:'I  S %=^(I) D
 ..S X=$P(%,U,3)
 ..S A=$P(%,U,2)
 ..S:'A A=1
 ..D @AMQQHDR
 .I $G(%),$P($G(^AMQQ(1,+%,0)),U,3)=9000010.01,$D(AMQQDVQU),AMQQHDR="HF1" D
 ..W ?J,"QUALIFIER"
 ..S J=J+2+20
 K W
 S %=""
 S $P(%,"-",IOM)=""
 W !,%,!
 K AMQQHDR,AMQQORCT
 Q
 ;
HV F AMQQHDR="HF1","HF2" W:AMQQHDR[1 "VISIT NO.   VISIT DATE" W:AMQQHDR[2 !?13,"AND TIME" S J=29 F I=9:0 S I=$O(^UTILITY("AMQQ",$J,"VAR NAME",I)) Q:'I  S %=^(I),X=$P(%,U,3),A=$P(%,U,2) S:'A A=1 D @AMQQHDR
HV1 S %=""
 S $P(%,"-",IOM)=""
 W !,%,!
 K AMQQHDR
 Q
 ;
HD F AMQQHDR="HF1","HF2" D
 .W:AMQQHDR[1 "POV NO."
 .W:AMQQHDR[2 !
 .S J=9
 .F I=9:0 S I=$O(^UTILITY("AMQQ",$J,"VAR NAME",I)) Q:'I  S %=^(I),X=$P(%,U,3),A=$P(%,U,2) S:'A A=1 D @AMQQHDR
 D HV1
 Q
 ;
HH F AMQQHDR="HF1","HF2" D
 .W:AMQQHDR[1 "PROVIDERS",?19,"IHS"
 .W:AMQQHDR[2 !,?19,"CODE"
 .S J=24
 .F I=9:0 S I=$O(^UTILITY("AMQQ",$J,"VAR NAME",I)) Q:'I  S %=^(I),X=$P(%,U,3),A=$P(%,U,2) S:'A A=1 D @AMQQHDR
 K W
 S %=""
 S $P(%,"-",IOM)=""
 W !,%,!
 K AMQQHDR
 Q
 ;
HF1 I X["\" S X=$P(X,"\")
 I X'="" W ?J,X S J=J+2+$P(%,U,4) Q
 D LABCONV^AMQQDO
 S X=^AMQQ(1,+%,4,A,0)
 S Y=$P(X,U,6)
 W ?J,$P(X,U,4)
 S J=J+2+Y
 Q
 ;
HF2 I X["\" S X=$P(X,"\",2) W ?J,X S J=J+2+$P(%,U,4) Q
 D LABCONV^AMQQDO
 S X=^AMQQ(1,+%,4,A,0)
 S Z=$P(X,U,7)
 S:Z["SERIES" Z=""
 I $P(X,U,8) S Z="#" ;_$P(%,U,4)
 I +%=179 S AMQQORCT=1+$G(AMQQORCT),Z="#"_AMQQORCT
 S Y=$P(X,U,6)
 I $P(%,U,4)>Y S Y=$P(%,U,4)
 W ?J
 I Z'="",A=1 W Z
 S J=J+2+Y
 Q
 ;
TOP W ?7,"*****   IHS Query Manager        Confidential Patient Data  *****"
 S %=$P(@AMQQ200(3)@(DUZ,0),U)
 S %=$P(%,",",2,9)_" "_$P(%,",")
 W !,"**  Report requested by ",%
 W ?64
 S Y=DT
 X ^DD("DD")
 W Y,"  **",!!
 Q
CHKVA(C) ;RETURN C+# IF VA, ELSE C
 Q $S('$D(DUZ("AG")):C,$E(DUZ("AG"))="V":C+3,1:C)
