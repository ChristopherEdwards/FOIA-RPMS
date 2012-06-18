BAREUTL ; IHS/SD/LSL - EDI UTILITIES ;  11/05/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**10**;OCT 26, 2005
 ;
 Q
 ; ********************************************************************
 ;
 ;
CHKSEL(IMPDA,BARACTN) ; EP
 ; List checks for file and allow user to choose
 D DISPLAY                             ; Display list
 I BARCNT<1 D  Q BARCKIEN
 . S BARCKIEN=0
 . I BARACTN="POST" W !!,"I'm sorry. You must first REVIEW checks before they can be posted."
 . I BARACTN="REVIEW" W !!,"I'm sorry, there are no checks to review."
 . I BARACTN="REPORT" W !!,"I'm sorry, there are no checks available for reporting"
 . D EOP^BARUTL(1)
 D ASK                                 ; Ask user to choose
 Q BARCKIEN                            ; IEN to A/R EDI Check file
 ; ********************************************************************
 ;
DISPLAY ;
 ; Loop checks to choose from (A/R EDI CHECKS File)
 N BARANS,BARCHECK,BARCHK,BARBATCH,BARITEM
 K BARTMP,BARCNT
 I BARACTN="REVIEW" W $$EN^BARVDF("IOF")
 S BARCNT=0
 S BARCKIEN=0
 F  S BARCKIEN=$O(^BARECHK("C",IMPDA,BARCKIEN)) Q:'+BARCKIEN  D LINE
 Q
 ; ********************************************************************
 ;
LINE ;
 ; Display each check for ERA file
 K BARTMP2
 Q:'$D(^BARECHK(BARCKIEN))
 S BARDTREV=$P($G(^BARECHK(BARCKIEN,0)),U,5)
 ; If posting, only list reviewed checks
 I BARACTN="POST",BARDTREV="" Q
 S BARCNT=BARCNT+1
 S BARTMP2=$G(^BARECHK(BARCKIEN,0))
 S BARBTCH=$P(BARTMP2,U,3)
 ;I BARBTCH]"" D             ;IHS/OIT/MRS:BAR*1.8*10 H831                
 D                           ;IHS/OIT/MRS:BAR*1.8*10 H831
 . S BARBTCHN=$$GET1^DIQ(90051.01,BARBTCH,.01)
 . S BARIENS=$P(BARTMP2,U,4)_","_BARBTCH_","
 . S BARACCT=$$GET1^DIQ(90051.1101,BARIENS,7)
 . S BARBDOL=$$GET1^DIQ(90051.1101,BARIENS,101)
 . S BARBBAL=$$GET1^DIQ(90051.1101,BARIENS,19)
 S:$G(BARBTCHN)="" BARBTCHN="** no RPMS match **"
 S BARTMP(BARCNT)=BARCKIEN
 W !!,$J(BARCNT,2),")"
 W " CHECK #: ",$E($P(BARTMP2,U),1,16)
 W ?31,"BATCH:",?38,$E($G(BARBTCHN),1,31)
 W ?71,"ITEM: ",$J($P(BARTMP2,U,4),3)
 W !?7,"A/R ACCOUNT: ",$E($G(BARACCT),1,15)
 W ?36,"BATCHED AMT: ",$J($FN($G(BARBDOL),",",2),10)
 W ?61,"BALANCE: ",$J($FN($G(BARBBAL),",",2),10)
 Q
 ; ********************************************************************
 ;
ASK ;
 ; Ask user to select check to post
 W !
 S BARCKIEN=0
 K DIR
 S DIR(0)="NAO^1:"_BARCNT
 S DIR("A")="Please enter the LINE # of the check you wish to "_BARACTN_": "
 I BARCNT=1 S DIR("B")=BARCNT
 S DIR("?")="Enter a number between 1 and "_BARCNT
 D ^DIR
 I Y>0 S BARCKIEN=BARTMP(+Y)
 Q
