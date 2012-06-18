APCLAPIR ; IHS/CMI/LAB - visit data ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;Documentation for each API:
 ;  Input:
 ;   APCLPDFN - Patient DFN
 ;   APCLBD - beginning date to begin search for value - if blank, default is DOB
 ;   APCLED - ending date of search - if blank, default is DT
 ;
 ;  Output:
 ;returns the string:
 ;    1 or 0^date^text of item found^value if appropriate^visit ien^File found in^ien of file found in
 ; piece 1:  1 if item found, 0 if no item found in the date range
 ;       2:  date of last item
 ;       3:  text of item found
 ;       4:  value - result
 ;       5:  visit ien on which item found
 ;       6:  file item found in (usually a V File #)
 ;       7:  ien of V File entry found
 ;       
REMDEPS(P,APCLBD,APCLED) ;PEP - called from reminders to get data on last depression screening exam
 ;       
 I '$G(P) Q 0
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(P)
 I $G(APCLED)="" S APCLED=DT
 NEW APCLR
 S APCLR=$$LASTDEPS^APCLAPI(P,APCLBD,APCLED,"A")
 I APCLR]"" Q 1_"^"_APCLR
 Q 0
 ;
REMALCS(P,APCLBD,APCLED) ;PEP - called from reminders to get data on last alcohol screening exam
 ;       
 I '$G(P) Q 0
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(P)
 I $G(APCLED)="" S APCLED=DT
 NEW APCLR
 S APCLR=$$LASTALC^APCLAPI(P,APCLBD,APCLED,"A")
 I APCLR]"" Q 1_"^"_APCLR
 Q 0
 ;
REMAOF(P,APCLBD,APCLED) ;PEP - called from reminders to get data on last assessment of function
 ;       
 I '$G(P) Q 0
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(P)
 I $G(APCLED)="" S APCLED=DT
 NEW APCLR
 S APCLR=$$LASTAOF^APCLAPI4(P,APCLBD,APCLED,"A")
 I APCLR]"" Q 1_"^"_APCLR
 Q 0
 ;
REMBP(P,APCLBD,APCLED) ;PEP - called from reminders to get last BP
 ;
 I '$G(P) Q 0
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(P)
 I $G(APCLED)="" S APCLED=DT
 NEW APCLR
 S APCLR=$$LASTITEM^APCLAPIU(APCLPDFN,"BP","MEASUREMENT",APCLBD,APCLED,"A")
 I APCLR]"" Q 1_"^"_APCLR
 Q 0
 ;
REMBRST(P,APCLBD,APCLED) ;PEP - called from reminders to get data on last breast exam
 ;       
 I '$G(P) Q 0
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(P)
 I $G(APCLED)="" S APCLED=DT
 NEW APCLR
 S APCLR=$$LASTBRST^APCLAPI3(P,APCLBD,APCLED,"A")
 I APCLR]"" Q 1_"^"_APCLR
 Q 0
 ;
REMCHOL(P,APCLBD,APCLED) ;PEP - called from reminders to get data on last cholesterol
 ;       
 I '$G(P) Q 0
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(P)
 I $G(APCLED)="" S APCLED=DT
 NEW APCLR
 S APCLR=$$LASTCHOL^APCLAPI3(P,APCLBD,APCLED,"A")
 I APCLR]"" Q 1_"^"_APCLR
 Q 0
 ;
REMDENT(P,APCLBD,APCLED) ;PEP - called from reminders to get data on last dental exam
 ;       
 I '$G(P) Q 0
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(P)
 I $G(APCLED)="" S APCLED=DT
 NEW APCLR
 S APCLR=$$LASTDENT^APCLAPI2(P,APCLBD,APCLED,"A")
 I APCLR]"" Q 1_"^"_APCLR
 Q 0
 ;
REMGLUC(P,APCLBD,APCLED) ;PEP - called from reminders to get data on last glucose test
 ;       
 I '$G(P) Q 0
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(P)
 I $G(APCLED)="" S APCLED=DT
 NEW APCLR
 S APCLR=$$LASTGLUC^APCLAPI3(P,APCLBD,APCLED,"A")
 I APCLR]"" Q 1_"^"_APCLR
 Q 0
 ;
REMIPVS(P,APCLBD,APCLED) ;PEP - called from reminders to get data on IPV
 ;       
 I '$G(P) Q 0
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(P)
 I $G(APCLED)="" S APCLED=DT
 NEW APCLR
 S APCLR=$$LASTIPVS^APCLAPI(P,APCLBD,APCLED,"A")
 I APCLR]"" Q 1_"^"_APCLR
 Q 0
 ;
REMEPSDT(P,APCLBD,APCLED) ;PEP - called from reminders to get data on last EPSDT
 I '$G(P) Q 0
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(P)
 I $G(APCLED)="" S APCLED=DT
 NEW APCLR
 S APCLR=$$LASTEPS^APCLAPI3(P,APCLBD,APCLED,"A")
 I APCLR]"" Q 1_"^"_APCLR
 Q 0
 ;
REMFRA(P,APCLBD,APCLED) ;PEP - called from reminders to get data on last FALL RISK ASSESSMENT exam
 ;       
 I '$G(P) Q 0
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(P)
 I $G(APCLED)="" S APCLED=DT
 NEW APCLR
 S APCLR=$$LASTFRA^APCLAPI2(P,APCLBD,APCLED,"A")
 I APCLR]"" Q 1_"^"_APCLR
 Q 0
 ;
REMHC(P,APCLBD,APCLED) ;PEP - called from reminders to get data on last HEAD CIRCUMFERENCE
 ;       
 I '$G(P) Q 0
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(P)
 I $G(APCLED)="" S APCLED=DT
 NEW APCLR
 S APCLR=$$LASTITEM^APCLAPIU(APCLPDFN,"HC","MEASUREMENT",APCLBD,APCLED,"A")
 I APCLR]"" Q 1_"^"_APCLR
 Q 0
 ;
REMHEAR(P,APCLBD,APCLED) ;PEP - called from reminders to get data on last HEARING exam
 ;       
 I '$G(P) Q 0
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(P)
 I $G(APCLED)="" S APCLED=DT
 NEW APCLR
 S APCLR=$$LASTHEAR^APCLAPI3(P,APCLBD,APCLED,"A")
 I APCLR]"" Q 1_"^"_APCLR
 Q 0
 ;
REMHT(P,APCLBD,APCLED) ;PEP - called from reminders to get data on last HEIGHT
 ;       
 I '$G(P) Q 0
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(P)
 I $G(APCLED)="" S APCLED=DT
 NEW APCLR
 S APCLR=$$LASTITEM^APCLAPIU(APCLPDFN,"HT","MEASUREMENT",APCLBD,APCLED,"A")
 I APCLR]"" Q 1_"^"_APCLR
 Q 0
 ;
REMFLU(P,APCLBD,APCLED) ;PEP - called from reminders to get data on last FLU SHOT
 ;       
 I '$G(P) Q 0
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(P)
 I $G(APCLED)="" S APCLED=DT
 NEW APCLR
 S APCLR=$$LASTFLU^APCLAPI4(P,APCLBD,APCLED,"A")
 I APCLR]"" Q 1_"^"_APCLR
 Q 0
 ;
REMMAMM(P,APCLBD,APCLED) ;PEP - called from reminders to get data on last MAMMOGRAM
 ;       
 I '$G(P) Q 0
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(P)
 I $G(APCLED)="" S APCLED=DT
 NEW APCLR
 S APCLR=$$LASTMAM^APCLAPI1(P,APCLBD,APCLED,"A")
 I APCLR]"" Q 1_"^"_APCLR
 Q 0
 ;
REMOSTEO(P,APCLBD,APCLED) ;PEP - called from reminders to get data on last OSTEOPOROSIS SCREENING
 ;       
 I '$G(P) Q 0
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(P)
 I $G(APCLED)="" S APCLED=DT
 NEW APCLR
 S APCLR=$$LASTOST^APCLAPI4(P,APCLBD,APCLED,"A")
 I APCLR]"" Q 1_"^"_APCLR
 Q 0
 ;
REMPAP(P,APCLBD,APCLED) ;PEP - called from reminders to get data on last PAP SMEAR
 ;       
 I '$G(P) Q 0
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(P)
 I $G(APCLED)="" S APCLED=DT
 NEW APCLR
 S APCLR=$$LASTPAP^APCLAPI1(P,APCLBD,APCLED,"A")
 I APCLR]"" Q 1_"^"_APCLR
 Q 0
 ;
REMPELV(P,APCLBD,APCLED) ;PEP - called from reminders to get data on last PELVIC EXAM
 ;       
 I '$G(P) Q 0
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(P)
 I $G(APCLED)="" S APCLED=DT
 NEW APCLR
 S APCLR=$$LASTPELV^APCLAPI2(P,APCLBD,APCLED,"A")
 I APCLR]"" Q 1_"^"_APCLR
 Q 0
 ;
REMPHYS(P,APCLBD,APCLED) ;PEP - called from reminders to get data on last PHYSICAL EXAM
 ;       
 I '$G(P) Q 0
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(P)
 I $G(APCLED)="" S APCLED=DT
 NEW APCLR
 S APCLR=$$LASTPHYS^APCLAPI2(P,APCLBD,APCLED,"A")
 I APCLR]"" Q 1_"^"_APCLR
 Q 0
 ;
REMPNEU(P,APCLBD,APCLED) ;PEP - called from reminders to get data on last PNEUMOVAX
 ;       
 I '$G(P) Q 0
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(P)
 I $G(APCLED)="" S APCLED=DT
 NEW APCLR
 S APCLR=$$LASTPNEU^APCLAPI4(P,APCLBD,APCLED,"A")
 I APCLR]"" Q 1_"^"_APCLR
 Q 0
 ;
REMRECT(P,APCLBD,APCLED) ;PEP - called from reminders to get data on last RECTAL EXAM
 ;       
 I '$G(P) Q 0
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(P)
 I $G(APCLED)="" S APCLED=DT
 NEW APCLR
 S APCLR=$$LASTRECT^APCLAPI2(P,APCLBD,APCLED,"A")
 I APCLR]"" Q 1_"^"_APCLR
 Q 0
 ;
REMRUBEL(P,APCLBD,APCLED) ;PEP - called from reminders to get data on last RUBELLA
 ;       
 I '$G(P) Q 0
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(P)
 I $G(APCLED)="" S APCLED=DT
 NEW APCLR
 S APCLR=$$LASTRUB^APCLAPI3(P,APCLBD,APCLED,"A")
 I APCLR]"" Q 1_"^"_APCLR
 Q 0
 ;
REMTD(P,APCLBD,APCLED) ;PEP - called from reminders to get data on last TD
 ;       
 I '$G(P) Q 0
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(P)
 I $G(APCLED)="" S APCLED=DT
 NEW APCLR
 S APCLR=$$LASTTD^APCLAPI4(P,APCLBD,APCLED,"A")
 I APCLR]"" Q 1_"^"_APCLR
 Q 0
 ;
REMTOBS(P,APCLBD,APCLED) ;PEP - called from reminders to get data on last TOBACCO SCREENING
 ;       
 I '$G(P) Q 0
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(P)
 I $G(APCLED)="" S APCLED=DT
 NEW APCLR
 S APCLR=$$LASTTOBS^APCLAPI1(P,APCLBD,APCLED,"A")
 I APCLR]"" Q 1_"^"_APCLR
 Q 0
 ;
REMTON(P,APCLBD,APCLED) ;PEP - called from reminders to get data on last TONOMETRY
 ;       
 I '$G(P) Q 0
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(P)
 I $G(APCLED)="" S APCLED=DT
 NEW APCLR
 S APCLR=$$LASTTON^APCLAPI1(P,APCLBD,APCLED,"A")
 I APCLR]"" Q 1_"^"_APCLR
 Q 0
 ;
REMVAE(P,APCLBD,APCLED) ;PEP - called from reminders to get data on last VISUAL ACUTIY EXAM
 ;       
 I '$G(P) Q 0
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(P)
 I $G(APCLED)="" S APCLED=DT
 NEW APCLR
 S APCLR=$$LASTVAE^APCLAPI1(P,APCLBD,APCLED,"A")
 I APCLR]"" Q 1_"^"_APCLR
 Q 0
 ;
REMWT(P,APCLBD,APCLED) ;PEP - called from reminders to get data on last WEIGHT
 ;       
 I '$G(P) Q 0
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(P)
 I $G(APCLED)="" S APCLED=DT
 NEW APCLR
 S APCLR=$$LASTITEM^APCLAPIU(APCLPDFN,"WT","MEASUREMENT",APCLBD,APCLED,"A")
 I APCLR]"" Q 1_"^"_APCLR
 Q 0
 ;
