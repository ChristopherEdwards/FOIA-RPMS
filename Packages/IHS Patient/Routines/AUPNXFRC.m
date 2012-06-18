AUPNXFRC ; IHS/CMI/LAB - XREF TRIGGER FROM #1117 (RESIDENCE COMMUNITY PT) TO LAST PREVIOUS COMMUNITY ;
 ;;99.1;IHS DICTIONARIES (PATIENT);;MAR 09, 1999
 ; This routine is triggered from the AH Mumps trigger on the residence
 ; community field (#1117) of the IHS patient file. It will update the
 ; Previous Community:community of Residence if Current Community #1118
 ; does not already equal the residence community
 ; This trigger and routine are to be removed when Previous Community
 ; goes away.
 ; data node is Date Entered^Date Moved^Community
S ;
 S AUPNXRC=$P(^AUPNPAT(D0,11),U,17),AUPNXCC=$P(^(11),U,18),AUPNXRCN=$P(^AUTTCOM(AUPNXRC,0),U)
 ;W !,^AUPNPAT(D0,11),!,AUPNXRCN
 I AUPNXCC=AUPNXRCN G END
 S:'$D(^AUPNPAT(D0,51,0)) ^(0)="^9000001.51^^0"
 S:'$D(^AUPNPAT(D0,51,DT,0)) $P(^(0),U,4)=$P(^AUPNPAT(D0,51,0),U,4)+1
 ;W !,$ZR,"=",@$ZR
 S ^AUPNPAT(D0,51,DT,0)=DT_U_DT_U_AUPNXRC ;HARD SET DATA - NO TRIGGERS ARE TO EXECUTE
 ;W !,$ZR,"=",@$ZR
END K AUPNXRC,AUPNXCC,AUPNXRCN
 Q
