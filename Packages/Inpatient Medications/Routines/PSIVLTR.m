PSIVLTR ;BIR/PR-BUILD LABEL TRACKER FOR ACTIVITY LOG ;03-Aug-2012 14:34;PB
 ;;5.0; INPATIENT MEDICATIONS ;**3,1015**;16 DEC 97;Build 62
 ;This routine needs the following parameters:
 ;TRACK - only defined if label action is dispensed or suspended
 ;        1=Ind lbs, 2=Sched lbs, 3= Sus lbs, 4= Order act lab
 ;ACTION - What is being done with the labels
 ;1=Dispensed, 2=Recycled, 3=Destroyed, 4=Cancelled, 5=Suspended
 ;PSIVNOL- number of labels being acted on
 ;DFN - Patient
 ;ON - Order number
 ;L +^PS(55,DFN,"IV",0)
 ;
 ; Modified - IHS/MSC/PB -04/25/12 - Modified to add the Stability Offset Value to the Label multiple in PS(55
 ;
 S:'$D(^PS(55,DFN,"IV",+ON,"LAB",0)) ^(0)="^55.1111^^" S N=^(0)
 F DA=$P(N,U,3)+1 I '$D(^PS(55,DFN,"IV",+ON,"LAB",DA)) S $P(N,U,3)=DA,$P(N,U,4)=$P(N,U,4)+1,^PS(55,DFN,"IV",+ON,"LAB",0)=N Q
 D NOW^%DTC D @ACTION G K
 ;
1 ;Dispensed
 S J=DA_U_%_U_ACTION_U_DUZ_U_PSIVNOL_U_TRACK_U_$S('$D(PSIVCT):1,1:0),^PS(55,DFN,"IV",+ON,"LAB",DA,0)=J
 Q
 ;
2 ;Recycled
 S J=DA_U_%_U_ACTION_U_DUZ_U_PSIVNOL D ERROR S ^PS(55,DFN,"IV",+ON,"LAB",DA,0)=J
 Q
3 ;Destroyed
 S J=DA_U_%_U_ACTION_U_DUZ_U_PSIVNOL D ERROR S ^PS(55,DFN,"IV",+ON,"LAB",DA,0)=J
 Q
4 ;Cancelled
 S J=DA_U_%_U_ACTION_U_DUZ_U_PSIVNOL D ERROR S ^PS(55,DFN,"IV",+ON,"LAB",DA,0)=J
 Q
5 ;Suspended
 S J=DA_U_%_U_ACTION_U_DUZ_U_PSIVNOL_U_TRACK,^PS(55,DFN,"IV",+ON,"LAB",DA,0)=J
 ;IHS/MSC/PB - 4/25/12 Next line added to compute and add the Stablity Offset Value to the Label Multiple in PS(55
 D OFFSET
 Q
ERROR ;Set piece 8 if user is in the wrong IV room.
 I $D(E)&($D(E1)) S $P(J,U,8)=E1_" "_E
 Q
K ;
 ;L -^PS(55,DFN,"IV",0) K DA,J,%,N,TRACK,ACTION
 K DA,J,%,N,TRACK,ACTION
 Q
OFFSET; IHS/MSC/PB - 4/25/12 added to compute the Stability Offset Value and add to the label multiple in PS(55
 ;S:$P(^PS(59.5,+$G(P("IVRM")),9999999),"^")=1 OFFSET=$P(^PS(55,DFN,"IV",+ON,9999999),"^")
 ;IHS/MSC/PB - 08/03/12 modified the line to correct the assumption the node would always exist
 S:$P($G(^PS(59.5,+$G(P("IVRM")),9999999)),"^")=1 OFFSET=$P($G(^PS(55,DFN,"IV",+ON,9999999)),"^")
 D NOW^%DTC S DOFF=$P(%,"."),SOFF=$$FMADD^XLFDT(DOFF,$G(OFFSET),0,0,0),^PS(55,DFN,"IV",+ON,"LAB",DA,9999999)=SOFF
 K SOFF,DOFF,OFFSET
 Q
