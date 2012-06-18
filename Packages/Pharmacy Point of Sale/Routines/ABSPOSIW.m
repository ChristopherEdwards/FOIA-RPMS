ABSPOSIW ; IHS/FCS/DRS - Old-style input ;
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 ; overflow from ABSPOSIV
BACKLOG() ;EP - from ABSPOSIV
 ; a rough guess on how many seconds of backlog there are
 N STATS,LOCK,TALLY S LOCK=1,TALLY=0
 D FETSTAT^ABSPOS2("STATS(1)")
 N A S A="" F  S A=$O(STATS(1,A)) Q:'A  D
 . S TALLY=STATS(1,A)*7 ; 7 seconds of packet preparation & overhead
 D FETPKTQ^ABSPOS2("STATS(2)")
 N CLAIMS S CLAIMS=$G(STATS(2,"C")) ; figure about 12 secs each
 N RESPS S RESPS=$G(STATS(2,"R")) ; figure about 3 secs each
 S TALLY=CLAIMS*12+(RESPS*3)+TALLY ; 
 S TALLY=CLAIMS*20+TALLY ; and 20 secs dialing for each one (EOT prob)
 ;I CLAIMS S TALLY=TALLY+20 ; normally, just 20 secs once
 I 0,+$H=58107,$P($H,",",2)<(7*3600) D  Q 300
 . W "Computed value from $$BACKLOG=",TALLY," but change it for testing.",!
 Q TALLY
GETNDC() ;EP - from ABSPOSIV
 ;Prompt - get NDC #
 ; Returns the NDC # with the "-"
 ; Even if pure numeric input, figure it out and put in the "-"
 ; "^" OR "^^" or "" if the user inputs one of those
 ; 0 if automatic answer input was a bad number
 ;
 ; Don't default it - they want the real, true number to always be
 ; scanned in from the bottle, every time.
 ;
 N X,NDCDEF
NDC0 I DEFNDCNO S NDCDEF=$$DEFNDC^ABSPOSIV ; relies on ABSBRXI, ABSBRXR
 E  S NDCDEF=""
 S X=$$FREETEXT^ABSPOSU2("NDC#: ",NDCDEF,1,1,15,$G(DTIME))
 ;
 ; "the Abbot Labs bar codes are really funky"
 I X?1"++3"10.11N2E D
 . S X=$E(X,4,$L(X)-2) ; strip off the surrounding junk
 . ; fine if it's 11N
 . ; if it's 10N, what?  leave it to the mercy of the $$NDC10^ABSPOS9?
 I "^^"[X Q X    ;I X="^^" Q X ;Q:X=-1 "^"  Q:X="" X
 ; If it's entirely numeric input, figure out where the "-" go.
 I X?10N D
 .N Y S Y=$$NDC10^ABSPOS9(X)
 .I Y="" W !,"We couldn't figure out ",X,!
 .E  W "  ",Y S X=Y
 I X?11N D
 .S X=$E(X,1,5)_"-"_$E(X,6,9)_"-"_$E(X,10,11)
 I X?12N D  ; got to ask Carlene about this
 .W !,"12 digit NDC number?  We will proceed anyhow, but it's going",!
 .W "to be truncated"
 .S X=$E(X,1,6)_"-"_$E(X,7,10)_"-"_$E(X,11,12) ; put in 6-4-2 format
 .W !
 I X?4N1"-"4N1"-"2N G NDC1
 I X?5N1"-"3N1"-"2N G NDC1
 I X?5N1"-"4N1"-"1N G NDC1
 I X?5N1"-"4N1"-"2N G NDC1
 I X?6N1"-"4N1"-"2N G NDC1
 W:'$G(SILENT) !,"Bad NDC #",! G NDC0
NDC1 ;S $P(^PSRX(ABSBRXI,2),U,7)=X ; store input NDC # in PRESCRIPTION file
 ; Don't store it yet - just get input now - let background job store it
 W "    ",$$NAME^ABSPOS9(X)
 Q X    ; JUST RETURN WHAT WAS INPUT!!!
